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
    
    var time: Float = 0
    
    /// Rendering command used on scenes
    func render(with commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {
        time += deltaTime
        
        let rotationmatrix = matrix_float4x4(rotationAngle: time, x: 1, y: 1, z: 0)
        let viewMatrix = matrix_float4x4(translationX: 0, y: 0, z: -10)
        let modelMatrix = matrix_multiply(viewMatrix, rotationmatrix)
        
        let projectionMatrix = matrix_float4x4(projectionFov: radians(fromDegrees: 65), aspect: Float(750.0/1334.0), nearZ: 0.1, farZ: 100)
        let modelViewMatrix = matrix_multiply(projectionMatrix, modelMatrix)
        
        for child in children {
            child.render(with: commandEncoder, parentModelViewMatrix: modelViewMatrix)
        }
    }
}
