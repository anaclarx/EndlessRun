//
//  Ground.swift
//  EndlessRun
//
//  Created by Ana Clara Filgueiras Granato on 17/09/21.
//

import Foundation
import SpriteKit

class Ground: SKSpriteNode {
    
    init (){
        
        super.init(texture: .none, color: .clear, size: CGSize(width: 2000, height:15))
        let position = CGPoint(x: frame.midX, y: -140)
        self.position = position
        
        self.physicsBody =  SKPhysicsBody(rectangleOf: self.size)
        
        self.physicsBody?.categoryBitMask       = PhysicsCategory.platformCategory
        self.physicsBody?.contactTestBitMask    = PhysicsCategory.monster | PhysicsCategory.projectile
        self.physicsBody?.collisionBitMask      = PhysicsCategory.monster | PhysicsCategory.projectile
        self.physicsBody?.allowsRotation        = false
        self.name                               = "platform"
        self.physicsBody?.isDynamic             = false
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
