//
//  Game.swift
//  MemoryGame
//
//  Created by Hugo Troche on 4/15/19.
//  Copyright © 2019 Hugo Troche. All rights reserved.
//

import Foundation

struct GameType {
    
    var rows:Int
    var columns:Int
    
}

//Had to use class instead of struck because I needed to pass by reference in UI
class Card {
    
    var backgroundImageName:String
    var imageName:String
    var cardID:String
    var revealed:Bool
    
    init(backgroundImageName:String, imageName: String, cardID: String, revealed:Bool) {
        self.backgroundImageName = backgroundImageName
        self.imageName = imageName
        self.cardID = cardID
        self.revealed = revealed
    }
    
    func copy() -> Card {
        let card = Card(backgroundImageName: self.backgroundImageName, imageName: self.imageName, cardID: self.cardID, revealed: self.revealed)
        return card
    }
    
}

class Game {
    
    enum Games:Int {
        case g3x4=0, g5x2, g4x4, g4x5
    }
    
    let UNIQUE_CARDS_COUNT:Int = 10
    
    static let g3x4 = GameType(rows:4, columns:3)
    static let g5x2 = GameType(rows:2, columns:5)
    static let g4x4 = GameType(rows:4, columns:4)
    static let g4x5 = GameType(rows:5, columns:4)
    
    var selecteGameType:GameType
    var cards:[[Card]] = [[Card]]()
    var possibleCards:[Card] = []
    
    static let sharedGame:Game = Game()
    
    private init() {
        self.selecteGameType = Game.g3x4
        initPossibleCards()
    }
    
    private func initPossibleCards() {
        for index in 1...UNIQUE_CARDS_COUNT  {
            let card = Card(backgroundImageName: "CardBack", imageName: "card\(index)", cardID: "card\(index)", revealed:false)
            self.possibleCards.append(card)
        }
    }
    
    
    func configureGame(type:GameType) {
        self.selecteGameType = type
        self.cards = [[Card]]()
        
        //Define cards we will use for game
        let cardsToRemove =  UNIQUE_CARDS_COUNT - self.selecteGameType.columns*self.selecteGameType.rows/2
        var cardsToUse:[Card] = []
        for card in self.possibleCards {
            cardsToUse.append(card.copy())
        }
        if cardsToRemove > 0 {
            for _ in 1...cardsToRemove {
                cardsToUse.remove(at: Int.random(in: 0 ..< cardsToUse.count-1))
            }
        }
        
        //Doublethe cardsToUse
        var duplicateCards:[Card] = []
        for card in cardsToUse {
            duplicateCards.append(card.copy())
        }
        cardsToUse += duplicateCards
        
        //Load cards
        for row in 0...self.selecteGameType.rows-1 {
            self.cards.append([Card]())
            for _ in 0...self.selecteGameType.columns-1 {
                if(cardsToUse.count > 1) {
                    self.cards[row].append(cardsToUse.remove(at: Int.random(in: 0 ..< cardsToUse.count-1)))
                } else {
                    self.cards[row].append(cardsToUse.remove(at: 0))
                }
            }
        }
        
    }
    
    func getCard(row:Int, column:Int) -> Card {
        return self.cards[row][column]
    }
    
    func setCard(card:Card, row:Int, column:Int) {
        self.cards[row][column] = card
    }
    
    func rows() -> Int {
        return self.cards.count
    }
    
    func columns(row:Int) -> Int {
        return self.cards[row].count
    }
}
