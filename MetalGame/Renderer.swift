//
//  Renderer.swift
//  MetalGame
//
//  Created by scott mehus on 7/18/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

enum ShaderFunctions {
    case vertex
    case fragment
    
    var name: String {
        switch self {
        case .vertex:
            return "vertex_shader"
        case .fragment:
            return "fragment_shader"
        }
    }
}

internal final class Renderer: NSObject {
    
    var commandQueue: MTLCommandQueue!
    var device: MTLDevice!
    
    fileprivate var vertexBuffer: MTLBuffer?
    fileprivate var pipelineState: MTLRenderPipelineState?
    
    fileprivate var vertices: [Vertex] = [
        Vertex(position: float4(0, -1, 0, 1), color: float4(1, 0, 0, 1)),
        Vertex(position: float4(-1, 1, 0, 1), color: float4(0, 1, 0, 1)),
        Vertex(position: float4(1, 1, 0, 1), color: float4(0, 0, 1, 1)),
    ]
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        
        super.init()
        
        buildBuffers()
        buildPipelineState()
    }
    
    private func buildBuffers() {
        vertexBuffer = device.makeBuffer(bytes: vertices, length: MemoryLayout<Vertex>.stride * vertices.count, options: [])
    }
    
    private func buildPipelineState() {
        let library = device.newDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: ShaderFunctions.vertex.name)
        let fragmentFunction = library?.makeFunction(name: ShaderFunctions.fragment.name)
        
        //  holds configuration options for a pipeline
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        do {
            // describes how Metal should render our geometry
            // The pipeline state encapsulates the compiled and linked shader program derived from the shaders we set on the descriptor.
            pipelineState = try device.makeRenderPipelineState(descriptor: pipelineDescriptor)
        } catch let error as NSError {
            assertionFailure("Failed to create pipeline state: \(error.localizedDescription)")
        }
    }
    
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard
            let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor,
            let pipeline = pipelineState
            else {
                return
        }
        
        // represents a collection of render commands to be executed as a unit
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        // used to tell Metal what drawing we actually want to do
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        
        // Configure shaders
        commandEncoder.setRenderPipelineState(pipeline)
        
        // method is used to map from the MTLBuffer objects we created earlier to the parameters of the vertex function in our shader code.
        commandEncoder.setVertexBuffer(vertexBuffer, offset: 0, at: 0)
        
        // encode a request to draw
        commandEncoder.drawPrimitives(type: .triangle, vertexStart: 0, vertexCount: vertices.count)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
