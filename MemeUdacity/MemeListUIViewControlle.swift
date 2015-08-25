//
//  MemeListUIViewControlle.swift
//  MemeUdacity
//
//  Created by Klaus Villaca on 8/15/15.
//  Copyright (c) 2015 Klaus Villaca. All rights reserved.
//

import UIKit


class MemeListUIViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var memeTabBarController: MemeTabBarController!
    
    var memesArray: [MemeData?]!
    var selectedKey: Int!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        memeTabBarController = tabBarController as! MemeTabBarController
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        tabBarController?.tabBar.hidden = false
        navigationController?.setToolbarHidden(true, animated: false)
        navigationItem.title = "Memes List"
        tableView.rowHeight = 200
        memesArray = memeTabBarController.memesArray
        selectedKey = memeTabBarController.selectedKey
        tableView?.reloadData()
        memeSegue()
    }
    
    
    func memeSegue() {
        if memesArray?.count == 0 {
            tabBarController?.tabBar.hidden = true
            navigationItem.title = nil
            performSegueWithIdentifier("listToEditor", sender: self)
            let editorController = storyboard!.instantiateViewControllerWithIdentifier("memeEditor") as! ViewController
        }
    }
    
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memesArray.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let meme: MemeData = memesArray[indexPath.row] as MemeData!
        
        let cell = tableView.dequeueReusableCellWithIdentifier("CustomCell", forIndexPath: indexPath) as! MemeTableViewCell
        
        cell.imageViewTableCell?.image = meme.imageMemeStored
        cell.imageViewTableCell?.contentMode = UIViewContentMode.ScaleToFill
        cell.topLabelTableCell?.text = meme.topText
        cell.bottomLabelTableCell?.text = meme.bottomText
        cell.topLabelTableCellHz?.text = meme.topText
        cell.bottomLabelTableCellHz?.text = meme.bottomText
        return cell
    }
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.selectedKey = indexPath.row
        memeTabBarController.selectedKey = self.selectedKey
        
        tabBarController!.tabBar.hidden = true
        navigationItem.title = nil
        performSegueWithIdentifier("listToDetails", sender: self)
        let detailController = storyboard!.instantiateViewControllerWithIdentifier("detailController") as! DetailViewController
    }
    
    
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        tabBarController?.tabBar.hidden = true
        navigationItem.title = nil
        performSegueWithIdentifier("listToEditor", sender: self)
        let editorController = storyboard!.instantiateViewControllerWithIdentifier("memeEditor") as! ViewController
        editorController.typeCall = TypeCall.NEW
    }
    
    
    
    
}

