//
//  Renderer.swift
//  MetalGame
//
//  Created by scott mehus on 7/18/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

internal final class Renderer: NSObject {
    
    var commandQueue: MTLCommandQueue!
    var device: MTLDevice!
    var scene: Scene?
    var samplerState: MTLSamplerState?

    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        
        super.init()
        
        buildSamplerState()
    }
    
    private func buildSamplerState() {
        let descriptor = MTLSamplerDescriptor()
        descriptor.minFilter = .linear
        descriptor.magFilter = .linear
        samplerState = device.makeSamplerState(descriptor: descriptor)
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        scene?.sizeWillChange(to: size)
    }
    
    func draw(in view: MTKView) {
        guard
            let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor
            else {
                return
        }
        
        // represents a collection of render commands to be executed as a unit
        let commandBuffer = commandQueue.makeCommandBuffer()
        
        // used to tell Metal what drawing we actually want to do
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        
        // Fragment Sampler state
        commandEncoder.setFragmentSamplerState(samplerState, at: 0)
        
        // Culling
        commandEncoder.setFrontFacing(.counterClockwise)
        commandEncoder.setCullMode(.back)
        
        let delta = 1 / Float(view.preferredFramesPerSecond)
        
        // Draws the scene - which draws all of its children - then renders any Renderable
        scene?.render(with: commandEncoder, deltaTime: delta)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
