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
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.memeTabBarController = self.tabBarController as! MemeTabBarController
    }
    
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        self.tabBarController?.tabBar.hidden = false
        self.navigationController?.setToolbarHidden(true, animated: false)
        self.navigationItem.title = "Memes List"
        self.tableView.rowHeight = 200
        self.memesArray = memeTabBarController.memesArray
        self.selectedKey = memeTabBarController.selectedKey
        self.tableView?.reloadData()
        memeSegue()
    }
    
    
    func memeSegue() {
        if self.memesArray?.count == 0 {
            self.tabBarController?.tabBar.hidden = true
            self.navigationItem.title = nil
            self.performSegueWithIdentifier("listToEditor", sender: self)
            let editorController = self.storyboard!.instantiateViewControllerWithIdentifier("memeEditor") as! ViewController
            
        }
    }
    
    
    // MARK: - Table view data source
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memesArray.count
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
        
        self.tabBarController!.tabBar.hidden = true
        self.navigationItem.title = nil
        self.performSegueWithIdentifier("listToDetails", sender: self)
        let detailController = self.storyboard!.instantiateViewControllerWithIdentifier("detailController") as! DetailViewController
    }
    
    
    
    @IBAction func addMeme(sender: UIBarButtonItem) {
        memeSegue()
    }
    
    
    
    
}

