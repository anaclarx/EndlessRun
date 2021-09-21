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
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    func runOverScene(completion: @escaping ()->()){
        //Roda pela Scene de ponta a ponta, se ela existe.
        let actualDuration = random(min: CGFloat(3.0), max: CGFloat(4.0))
        guard let parent = self.parent else {return}
        self.position.x = parent.frame.maxX + self.size.width
        let destination = CGPoint(x: 2*parent.frame.minX , y: platform.position.y + platform.size.height/2 + self.size.height/2 )
        let runAction = SKAction.move(to: destination, duration: TimeInterval(actualDuration))
        run(runAction, completion: completion)
    }
    
    
    init(){
        
        let texture = SKTexture(imageNamed: "obstaculo.png")
        
        super.init(texture: texture, color: .clear, size: texture.size())
        self.size = CGSize(width: 25, height: 25)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        self.physicsBody?.contactTestBitMask = PhysicsCategory.monster | PhysicsCategory.platformCategory
        self.physicsBody?.collisionBitMask =  PhysicsCategory.platformCategory
        self.physicsBody?.affectedByGravity = true
        
        self.position = CGPoint(x: size.width + self.size.width/2, y:  platform.position.y + platform.size.height/2 + self.size.height/2)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
