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
    
    @IBAction func backTouch(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    var twoGamer: Bool = false
    var gameWithComputer: Bool = false
    var blindGame: Bool = false
    
    private var counter: Int = 0
    private var limitCounter: Int {
        return GameboardSize.columns * GameboardSize.rows
    }
    
    private var flagComputerSet: Bool = false
    
    private var counterBlindMove: Int = 0
    private var limitCounterBlindMove: Int = 5
    private var gameboard = Gameboard()
    
    private var flagStartBlindGame = false
    private var timer: Timer?
    
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
            
            if self.gameWithComputer {
                self.flagComputerSet = true
            }
            
            if self.blindGame {
                if self.counterBlindMove < self.limitCounterBlindMove * 2  {
                    self.currentState.addCommandToInvoker(at: position)
                }
                self.counterBlindMove += 1
                self.currentState.addMark(at: position)
                self.goToNextState()
            }
            
            
            if !self.blindGame {
                self.counter += 1
                self.currentState.addMark(at: position)
                if self.currentState.isCompleted {
                    self.goToNextState()
                }
            }
        }
    }
    
    private func goToFirstState() {
        
        if gameWithComputer {
            let player = Player.first
            self.currentState = ComputerInputState (player: .first,
                                                    markViewPrototype: player.markViewPrototype,
                                                    gameViewController: self,
                                                    gameboard: gameboard,
                                                    gameboardView: gameboardView)
        }
        
        if twoGamer {
            let player = Player.first
            self.currentState = PlayerInputState (player: .first,
                                                  markViewPrototype: player.markViewPrototype,
                                                  gameViewController: self,
                                                  gameboard: gameboard,
                                                  gameboardView: gameboardView)
        }
        
        if blindGame {
            let player = Player.first
            self.currentState = BlindGameInputState (player: .first,
                                                     markViewPrototype: player.markViewPrototype,
                                                     gameViewController: self,
                                                     gameboard: gameboard,
                                                     gameboardView: gameboardView)
        }
    }
    
    
    private func goToNextState() {
        if twoGamer || gameWithComputer || flagStartBlindGame
        
        {
            if let winner = self.referee.determineWinner() {
                self.currentState = GameEndedState(winner: winner, gameViewController: self)
                if let timer = timer {
                    timer.invalidate()
                }
                return
            }
            
            if counter == limitCounter && !flagStartBlindGame {
                self.currentState = GameEndedState (winner: nil, gameViewController: self )
                return
            }
            
            if counter == (limitCounterBlindMove * 2) && flagStartBlindGame {
                self.currentState = GameEndedState (winner: nil, gameViewController: self )
                if let timer = timer {
                    timer.invalidate()
                }
                return
            }
        }
        
        if twoGamer {
            if let playerInputState = currentState as? PlayerInputState {
                let player = playerInputState.player.next
                self.currentState = PlayerInputState(player: player,
                                                     markViewPrototype: player.markViewPrototype,
                                                     gameViewController: self,
                                                     gameboard: gameboard,
                                                     gameboardView: gameboardView)
            }
        }
        
        if gameWithComputer {
            if let playerInputState = currentState as? ComputerInputState {
                let player = playerInputState.player.next
                self.currentState = ComputerInputState (player: player,
                                                        markViewPrototype: player.markViewPrototype,
                                                        gameViewController: self,
                                                        gameboard: gameboard,
                                                        gameboardView: gameboardView)
                
                if flagComputerSet {
                    let positions = gameboard.getLeaveGameBoardPositions ()
                    let position = positions.randomElement()
                    if let position = position {
                        self.currentState.addMark(at: position)
                        self.counter += 1
                        flagComputerSet = false
                        if self.currentState.isCompleted {
                            self.goToNextState()
                        }
                    }
                }
            }
        }
        
        if blindGame {
            
            if self.counterBlindMove == limitCounterBlindMove {
                self.gameboard.clear()
                self.gameboardView.clear()
                if let playerInputState = currentState as? BlindGameInputState {
                    let player = playerInputState.player.next
                    self.currentState = BlindGameInputState(player: player,
                                                            markViewPrototype: player.markViewPrototype,
                                                            gameViewController: self,
                                                            gameboard: gameboard,
                                                            gameboardView: gameboardView)
                }
            }
            if self.counterBlindMove == limitCounterBlindMove * 2 {
                self.counterBlindMove = 0
                self.flagStartBlindGame = true
                self.gameboard.clear()
                self.gameboardView.clear()
                self.currentState.executeInvoker()
                
                if let blindGameInputState = currentState as? BlindGameInputState {
                    let player = Player.first
                    self.currentState = StepSettingInputState (player: player,
                                                               markViewPrototype: player.markViewPrototype,
                                                               gameViewController: self,
                                                               gameboard: gameboard,
                                                               gameboardView: gameboardView)
                    timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(stepSettingMovement), userInfo: nil, repeats: true)
                }
            }
        }
    }
    
    @objc func stepSettingMovement () {
        self.flagStartBlindGame = true
        self.counter += 1
        MoveInvoker.shared.stepExecutionMoveCommands()
        self.goToNextState()
    }
    
    @IBAction func restartButtonTapped(_ sender: UIButton) {
        Log(.restartGame)
        MoveInvoker.shared.resetMoveInvoker()
        self.gameboardView.clear()
        self.gameboard.clear()
        self.counter = 0
        self.counterBlindMove = 0
        self.flagStartBlindGame = false
        goToFirstState()
    }
}

