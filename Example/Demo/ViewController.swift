//
//  ViewController.swift
//  Cards
//
//  Created by Paolo on 05/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import UIKit
import Cards

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let icons: [UIImage] = [
            UIImage(named: "grBackground")!,
            UIImage(named: "background")!,
            UIImage(named: "flappy")!,
            UIImage(named: "flBackground")!,
            UIImage(named: "Icon")!,
            UIImage(named: "mvBackground")!
            
        ]   // Data source for CardGroupSliding
        
        let card = CardHighlight(frame: CGRect(x: 10, y: 30, width: 200 , height: 240))
        card.backgroundColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)
        card.icon = UIImage(named: "flappy")
        card.title = "Welcome \nto \nCards !"
        card.itemTitle = "Flappy Bird"
        card.itemSubtitle = "Flap That !"
        card.textColor = UIColor.white
        
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "CardContent")
        card.detailView = detailVC?.view
        
        view.addSubview(card)
    }
}

extension CardGroupSliding {
    func make() -> CardGroupSliding {
        let view = CardGroupSliding(frame: CGRect(x: 10, y: 30, width: 200 , height: 240))
        view.backgroundColor = UIColor(red: 0, green: 94/255, blue: 112/255, alpha: 1)

        view.title = "Welcome \nto \nCards !"
        
        view.subtitle = "Flap That !"
        view.textColor = UIColor.white

        // Data source for CardGroupSliding
        view.icons = [
            UIImage(named: "grBackground")!,
            UIImage(named: "background")!,
            UIImage(named: "flappy")!,
            UIImage(named: "flBackground")!,
            UIImage(named: "Icon")!,
            UIImage(named: "mvBackground")!
        ]

        return view
    }
}


