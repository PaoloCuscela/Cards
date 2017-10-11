//
//  ViewController.swift
//  Cards
//
//  Created by Paolo on 05/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icons: [UIImage] = [
            
            UIImage(named: "grBackground")!,
            UIImage(named: "background")!,
            UIImage(named: "flappy")!,
            UIImage(named: "flBackground")!,
            UIImage(named: "icon")!,
            UIImage(named: "mvBackground")!
            
        ]
        
        // Aspect Ratio of 5:6 is preferred
        let card = CardGroupSliding(frame: CGRect(x: 50, y: 50, width: 300 , height: 360))
        card.textColor = UIColor.black
        card.iconsSize = 60
        card.iconsRadius = 30
        card.icons = icons
        view.addSubview(card)
        
        card.delegate = self
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension ViewController: CardDelegate {
    
    func cardDidTapInside(card: Card) {
        if let cardGS = card as? CardGroupSliding {
            print("Card with title: \(cardGS.title) has ben tapped.")
        }
    }
    
}

