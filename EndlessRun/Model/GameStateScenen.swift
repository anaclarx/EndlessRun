//
//  GameStateScenen.swift
//  EndlessRun
//
//  Created by Ana Clara Filgueiras Granato on 16/09/21.
//

import Foundation

import GameplayKit
import SpriteKit

/// The StartGameState class represents the state of the game when a level is starting. It sets up the GameScene for a new game.
class StartGameState: GKState {
    
    /// The scene that is running the GameStateMachine.
    var scene: GameScene?
    
    /// Initializes the StartGameState object.
    /// - Parameter scene: the scene that is running the GameStateMachine
    init(scene: GameScene){
        self.scene = scene
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        
        // The only valid state that the GameStateMachine can transition to from the
        // StartGameState is the ActiveGameState, once the game level starts
        return stateClass == ActiveGameState.self
    }
    
    override func didEnter(from previousState: GKState?) {
//        if previousState?.classForCoder == PauseGameState.self {
//            scene?.endGame(hitobstaculo: true)
//        }
        scene!.reset()
        self.stateMachine?.enter(ActiveGameState.self)
    }
}

/// The ActiveGameState represents the state of the game when the player is actually playing a game level.
class ActiveGameState: GKState {
    var scene: GameScene?
    
    init(scene: GameScene){
        self.scene = scene
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        // The only valid state that the GameStateMachine can transition to from the
        // ActiveGameState is the EndGameState, once the game level finishes for whatever reason
        
        // In the future, it should also be able to transition to the StartGameState, if the
        // game is restarted for example
        return stateClass == EndGameState.self //|| stateClass == PauseGameState.self
    }
    
//    override func didEnter(from previousState: GKState?) {
//        if previousState?.classForCoder == PauseGameState.self {
//            scene?.unpauseGame()
//        }
//    }
}

/// The PauseGameState represents the state of the game when it has been paused - that is, when the player pauses while playing the game.
//class PauseGameState: GKState {
//    var scene: GameScene?
//
//    init(scene: GameScene){
//        self.scene = scene
//        super.init()
//    }
//
//    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
//        // The only valid state that the GameStateMachine can transition to from the
//        // PauseGameState is the ActiveGameState, once the game is unpaused
//        return stateClass == ActiveGameState.self || stateClass == StartGameState.self
//    }
//
////    override func didEnter(from previousState: GKState?) {
////        scene?.pauseGame()
////    }
//}

/// The EndGameState represents the state of the game when it has ended - that is, when the player won or lost the level.
class EndGameState: GKState {
    var scene: GameScene?
    
    init(scene: GameScene){
        self.scene = scene
        super.init()
    }
    
    override func isValidNextState(_ stateClass: AnyClass) -> Bool {
        // The only valid state that the GameStateMachine can transition to from the
        // EndGameState is the StartGameState, if the user restarts the level;
        // Otherwise, another scene will be presented so GameStateMachine will become moot
        
        return stateClass == StartGameState.self
    }
    
    override func didEnter(from previousState: GKState?) {
        scene!.endGame(hitobstaculo: true)
    }
}


