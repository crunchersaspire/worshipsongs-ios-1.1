//
//  MasterViewController.swift
//  worshipsongs
//
//  Created by Seenivasan Sankaran on 3/31/15.
//  Copyright (c) 2015 mCruncher. All rights reserved.
//

import UIKit

class MasterViewController: UITableViewController, UIPopoverPresentationControllerDelegate, UISearchBarDelegate {
    
    var songTitles : NSMutableArray = []
    var songs = [String]()
    var songData = [(Songs)]()
    var filteredData = [(Songs)]()
    var detailViewController: DetailViewController? = nil
    var searchBar: UISearchBar!
    //var objects = [AnyObject]()


    override func awakeFromNib() {
        super.awakeFromNib()
        if UIDevice.currentDevice().userInterfaceIdiom == .Pad {
            self.clearsSelectionOnViewWillAppear = false
            self.preferredContentSize = CGSize(width: 320.0, height: 600.0)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "Worship Songs"
        self.addSearchBarButton()
        self.songData = SongDao.instance.getSongList()
        
        var searchBarFrame = CGRectMake(self.view.bounds.origin.x, self.view.bounds.origin.y,
            self.view.bounds.size.width, 44);
        searchBar = UISearchBar(frame: searchBarFrame)
        searchBar.delegate = self;
        searchBar.placeholder = "Search Songs"
        //display the cancel button next to the search bar
        searchBar.showsCancelButton = true;
        searchBar.tintColor = UIColor.grayColor()
        
        if let split = self.splitViewController {
            let controllers = split.viewControllers
            self.detailViewController = controllers[controllers.count-1].topViewController as? DetailViewController
        }
        tableView.dataSource = self
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

//    func insertNewObject(sender: AnyObject) {
//        objects.insert(NSDate(), atIndex: 0)
//        let indexPath = NSIndexPath(forRow: 0, inSection: 0)
//        self.tableView.insertRowsAtIndexPaths([indexPath], withRowAnimation: .Automatic)
//    }

    // MARK: - Segues

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        print("prepare for segue: \(segue.identifier)")
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad)
        {
             print("iPad")
                if segue.identifier == "showDetail" {
                    println("Selected index path:\(self.tableView.indexPathForSelectedRow())")
                    if let indexPath = self.tableView.indexPathForSelectedRow() {
                        let object = self.songData[indexPath.row] as Songs
                        let controller = (segue.destinationViewController as UINavigationController).topViewController as DetailViewController
                        controller.detailItem = object
                        controller.navigationItem.leftBarButtonItem = self.splitViewController?.displayModeButtonItem()
                        controller.navigationItem.leftItemsSupplementBackButton = true
                    }
                }
            
            println("showSettingsPopOver")
            if segue.identifier == "showSettingsPopOver"{
                var popoverContent = self.storyboard?.instantiateViewControllerWithIdentifier("SettingsView") as UIViewController
                var nav = UINavigationController(rootViewController: popoverContent)
                nav.modalPresentationStyle = UIModalPresentationStyle.Popover
                var popover = nav.popoverPresentationController as UIPopoverPresentationController!
                popover.delegate = self
                popover.sourceView = self.view
                self.presentViewController(nav, animated: true, completion: nil)
            }
        }
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            println("iPhone")
            if (segue.identifier == "showDetailPhoneView") {
                let indexPath: AnyObject! = sender
                println("Selected index path:\(indexPath.row)")
                let object = self.songData[indexPath.row] as Songs
                print("Song object: \(object)")
                var detailController = segue.destinationViewController as DetailViewController;
                detailController.detailItem = object
            }
        }
    }

    // MARK: - Table View

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return songData.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell

        let object = songData[indexPath.row] as Songs
        cell.textLabel!.text = object.title
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone)
        {
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            tableView.deselectRowAtIndexPath(indexPath, animated: true)
            performSegueWithIdentifier("showDetailPhoneView", sender: indexPath)
        }
       
    }

    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        return .FullScreen
    }
    
    
    func presentationController(controller: UIPresentationController!, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController! {
        println("hi")
        return UINavigationController(rootViewController: controller.presentedViewController)
    }
    
    func addSearchBarButton(){
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "searchButtonItemClicked:"), animated: true)
    }

}

