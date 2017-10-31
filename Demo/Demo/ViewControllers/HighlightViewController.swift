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
        let cardContent = storyboard?.instantiateViewController(withIdentifier: "CardContent").view
        second.shouldPresent(cardContent, from: self)
        
        
    }

    
}


extension HighlightViewController: CardDelegate {
    
    func cardDidTapInside(card: Card) {
        
        if card == first {
            card.shadowColor = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        } else {
            print("Hey, I'm the second one :)")
        }
    }
    
    func cardHighlightDidTapButton(card: CardHighlight, button: UIButton) {
        
        card.buttonText = "HEY!"
    }
    
}
