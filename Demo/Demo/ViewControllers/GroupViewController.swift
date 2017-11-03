//
//  GroupViewController.swift
//  Demo
//
//  Created by Paolo Cuscela on 31/10/17.
//  Copyright © 2017 Paolo Cuscela. All rights reserved.
//

import UIKit
import Cards

class GroupViewController: UIViewController {
    
    @IBOutlet weak var group: CardGroup!
    @IBOutlet weak var sliding: CardGroupSliding!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icons: [UIImage] = [
            
            UIImage(named: "grBackground")!,
            UIImage(named: "background")!,
            UIImage(named: "flappy")!,
            UIImage(named: "flBackground")!,
            UIImage(named: "Icon")!,
            UIImage(named: "mvBackground")!
            
        ]
        
        sliding.icons = icons
        
        let groupCardContent = storyboard?.instantiateViewController(withIdentifier: "CardContent")
        group.shouldPresent(groupCardContent, from: self)
        
        let slidingCardContent = storyboard?.instantiateViewController(withIdentifier: "CardContent")
        sliding.shouldPresent(slidingCardContent, from: self)
        
        
    }

}
