//
//  MemeListUICollectionViewController.swift
//  MemeUdacity
//
//  Created by Klaus Villaca on 8/16/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import UIKit


class MemeListUICollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var memeTabBarController: MemeTabBarController!
    
    var memesArray: [MemeData?]!
    var selectedKey: Int!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.memeTabBarController = self.tabBarController as! MemeTabBarController

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.tabBarController?.tabBar.hidden = false
        self.navigationItem.title = "Memes Collection"
        self.memesArray = memeTabBarController.memesArray
        self.collectionView?.reloadData()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memesArray.count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        
        let meme: MemeData = self.memesArray[indexPath.row] as MemeData!
        
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("CollectionViewCell", forIndexPath: indexPath) as! MemeUICollectionViewCell
        
        cell.imageViewTableCell?.image = meme.imageMemeStored
        cell.imageViewTableCell?.contentMode = UIViewContentMode.ScaleToFill
        cell.topLabelTableCell?.text = meme.topText
        cell.bottomLabelTableCell?.text = meme.bottomText
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath:NSIndexPath)
    {
        self.selectedKey = indexPath.row
        memeTabBarController.selectedKey = self.selectedKey
        
        self.tabBarController!.tabBar.hidden = true
        self.navigationItem.title = nil
        self.performSegueWithIdentifier("collectionToDetails", sender: self)
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("detailController") as! DetailViewController
    }
    
    @IBAction func addMemesAction(sender: UIBarButtonItem) {
        self.tabBarController?.tabBar.hidden = true
        self.navigationItem.title = nil
        self.performSegueWithIdentifier("collectionToEditor", sender: self)
        let editorController = self.storyboard!.instantiateViewControllerWithIdentifier("memeEditor") as! ViewController
    }
    
}
