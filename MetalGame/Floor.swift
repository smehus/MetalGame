//
//  Floor.swift
//  MetalGame
//
//  Created by scott mehus on 7/19/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

final class Floor: Node, Renderable, DefaultVertexDescriptorProtocol {
    
    var vertexBuffer: MTLBuffer?
    var indexBuffer: MTLBuffer?
    var pipelineState: MTLRenderPipelineState?
    var vertexShader: ShaderFunction = .vertex
    var fragmentShader: ShaderFunction = .fragment
    
    var modelConstants = ModelConstants()
    
    var vertices: [Vertex] = [
        Vertex(position: float3(-1, 1, 1), color: float4(1, 0, 0, 1), texture: float2(0, 0)),
        Vertex(position: float3(-1, -1, 1), color: float4(0, 1, 0, 1), texture: float2(0, 1)),
        Vertex(position: float3(1, -1, 1), color: float4(0, 0, 1, 1), texture: float2(1, 1)),
        Vertex(position: float3(1, 1, 1), color: float4(1, 0, 1, 1), texture: float2(1, 0))
    ]
    
    var indices: [UInt16] = [
        0, 1, 2, 0, 2, 3,
    ]
    
    init(device: MTLDevice) {
        super.init()
        // Handled in Renderable extension
        buildBuffers(device: device)
        buildPipelineState(device: device)
    }
    
    func buildBuffers(device: MTLDevice) {
        print("VERTICES: \(vertices.count)")
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
        
        
        commandEncoder.drawIndexedPrimitives(type: .triangle, indexCount: indices.count, indexType: .uint16, indexBuffer: idxBuffer, indexBufferOffset: 0)
    }
}
