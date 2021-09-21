//
//  PhysicsCategory.swift
//  EndlessRun
//
//  Created by Ana Clara Filgueiras Granato on 17/09/21.
//

import Foundation

struct PhysicsCategory {
    static let none      : UInt32 = 0
    static let all       : UInt32 = UInt32.max
    static let monster   : UInt32 = 0x1 << 0       // 1
    static let projectile: UInt32 = 0x1 << 1
    static let platformCategory : UInt32 = 0x1 << 2
    static let point: UInt32 = 0x1 << 3
}
