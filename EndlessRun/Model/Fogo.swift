//
//  Fogo.swift
//  EndlessRun
//
//  Created by Ana Clara Filgueiras Granato on 16/11/21.
//

import Foundation
import SpriteKit

class Fogo: SKSpriteNode{
    
    private let platform: Ground = Ground()
    var fogoFrames: [SKTexture] = []
    private var fogo = SKSpriteNode()
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    init(){
        
        
        for i in stride(from:1, through: 2, by: 1){
            let texture = SKTexture(imageNamed: "fogo \(i)")
            fogoFrames.append(texture)
        }
        super.init(texture: fogoFrames[0], color: .clear, size: fogoFrames[0].size())
        self.size = CGSize(width: 190, height: 289)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        self.physicsBody?.contactTestBitMask = PhysicsCategory.monster | PhysicsCategory.platformCategory
        self.physicsBody?.collisionBitMask =  PhysicsCategory.platformCategory
        self.physicsBody?.affectedByGravity = true
        self.position = CGPoint(x: -430 , y:  platform.position.y + platform.size.height/2 + self.size.height/2 - 70)
        self.zPosition = 1
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
