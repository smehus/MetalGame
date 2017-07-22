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
    var pipelineState: MTLRenderPipelineState?
    var vertexShader: ShaderFunction = .vertex
    var fragmentShader: ShaderFunction = .fragment
    
    var vertices: [Vertex] = [
        Vertex(position: float3(0, -1, 0), color: float4(1, 0, 0, 1)),
        Vertex(position: float3(-1, 1, 0), color: float4(0, 1, 0, 1)),
        Vertex(position: float3(1, 1, 0), color: float4(0, 0, 1, 1)),
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
    }
    
    
    func performRender(with commandEncoder: MTLRenderCommandEncoder, parentModelViewMatrix: matrix_float4x4) {
        guard let pipeline = pipelineState else { return }
        
        // Configure shaders
        commandEncoder.setRenderPipelineState(pipeline)
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        
        // encode a request to draw
        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
    }
}
