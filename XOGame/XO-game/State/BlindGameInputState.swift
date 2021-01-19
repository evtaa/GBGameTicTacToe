//
//  BlindGameInputState.swift
//  XO-game
//
//  Created by Alexandr Evtodiy on 29.12.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public class BlindGameInputState: GameState {
    
    public let markViewPrototype: MarkView
    
    public private(set) var isCompleted = false
    
    public let player: Player
    private(set) weak var gameViewController: GameViewController?
    private(set) weak var gameboard: Gameboard?
    private(set) weak var gameboardView: GameboardView?
    
    init(player: Player, markViewPrototype: MarkView, gameViewController: GameViewController, gameboard: Gameboard, gameboardView: GameboardView) {
        self.player = player
        self.markViewPrototype = markViewPrototype
        self.gameViewController = gameViewController
        self.gameboard = gameboard
        self.gameboardView = gameboardView
    }
    
    public func begin() {
        switch self.player {
        case .first:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = false
            self.gameViewController?.secondPlayerTurnLabel.isHidden = true
        case .second:
            self.gameViewController?.firstPlayerTurnLabel.isHidden = true
            self.gameViewController?.secondPlayerTurnLabel.isHidden = false
        }
        self.gameViewController?.winnerLabel.isHidden = true
    }
       
    public func addCommandToInvoker (at position: GameboardPosition) {
        guard let gameboardView = self.gameboardView,
              let gameboard = self.gameboard
            , gameboardView.canPlaceMarkView(at: position)
            else { return }
        let moveCommand = MoveCommand(player: player, gameboardPosition: position, gameboard: gameboard, gameboardView: gameboardView, markViewPrototype: markViewPrototype)
        MoveInvoker.shared.addMoveCommand(moveCommand)
    }
    
    public func executeInvoker () {
       
    }
    
    public func addMark(at position: GameboardPosition) {
        Log(.playerInput(player: self.player, position: position))
        guard let gameboardView = self.gameboardView
            , gameboardView.canPlaceMarkView(at: position)
            else { return }
        
        self.gameboard?.setPlayer(self.player, at: position)
        self.gameboardView?.placeMarkView(self.markViewPrototype.copy(), at: position)
        self.isCompleted = true
    }
}
