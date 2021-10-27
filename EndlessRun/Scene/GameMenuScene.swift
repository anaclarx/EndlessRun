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
    lazy var highScoreLabel: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Arial-BoldMT")
        label.fontSize = 20
        label.fontColor = SKColor.black
        label.position = CGPoint(x:  -260, y: 140 )
        label.text = "Points: 0"
        return label
    }()
    
    lazy var int1Label: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Arial-BoldMT")
        label.fontSize = 20
        label.fontColor = SKColor.black
        label.position = CGPoint(x:  -220, y: 0.5 )
        label.text = "Clique Esquerdo: Destrua Moto-Serras"
        return label
    }()
    
    lazy var int2Label: SKLabelNode = {
        var label = SKLabelNode(fontNamed: "Arial-BoldMT")
        label.fontSize = 20
        label.fontColor = SKColor.black
        label.position = CGPoint(x:  220, y: 0.5 )
        label.text = "Clique Direito: Pulo e Pulo Duplo"
        return label
    }()
    
    override func didMove(to view: SKView) {
        
        let gameScene = GameScene(size: self.size)
        highScoreLabel.text = "Maior Pontuação: \(gameScene.highestScore)"
        playButton = SKSpriteNode(texture: playButtonTex)
        playButton.size = CGSize(width: 45, height: 45)
        playButton.position = CGPoint(x: 0.5, y: 0.5)
        self.backgroundColor = .white
        self.addChild(playButton)
        self.addChild(highScoreLabel)
        self.addChild(int1Label)
        self.addChild(int2Label)
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
