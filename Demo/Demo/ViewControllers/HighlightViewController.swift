//
//  HighlightViewController.swift
//  Demo
//
//  Created by Paolo Cuscela on 30/10/17.
//  Copyright © 2017 Paolo Cuscela. All rights reserved.
//

import UIKit
import Cards
import Foundation

class HighlightViewController: UIViewController {

    @IBOutlet weak var first: CardHighlight!
    @IBOutlet weak var second: CardHighlight!
    
    let colors = [
    
        UIColor.red,
        UIColor.yellow,
        UIColor.blue,
        UIColor.green,
        UIColor.gray,
        UIColor.brown,
        UIColor.purple,
        UIColor.orange
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        first.delegate = self
        first.hasParallax = true
        
        second.delegate = self
        let cardContent = storyboard?.instantiateViewController(withIdentifier: "CardContent")
        second.shouldPresent(cardContent, from: self, fullscreen: true)
        
        
    }

    func random(min: Int, max:Int) -> Int {
        return min + Int(arc4random_uniform(UInt32(max - min + 1)))
    }
}


extension HighlightViewController: CardDelegate {
    
    func cardDidTapInside(card: Card) {
        
        if card == first {
            card.shadowColor = colors[random(min: 0, max: colors.count-1)]
            (card as! CardHighlight).title = "everyday \nI'm \nshufflin'"
        } else {
            print("Hey, I'm the second one :)")
        }
    }
    
    func cardHighlightDidTapButton(card: CardHighlight, button: UIButton) {
        
        card.buttonText = "HEY!"
    }
    
}



