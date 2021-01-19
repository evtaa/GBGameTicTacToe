//
//  GameState.swift
//  XO-game
//
//  Created by Alexandr Evtodiy on 27.12.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import Foundation

public protocol GameState {
    
    var isCompleted: Bool { get }
    
    func begin()
    
    func addMark(at position: GameboardPosition)
    
    func addCommandToInvoker (at position: GameboardPosition)
    
    func executeInvoker ()
}
