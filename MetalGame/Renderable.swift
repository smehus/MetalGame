//
//  Renderable.swift
//  MetalGame
//
//  Created by scott mehus on 7/20/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

protocol Renderable: class {
    var vertices: [Vertex]  { get }
    var vertexBuffer: MTLBuffer? { get set }
    var vertexDescriptor: MTLVertexDescriptor  { get }
    var pipelineState: MTLRenderPipelineState? { get set }
    
    var vertexShader: ShaderFunction { get set }
    var fragmentShader: ShaderFunction { get set }
    
    func performRender(with commandEncoder: MTLRenderCommandEncoder)
    func buildPipelineState(device: MTLDevice)
}

extension Renderable {
    
    func buildPipelineState(device: MTLDevice) {
        let library = device.newDefaultLibrary()
        let vertexFunction = library?.makeFunction(name: vertexShader.name)
        let fragmentFunction = library?.makeFunction(name: fragmentShader.name)
        
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
            fatalError("error \(error.localizedDescription)")
        }
    }
}
