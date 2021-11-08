//
//  GameScene.swift
//  EndlessRun
//
//  Created by Ana Clara Filgueiras Granato on 01/09/21.
//

import SpriteKit
import UIKit
import GameplayKit
import AVKit
import AVFoundation

class GameScene: SKScene {
    
    //MARK: Components
    
    
    private var player = SKSpriteNode()
    
    private var playerRunning: [SKTexture] = []
    
    private var playerJumping: [SKTexture] = []
    
    private var playerAttacking: [SKTexture] = []
    
    var statePlayer = "running"
    
    var velocityBackground = 7.0
    
    //let playerAction: SKAction
    
    private let platform: Ground = Ground()
    
    private let obstaculo: Obstacle = Obstacle()
    
    private let lama: Lama = Lama()
    
    private let nuvem: Nuvem = Nuvem()
    
    private let vaca: Vaca = Vaca()
    
    var music: SKAudioNode!
    
    var jumpSound: SKAudioNode!

    
    private let flyingobstaculo: FlyingObstacle = FlyingObstacle()
    
    private let point: Points = Points()
    
    var pressed = false
    
    var isGameEnded = false
    
    var isCharacterOnGround = false
    
    var score = 0
    
    var highestScore = UserDefaults.standard.integer(forKey: "highScore")
    
    var isPlayerDoubleJumping = false
    
    var arrayFlyObst:[FlyingObstacle] = []
    
    var arrayObst:[Obstacle] = []
    
    var arrayPoints:[Points] = []
    
    var arrayNuvem:[Nuvem] = []
    
    var arrayLama:[Lama] = []
    
    var isJumping = false
    
