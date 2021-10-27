//
//  Points.swift
//  EndlessRun
//
//  Created by Ana Clara Filgueiras Granato on 22/09/21.
//

import Foundation
import SpriteKit

class Points: SKSpriteNode{

    private let platform: Ground = Ground()
    var pointsFrames: [SKTexture] = []
    private var point = SKSpriteNode()
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    func runOverScene(completion: @escaping ()->()){
        //Roda pela Scene de ponta a ponta, se ela existe.
        let actualDuration = 3
        guard let parent = self.parent else {return}
        self.position.x = parent.frame.maxX + self.size.width
        let destination = CGPoint(x: 2*parent.frame.minX , y: platform.position.y + 60 +  random(min: CGFloat(0), max: CGFloat(20.0)))
        let runAction = SKAction.move(to: destination, duration: TimeInterval(actualDuration))
        run(runAction, completion: completion)
    }
    
    
    init(){
        
        for i in stride(from:1, through: 5, by: 1){
            let texture = SKTexture(imageNamed: "capsula_\(i)")
            pointsFrames.append(texture)
        }
        super.init(texture: pointsFrames[0], color: .clear, size: pointsFrames[0].size())
        self.size = CGSize(width: 45, height: 45)
        self.physicsBody = SKPhysicsBody(rectangleOf: self.size)
        self.physicsBody?.isDynamic = false
        self.physicsBody?.categoryBitMask = PhysicsCategory.point
        self.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        self.physicsBody?.collisionBitMask =  PhysicsCategory.monster
        self.physicsBody?.affectedByGravity = false
        
        self.position = CGPoint(x: size.width + self.size.width/2, y:  platform.position.y + 60 +  random(min: CGFloat(0), max: CGFloat(20.0)))

        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
