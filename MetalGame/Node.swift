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
    
    func render(with commandEncoder: MTLRenderCommandEncoder, parentModelViewMatrix: matrix_float4x4) {
        for child in children {
            /// Recursively calls this same function in order to climb down the ladder - eventually calling the perform render on all nodes
            /// Some nodes don't want to be renderd. i.e. parent container nodes
            child.render(with: commandEncoder, parentModelViewMatrix: parentModelViewMatrix)
        }
        
        if let renderable = self as? Renderable {
            renderable.performRender(with: commandEncoder, parentModelViewMatrix: parentModelViewMatrix)
        }
    }
}
