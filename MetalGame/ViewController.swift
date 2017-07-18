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
        metalView.delegate = renderer
    }
    
}
