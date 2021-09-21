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
    
    // 1
    let player = SKSpriteNode(imageNamed: "boneco.png")
    
    private let platform: Ground = Ground()
    
    private let obstaculo: Obstacle = Obstacle()
    
    var pressed = false
    
    var isGameEnded = false
    
    var isCharacterOnGround = false
    
    var score = 0
    
    var isPlayerDoubleJumping = false
    
    var arrayObst:[Obstacle] = []
    
    var isJumping = false
    
    lazy var scoreLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Arial-BoldMT")
        label.fontSize = 20
        label.fontColor = SKColor.black
        label.position = CGPoint(x:  -190, y: 120 )
        label.text = "Points: 0"
        return label
    }()
    
    var gameOver: SKSpriteNode = {
        let gameOver = SKSpriteNode(imageNamed: "gameOver")
        gameOver.size = CGSize(width: UIScreen.main.bounds.width / 3, height: UIScreen.main.bounds.height / 3)
        gameOver.position = CGPoint(x: 0, y: 0 + 20)
        return gameOver
    }()
    
    lazy var tapLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Arial-BoldMT")
        label.fontSize = 20
        label.fontColor = SKColor.black
        label.position = CGPoint(x:  gameOver.position.x, y: -50 )
        label.text = "Tap anywhere to try again"
        return label
    }()
    
    //MARK: Methods
    
    override func didMove(to view: SKView) {
        
        physicsWorld.contactDelegate = self
        physicsWorld.speed = 0.5
        //Setup borders so elements can't escape from us :-)
        self.physicsBody = SKPhysicsBody(edgeLoopFrom: self.frame)
        
        // 2
        backgroundColor = SKColor.white
        // 3
        player.position = CGPoint(x: -100, y: platform.position.y + platform.size.height)
        player.size = CGSize(width: 25, height: 25)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.monster
        player.physicsBody?.contactTestBitMask = PhysicsCategory.projectile | PhysicsCategory.platformCategory
        player.physicsBody?.collisionBitMask =  PhysicsCategory.platformCategory
        addChild(player)
        // 4
        
        addChild(scoreLabel)
        setUpScenario()
        if isGameEnded == false{
        run(SKAction.repeatForever(
            SKAction.sequence([
                SKAction.run(addObstaculo),
                SKAction.wait(forDuration: 1),
                SKAction.run(addPoint),
                SKAction.wait(forDuration: 1.5)
            ])
        ))
        }
    }
    
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
    func endGame(hitobstaculo: Bool){
        
        if isGameEnded{return}
        
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = true
        arrayObst.removeAll()
        //removeAllChildren()
        
        addChild(gameOver)
        addChild(tapLabel)
        
        
    }
    
    func reset(){
        self.gameOver.removeFromParent()
        self.tapLabel.removeFromParent()
        //self.pauseLayer?.isHidden = true
        //pauseButton.texture = SKTexture(imageNamed: "Pause")
        scene?.physicsWorld.speed = 0.5
        self.isGameEnded = false
        self.score = 0
        adjustScore(by: score)
        addObstaculo()
        resetPlayer()
        addPoint()
        
        
    }
    
    func resetPlayer(){
        addChild(player)
    }
    
    func setUpScenario(){
        addChild(platform)
    }
    
}

// MARK: Jump and Touchs Handler

extension GameScene: SKPhysicsContactDelegate {
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if(isGameEnded){
            reset()
            return
        }
        for t in touches {
            print("entrou")
            self.touchDown(atPoint: t.location(in: self)) }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.pressed = false
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        
    }
    
    func jump(){
        
        if(self.isCharacterOnGround){
            player.texture = SKTexture(imageNamed: "boneco")
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 12))
            isJumping = true
            self.isCharacterOnGround = false
            return
        }
        
        if(isJumping == true && isPlayerDoubleJumping == false && isCharacterOnGround == false){
            player.texture = SKTexture(imageNamed: "boneco")
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 12))
            isJumping = false
            isPlayerDoubleJumping = false
            return
        }
    }
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    
    func attack(){
        if arrayObst.count == 0 {return}
        else{
            if(CGPointDistance(from: player.position, to: arrayObst[0].position) <= CGFloat(100)){
                removeObstArray()
            }
        }
    }
    
    func touchDown(atPoint pos: CGPoint) {
        if pos.x >= 0{
            jump()
        }
        else{
            attack()
        }
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
    
    func removeObstArray(){
        arrayObst[0].removeFromParent()
        arrayObst.removeFirst()
    }
    
    func addObstaculo() {
        
        if isGameEnded{return}
        let obstaculo = Obstacle()
        arrayObst.append(obstaculo)
        addChild(obstaculo)
        obstaculo.runOverScene(completion: removeObstArray)
        
    }
    
    func playerCollideWithObstaculo(projectile: SKSpriteNode, monster: SKSpriteNode){
        monster.removeFromParent()
        endGame(hitobstaculo: isGameEnded)
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
        
        point.position = CGPoint(x: size.width + point.size.width/2, y:  platform.position.y + 60 +  random(min: CGFloat(0), max: CGFloat(20.0)))
        
        
        
        addChild(point)
        
        let actualDuration = random(min: CGFloat(3.0), max: CGFloat(7.0))
        
        let actionMove = SKAction.move(to: CGPoint(x: point.size.width - 1000, y: platform.position.y + 60 +  random(min: CGFloat(0), max: CGFloat(5.0))), duration: TimeInterval(actualDuration))
        
        let actionMoveDone = SKAction.removeFromParent()
        
        if isGameEnded{return}
        
        else{point.run(SKAction.sequence([actionMove, actionMoveDone]))}
        
    }
    
    func adjustScore(by points: Int) {
        score += points
        scoreLabel.text = "Points: \(score)"
        
    }
    func playerCollideWithPoint(point: SKSpriteNode, monster: SKSpriteNode) {
        print("Hit")
        
        point.removeFromParent()
        adjustScore(by: 1)
        
    }
    
}


