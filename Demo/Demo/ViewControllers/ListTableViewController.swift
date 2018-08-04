//
//  ListTTableViewController.swift
//  Demo
//
//  Created by Paolo Cuscela on 04/08/18.
//  Copyright © 2018 Paolo Cuscela. All rights reserved.
//

import UIKit
import Cards

class ListTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 10
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let card = cell.viewWithTag(1000) as! CardArticle
        let cardContent = storyboard!.instantiateViewController(withIdentifier: "CardContent")
        
        card.shouldPresent(cardContent, from: self, fullscreen: true)
        return cell
    }
    



}
