//
//  GameOverScene.swift
//  EndlessRun
//
//  Created by Ana Clara Filgueiras Granato on 09/09/21.
//

import Foundation
import SpriteKit


class GameMenuScene: SKScene,SKPhysicsContactDelegate
{
    
    var playButton = SKSpriteNode()
    let playButtonTex = SKTexture(imageNamed: "play")
    
    override func didMove(to view: SKView) {
        
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.size = CGSize(width: 45, height: 45)
        playButton.position = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = .systemPink
        self.addChild(playButton)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            if node == playButton {
                let scene = GameScene(size: self.size)
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                let skView = view as! SKView
                skView.presentScene(scene)
            }
        }
    }
    
    
}
