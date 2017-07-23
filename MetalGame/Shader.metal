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
    float3x3 normalMatrix;
    float specularIntensity;
    float shininess;
};

struct VertexIn {
    float4 position [[attribute(0)]];
    float4 color [[attribute(1)]] ;
    float2 textureCoordinates [[ attribute(2) ]];
    float3 normal [[ attribute(3) ]];
};

struct VertexOut {
    float4 position [[position]];
    float4 color;
    float2 textureCoordinates;
    float3 normal;
    float specularIntensity;
    float shininess;
    float3 eyePosition;
};

struct Light {
    float3 color;
    float ambientIntensity;
    float diffuseIntensity;
    float3 direction;
};

vertex VertexOut vertex_shader(const VertexIn vertexIn [[ stage_in ]],
                               constant ModelConstants &modelConstants [[ buffer(1) ]],
                               constant SceneConstants &sceneConstants [[ buffer (2) ]]) {
    VertexOut vertexOut;
    
    float4x4 matrix = sceneConstants.projectionViewMatrix * modelConstants.modelViewMatrix;
    vertexOut.position = matrix * vertexIn.position;
    vertexOut.textureCoordinates = vertexIn.textureCoordinates;
    vertexOut.color = vertexIn.color;
    vertexOut.shininess = modelConstants.shininess;
    vertexOut.specularIntensity = modelConstants.specularIntensity;
    vertexOut.normal = modelConstants.normalMatrix * vertexIn.normal;
    vertexOut.normal = modelConstants.normalMatrix * vertexIn.normal;
    vertexOut.eyePosition = (modelConstants.modelViewMatrix * vertexIn.position).xyz;
    
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

fragment float4 lit_textured_fragment(VertexOut inVertex [[stage_in ]],
                                  sampler sampler2d [[ sampler(0) ]],
                                  constant Light &light [[ buffer(3) ]],
                                  texture2d<float> texture [[ texture(0) ]]) {
    
    float4 color = texture.sample(sampler2d, inVertex.textureCoordinates);
    
    float3 ambientColor = light.color * light.ambientIntensity;
    
    float3 normal = normalize(inVertex.normal);
    float diffuseFactor = saturate(-dot(normal, light.direction));
    float3 diffuseColor = light.color * light.diffuseIntensity * diffuseFactor;
    
    // Specular
    float3 eye = normalize(inVertex.eyePosition);
    float3 reflection = reflect(light.direction, normal);
    float specularFactor = pow(saturate(-dot(reflection, eye)), inVertex.shininess);
    float3 specularColor = light.color * inVertex.specularIntensity * specularFactor;
    
    
    color = color * float4((ambientColor + diffuseColor + specularColor), 1);
    
    if (color.a == 0)
        discard_fragment();
    
    return float4(color.r, color.g, color.b, 1.0);
    
}




