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
    var scene: Scene?
    
    fileprivate var pipelineState: MTLRenderPipelineState?
    
    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        
        super.init()
        
        buildPipelineState()
    }
    
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
    
    private func buildPipelineState() {
        let library = device.newDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: ShaderFunctions.vertex.name)
        let fragmentFunction = library?.makeFunction(name: ShaderFunctions.fragment.name)
        
        //  holds configuration options for a pipeline
        let pipelineDescriptor = MTLRenderPipelineDescriptor()
        pipelineDescriptor.vertexFunction = vertexFunction
        pipelineDescriptor.fragmentFunction = fragmentFunction
        pipelineDescriptor.colorAttachments[0].pixelFormat = .bgra8Unorm
        
        pipelineDescriptor.vertexDescriptor = vertexDescriptor
        
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
        
        let delta = 1 / Float(view.preferredFramesPerSecond)
        scene?.render(with: commandEncoder, deltaTime: delta)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
