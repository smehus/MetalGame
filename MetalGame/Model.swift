//
//  Model.swift
//  MetalGame
//
//  Created by scott mehus on 7/23/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

final class Model: Node, Renderable, ModelVertexDescriptor, Texturable {
    
    var meshes: [AnyObject]?
    
    var vertexBuffer: MTLBuffer?
    var texture: MTLTexture?
    var pipelineState: MTLRenderPipelineState?
    var vertexShader: ShaderFunction = .vertex
    var fragmentShader: ShaderFunction = .fragment
    
    var modelConstants = ModelConstants()
    
    private let modelName: String
    
    init(device: MTLDevice, modelName: String) {
        self.modelName = modelName
        super.init()
        
        if let lTexture = loadTexture(device: device, image: #imageLiteral(resourceName: "mushroom.png")) {
            texture = lTexture
            fragmentShader = .texturedFragmentLit
        }
        loadModel(device: device, modelName: modelName)
        buildPipelineState(device: device)
    }
    
    func performRender(with commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        guard let pipeline = pipelineState else { return }
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        
        modelConstants.modelViewMatrix = modelViewMatrix
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, at: 1)
        
        if let texture = self.texture {
            commandEncoder.setFragmentTexture(texture, at: 0)
        }
        
        commandEncoder.setRenderPipelineState(pipeline)
        
        guard let meshes = meshes as? [MTKMesh], !meshes.isEmpty else {
            return
        }
        
        render(meshes: meshes, commandEncorder: commandEncoder)
    }
    
    private func render(meshes: [MTKMesh], commandEncorder: MTLRenderCommandEncoder) {
        
        for mesh in meshes {
            let vertexBuffer = mesh.vertexBuffers[0]
            commandEncorder.setVertexBuffer(vertexBuffer.buffer, offset: vertexBuffer.offset, at: 0)
            
            for subMesh in mesh.submeshes {
                commandEncorder.drawIndexedPrimitives(type: subMesh.primitiveType,
                                                      indexCount: subMesh.indexCount,
                                                      indexType: subMesh.indexType,
                                                      indexBuffer: subMesh.indexBuffer.buffer,
                                                      indexBufferOffset: subMesh.indexBuffer.offset)
            }
        }
    }
}

extension Model {
    fileprivate func loadModel(device: MTLDevice, modelName: String) {
        guard let assetURL = Bundle.main.url(forResource: modelName, withExtension: "obj") else {
            assertionFailure()
            return
        }
        
        let descriptor = MTKModelIOVertexDescriptorFromMetal(vertexDescriptor)
        
        let attributePosition = descriptor.attributes[0] as! MDLVertexAttribute
        attributePosition.name = MDLVertexAttributePosition
        descriptor.attributes[0] = attributePosition
        
        let attributeColor = descriptor.attributes[1] as! MDLVertexAttribute
        attributeColor.name = MDLVertexAttributeColor
        descriptor.attributes[1] = attributeColor
        
        let attributeTexture = descriptor.attributes[2] as! MDLVertexAttribute
        attributeTexture.name = MDLVertexAttributeTextureCoordinate
        descriptor.attributes[2] = attributeTexture
        
        let attributeNormal = descriptor.attributes[3] as! MDLVertexAttribute
        attributeNormal.name = MDLVertexAttributeNormal
        descriptor.attributes[3] = attributeNormal
        
        let bufferAllocator = MTKMeshBufferAllocator(device: device)
        let asset = MDLAsset(url: assetURL, vertexDescriptor: descriptor, bufferAllocator: bufferAllocator)
        
        do {
            meshes = try MTKMesh.newMeshes(from: asset, device: device, sourceMeshes: nil)
        } catch {
            fatalError()
        }
    }
}
