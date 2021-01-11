//
//  MoveCommand.swift
//  XO-game
//
//  Created by Alexandr Evtodiy on 09.01.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation


class MoveCommand {
    internal init(player: Player, gameboardPosition: GameboardPosition, gameboard: Gameboard, gameboardView: GameboardView, markViewPrototype: MarkView) {
        self.player = player
        self.gameboardPosition = gameboardPosition
        self.gameboard = gameboard
        self.gameboardView = gameboardView
        self.markViewPrototype = markViewPrototype
    }
    
    var player: Player
    var gameboardPosition: GameboardPosition
    var gameboard: Gameboard
    var gameboardView: GameboardView
    var markViewPrototype: MarkView
    var isCompleted: Bool = false
    
    func execute () {
        Log(.playerInput(player: self.player, position: self.gameboardPosition))
        self.gameboardView.removeMarkView(at: self.gameboardPosition)
        guard  gameboardView.canPlaceMarkView(at: self.gameboardPosition)
        else { return }
        self.gameboard.setPlayer(self.player, at: self.gameboardPosition)
        self.gameboardView.placeMarkView(self.markViewPrototype.copy(), at: self.gameboardPosition)
        self.isCompleted = true
    }
    
}
