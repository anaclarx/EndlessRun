//
//  Obstaculo.swift
//  EndlessRun
//
//  Created by Ana Clara Filgueiras Granato on 17/09/21.
//

import Foundation
import SpriteKit

class Obstacle: SKSpriteNode{
    
    private let platform: Ground = Ground()
    var tocoFrames: [SKTexture] = []
    private var toco = SKSpriteNode()
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    func runOverScene(){
        //Roda pela Scene de ponta a ponta, se ela existe.
        let actualDuration = 3.5
        guard let parent = self.parent else {return}
        self.position.x = parent.frame.maxX + self.size.width
        let destination = CGPoint(x: 2*parent.frame.minX , y: platform.position.y + platform.size.height/2 + self.size.height/2 - 20)
        let runAction = SKAction.move(to: destination, duration: TimeInterval(actualDuration))
        let deleteAction = SKAction.removeFromParent()
        run(SKAction.repeatForever(SKAction.sequence([runAction, deleteAction])))
    }
    
    
    init(){
        
        
        for i in stride(from:1, through: 2, by: 1){
            let texture = SKTexture(imageNamed: "toco_\(i)")
            tocoFrames.append(texture)
        }
        super.init(texture: tocoFrames[0], color: .clear, size: tocoFrames[0].size())
        self.size = CGSize(width: 140, height: 110)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        self.physicsBody?.contactTestBitMask = PhysicsCategory.monster | PhysicsCategory.platformCategory
        self.physicsBody?.collisionBitMask =  PhysicsCategory.platformCategory
        self.physicsBody?.affectedByGravity = true
        self.position = CGPoint(x: size.width + self.size.width/2, y:  platform.position.y + platform.size.height/2 + self.size.height/2 - 20)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
