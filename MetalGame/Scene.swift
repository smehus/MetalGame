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
    
    var camera = Camera()
    var sceneConstants = SceneConstants()
    
    init(device: MTLDevice, size: CGSize) {
        self.device = device
        self.size = size
        
        super.init()
    }
    
    func update(with deltaTime: Float) { }
    
    /// Rendering command used on scenes
    func render(with commandEncoder: MTLRenderCommandEncoder, deltaTime: Float) {

        sceneConstants.projectionMatrix = camera.projectionMatrix
        
        commandEncoder.setVertexBytes(&sceneConstants, length: MemoryLayout<SceneConstants>.stride, at: 2)
        
        update(with: deltaTime)
        for child in children {
            // camera view matrix gets altered in the scene sublcass
            child.renderNode(with: commandEncoder, parentModelViewMatrix: camera.viewMatrix)
        }
    }
    
    func sizeWillChange(to size: CGSize) {
        camera.aspect = Float(size.width / size.height)
    }
}
