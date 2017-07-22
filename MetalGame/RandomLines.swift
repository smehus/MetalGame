//
//  RandomLines.swift
//  MetalGame
//
//  Created by scott mehus on 7/20/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit


extension Float {
    static func random() -> Float {
        let floatValue = Float(arc4random()) / Float(UInt32.max)
        return  arc4random_uniform(2) == 0 ? floatValue : -floatValue
    }
}

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
        
        for i in stride(from: -1, through: 1, by: 0.1) {
            let point = Float(i)
            let r = Float.random()
            let g = Float.random()
            let b = Float.random()
            let vert = Vertex(position: float3(point, r, 0), color: float4(r, g, b, 1))
            let vert2 = Vertex(position: float3(point, -1, 0), color: float4(r, g, b, 1))
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


