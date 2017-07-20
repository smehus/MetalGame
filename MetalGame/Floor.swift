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
    
    var vertices: [Vertex] = [
        Vertex(position: float3(0, -1, 0), color: float4(1, 0, 0, 1)),
        Vertex(position: float3(-1, 1, 0), color: float4(0, 1, 0, 1)),
        Vertex(position: float3(1, 1, 0), color: float4(0, 0, 1, 1)),
    ]
    
    init(device: MTLDevice) {
        super.init()
        buildBuffers(device: device)
    }
    
    func buildBuffers(device: MTLDevice) {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
    }
    
    func performRender(with commandEncoder: MTLRenderCommandEncoder) {
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        
        // encode a request to draw
        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
    }
}
