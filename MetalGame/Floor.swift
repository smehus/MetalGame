//
//  Floor.swift
//  MetalGame
//
//  Created by scott mehus on 7/19/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

class Floor: Node, Renderable {
    
    var vertexBuffer: MTLBuffer?
    var pipelineState: MTLRenderPipelineState?
    var vertexShader: ShaderFunction = .vertex
    var fragmentShader: ShaderFunction = .fragment
    
    var vertices: [Vertex] = [
        Vertex(position: float3(0, -1, 0), color: float4(1, 0, 0, 1)),
        Vertex(position: float3(-1, 1, 0), color: float4(0, 1, 0, 1)),
        Vertex(position: float3(1, 1, 0), color: float4(0, 0, 1, 1)),
    ]
    
    var vertexDescriptor: MTLVertexDescriptor {
        let descriptor = MTLVertexDescriptor()
        
        descriptor.attributes[0].format = .float3
        descriptor.attributes[0].offset = 0
        descriptor.attributes[0].bufferIndex = 0
        
        descriptor.attributes[1].format = .float4
        descriptor.attributes[1].offset = MemoryLayout<float3>.stride
        descriptor.attributes[1].bufferIndex = 0
        
        descriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return descriptor
    }
    
    init(device: MTLDevice) {
        super.init()
        // Handled in Renderable extension
        buildBuffers(device: device)
        buildPipelineState(device: device)
    }
    
    func performRender(with commandEncoder: MTLRenderCommandEncoder) {
        guard let pipeline = pipelineState else { return }
        
        // Configure shaders
        commandEncoder.setRenderPipelineState(pipeline)
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        
        // encode a request to draw
        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
    }
}
