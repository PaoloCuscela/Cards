//
//  PlayerViewController.swift
//  Demo
//
//  Created by Paolo Cuscela on 30/10/17.
//  Copyright © 2017 Paolo Cuscela. All rights reserved.
//

import UIKit
import Cards

class PlayerViewController: UIViewController {

    @IBOutlet weak var card: CardPlayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        card.videoSource = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        card.shouldDisplayPlayer(from: self)    //Required.
        
        card.playerCover = UIImage(named: "mvBackground")!  // Shows while the player is loading
        card.playImage = UIImage(named: "CardPlayerPlayIcon")!  // Play button icon
        
        card.isAutoplayEnabled = false
        card.shouldRestartVideoWhenPlaybackEnds = true
        
        card.title = "Big Buck Bunny"
        card.subtitle = "Inside the extraordinary world of Buck Bunny"
        card.category = "today's movie"

        let cardContent = storyboard?.instantiateViewController(withIdentifier: "CardContent")
        card.shouldPresent(cardContent, from: self)
        
    }

    
}
