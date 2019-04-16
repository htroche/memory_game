//
//  GameViewController.swift
//  MemoryGame
//
//  Created by Hugo Troche on 4/15/19.
//  Copyright © 2019 Hugo Troche. All rights reserved.
//

import UIKit
import AVFoundation
import AudioToolbox

private let reuseIdentifier = "CardCell"

class GameViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    
    let ASPECT_RATIO:Double = 292.0/422.0
    let soundID: SystemSoundID = 1025
    
    var card1:(Card, IndexPath)?
    var card2:(Card, IndexPath)?
    
    var isWaiting:Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()

        let button: UIButton = UIButton(type: UIButton.ButtonType.custom)
        button.setImage(UIImage(named: "BackButton"), for: UIControl.State.normal)
        button.addTarget(self, action: #selector(GameViewController.goBack), for: UIControl.Event.touchUpInside)
        let barButton = UIBarButtonItem(customView: button)
        self.navigationItem.leftBarButtonItem = barButton
        
    }
    
    @objc func goBack() {
        self.navigationController?.popViewController(animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return Game.sharedGame.rows()
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return Game.sharedGame.columns(row: section)
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! CardCell
    
        let card = Game.sharedGame.getCard(row: indexPath.section, column: indexPath.row)
        if card.revealed {
                UIView.transition(with: cell.imageView!,
                              duration: 0.25,
                              options: .transitionFlipFromRight,
                              animations: { cell.imageView?.image = UIImage(named: card.imageName) },
                              completion: nil)

        } else {
            UIView.transition(with: cell.imageView!,
                              duration: 0.25,
                              options: .transitionFlipFromRight,
                              animations: { cell.imageView?.image = UIImage(named: card.backgroundImageName) },
                              completion: nil)
            
        }
        return cell
    }
    
    override func collectionView(_: UICollectionView, didSelectItemAt: IndexPath) {
        if(isWaiting) {
            return
        }
        let card = Game.sharedGame.getCard(row: didSelectItemAt.section, column: didSelectItemAt.row)
        if(card.revealed) {
            return
        }
        card.revealed = true
        if(self.card1 == nil) {
            card1 = (card, didSelectItemAt)
            self.collectionView.reloadItems(at: [didSelectItemAt])
        } else {
            if(card2 == nil) {
                card2 = (card, didSelectItemAt)
            }
            self.collectionView.reloadItems(at: [didSelectItemAt])
            if(card1!.0.cardID != card2!.0.cardID) {
                self.isWaiting = true
                AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate)) 
                Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { timer in
                    self.card1!.0.revealed = false
                    self.card2!.0.revealed = false
                    self.collectionView.reloadItems(at: [self.card1!.1, self.card2!.1])
                    self.card1 = nil
                    self.card2 = nil
                    self.isWaiting = false
                }
            } else {
                self.collectionView.reloadItems(at: [didSelectItemAt])
                self.card1 = nil
                self.card2 = nil
                AudioServicesPlaySystemSound(self.soundID)
               
            }
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView,
                                 layout collectionViewLayout: UICollectionViewLayout,
                                 sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let availableRowWidth = 320.0
        let rowCardCount = Double(exactly: self.collectionView(collectionView, numberOfItemsInSection: indexPath.section))
        let cellWidth = availableRowWidth/rowCardCount!
        let cellHeight = cellWidth/ASPECT_RATIO
        return CGSize(width: cellWidth, height: cellHeight)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5.0, left: 5.0, bottom: 5.0, right: 5.0)
    }

}
