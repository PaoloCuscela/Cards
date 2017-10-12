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
        
    // Data source for CardGroupSliding
    let icons: [UIImage] = [
        
        UIImage(named: "grBackground")!,
        UIImage(named: "background")!,
        UIImage(named: "flappy")!,
        UIImage(named: "flBackground")!,
        UIImage(named: "icon")!,
        UIImage(named: "mvBackground")!
        
    ]
    
    let card = CardGroupSliding(frame: CGRect(x: 40, y: 50, width: 300 , height: 360))
    card.textColor = UIColor.black
    
    card.icons = icons
    card.iconsSize = 60
    card.iconsRadius = 30
    
    card.title = "from the editors"
    card.subtitle = "Welcome to XI Cards !"

    
    view.addSubview(card)
    }

    
    
    
}


