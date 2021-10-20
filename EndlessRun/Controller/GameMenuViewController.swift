//
//  GameOverViewController.swift
//  EndlessRun
//
//  Created by Ana Clara Filgueiras Granato on 09/09/21.
//

import Foundation


import UIKit
import SpriteKit
import GameplayKit

class GameMenuViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let scene = GameMenuScene(size: view.frame.size)
        let skView = view as! SKView
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true
        scene.scaleMode = .resizeFill
        skView.presentScene(scene)
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .landscape
        } else {
            return .landscape
        }
        
    }
}
