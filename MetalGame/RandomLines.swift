//
//  RandomLines.swift
//  MetalGame
//
//  Created by scott mehus on 7/20/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

class RandomLines: Node, Renderable {
    
    var vertices: [Vertex] = []
    var vertexShader: ShaderFunction = .vertex
    var fragmentShader: ShaderFunction = .fragment
    
    init(device: MTLDevice) {
        super.init()
        buildVertices()
        buildBuffers(device: device)
        buildPipelineState(device: device)
    }
    
    
    private func buildVertices() {
        
    }
    
    
    func performRender(with commandBuffer: MTLRenderCommandEncoder) {
        guard let pipeline = pipelineState else {
            assertionFailure()
            return
        }
        
        
    }
}


