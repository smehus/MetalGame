//
//  RandomLines.swift
//  MetalGame
//
//  Created by scott mehus on 7/20/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

class RandomLines: Node, Renderable, DefaultVertexDescriptorProtocol {
    
    var vertices: [Vertex] = []
    var vertexBuffer: MTLBuffer?
    var pipelineState: MTLRenderPipelineState?
    
    var vertexShader: ShaderFunction = .vertex
    var fragmentShader: ShaderFunction = .fragment
    
    init(device: MTLDevice) {
        super.init()
        buildVertices()
        buildBuffers(device: device)
        buildPipelineState(device: device)
    }
    
    private func buildVertices() {
        for i in stride(from: -1, to: 1, by: 0.1) {
            let point = Float(i)
            let vert = Vertex(position: float3(point, point, 0), color: float4(1, 0, 0, 1))
            let vert2 = Vertex(position: float3(point, -1, 0), color: float4(1, 0, 0, 1))
            vertices.append(vert)
            vertices.append(vert2)
        }
    }
    
    func performRender(with commandEncoder: MTLRenderCommandEncoder) {
        guard let pipeline = pipelineState else {
            assertionFailure()
            return
        }
        
        commandEncoder.setRenderPipelineState(pipeline)
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        
        commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertices.count)
    }
}


