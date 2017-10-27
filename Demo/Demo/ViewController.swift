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
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.rowHeight = 300
        
        /* let icons: [UIImage] = [
            
            UIImage(named: "grBackground")!,
            UIImage(named: "background")!,
            UIImage(named: "flappy")!,
            UIImage(named: "flBackground")!,
            UIImage(named: "Icon")!,
            UIImage(named: "mvBackground")!
            
        ]   // Data source for CardGroupSliding */
        
        let card = CardPlayer(frame: CGRect(x: 40, y: 50, width: 300 , height: 360))
        card.textColor = UIColor.black
        card.videoSource = URL(string: "http://clips.vorwaerts-gmbh.de/big_buck_bunny.mp4")
        self.addChildViewController(card.player)    /// IMPORTANT: Don't forget this
        
        card.playerCover = UIImage(named: "mvBackground")!  // Shows while the player is loading
        card.playImage = UIImage(named: "CardPlayerPlayIcon")!  // Play button icon
        
        card.isAutoplayEnabled = true
        card.shouldRestartVideoWhenPlaybackEnds = true
        
        card.title = "Big Buck Bunny"
        card.subtitle = "Inside the extraordinary world of Buck Bunny"
        card.category = "today's movie"
        
        card.hasParallax = true
        
        let cardContentVC = storyboard!.instantiateViewController(withIdentifier: "CardContent")
        card.shouldPresent(cardContentVC.view, from: self)
        
        //view.addSubview(card)
    }
}

extension ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CardCell", for: indexPath)
        let card = cell.viewWithTag(1000) as! CardHighlight
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "CardContent")
        
        card.shouldPresent(detailVC?.view, from: self)
        card.textColor = UIColor.white
        card.title = "Welcome \nto \ncards !"
        
        switch indexPath.row {
        case 0:
            card.icon = UIImage(named: "Icon")
            card.textColor = UIColor.black
            card.backgroundColor = UIColor.white
            card.tintColor = UIColor.red
            break
        case 1:
            card.icon = UIImage(named: "flappy")
            card.backgroundColor = UIColor.lightGray
            card.tintColor = UIColor.green
            break
        case 2:
            card.icon = UIImage(named: "flappy")
            card.backgroundImage = UIImage(named: "flBackground")
            card.tintColor = UIColor.green
            
        default:
            break
        }
        
        return cell
    }
    
    
}










