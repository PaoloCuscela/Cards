//
//  ArticleViewController.swift
//  Demo
//
//  Created by Paolo Cuscela on 31/10/17.
//  Copyright © 2017 Paolo Cuscela. All rights reserved.
//

import UIKit
import Cards

class ArticleViewController: UIViewController {

    @IBOutlet weak var card: CardArticle!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let cardContent = storyboard?.instantiateViewController(withIdentifier: "CardContent")
        card.shouldPresent(cardContent, from: self)
        
        
    }

    

}
