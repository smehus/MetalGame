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
