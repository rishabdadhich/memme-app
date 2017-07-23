//
//  MemeDetailViewController.swift
//  memme-app
//
//  Created by Rishabh on 30/04/1939 Saka.
//  Copyright © 1939 Saka rishi. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    
    @IBOutlet weak var imgView: UIImageView!
    var meme:Meme! = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        imgView.image = meme.memed
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
