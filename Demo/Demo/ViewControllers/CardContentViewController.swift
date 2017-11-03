//
//  DetailViewController.swift
//  Demo
//
//  Created by Paolo Cuscela on 03/11/17.
//  Copyright © 2017 Paolo Cuscela. All rights reserved.
//

import UIKit

class CardContentViewController: UIViewController {

    
    let colors = [
        
        UIColor.red,
        UIColor.yellow,
        UIColor.blue,
        UIColor.green,
        UIColor.brown,
        UIColor.purple,
        UIColor.orange
        
    ]
    
    override func viewDidLoad() {
        print("Loaded!")
    }
    
    @IBAction func doMagic(_ sender: Any) {
        
        view.backgroundColor = colors[Int(arc4random_uniform(UInt32(colors.count)))]
        
        
    }
    
}
