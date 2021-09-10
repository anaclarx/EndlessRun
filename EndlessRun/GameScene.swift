//
//  GameScene.swift
//  EndlessRun
//
//  Created by Ana Clara Filgueiras Granato on 01/09/21.
//

import SpriteKit
import UIKit
import GameplayKit

class GameScene: SKScene {
    
    struct PhysicsCategory {
        static let none      : UInt32 = 0
        static let all       : UInt32 = UInt32.max
        static let monster   : UInt32 = 0x1 << 0       // 1
        static let projectile: UInt32 = 0x1 << 1
        static let platformCategory : UInt32 = 0x1 << 2
        static let point: UInt32 = 0x1 << 3
    }
    
    // 1
    let player = SKSpriteNode(imageNamed: "boneco.png")
    
    let platform = SKSpriteNode(color: .black, size: CGSize(width: 2000, height:15))
    
    var pressed = false
    
    var isGameEnded = false
    
    var isCharacterOnGround = false
    
    var score = 0
    
    
    
    //MARK: Methods
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.speed = 0.5
        //Setup borders so character can't escape from us :-)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        //        self.physicsBody?.categoryBitMask = PhysicsCategory.wallCategory
        //        self.physicsBody?.collisionBitMask = PhysicsCategory.characterCategory
        
        
        // 2
        backgroundColor = SKColor.white
        // 3
        player.position = CGPoint(x: size.width * 0.1, y: (UIScreen.main.bounds.width/2) + platform.size.height/2)
        player.size = CGSize(width: 25, height: 25)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.monster
        player.physicsBody?.contactTestBitMask = PhysicsCategory.projectile | PhysicsCategory.platformCategory
        player.physicsBody?.collisionBitMask =  PhysicsCategory.platformCategory
        
        // 4
        addChild(player)
        
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addObstaculo),
                SKAction.wait(forDuration: 2.5),
                SKAction.run(addPoint),
                SKAction.wait(forDuration: 1.5)
            ])
        ))
        generatePlatforms()
    }
    
    
    func generatePlatforms(){
        
        let position = CGPoint(x: frame.midX, y: UIScreen.main.bounds.height / 3)
        let platform = createPlatformAtPosition(position: position)
        self.addChild(platform)
        
    }
    
    func createPlatformAtPosition(position : CGPoint)->SKSpriteNode{
        
        
        platform.position = position
        
        platform.physicsBody =  SKPhysicsBody(rectangleOf: platform.size)
        
        platform.physicsBody?.categoryBitMask       = PhysicsCategory.platformCategory
        platform.physicsBody?.contactTestBitMask    = PhysicsCategory.monster | PhysicsCategory.projectile
        platform.physicsBody?.collisionBitMask      = PhysicsCategory.monster | PhysicsCategory.projectile
        platform.physicsBody?.allowsRotation        = false
        platform.name                               = "platform"
        platform.physicsBody?.isDynamic             = false
        
        return platform
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }

    func endGame(hitobstaculp: Bool){
        
        if isGameEnded{return}
        
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = false
        
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.size = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 3)
        gameOver.position = CGPoint(x: UIScreen.main.bounds.width / 2, y: (UIScreen.main.bounds.height / 2) - 40)
        addChild(gameOver)
        
        
    }
    
}

extension GameScene: SKPhysicsContactDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for t in touches { self.touchDown(atPoint: t.location(in: self)) }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.pressed = false
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        
    }
    
    func jump(){
        if(self.isCharacterOnGround){
            player.texture = SKTexture(imageNamed: "boneco")
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 15))
            self.isCharacterOnGround = false
        }
    }
    
    func touchDown(atPoint pos: CGPoint) {
        jump()
    }
    
    
    func touchUp(atPoint pos: CGPoint) {
        player.texture = SKTexture(imageNamed: "boneco")
    }
    
    override func update(_ currentTime: TimeInterval) {
        
    }
    
    func didBegin(_ contact: SKPhysicsContact){
        
        var firstBody: SKPhysicsBody
        var secondBody: SKPhysicsBody
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask{
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        }
        
        else{
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if((firstBody.categoryBitMask & PhysicsCategory.monster != 0) && (secondBody.categoryBitMask & PhysicsCategory.projectile != 0 )){
            if let monster = firstBody.node as? SKSpriteNode, let projectile = secondBody.node as? SKSpriteNode{
                playerCollideWithObstaculo(projectile: projectile, monster: monster)
            }
        }
        
        if((firstBody.categoryBitMask & PhysicsCategory.monster != 0) && (secondBody.categoryBitMask & PhysicsCategory.point != 0 )){
            if let monster = firstBody.node as? SKSpriteNode, let point = secondBody.node as? SKSpriteNode{
               playerCollideWithPoint(point: point , monster: monster)
            }
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.monster) != 0 &&
                (secondBody.categoryBitMask & PhysicsCategory.platformCategory != 0)){
            
            player.physicsBody?.collisionBitMask = PhysicsCategory.platformCategory
            self.isCharacterOnGround = true
            
            if(self.pressed){
                let characterDx = player.physicsBody?.velocity.dx
                player.physicsBody?.velocity = CGVector(dx: characterDx!, dy: 0.0)
                jump()
            }
        }
    }
    
    
    func didEnd(_ contact: SKPhysicsContact) {
        
        var firstBody, secondBody: SKPhysicsBody
        
        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
            firstBody = contact.bodyA
            secondBody = contact.bodyB
        } else {
            firstBody = contact.bodyB
            secondBody = contact.bodyA
        }
        
        if ((firstBody.categoryBitMask & PhysicsCategory.monster) != 0 &&
                (secondBody.categoryBitMask & PhysicsCategory.platformCategory != 0)) {
            
            let platform = secondBody.node as! SKSpriteNode
            let platformSurfaceYPos = platform.position.y + platform.size.height/2.0
            
            let player = contact.bodyB.node as! SKSpriteNode
            let playerLegsYPos = player.position.y - player.size.height/2.0
            
            if((platformSurfaceYPos <= playerLegsYPos)){
                player.physicsBody?.collisionBitMask = PhysicsCategory.platformCategory
                self.isCharacterOnGround = false
            }
        }
    }
    
    
    
}

