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
    
    static func randomFloatRange(min: Float, max: Float) -> Float {
        return Float(Float(arc4random()) / Float(UInt32.max)) * (max - min) + min
    }
}

final class RandomLines: Node, Renderable, DefaultVertexDescriptorProtocol {
    
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
    
    func buildBuffers(device: MTLDevice) {
        print("VERTICES: \(vertices.count)")
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
    }
    
    
    private func buildVertices() {
        
        let kNumHillKeyPoints = 5
        let kNumHillSmoothSegments = 100
        let kNumHillSmoothPoints = (kNumHillKeyPoints - 1) * kNumHillSmoothSegments
        let kNumHillVertices = kNumHillSmoothPoints * 2
        
        var hillKeyPoints: [Vertex] = Vertex.defaultValues(with: kNumHillKeyPoints)
        var hillSmoothPoints: [Vertex] = Vertex.defaultValues(with: kNumHillSmoothPoints)
        var hillVertices: [Vertex] = Vertex.defaultValues(with: kNumHillVertices)
        
        let startingY = Float.randomFloatRange(min: -1, max: 1)
        let firstVertex = Vertex(position: float3(-1, startingY, 0), color: float4(1, 0, 0, 1))
        hillKeyPoints[0] = firstVertex
      

        var sign: Float = 1
        var y: Float  = startingY
        var x: Float = -1
        let width: Float = 2
        
        for i in 1..<kNumHillKeyPoints {
            x += width / Float(kNumHillKeyPoints - 1)
            y = sign * Float.randomFloatRange(min: 0, max: 0.8)
            sign = -sign
            
            let vert = Vertex(position: float3(x, y, 0), color: float4(1, 0, 0, 1))
            hillKeyPoints[Int(i)] = vert
        }
        
        hillKeyPoints[kNumHillKeyPoints - 1] = Vertex(position: float3(1, startingY, 0), color: float4(1, 0, 0, 1))
        
        
        for i in 0..<kNumHillKeyPoints {
            guard hillKeyPoints.indices.contains(i + 1) else { continue }
            let p0 = hillKeyPoints[i]
            let p1 = hillKeyPoints[i + 1]
            
            let da: Float = Float(Double.pi / Double((kNumHillSmoothSegments - 1)))
            let ymid: Float = (p0.position.y + p1.position.y) / 2
            let ampl: Float = (p0.position.y - p1.position.y) / 2
            
            let r = Float.random()
            let g = Float.random()
            let b = Float.random()
            
            // Adding 100(kNumHillSmoothSegments> triangles in between current point and next point
            for j in 0..<kNumHillSmoothSegments {
                let alpha: Float = Float(j) / Float(kNumHillSmoothSegments - 1)
                let x: Float = ((1 - alpha) * p0.position.x) + (alpha * p1.position.x)
                let y: Float = ymid + ampl * cosf(da * Float(j))
                
                let smoothVertex = Vertex(position: float3(x, y, 0), color: float4(r, g, b, 1))
                hillSmoothPoints[(i * kNumHillSmoothSegments) + j] = smoothVertex
                
            }
        }
        
        // Adding the paired triangle for each smooth triangle to extend the strip to the floor of the screen
        for (index, point) in hillSmoothPoints.enumerated() {
            hillVertices[index * 2] = point
            hillVertices[(index * 2) + 1] = Vertex(position: float3(point.position.x, -1, 0), color: point.color)
        }
        
        
        vertices = hillVertices
    }
    
    func performRender(with commandEncoder: MTLRenderCommandEncoder, modelViewMatrix: matrix_float4x4) {
        guard let pipeline = pipelineState else {
            assertionFailure()
            return
        }
        
        commandEncoder.setRenderPipelineState(pipeline)
        
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        
        commandEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: vertices.count)
    }
}

extension Vertex {
    static func defaultValue() -> Vertex {
        return Vertex(position: float3(0, 0, 0), color: float4(0, 0, 0, 1))
    }
    
    static func defaultValues(with num: Int) -> [Vertex] {
        var values: [Vertex] = []
        for _ in 0..<num {
            values.append(Vertex.defaultValue())
        }
        
        return values
    }
}
