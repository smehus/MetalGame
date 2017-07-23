//
//  Texturable.swift
//  MetalGame
//
//  Created by scott mehus on 7/23/17.
//  Copyright © 2017 scott mehus. All rights reserved.
//

import MetalKit

protocol Texturable {
    var texture: MTLTexture? { get }
}

extension Texturable {
    func loadTexture(device: MTLDevice, image: UIImage) -> MTLTexture? {
        guard let cgImage = image.cgImage else { return nil }
        
        let textureLoader = MTKTextureLoader(device: device)
        var texture: MTLTexture? = nil
        let textureLoaderOptions = [MTKTextureLoaderOptionOrigin: NSString(string: MTKTextureLoaderOriginBottomLeft)]
        
        do {
            texture = try textureLoader.newTexture(with: cgImage, options: textureLoaderOptions)
        } catch let error as NSError {
            fatalError("Failed to load texture: \(error.localizedDescription)")
        }
        
        return texture
    }
}
