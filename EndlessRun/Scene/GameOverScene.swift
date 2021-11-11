//
//  GameOverScene.swift
//  EndlessRun
//
//  Created by João Gabriel Araujo Jorge on 11/11/21.
//

import Foundation
import SpriteKit

class GameOverScene: SKScene {
    
    var gameOverLettering = SKSpriteNode()
    var replayButton = SKSpriteNode()
    var menuButton = SKSpriteNode()
    var background = SKSpriteNode()
    
    
    override func didMove(to view: SKView) {
        
        background.texture = SKTexture(imageNamed: "background.png")
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background.zPosition = -1
        self.addChild(background)
        
        self.animateGameOver(gameOverLettering)
        gameOverLettering.size = CGSize(width: 1382/3, height: 787/3)
        gameOverLettering.position = CGPoint(x: 0, y: -30)
        gameOverLettering.zPosition = 0
        self.addChild(gameOverLettering)
        
        replayButton.texture = SKTexture(imageNamed: "rejogar.png")
        replayButton.size = CGSize(width: 384/2, height: 194/2)
        replayButton.position = CGPoint(x: UIScreen.main.bounds.midX/2, y: UIScreen.main.bounds.midY/1.5)
        replayButton.zPosition = 1
        self.addChild(replayButton)
        
        menuButton.texture = SKTexture(imageNamed: "menu.png")
        menuButton.size = CGSize(width: 280/2, height: 181/2)
        menuButton.position = CGPoint(x: (-1)*UIScreen.main.bounds.midX/2, y: UIScreen.main.bounds.midY/1.5)
        menuButton.zPosition = 1
        self.addChild(menuButton)
        
        let wait = SKAction.wait(forDuration: 1)
        let enableUserInteraction = SKAction.run {
            self.isUserInteractionEnabled = true
        }
        self.isUserInteractionEnabled = false
        self.run(SKAction.sequence([wait, enableUserInteraction]))
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            switch node {
            case replayButton:
                replayButton.run(SKAction.playSoundFileNamed("botoes.wav", waitForCompletion: false))
                let scene = GameScene(size: self.size)
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                let skView = view! as SKView
                skView.presentScene(scene)
            
            case menuButton:
                menuButton.run(SKAction.playSoundFileNamed("botoes.wav", waitForCompletion: false))
                let scene = GameMenuScene(size: self.size)
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                let skView = view! as SKView
                skView.presentScene(scene)
                
            default: break
            }
        }
        
    }
    
}

extension GameOverScene {
    func animateGameOver (_ lettering: SKSpriteNode) {
        lettering.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "game over 1.png"), SKTexture(imageNamed: "game over 2.png")], timePerFrame: 1/7)))
    }
    
    func animateReplayButton (_ button: SKSpriteNode) {
        
    }
    
    func animateMenuButton (_ button: SKSpriteNode) {
        
    }
    
}
