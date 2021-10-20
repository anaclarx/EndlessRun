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
    
    //MARK: Components
    private var player = SKSpriteNode()
    
    private var playerRunning: [SKTexture] = []
    
    private var playerJumping: [SKTexture] = []
    
    private var playerAttacking: [SKTexture] = []
    
    var statePlayer = "running"
    
    //let playerAction: SKAction
    
    private let platform: Ground = Ground()
    
    private let obstaculo: Obstacle = Obstacle()
    
    private let flyingobstaculo: FlyingObstacle = FlyingObstacle()
    
    private let point: Points = Points()
    
    var pressed = false
    
    var isGameEnded = false
    
    var isCharacterOnGround = false
    
    var score = 0
    
    var isPlayerDoubleJumping = false
    
    var arrayObst:[FlyingObstacle] = []
    
    var arrayPoints:[Points] = []
    
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
        backgroundColor = SKColor.gray
        // 3
        buildPlayer()
        if statePlayer == "running"{
            animateRunning()
        }
        if statePlayer == "jumping"{
            animateJump()
        }
        if statePlayer == "attacking"{
            animateAttack()
        }
        addChild(scoreLabel)
        setUpScenario()
    }
    
    func endGame(hitobstaculo: Bool){
        if isGameEnded{
            return
        }
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = true
        for obs in arrayObst {
            obs.removeFromParent()
        }
        arrayObst.removeAll()
        platform.removeFromParent()
        addChild(gameOver)
        addChild(tapLabel)
    }
    
    func runActionNodes(){
        if(isGameEnded == false){
            run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(addObstaculo),
                    SKAction.wait(forDuration: random(min: 6, max: 12))
                ])
            ))
            //classe que cuida das actions e add obstaculo
            run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(addFlyingObstaculo),
                    SKAction.wait(forDuration: random(min: 7, max: 12)),
                    SKAction.run(addPoint),
                    SKAction.wait(forDuration: random(min: 3, max: 5))
                ])
            ))
        }
        
    }
    
    func reset(){
        self.gameOver.removeFromParent()
        self.tapLabel.removeFromParent()
        scene?.physicsWorld.speed = 0.5
        self.isGameEnded = false
        self.score = 0
        adjustScore(by: score)
        resetPlayer()
        setUpScenario()
        //alterar função:
        FlyingObstacle.actualDuration = 3.4
    }
    
    func resetPlayer(){
        addChild(player)
    }
    
    func setUpScenario(){
        runActionNodes()
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
            self.touchDown(atPoint: t.location(in: self)) }
    }
    
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        self.pressed = false
        for t in touches { self.touchUp(atPoint: t.location(in: self)) }
        
    }
    
    func jump(){
        statePlayer = "jumping"
        if(self.isCharacterOnGround){
            player.texture = SKTexture(imageNamed: "pulo_1")
            animateJump()
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 240))
            isJumping = true
            self.isCharacterOnGround = false
            return
        }
        
        if(isJumping == true && isPlayerDoubleJumping == false && isCharacterOnGround == false){
            if(player.position.y > platform.position.y + platform.size.height*1.2){
                jumpImpulse(impulso: 160)
                animateJump()
                return
            }
            else{
                jumpImpulse(impulso: 160)
                player.run((
                    SKAction.animate(with: [playerJumping[1], playerJumping[2], playerJumping[3]],
                                     timePerFrame: 0.25,
                                     resize: false,
                                     restore: true)),
                           withKey:"jumpingInPlace")
                return
            }
        }
    }
    
    func jumpImpulse(impulso: CGFloat){
        player.texture = SKTexture(imageNamed: "correndo1")
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: impulso))
        isJumping = false
        isPlayerDoubleJumping = false
    }
    
    
    func attack(){
        if arrayObst.count == 0 {return}
        else{
            if(CGPointDistance(from: player.position, to: arrayObst[0].position) <= CGFloat(100)){
                removeObstArray()
            }
            else{return}
        }
    }
    
    func touchDown(atPoint pos: CGPoint) {
        if pos.x >= 0{
            jump()
        }
        else{
            attack()
            animateAttack()
            statePlayer = "attacking"
        }
    }
    
    
    func touchUp(atPoint pos: CGPoint) {
        player.texture = SKTexture(imageNamed: "correndo1")
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
        if isGameEnded{return}
        let obstaculo = Obstacle()
        addChild(obstaculo)
        animateToco(obst: obstaculo)
        obstaculo.runOverScene()
        
    }
    
    func playerCollideWithObstaculo(projectile: SKSpriteNode, monster: SKSpriteNode){
        monster.removeFromParent()
        endGame(hitobstaculo: isGameEnded)
    }
    
    func removeObstArray(){
        if arrayObst.count == 0 {return}
        arrayObst[0].removeFromParent()
        arrayObst[0].removeAllActions()
        arrayObst.removeFirst()
    }
    
    func addFlyingObstaculo() {
        
        if isGameEnded{return}
        let flyobstaculo = FlyingObstacle()
        arrayObst.append(flyobstaculo)
        addChild(flyobstaculo)
        animateSerra(serra: flyobstaculo)
        flyobstaculo.runOverScene(completion: removeObstArray)
        
    }
    
}

