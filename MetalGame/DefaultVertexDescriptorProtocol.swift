//
//  DefaultVertexDescriptorProtocol.swift
//  MetalGame
//
//  Created by scott mehus on 7/21/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

protocol ModelVertexDescriptor {
    var vertexDescriptor: MTLVertexDescriptor { get }
}

extension ModelVertexDescriptor {
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        vertexDescriptor.attributes[1].format = .float4
        vertexDescriptor.attributes[1].offset = MemoryLayout<Float>.stride * 3
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<Float>.stride * 7
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].offset = MemoryLayout<Float>.stride * 9
        vertexDescriptor.attributes[3].bufferIndex = 0
        
        vertexDescriptor.layouts[0].stride = MemoryLayout<Float>.stride * 12
        
        return vertexDescriptor
    }
    
}

protocol DefaultVertexDescriptorProtocol {
    var vertexDescriptor: MTLVertexDescriptor { get }
}

extension DefaultVertexDescriptorProtocol {
    var vertexDescriptor: MTLVertexDescriptor {
        let vertexDescriptor = MTLVertexDescriptor()
        
        // position data
        vertexDescriptor.attributes[0].format = .float3
        vertexDescriptor.attributes[0].offset = 0
        // Index that goes into the shader?
        vertexDescriptor.attributes[0].bufferIndex = 0
        
        // color data
        vertexDescriptor.attributes[1].format = .float4
        // size of the first data index - aka. position
        vertexDescriptor.attributes[1].offset = MemoryLayout<float3>.stride
        // Index that goes into the shader?
        vertexDescriptor.attributes[1].bufferIndex = 0
        
        vertexDescriptor.attributes[2].format = .float2
        vertexDescriptor.attributes[2].offset = MemoryLayout<float3>.stride + MemoryLayout<float4>.stride
        vertexDescriptor.attributes[2].bufferIndex = 0
        
        vertexDescriptor.attributes[3].format = .float3
        vertexDescriptor.attributes[3].offset = MemoryLayout<Float>.stride * 9
        vertexDescriptor.attributes[3].bufferIndex = 0
        
        // size of the information
        vertexDescriptor.layouts[0].stride = MemoryLayout<Vertex>.stride
        
        return vertexDescriptor
    }
    
}
