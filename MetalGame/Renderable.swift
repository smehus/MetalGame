//
//  Renderable.swift
//  MetalGame
//
//  Created by scott mehus on 7/20/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

protocol Renderable {
    var vertices: [Vertex]  { get }
    var vertexBuffer: MTLBuffer? { get set }
    func performRender(with commandBuffer: MTLRenderCommandEncoder)
}

extension Renderable {
    
}