    lazy var scoreLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Arial-BoldMT")
        label.fontSize = 20
        label.fontColor = SKColor.white
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
        if let musicURL = Bundle.main.url(forResource: "musica", withExtension: "wav") {
            music = SKAudioNode(url: musicURL)
            addChild(music)
        }
        music.run(SKAction.changeVolume(to: Float(0.3), duration: 0))
        addChild(scoreLabel)
        setUpScenario()
        createBackground()
        createRectangle()
    }
    
    override func update(_ currentTime: TimeInterval) {
        moveGround(velocity: velocityBackground)
    }
    
    func createRectangle(){
        let rectangle = SKSpriteNode()
        rectangle.size = UIScreen.main.bounds.size
        rectangle.color = .black
        rectangle.alpha = 0.5
        rectangle.zPosition = 1
        if(isGameEnded == true){
            self.addChild(rectangle)
        }
        else{
            rectangle.removeFromParent()
        }
    }
    
    
    func endGame(hitobstaculo: Bool){
        if isGameEnded{
            return
        }
        if(score > highestScore){
            highestScore = score
            UserDefaults.standard.set(score, forKey: "highScore")
        }
        isGameEnded = true
        physicsWorld.speed = 0
        isUserInteractionEnabled = true
        for flyobs in arrayFlyObst {
            flyobs.removeFromParent()
        }
        music.run(SKAction.stop())
        music.removeFromParent()
        arrayFlyObst.removeAll()
        arrayObst.removeAll()
        velocityBackground = 0
        addChild(gameOver)
        addChild(tapLabel)
    }
    
    func runActionNodes(){
        if(isGameEnded == false){
            run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(addObstaculo),
                    SKAction.wait(forDuration: random(min: 3, max: 8)),
                    SKAction.run(addLama),
                    SKAction.wait(forDuration: random(min: 4, max: 9)),
                    SKAction.run(addVaca),
                    SKAction.wait(forDuration: random(min: 5, max: 10)),
                    SKAction.run(addNuvem),
                    SKAction.wait(forDuration:  random(min: 3, max: 8))
                ])
            ))
            run(SKAction.repeatForever(
                SKAction.sequence([
                    SKAction.run(addFlyingObstaculo),
                    SKAction.wait(forDuration: random(min: 2, max: 7)),
                    SKAction.run(addPoint)
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
        velocityBackground = 7
        FlyingObstacle.actualDuration = 3.4
        if let musicURL = Bundle.main.url(forResource: "musica", withExtension: "wav") {
            music = SKAudioNode(url: musicURL)
            addChild(music)
        }
        music.run(SKAction.changeVolume(to: Float(0.3), duration: 0))
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
    
    func touchDown(atPoint pos: CGPoint) {
        if pos.x >= 0 {
            if(pos.y > -140){
                jump()
            }
            if (pos.y <= -140 && isCharacterOnGround == false) {
              goToGround()
            }
        }
        else{
            attack()
            animateAttack()
            player.run(SKAction.playSoundFileNamed("attack.wav", waitForCompletion: false))
            statePlayer = "attacking"
        }
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
            player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 150))
            isJumping = true
            self.isCharacterOnGround = false
            player.run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
            return
        }
        
        if(isJumping == true && isPlayerDoubleJumping == false && isCharacterOnGround == false){
            if(player.position.y > platform.position.y + platform.size.height*1.2){
                jumpImpulse(impulso: 110)
                animateJump()
                player.run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
                return
            }
            else{
                jumpImpulse(impulso: 110)
                player.run((
                    SKAction.animate(with: [playerJumping[1], playerJumping[2], playerJumping[3]],
                                     timePerFrame: 0.25,
                                     resize: false,
                                     restore: true)),
                           withKey:"jumpingInPlace")
                player.run(SKAction.playSoundFileNamed("jump.wav", waitForCompletion: false))
                return
            }
        }
    }
    
    func goToGround(){
        let toGround = SKAction.moveTo(y: platform.position.y + platform.size.height, duration: 0.2)
        player.texture = SKTexture(imageNamed: "correndo1")
        player.run(toGround)
        isJumping = false
        isPlayerDoubleJumping = false
    }
    
    func jumpImpulse(impulso: CGFloat){
        player.texture = SKTexture(imageNamed: "correndo1")
        player.physicsBody?.velocity = CGVector(dx: 0, dy: 0)
        player.physicsBody?.applyImpulse(CGVector(dx: 0, dy: impulso))
        isJumping = false
        isPlayerDoubleJumping = false
    }
    
    
    func attack(){
        if arrayFlyObst.count == 0 {return}
        else{
            if(CGPointDistance(from: player.position, to: arrayFlyObst[0].position) <= CGFloat(200)){
                removeObstArray()
                adjustScore(by: 1)
            }
            else{return}
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
                player.run(SKAction.playSoundFileNamed("die.wav", waitForCompletion: false))
                playerCollideWithObstaculo(projectile: projectile, monster: monster)
            }
        }
        
        if((firstBody.categoryBitMask & PhysicsCategory.monster != 0) && (secondBody.categoryBitMask & PhysicsCategory.point != 0 )){
            if let monster = firstBody.node as? SKSpriteNode, let point = secondBody.node as? SKSpriteNode{
                playerCollideWithPoint(point: point , monster: monster)
                player.run(SKAction.playSoundFileNamed("point.wav", waitForCompletion: false))
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
        arrayObst.append(obstaculo)
        addChild(obstaculo)
        animateToco(obst: obstaculo)
        obstaculo.runOverScene()
        
    }
    
    func addLama(){
        if isGameEnded{return}
        let lama = Lama()
        arrayLama.append(lama)
        addChild(lama)
        animateLama(lamaChao: lama)
        lama.runOverScene()
        
    }
    
    func playerCollideWithObstaculo(projectile: SKSpriteNode, monster: SKSpriteNode){
        monster.removeFromParent()
        //projectile.removeAllActions()
        projectile.removeFromParent()
        player.run(SKAction.playSoundFileNamed("die.wav", waitForCompletion: false))
        endGame(hitobstaculo: isGameEnded)
    }
    
    func removeObstArray(){
        arrayFlyObst[0].removeFromParent()
        arrayFlyObst[0].removeAllActions()
        arrayFlyObst.removeFirst()
    }
    
    func removePointArray(){
        if arrayPoints.count == 0 {return}
        arrayPoints[0].removeFromParent()
        arrayPoints[0].removeAllActions()
        arrayPoints.removeFirst()
    }
    
    func addFlyingObstaculo() {
        
        if isGameEnded{return}
        let flyobstaculo = FlyingObstacle()
        arrayFlyObst.append(flyobstaculo)
        addChild(flyobstaculo)
        animateSerra(serra: flyobstaculo)
        flyobstaculo.runOverScene(completion: removeObstArray)
        
    }
    
    func addNuvem(){
        if isGameEnded{return}
        let nuvem = Nuvem()
        arrayNuvem.append(nuvem)
        addChild(nuvem)
        animateNuvem(nuvemCeu: nuvem)
        nuvem.runOverScene()
    }
    
    func addVaca(){
        if isGameEnded{return}
        let vaca = Vaca()
        addChild(vaca)
        animateVaca(cow: vaca)
        vaca.runOverScene()
    }
    
    func animateToco(obst: Obstacle){
        obst.run(SKAction.repeatForever(SKAction.animate(with: obstaculo.tocoFrames,timePerFrame: 0.2,resize: false,restore: true)), withKey: "animateToco")
    }
    
    func animateSerra(serra: FlyingObstacle){
        serra.run(SKAction.repeatForever(SKAction.animate(with: flyingobstaculo.serraFrames,timePerFrame: 0.2,resize: false,restore: true)), withKey: "animateSerra")
    }
    
    func animateLama(lamaChao: Lama){
        lamaChao.run(SKAction.repeatForever(SKAction.animate(with: lama.lamaFrames ,timePerFrame: 0.2,resize: false,restore: true)), withKey: "animateLama")
    }
    
    func animateNuvem(nuvemCeu: Nuvem){
        nuvemCeu.run(SKAction.repeatForever(SKAction.animate(with: nuvem.nuvemFrames,timePerFrame: 0.2,resize: false,restore: true)), withKey: "animateNuvem")
    }
    
    func animateVaca(cow: Vaca){
        vaca.run(SKAction.repeatForever(SKAction.animate(with: vaca.vacaFrames,timePerFrame: 0.2,resize: false,restore: true)), withKey: "animateVaca")
    }
    
    
//MARK: Background
    
    func createBackground(){
        for i in 0...5{
            let ground = SKSpriteNode(imageNamed: "background")
            ground.name = "BackGround"
            ground.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
            ground.anchorPoint = CGPoint(x: 0.5, y: 0.5)
            ground.position = CGPoint(x: CGFloat(i) * ground.size.width, y: UIScreen.main.bounds.minX)
            ground.zPosition = -1
            self.addChild(ground)
        }
    }
    
    func moveGround(velocity: CGFloat){
        self.enumerateChildNodes(withName: "BackGround", using: ({(node, error) in node.position.x -= velocity
            if node.position.x < -(UIScreen.main.bounds.width){
                node.position.x += UIScreen.main.bounds.width * 3
            }
        }))
    }
    
}

//MARK: Point

extension GameScene{
    
    func addPoint() {
        
        if isGameEnded{return}
        let point = Points()
        arrayPoints.append(point)
        animatePoints(point: point)
        addChild(point)
        point.runOverScene(completion: removePointArray)
        
    }
    
    func adjustScore(by points: Int) {
        score += points
        scoreLabel.text = "Points: \(score)"
        
    }
    func playerCollideWithPoint(point: SKSpriteNode, monster: SKSpriteNode) {
        removePointArray()
        adjustScore(by: 1)
        
    }
    
    func animatePoints(point: Points){
        point.run(SKAction.repeatForever(SKAction.animate(with: point.pointsFrames,timePerFrame: 0.1,resize: false,restore: true)), withKey: "animateToco")
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
        player.position = CGPoint(x: -250, y: platform.position.y + platform.size.height)
        player.size = CGSize(width: 103, height: 80)
        player.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: player.size.width - 20, height: player.size.height - 20))
        player.physicsBody?.isDynamic = true
        player.physicsBody?.categoryBitMask = PhysicsCategory.monster
        player.physicsBody?.contactTestBitMask = PhysicsCategory.projectile | PhysicsCategory.platformCategory
        player.physicsBody?.collisionBitMask =  PhysicsCategory.platformCategory
        player.physicsBody?.allowsRotation = false
        //player.constraints = [SKConstraint.zRotation(SKRange(lowerLimit:0 upperLimit:0))]
        addChild(player)
    }
    
    func animateRunning() {
        player.run(SKAction.repeatForever(
            SKAction.animate(with: playerRunning,
                             timePerFrame: 0.08,
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

