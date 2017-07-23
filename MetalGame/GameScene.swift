//
//  GameScene.swift
//  MetalGame
//
//  Created by scott mehus on 7/19/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

final class GameScene: Scene {

    enum Constants {
        static let gameHeight: Float = 40
        static let gameWidth: Float = 22.5
    }
    
    var model: Model
    
    override init(device: MTLDevice, size: CGSize) {
        model = Model(device: device, modelName: "mushroom")
        super.init(device: device, size: size)
        add(model)
        
        setupCamera()
        
        light.color = float3(1, 1, 1)
        light.ambientIntensity = 0.2
        light.diffuseIntensity = 0.8
        light.direction = float3(0, 0, -1)
    }
    
    override func update(with deltaTime: Float) {
        model.rotation.x += deltaTime
        model.rotation.y += deltaTime
    }
    
    private func setupCamera() {
//        camera.position.z = -(Constants.gameHeight / 2) / tan(camera.fovRadians / 2)
        camera.position.z = -10
    }
}
