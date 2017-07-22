//
//  MemeTableViewController.swift
//  memme-app
//
//  Created by Rishabh on 30/04/1939 Saka.
//  Copyright © 1939 Saka rishi. All rights reserved.
//

import UIKit

class MemeTableViewController: UITableViewController,UIViewControllerTransitioningDelegate {

    
    var memes = [Meme]()
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       memes = appDelegate.memes
       tableView.reloadData()
    }

   
    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return memes.count
    }

  
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableViewCell", for: indexPath) as! MemeTableViewCell
        let meme = memes[indexPath.row]
        
        cell.imgView?.image = meme.memed
        cell.lblView?.text = "\(meme.topText) ... \(meme.bottomText)"

        return cell
    }
    

   
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCellEditingStyle.delete {
            appDelegate.memes.remove(at: indexPath.row)  // added as per instructor
            memes.remove(at: indexPath.row)
            tableView.reloadData()
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailViewController = self.storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! MemeDetailViewController
        detailViewController.meme = memes[indexPath.row]
        navigationController!.pushViewController(detailViewController, animated: true)

    }
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
