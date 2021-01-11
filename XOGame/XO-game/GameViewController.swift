//
//  GameViewController.swift
//  XO-game
//
//  Created by Evgeny Kireev on 25/02/2019.
//  Copyright © 2019 plasmon. All rights reserved.
//

import UIKit

class GameViewController: UIViewController {

    @IBOutlet var gameboardView: GameboardView!
    @IBOutlet var firstPlayerTurnLabel: UILabel!
    @IBOutlet var secondPlayerTurnLabel: UILabel!
    @IBOutlet var winnerLabel: UILabel!
    @IBOutlet var restartButton: UIButton!
    
    private var counter: Int = 0
    private let gameboard = Gameboard()
    private var currentState: GameState! {
        didSet {
            self.currentState.begin()
        }
    }
    
    private lazy var referee = Referee(gameboard: self.gameboard)

    
    override func viewDidLoad() {
        super.viewDidLoad()
            self.goToFirstState()
            
            gameboardView.onSelectPosition = { [weak self] position in
                guard let self = self else { return }
                self.currentState.addMark(at: position)
                self.counter += 1
                if self.currentState.isCompleted {
                    self.goToNextState()
                }
            }

    }
    
    private func goToFirstState() {
        let player = Player.first
        self.currentState = PlayerInputState(player: .first,
                                             markViewPrototype: player.markViewPrototype,
                                             gameViewController: self,
                                             gameboard: gameboard,
                                             gameboardView: gameboardView)
    }

    private func goToNextState() {
        if let winner = self.referee.determineWinner() {
                self.currentState = GameEndedState(winner: winner, gameViewController: self)
                return
            }
        
        if counter >= 9 {
            self.currentState = GameEndedState (winner: nil, gameViewController: self )
        }
        
            if let playerInputState = currentState as? PlayerInputState {
                let player = playerInputState.player.next
                self.currentState = PlayerInputState(player: player,
                                                     markViewPrototype: player.markViewPrototype,
                                                     gameViewController: self,
                                                     gameboard: gameboard,
                                                     gameboardView: gameboardView)
            }
    }

    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Log(.restartGame)
        
        gameboardView.clear()
        gameboard.clear()
        counter = 0
        goToFirstState()
    }
}

