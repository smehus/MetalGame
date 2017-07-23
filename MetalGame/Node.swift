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
    
    var position = float3(0)
    var rotation = float3(0)
    var scale = float3(1)
    
    var modelMatrix: matrix_float4x4 {
        var matrix = matrix_float4x4(translationX: position.x, y: position.y, z: position.z)
        
        matrix = matrix.rotatedBy(rotationAngle: rotation.x, x: 1, y: 0, z: 0)
        matrix = matrix.rotatedBy(rotationAngle: rotation.y, x: 0, y: 1, z: 0)
        matrix = matrix.rotatedBy(rotationAngle: rotation.z, x: 0, y: 0, z: 1)
        
        matrix = matrix.scaledBy(x: scale.x, y: scale.y, z: scale.z)
        
        return matrix
    }
    
    func add(_ child: Node) {
        children.append(child)
    }
    
    func renderNode(with commandEncoder: MTLRenderCommandEncoder, parentModelViewMatrix: matrix_float4x4) {
        
        // Camera matrix multiplied by this nodes model matrix
        // model view matrix = view matirx multiplied by the model matrix
        // Nothing to do with vertices... kinda
        let modelViewMatrix = matrix_multiply(parentModelViewMatrix, modelMatrix)
        
        for child in children {
            /// Recursively calls this same function in order to climb down the ladder - eventually calling the perform render on all nodes
            /// Some nodes don't want to be renderd. i.e. parent container nodes
            child.renderNode(with: commandEncoder, parentModelViewMatrix: parentModelViewMatrix)
        }
        
        if let renderable = self as? Renderable {
            renderable.performRender(with: commandEncoder, modelViewMatrix: modelViewMatrix)
        }
    }
}
