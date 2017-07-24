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
//    var cube: Cube
    var previousTouchLocation: CGPoint = .zero
    
    override init(device: MTLDevice, size: CGSize) {
//        cube = Cube(device: device)
        model = Model(device: device, model: .handstand)
        super.init(device: device, size: size)
//        cube.position.z = -10
//        add(cube)
        
        model.specularIntensity = 0.8
        model.shininess = 8.0
        model.position.y = -10
        add(model)
        
        setupCamera()
        
        light.color = float3(1, 1, 1)
        light.ambientIntensity = 0.2
        light.diffuseIntensity = 0.8
        light.direction = float3(0, 0, -1)
    }
    
    override func update(with deltaTime: Float) { }
    
    private func setupCamera() {
//        camera.position.z = -(Constants.gameHeight / 2) / tan(camera.fovRadians / 2)
        camera.position.z = -20
    }
    
    override func touchesBegan(_ view: UIView, touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let touch = touches.first else { return }
        previousTouchLocation = touch.location(in: view)
    }
    
    override func touchesMoved(_ view: UIView, touches: Set<UITouch>,
                               with event: UIEvent?) {
        guard let touch = touches.first else { return }
        let touchLocation = touch.location(in: view)
        let delta = CGPoint(x: previousTouchLocation.x - touchLocation.x,
                            y: previousTouchLocation.y - touchLocation.y)
        let sensitivity: Float = 0.01
        model.rotation.x += Float(delta.y) * sensitivity
        model.rotation.y += Float(delta.x) * sensitivity
        previousTouchLocation = touchLocation
    }
    
}
