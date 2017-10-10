//
//  ViewController.swift
//  Cards
//
//  Created by Paolo on 05/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

   // @IBOutlet weak var card: CardGroupSliding!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icons = [
        
            UIImage(named: "background")!,
            UIImage(named: "Icon")!,
            UIImage(named: "math")!,
            UIImage(named: "mvBackground")!,
            UIImage(named: "math")! 
        ]
        
        //card.icons = icons
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

