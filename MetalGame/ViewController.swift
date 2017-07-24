//
//  ViewController.swift
//  MetalGame
//
//  Created by scott mehus on 7/18/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

internal final class ViewController: UIViewController {
    
    var renderer: Renderer?
    
    var metalView: MTKView {
        return view as! MTKView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        guard let device = MTLCreateSystemDefaultDevice() else {
            fatalError()
        }
        
        metalView.device = device
        metalView.clearColor = Colors.skyBlue.mtlColor
        
        renderer = Renderer(device: device)
        renderer?.scene = GameScene(device: device, size: view.bounds.size)
        
        metalView.delegate = renderer
    }
}

extension ViewController {
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer?.scene?.touchesBegan(view, touches:touches, with: event)
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer?.scene?.touchesMoved(view, touches: touches, with: event)
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer?.scene?.touchesEnded(view, touches: touches, with: event)
    }
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        renderer?.scene?.touchesCancelled(view, touches: touches, with: event)
    }
}
