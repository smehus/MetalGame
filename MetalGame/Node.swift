//
//  Node.swift
//  MetalGame
//
//  Created by scott mehus on 7/19/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

class Node {
    
    var children: [Node] = []
    
    func add(_ child: Node) {
        children.append(child)
    }
    
    func render(with commandEncoder: MTLRenderCommandEncoder, delta: Float) {
        for child in children {
            child.render(with: commandEncoder, delta: delta)
        }
    }
}
