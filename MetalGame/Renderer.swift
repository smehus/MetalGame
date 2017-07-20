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

    init(device: MTLDevice) {
        self.device = device
        commandQueue = device.makeCommandQueue()
        
        super.init()
    }
}

extension Renderer: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
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
        
        let delta = 1 / Float(view.preferredFramesPerSecond)
        scene?.render(with: commandEncoder, deltaTime: delta)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}
