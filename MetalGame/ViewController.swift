//
//  ViewController.swift
//  MetalGame
//
//  Created by scott mehus on 7/18/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

internal final class ViewController: UIViewController {
    
    var commandQueue: MTLCommandQueue!
    var device: MTLDevice!
    
    var metalView: MTKView {
        return view as! MTKView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        device = MTLCreateSystemDefaultDevice()
        metalView.device = device
        metalView.clearColor = Colors.skyBlue.mtlColor
        metalView.delegate = self
        commandQueue = device.makeCommandQueue()
        
    }
    
}

extension ViewController: MTKViewDelegate {
    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        
    }
    
    func draw(in view: MTKView) {
        guard
            let drawable = view.currentDrawable,
            let descriptor = view.currentRenderPassDescriptor
        else {
            return
        }
        
        let commandBuffer = commandQueue.makeCommandBuffer()
        let commandEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: descriptor)
        
        commandEncoder.endEncoding()
        commandBuffer.present(drawable)
        commandBuffer.commit()
    }
}

