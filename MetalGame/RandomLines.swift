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
        
        var hillPoints: [Vertex] = []
        var smoothPoints: [Vertex] = []

        var r = Float.random()
        var g = Float.random()
        var b = Float.random()
        
        for i in stride(from: -1, through: 1, by: 0.4) {
            let point = Float(i)
            r = Float.random()
            g = Float.random()
            b = Float.random()
            
            let vert = Vertex(position: float3(point, r, 0), color: float4(r, g, b, 1))
            let vert2 = Vertex(position: float3(point, -1, 0), color: float4(r, g, b, 1))
            hillPoints.append(vert)
            hillPoints.append(vert2)
        }
        
        
        // Trying to draw smooth hills.... and failing
        for i in 0..<hillPoints.count {
            guard hillPoints.indices.contains(i + 1) else {
                print("INDEX: \(i), hillpoints: \(hillPoints.count)")
                continue
            }
            
            let p0 = hillPoints[i]
            let p1 = hillPoints[i + 1]
            
            let da: Float = Float(Double.pi / Double((hillPoints.count - 1)))
            let ymid: Float = (p0.position.y + p1.position.y) / 2
            let ampl: Float = (p0.position.y - p1.position.y) / 2
            
            for j in 0..<hillPoints.count {
                let alpha: Float = Float(j) / Float(hillPoints.count - 1)
                let x: Float = ((1 - alpha) * p0.position.x) + (alpha * p1.position.x)
                let y: Float = ymid + ampl * cosf(da * Float(j))
                
                let smoothVertex = Vertex(position: float3(x, y, 0), color: float4(1, 0, 0, 1))
                let bottomSmooth = Vertex(position: float3(x, -1, 0), color: float4(1, 0, 0, 1))
                smoothPoints.append(contentsOf: [smoothVertex, bottomSmooth])
                
            }
        }
        
        
        
        vertices = smoothPoints
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


