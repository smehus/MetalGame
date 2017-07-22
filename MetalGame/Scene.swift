//
//  Scene.swift
//  MetalGame
//
//  Created by scott mehus on 7/19/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

class Scene: Node {
    let device: MTLDevice
    let size: CGSize
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        
        super.init()
    }

    let viewMatrix = matrix_float4x4(translationX: 0, y: 0, z: -10)
    
    /// Rendering command used on scenes
    func render(with commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        for child in children {
            child.render(with: commandEncoder, parentModelViewMatrix: viewMatrix)
        }
    }
}
