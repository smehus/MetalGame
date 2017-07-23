//
//  Cube.swift
//  MetalGame
//
//  Created by scott mehus on 7/22/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

final class Cube: Node, Renderable, DefaultVertexDescriptorProtocol, Texturable {
    
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    var pipelineState: MTLRenderPipelineState?
    
    /// Shader functions
    var vertexShader: ShaderFunction = .vertex
    var fragmentShader: ShaderFunction = .fragment

    /// Holds the model view matrix to send to shader
    var modelConstants = ModelConstants()
    
    /// Texturable
    var texture: MTLTexture?
    
    // TEXTURES DON'T RENDER CORRECTLY BECAUSE WE'RE USING INDEXED DRAWING. IF WE WANT TO RENDER 
    // TEXTURES CORRECT, WE NEED TO DRAW PRIMITIVES AND SET TEXTURE VERTEX FOR EACH SIDE
    var vertices: [Vertex] = [
        Vertex(position: float3(-1, 1, 1), color: float4(1, 0, 0, 1), texture: float2(0, 0)),
        Vertex(position: float3(-1, -1, 1), color: float4(0, 1, 0, 1), texture: float2(0, 1)),
        Vertex(position: float3(1, -1, 1), color: float4(0, 0, 1, 1), texture: float2(1, 1)),
        Vertex(position: float3(1, 1, 1), color: float4(1, 0, 1, 1), texture: float2(1, 0)),
        
        
        Vertex(position: float3(-1, 1, -1), color: float4(0, 0, 1, 1), texture: float2(1, 1)),
        Vertex(position: float3(-1, -1, -1), color: float4(0, 1, 0, 1), texture: float2(0, 1)),
        Vertex(position: float3(1, -1, -1), color: float4(1, 0, 0, 1), texture: float2(0, 0)),
        Vertex(position: float3(1, 1, -1), color: float4(1, 0, 1, 1), texture: float2(1, 0))
    ]
    
    var indices: [UInt16] = [
        0, 1, 2,     0, 2, 3,  // Front
        4, 6, 5,     4, 7, 6,  // Back
        
        4, 5, 1,     4, 1, 0,  // Left
        3, 6, 7,     3, 2, 6,  // Right
        
        4, 0, 3,     4, 3, 7,  // Top
        1, 5, 6,     1, 6, 2   // Bottom
    ]
    
    init(device: MTLDevice, image: UIImage? = nil) {
        super.init()
        
        if let img = image, let text = loadTexture(device: device, image: img) {
            texture = text
            fragmentShader = .texturedFragment
        }
        
        
        buildBuffers(device: device)
        buildPipelineState(device: device)
    }
    
    func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
        indexBuffer = device.makeBuffer(bytes: indices, length: indices.count * MemoryLayout<UInt16>.size, options: [])
    }
    
    func performRender(with commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        guard
            let pipeline = pipelineState,
            let idxBuffer = indexBuffer
        else { return }

        commandEncoder.setRenderPipelineState(pipeline)
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        
        modelConstants.modelViewMatrix = modelViewMatrix
        // Model constants perform all the translations to position the node correctly in the parent node
        commandEncoder.setVertexBytes(&modelConstants, length: MemoryLayout<ModelConstants>.stride, at: 1)
        
        commandEncoder.setFragmentTexture(texture, at: 0)
        
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: idxBuffer, indexBufferOffset: 0)
    }
    
}





