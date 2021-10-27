////
////  HighScore.swift
////  EndlessRun
////
////  Created by Ana Clara Filgueiras Granato on 22/10/21.
////
//
//import Foundation
//
//class HighScore: NSObject{
//    
//    var score: Int
//    var highestScore = UserDefaults.standard.integer(forKey: "highScore")
//
//    init(score: Int) {
//        self.score = score
//    }
//
//    func changeHighScore(){
//        if (score > highestScore) {
//            UserDefaults.standard.set(score, forKey: "highScore")
//        }
//    }
//
//}
