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
}
