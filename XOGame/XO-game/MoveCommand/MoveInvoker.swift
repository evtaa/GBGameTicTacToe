//
//  MoveInvoker.swift
//  XO-game
//
//  Created by Alexandr Evtodiy on 09.01.2021.
//  Copyright © 2021 plasmon. All rights reserved.
//

import Foundation

class MoveInvoker {
    var firstPlayerCommands: [MoveCommand] = []
    var secondPlayerCommands: [MoveCommand] = []
    var flagEven: Bool = false
    
    static let shared = MoveInvoker ()
    
    func addMoveCommand (_ moveCommand: MoveCommand) {
        let player = moveCommand.player
        switch player {
        case .first:
            firstPlayerCommands.append(moveCommand)
        case .second:
            secondPlayerCommands.append(moveCommand)
        }
    }
    
    @objc func stepExecutionMoveCommands () {
        
        if !flagEven {
            if let command = firstPlayerCommands.first {
                command.execute()
                firstPlayerCommands.remove(at: 0)
            }
            flagEven.toggle()
        } else {
            if let command = secondPlayerCommands.first {
                command.execute()
                secondPlayerCommands.remove(at: 0)
            }
            flagEven.toggle()
        }
    }
    func resetMoveInvoker () {
        firstPlayerCommands = []
        secondPlayerCommands = []
        flagEven = false
    }
}
