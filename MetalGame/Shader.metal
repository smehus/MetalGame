//
//  Shader.metal
//  MetalGame
//
//  Created by scott mehus on 7/18/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct ModelConstants {
    float4x4 modelViewMatrix;
};

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]] ;
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
};

vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]], constant ModelConstants &modelConstants [[ buffer(1) ]]) {
    VertexOut vertexOut;
    vertexOut.position = modelConstants.modelViewMatrix * vertexIn.position;
    vertexOut.color = vertexIn.color;
    
    return vertexOut;
}

fragment float4 fragment_shader(VertexOut inVertex [[stage_in]]) {
    return inVertex.color;
}
