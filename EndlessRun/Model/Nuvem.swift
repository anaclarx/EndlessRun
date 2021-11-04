//
//  Nuvem.swift
//  EndlessRun
//
//  Created by Ana Clara Filgueiras Granato on 04/11/21.
//

import Foundation
//
//  FlyingObstacle.swift
//  EndlessRun
//
//  Created by Ana Clara Filgueiras Granato on 23/09/21.
//

import Foundation
import SpriteKit

class Nuvem: SKSpriteNode{
    
    private let platform: Ground = Ground()
    var nuvemFrames: [SKTexture] = []
    private var nuvem = SKSpriteNode()
    var actualY: CGFloat = 30
    static var actualDuration = 2.5
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    func runOverScene(){
        //Roda pela Scene de ponta a ponta, se ela existe.
        guard let parent = self.parent else {return}
        self.position.x = parent.frame.maxX + self.size.width
        let destination = CGPoint(x: 2*parent.frame.minX , y: actualY)
        let runAction = SKAction.move(to: destination, duration: TimeInterval(Self.actualDuration))
        run(runAction)
        if Self.actualDuration > 0{
            Self.actualDuration *= 0.85
        }
    }
    
    
    init(){
        for i in stride(from:1, through: 3, by: 1){
            let texture = SKTexture(imageNamed: "nuvem\(i)")
            nuvemFrames.append(texture)
        }
        super.init(texture: nuvemFrames[0], color: .clear, size: nuvemFrames[0].size())
        self.size = CGSize(width: 164, height: 65)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        self.physicsBody?.contactTestBitMask = PhysicsCategory.monster | PhysicsCategory.platformCategory
        self.physicsBody?.collisionBitMask =  PhysicsCategory.platformCategory
        self.physicsBody?.affectedByGravity = true
        self.position = CGPoint(x:size.width + self.size.width/2, y:  actualY)
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
