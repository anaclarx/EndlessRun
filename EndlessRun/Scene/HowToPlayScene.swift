//
//  HowToPlayScene.swift
//  EndlessRun
//
//  Created by João Gabriel Araujo Jorge on 09/11/21.
//

import Foundation
import SpriteKit

class HowToPlayScene: SKScene {
    
    var background: SKSpriteNode = SKSpriteNode()
    var howToPlayBoard: SKSpriteNode = SKSpriteNode()
    
    var startTouch: CGPoint = CGPoint()
    var boardPosition: CGPoint = CGPoint(x: 829, y: 0)
    
    var bolinha1 = Bolinha()
    var bolinha2 = Bolinha()
    var bolinha3 = Bolinha()
    let xBolinhas = 0
    let yBolinhas = -160
    
    
    override func didMove(to view: SKView) {
        self.backgroundColor = .white
        
        background.size = CGSize(width: UIScreen.main.bounds.maxX, height: UIScreen.main.bounds.maxY)
        background.zPosition = -1
        background.texture = SKTexture(imageNamed: "fundoComNuvem-1.png")
        self.addChild(background)
        
    
        
        howToPlayBoard.size = CGSize(width: 2495, height: 380)
        howToPlayBoard.position = boardPosition
        howToPlayBoard.zPosition = 0
        howToPlayBoard.texture = SKTexture(imageNamed: "comojogarInteiro.png")
        self.addChild(howToPlayBoard)
        
        bolinha1.position = CGPoint(x: xBolinhas - 25, y: yBolinhas)
        bolinha1.zPosition = 1000
        self.addChild(bolinha1)
        
        bolinha2.position = CGPoint(x: xBolinhas, y: yBolinhas)
        bolinha2.zPosition = 1000
        self.addChild(bolinha2)
        
        bolinha3.position = CGPoint(x: xBolinhas + 25, y: yBolinhas)
        bolinha3.zPosition = 1000
        self.addChild(bolinha3)
        
        self.bolinha1.itIsMe()
        self.bolinha2.itIsNotMe()
        self.bolinha3.itIsNotMe()
        

    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            let location = touch.location(in: self)
            startTouch = location
            boardPosition = howToPlayBoard.position
            
            let touchedNode = self.atPoint(location)
            if touchedNode != howToPlayBoard {
                let scene = GameMenuScene(size: self.size)
                scene.anchorPoint = CGPoint(x: 0.5, y: 0.5)
                let skView = view! as SKView
                skView.presentScene(scene)
            }
        }
    }
        override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
            let touch = touches.first
            if let location = touch?.location(in: self){
                
                let xPosition: CGFloat = boardPosition.x + location.x - startTouch.x
                howToPlayBoard.run(SKAction.move(to: CGPoint(x: xPosition, y: boardPosition.y), duration: 0.1))
                
            }
        }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches.first
        if let location = touch?.location(in: self) {
            
            var xPosition: CGFloat = boardPosition.x + location.x - startTouch.x
            
            let transitionTime = 0.4
            
            let sensibility: CGFloat = 100
            
            switch boardPosition.x {
            case 829:
                switch xPosition {
                case 0..<(829 - sensibility):
                    self.bolinha1.itIsNotMe()
                    self.bolinha2.itIsMe()
                    self.bolinha3.itIsNotMe()
                    xPosition = 92
                default:
                    self.bolinha1.itIsMe()
                    self.bolinha2.itIsNotMe()
                    self.bolinha3.itIsNotMe()
                    xPosition = 829
                }
            case 92:
                switch xPosition {
                case (92 + sensibility)..<1000:
                    self.bolinha1.itIsMe()
                    self.bolinha2.itIsNotMe()
                    self.bolinha3.itIsNotMe()
                    xPosition = 829
                case -900..<(92 - sensibility):
                    self.bolinha1.itIsNotMe()
                    self.bolinha2.itIsNotMe()
                    self.bolinha3.itIsMe()
                    xPosition = -847
                default:
                    self.bolinha1.itIsNotMe()
                    self.bolinha2.itIsMe()
                    self.bolinha3.itIsNotMe()
                    xPosition = 92
                }
            case -847:
                switch xPosition {
                case (-847 + sensibility)..<200:
                    self.bolinha1.itIsNotMe()
                    self.bolinha2.itIsMe()
                    self.bolinha3.itIsNotMe()
                    xPosition = 92
                default:
                    self.bolinha1.itIsNotMe()
                    self.bolinha2.itIsNotMe()
                    self.bolinha3.itIsMe()
                    xPosition = -847
                }
            default:
                break
            }
            
            
            howToPlayBoard.run(SKAction.move(to: CGPoint(x: xPosition, y: boardPosition.y), duration: transitionTime))
        }
    }
    
}



class Bolinha: SKSpriteNode {
    var isItMe: Bool = false
    
    private func defineTexture ()->Void {
        if isItMe == false {
            self.texture = SKTexture(imageNamed: "bolinhacinza.png")
        } else {
            self.texture = SKTexture(imageNamed: "bolinhalaranja.png")
        }
    }
    
    public func itIsMe ()->Void {
        self.isItMe = true
        self.defineTexture()
    }
    
    public func itIsNotMe ()->Void {
        self.isItMe = false
        self.defineTexture()
    }
    
    init() {
        super.init(texture: SKTexture(imageNamed: "bolinhacinza.png"), color: .blue, size: CGSize(width: 8, height: 8))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
