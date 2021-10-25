//
//  ACTPlayerStats.swift
//  EndlessRun
//
//  Created by Ana Clara Filgueiras Granato on 22/10/21.
//

import Foundation
import SpriteKit

let kHighScoreState = "kHighScore"
let kScore = "kScore"

class ACTPlayerStats{
    
    private init(){}
    static let shared  = ACTPlayerStats()
    
//    if value > getBestScore(){
//        setBestScore(value)
//    }
    
    func setScore(_ value: Int){
        UserDefaults.standard.set(value, forKey: kScore)
        UserDefaults.standard.synchronize()
    }
    
    func getScore() -> Int{
        return UserDefaults.standard.integer(forKey: kScore)
    }
   
    func setBestScore(_ value: Int){
        UserDefaults.standard.set(value, forKey: kHighScoreState)
        UserDefaults.standard.synchronize()
    }
    
    func getBestScore() -> Int{
        return UserDefaults.standard.integer(forKey: kHighScoreState)
    }
    
    
}
