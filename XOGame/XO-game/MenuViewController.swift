//
//  MenuViewController.swift
//  XO-game
//
//  Created by Alexandr Evtodiy on 28.12.2020.
//  Copyright © 2020 plasmon. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

//    @IBAction func twoGamerTouchUpInside(_ sender: Any) {
//        let gameViewController = GameViewController ()
//        gameViewController.gameWithComputer = false
//        gameViewController.modalPresentationStyle = .fullScreen
//        present(gameViewController, animated: true, completion: nil)
//    }
//    @IBAction func GameWithComputerTouchUpInside(_ sender: Any) {
//        let gameViewController = GameViewController ()
//        gameViewController.gameWithComputer = true
//        gameViewController.modalPresentationStyle = .fullScreen
//        present(gameViewController, animated: true, completion: nil)
//    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "twoGamer" {
            let gameViewController = segue.destination as? GameViewController
            gameViewController?.twoGamer = true
            gameViewController?.gameWithComputer = false
            gameViewController?.blindGame = false
        }
        if segue.identifier == "gameWithComputer" {
            let gameViewController = segue.destination as? GameViewController
            gameViewController?.twoGamer = false
            gameViewController?.gameWithComputer = true
            gameViewController?.blindGame = false
        }
        if segue.identifier == "blindGame" {
            let gameViewController = segue.destination as? GameViewController
            gameViewController?.twoGamer = false
            gameViewController?.gameWithComputer = false
            gameViewController?.blindGame = true
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