//MARK: Point

extension GameScene{
    
    func addPoint() {
        
        if isGameEnded{return}
        let point = Points()
        arrayPoints.append(point)
        addChild(point)
        point.runOverScene(completion: removeObstArray)
        
    }
    
    func adjustScore(by points: Int) {
        score += points
        scoreLabel.text = "Points: \(score)"
        
    }
    func playerCollideWithPoint(point: SKSpriteNode, monster: SKSpriteNode) {
        point.removeFromParent()
        adjustScore(by: 1)
        
    }
    
}

//MARK: Player
extension GameScene{
    
    func buildPlayer() {
        
        var runningFrames: [SKTexture] = []
        var jumpingFrames: [SKTexture] = []
        for i in stride(from: 1, through: 4, by: 1) {
            let playerTextureName = "sisifo_\(i)"
            runningFrames.append(SKTexture(imageNamed: playerTextureName))
        }
        let playerJumpName = "pulo_1"
        jumpingFrames.append(SKTexture(imageNamed: playerJumpName))
        playerAttacking.append(SKTexture(imageNamed: "ataque"))
        playerJumping = jumpingFrames
        let firstFrameTexture = playerJumping[0]
        player = SKSpriteNode(texture: firstFrameTexture)
        playerRunning = runningFrames
        let firstTexture = playerRunning[0]
        player = SKSpriteNode(texture: firstTexture)
        player.position = CGPoint(x: -140, y: platform.position.y + platform.size.height)
        player.size = CGSize(width: 103, height: 80)
        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.monster
        player.physicsBody?.contactTestBitMask = PhysicsCategory.projectile | PhysicsCategory.platformCategory
        player.physicsBody?.collisionBitMask =  PhysicsCategory.platformCategory
        addChild(player)
    }
    
    func animateRunning() {
        player.run(SKAction.repeatForever(
            SKAction.animate(with: playerRunning,
                             timePerFrame: 0.1,
                             resize: false,
                             restore: true)),
                   withKey:"runningInPlace")
    }
    
    func animateJump() {
        player.run((
            SKAction.animate(with: playerJumping,
                             timePerFrame: 0.25,
                             resize: false,
                             restore: true)),
                   withKey:"jumpingInPlace")
    }
    
    func animateAttack() {
        player.run((
            SKAction.animate(with: playerAttacking,
                             timePerFrame: 0.25,
                             resize: false,
                             restore: true)),
                   withKey:"jumpingInPlace")
    }
    
    func animateToco(obst: Obstacle){
        obst.run(SKAction.repeatForever(SKAction.animate(with: obstaculo.tocoFrames,timePerFrame: 0.4,resize: false,restore: true)), withKey: "animateToco")
    }
    
    func animateSerra(serra: FlyingObstacle){
        serra.run(SKAction.repeatForever(SKAction.animate(with: flyingobstaculo.serraFrames,timePerFrame: 0.4,resize: false,restore: true)), withKey: "animateToco")
    }
}

//MARK: Secondary Functions:

extension GameScene{
    
    func CGPointDistanceSquared(from: CGPoint, to: CGPoint) -> CGFloat {
        return (from.x - to.x) * (from.x - to.x) + (from.y - to.y) * (from.y - to.y)
    }
    
    func CGPointDistance(from: CGPoint, to: CGPoint) -> CGFloat {
        return sqrt(CGPointDistanceSquared(from: from, to: to))
    }
    
    func random() -> CGFloat {
        return CGFloat(Float(arc4random()) / 0xFFFFFFFF)
    }
    
    func random(min: CGFloat, max: CGFloat) -> CGFloat{
        return random() * (max - min) + min
    }
    
}

