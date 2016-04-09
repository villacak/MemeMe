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
        collectionView.delegate = self
        collectionView.dataSource = self
        memeTabBarController = tabBarController as! MemeTabBarController
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tabBarController?.tabBar.hidden = false
        navigationItem.title = "Memes Collection"
        memesArray = memeTabBarController.memesArray
        collectionView?.reloadData()
    }
    
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return memesArray.count
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
        selectedKey = indexPath.row
        memeTabBarController.selectedKey = selectedKey
        
        tabBarController!.tabBar.hidden = true
        navigationItem.title = nil
        performSegueWithIdentifier("collectionToDetails", sender: self)
        storyboard!.instantiateViewControllerWithIdentifier("detailController") as! DetailViewController
    }
    
    @IBAction func addMemesAction(sender: UIBarButtonItem) {
        PropertiesListUtil().redirectToEditorForNew(self, path: "collectionToEditor")
    }
    
}
