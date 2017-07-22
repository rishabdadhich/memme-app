//
//  MemeCollectionViewController.swift
//  memme-app
//
//  Created by Rishabh on 30/04/1939 Saka.
//  Copyright © 1939 Saka rishi. All rights reserved.
//

import UIKit



class MemeCollectionViewController: UICollectionViewController {

    var memes = [Meme]()
    let appDelegate = (UIApplication.shared.delegate as! AppDelegate)

      @IBOutlet weak var flowLayout: UICollectionViewFlowLayout!
    
    override func viewDidLoad() {
        super.viewDidLoad()
      collectionView?.reloadData()
        memes = appDelegate.memes
        layoutCells()
    }

   
        struct Constants {
        static let CellVerticalSpacing: CGFloat = 2
    }
    
      func layoutCells() {
        var cellWidth: CGFloat
        var numWide: CGFloat
        
     
        switch UIDevice.current.orientation {
        case .portrait:
            numWide = 3
        case .portraitUpsideDown:
            numWide = 3
        case .landscapeLeft:
            numWide = 4
        case .landscapeRight:
            numWide = 4
        default:
            numWide = 4
        }
       
        cellWidth = collectionView!.frame.width / numWide
       
        cellWidth -= Constants.CellVerticalSpacing
        flowLayout.itemSize.width = cellWidth
        flowLayout.itemSize.height = cellWidth
        flowLayout.minimumInteritemSpacing = Constants.CellVerticalSpacing
        
        
        let actualCellVerticalSpacing: CGFloat = (collectionView!.frame.width - (numWide * cellWidth))/(numWide - 1)
        flowLayout.minimumLineSpacing = actualCellVerticalSpacing
        
       
        flowLayout.invalidateLayout()
    }
    

  

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return memes.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! MemeCollectionViewCell
    let meme = memes[indexPath.row]
       cell.imegView?.image = meme.memed
        cell.imegView?.contentMode = UIViewContentMode.scaleAspectFill
        return cell
    }
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let destinationController = storyboard?.instantiateViewController(withIdentifier: "DetailViewController") as! MemeDetailViewController
        let meme = memes[indexPath.row]
        destinationController.meme = meme
        navigationController?.pushViewController(destinationController, animated: true)
    }
   
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}
