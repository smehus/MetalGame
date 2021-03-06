//
//  Types.swift
//  MetalGame
//
//  Created by scott mehus on 7/18/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

enum Colors {
    case skyBlue
    
    var mtlColor: MTLClearColor {
        switch self {
        case .skyBlue:
            return MTLClearColor(red: 0.66, green: 0.9, blue: 0.96, alpha: 1.0)
        }
    }
}

struct ModelConstants {
    var modelViewMatrix = matrix_identity_float4x4
    var normalMatrix = matrix_identity_float3x3
    var specularIntensity: Float = 1
    var shininess: Float = 1
}

struct SceneConstants {
    var projectionMatrix = matrix_identity_float4x4
}

struct Light {
    var color = float3(1)
    var ambientIntensity: Float = 1.0
    var diffuseIntensity: Float = 1.0
    var direction = float3(0)
}

struct Vertex {
    var position: float3
    var color: float4
    var texture: float2
    
    init(position: float3, color: float4, texture: float2) {
        self.position = position
        self.color = color
        self.texture = texture
    }
    
    init(position: float3, color: float4) {
        self.position = position
        self.color = color
        texture = float2(1, 1)
    }
}

enum ShaderFunction {
    case vertex
    case fragment
    case texturedFragment
    case texturedFragmentLit
    
    var name: String {
        switch self {
        case .vertex:
            return "vertex_shader"
        case .fragment:
            return "fragment_shader"
        case .texturedFragment:
            return "textured_fragment"
        case .texturedFragmentLit:
            return "lit_textured_fragment"
        }
    }
}
