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
    
    var playButton = SKSpriteNode() //lettering inteiro funciona como playButton
    var background: SKSpriteNode = SKSpriteNode()
    var comoJogarButton = SKSpriteNode()
    var universoExpandidoButton = SKSpriteNode()
    var ajustesButton = SKSpriteNode() //ainda nao foi implementado
    
    override func didMove(to view: SKView) {
        
        //colocando lettering
        playButton.size = CGSize(width: (1.1)*1204/3, height: (1.1)*875/3)
        playButton.position = CGPoint(x: 180, y: 20)
        playButton.zPosition = 1
        self.animateLettering(playButton)
        self.addChild(playButton)
        
        //colocando background
        background.size = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
        background.zPosition = -1
        self.animateBackground(background)
        self.addChild(background)
        
        //colocando botoes
        comoJogarButton.size = CGSize(width: 822/3, height: 265/3)
        comoJogarButton.position = CGPoint(x: (-1/2)*UIScreen.main.bounds.maxX+822/6, y: (1/8)*UIScreen.main.bounds.maxY)
        comoJogarButton.zPosition = 1
        self.animateComoJogarButton(comoJogarButton)
        self.addChild(comoJogarButton)
        
        universoExpandidoButton.size = CGSize(width: 999/3, height: 265/3)
        universoExpandidoButton.position = CGPoint(x: (-1/2)*UIScreen.main.bounds.maxX+999/6, y: (-1/6)*UIScreen.main.bounds.maxY)
        universoExpandidoButton.zPosition = 1
        self.animateUniversoExpandidoButton(universoExpandidoButton)
        self.addChild(universoExpandidoButton)
        
        
    }
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let pos = touch.location(in: self)
            let node = self.atPoint(pos)
            
            switch node {
            case playButton:
                let scene = GameScene(size: self.size)
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                let skView = view as! SKView
                skView.presentScene(scene)
                playButton.run(SKAction.playSoundFileNamed("botoes.wav", waitForCompletion: false))
            
            case comoJogarButton:
                comoJogarButton.run(SKAction.playSoundFileNamed("botoes.wav", waitForCompletion: false))
                let scene = HowToPlayScene(size: self.size)
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                let skView = view! as SKView
                skView.presentScene(scene)
                
            case universoExpandidoButton:
                universoExpandidoButton.run(SKAction.playSoundFileNamed("botoes.wav", waitForCompletion: false))
                print("clicked universoExpandidoButton")
                universoExpandidoButton.run(SKAction.playSoundFileNamed("botoes.wav", waitForCompletion: false))
                if let url = URL(string: "https://www.hicetnunc.xyz/criptosisifo") {
                    UIApplication.shared.open(url)
                }
                
            default: break
            }
            
        }
    }
    
    
}

extension GameMenuScene {
    
    func animateLettering(_ playButton: SKSpriteNode) {
        playButton.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "logotipoejogar-1.png"), SKTexture(imageNamed: "logotipoejogar-2.png"), SKTexture(imageNamed: "logotipoejogar-3.png"), SKTexture(imageNamed: "logotipoejogar-2.png")], timePerFrame: 1/7)))
    }
    
    func animateBackground(_ background: SKSpriteNode) {
        background.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "fundoComNuvem-1.png"), SKTexture(imageNamed: "fundoComNuvem-2.png"), SKTexture(imageNamed: "fundoComNuvem-3.png"), SKTexture(imageNamed: "fundoComNuvem-2.png")], timePerFrame: 1/7)))
    }
    
    func animateUniversoExpandidoButton(_ universoExpandidoButton: SKSpriteNode) {
        universoExpandidoButton.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "universoexpandido-1.png"), SKTexture(imageNamed: "universoexpandido-2.png"), SKTexture(imageNamed: "universoexpandido-3.png"), SKTexture(imageNamed: "universoexpandido-2.png")], timePerFrame: 1/7)))
    }
    
    func animateComoJogarButton(_ comoJogarButton: SKSpriteNode) {
        comoJogarButton.run(SKAction.repeatForever(SKAction.animate(with: [SKTexture(imageNamed: "comojogar-1.png"), SKTexture(imageNamed: "comojogar-2.png"), SKTexture(imageNamed: "comojogar-3.png"), SKTexture(imageNamed: "comojogar-2.png")], timePerFrame: 1/7)))
    }
    
}
