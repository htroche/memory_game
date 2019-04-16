//
//  ViewController.swift
//  MemoryGame
//
//  Created by Hugo Troche on 4/15/19.
//  Copyright © 2019 Hugo Troche. All rights reserved.
//

import UIKit

class LobbyViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func gameSelectionPressed(sender: UIButton) {
        
        switch sender.tag {
        case Game.Games.g3x4.rawValue:
            Game.sharedGame.configureGame(type: Game.g3x4)
        case Game.Games.g4x4.rawValue:
            Game.sharedGame.configureGame(type: Game.g4x4)
        case Game.Games.g4x5.rawValue:
            Game.sharedGame.configureGame(type: Game.g4x5)
        case Game.Games.g5x2.rawValue:
            Game.sharedGame.configureGame(type: Game.g5x2)
        default:
            Game.sharedGame.configureGame(type: Game.g3x4)
        }
        self.performSegue(withIdentifier: "showGame", sender: self)
    }


}

