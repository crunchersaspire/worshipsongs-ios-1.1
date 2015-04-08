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
    var textAttributeService = TextAttributeService()
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
        if tableView == self.tableView && filteredData.count > 0 {
            return self.filteredData.count
        }
        else if filteredData.count == 0 && !searchBar.text.isEmpty {
            return 1
        }
        else if songData.count > 0{
            return self.songData.count
        }
        else{
            return 10
        }
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        //ask for a reusable cell from the tableview, the tableview will create a new one if it doesn't have any
        var dataCell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("Cell") as? UITableViewCell
        if(dataCell == nil)
        {
            dataCell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "Cell")
        }
        var song : Songs
        // Check to see whether the normal table or search results table is being displayed and set the Candy object from the appropriate array
        if tableView == self.tableView && filteredData.count > 0 {
            song = filteredData[indexPath.row]
            dataCell!.textLabel!.text = song.title
            dataCell!.textLabel?.font = textAttributeService.getDefaultFont()
        }
        else if filteredData.count == 0 && !searchBar.text.isEmpty {
            dataCell!.textLabel!.text = "No Results found!..."
        }
        else if songData.count > 0 {
            song = songData[indexPath.row]
            dataCell!.textLabel!.text = song.title
            dataCell!.textLabel?.font = textAttributeService.getDefaultFont()
        }
        else{
            dataCell!.textLabel!.text = ""
        }
        return dataCell!
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
    
    // MARK: UISearchBarDelegate
    
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        self.navigationController?.navigationBarHidden=true
        filterContentForSearchText(searchBar)
    }
    
    func searchBarCancelButtonClicked(searchBar: UISearchBar) {
        self.navigationItem.titleView = nil;
        self.searchBar.text = ""
        self.filteredData = [(Songs)]()
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "searchButtonItemClicked:"), animated: true)
        self.tableView.reloadData()
    }
    
    func searchBar(searchBar: UISearchBar, textDidChange searchText: String) {
        filterContentForSearchText(searchBar)
        self.tableView.reloadData()
    }
    
    func filterContentForSearchText(searchBar: UISearchBar) {
        // Filter the array using the filter method
        var searchText = searchBar.text
        var data = [(Songs)]()
        data = self.songData.filter({( song: Songs) -> Bool in
            var stringMatch = (song.title as NSString).localizedCaseInsensitiveContainsString(searchText)
            return (stringMatch.boolValue)
            
        })
        
        if data.count != songData.count{
            self.filteredData = data
        }
    }
    
    func searchButtonItemClicked(sender:UIBarButtonItem){
        self.navigationItem.titleView = searchBar;
        self.navigationItem.rightBarButtonItem=nil
        searchBar.becomeFirstResponder()
    }

    
    // MARK: - UIPopoverPresentationControllerDelegate
    func adaptivePresentationStyleForPresentationController(controller: UIPresentationController!) -> UIModalPresentationStyle {
        return .FullScreen
    }
    
    
    func presentationController(controller: UIPresentationController!, viewControllerForAdaptivePresentationStyle style: UIModalPresentationStyle) -> UIViewController! {
        return UINavigationController(rootViewController: controller.presentedViewController)
    }
    
    func addSearchBarButton(){
        self.navigationItem.setRightBarButtonItem(UIBarButtonItem(barButtonSystemItem: .Search, target: self, action: "searchButtonItemClicked:"), animated: true)
    }

}

