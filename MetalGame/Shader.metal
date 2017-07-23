//
//  Shader.metal
//  MetalGame
//
//  Created by scott mehus on 7/18/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

#include <metal_stdlib>
using namespace metal;

struct SceneConstants {
    float4x4 projectionViewMatrix;
};

struct ModelConstants {
    float4x4 modelViewMatrix;
};

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]] ;
    float2 textureCoordinates [[ attribute(2) ]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float2 textureCoordinates;
};

vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                               constant ModelConstants &modelConstants [[ buffer(1) ]],
                               constant SceneConstants &sceneConstants [[ buffer (2) ]]) {
    VertexOut vertexOut;
    
    float4x4 matrix = sceneConstants.projectionViewMatrix * modelConstants.modelViewMatrix;
    vertexOut.position = matrix * vertexIn.position;
    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
    vertexOut.color = vertexIn.color;
    
    return vertexOut;
}

fragment float4 fragment_shader(VertexOut inVertex [[stage_in]]) {
    return inVertex.color;
}



// Textures

fragment float4 textured_fragment(VertexOut inVertex [[stage_in ]],
                                  sampler sampler2d [[ sampler(0) ]],
                                  texture2d<float> texture [[ texture(0) ]]) {
    
    float4 color = texture.sample(sampler2d, inVertex.textureCoordinates);
    return float4(color.r, color.g, color.b, 1.0);
    
}