//MARK: Obstaculo

extension GameScene{
    
    func addObstaculo() {
        //Create Sprite
        
        let obstaculo = SKSpriteNode(imageNamed: "obstaculo.png")
        
        obstaculo.size = CGSize(width: 25, height: 25)
        obstaculo.physicsBody = SKPhysicsBody(rectangleOf: obstaculo.size)
        obstaculo.physicsBody?.isDynamic = false
        obstaculo.physicsBody?.categoryBitMask = PhysicsCategory.projectile
        obstaculo.physicsBody?.contactTestBitMask = PhysicsCategory.monster | PhysicsCategory.platformCategory
        obstaculo.physicsBody?.collisionBitMask =  PhysicsCategory.platformCategory
        obstaculo.physicsBody?.affectedByGravity = true
        
        //let actualY = size.height * 0.5 - 5
        
        obstaculo.position = CGPoint(x: size.width + obstaculo.size.width/2, y:  platform.position.y + platform.size.height/2 + obstaculo.size.height/2)
        
        
        
        addChild(obstaculo)
        
        let actualDuration = random(min: CGFloat(3.0), max: CGFloat(7.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: obstaculo.size.width - 50, y: platform.position.y + platform.size.height/2 + obstaculo.size.height/2), duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        
        obstaculo.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    func playerCollideWithObstaculo(projectile: SKSpriteNode, monster: SKSpriteNode){
        monster.removeFromParent()
        endGame(hitobstaculp: isGameEnded)
    }
    
}

//MARK: Point

extension GameScene{
    
    func addPoint() {
        //Create Sprite
        
        let point = SKSpriteNode(imageNamed: "folha")
        
        point.size = CGSize(width: 25, height: 25)
        point.physicsBody = SKPhysicsBody(rectangleOf: point.size)
        point.physicsBody?.isDynamic = false
        point.physicsBody?.categoryBitMask = PhysicsCategory.point
        point.physicsBody?.contactTestBitMask = PhysicsCategory.monster
        point.physicsBody?.collisionBitMask =  PhysicsCategory.none
        point.physicsBody?.affectedByGravity = false
        
        //let actualY = size.height * 0.5 - 5
        
        point.position = CGPoint(x: size.width + point.size.width/2, y:  platform.position.y + 60 +  random(min: CGFloat(0), max: CGFloat(20.0)))
        
        
        
        addChild(point)
        
        let actualDuration = random(min: CGFloat(1.0), max: CGFloat(5.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: point.size.width - 50, y: platform.position.y + 60 +  random(min: CGFloat(0), max: CGFloat(5.0))), duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        
        point.run(SKAction.sequence([actionMove, actionMoveDone]))
        
    }
    
    func reloadScore(score: Int){
        let scoreLabel = SKLabelNode(fontNamed: "Chalkduster")
        scoreLabel.text = "Points = \(score)"
        scoreLabel.fontSize = 20
        scoreLabel.fontColor = SKColor.black
        scoreLabel.position = CGPoint(x:60 , y:10 )
        addChild(scoreLabel)
    }
    
    func adjustScore(by points: Int) {
        score += points
        reloadScore(score: score)
        
    }
    func playerCollideWithPoint(point: SKSpriteNode, monster: SKSpriteNode) {
        print("Hit")

        point.removeFromParent()
        adjustScore(by: 1)

        }
    
}
