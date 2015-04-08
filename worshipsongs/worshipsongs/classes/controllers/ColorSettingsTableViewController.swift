//
//  ColorSettingsTableViewController.swift
//  worshipsongs
//
//  Created by Seenivasan Sankaran on 4/8/15.
//  Copyright (c) 2015 mCruncher. All rights reserved.
//

import UIKit

class ColorSettingsTableViewController: UITableViewController {
    
    var NUMBER_OF_ROWS = 2

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch(section) {
        case 0: return NUMBER_OF_ROWS   // section 0 has 2 rows
        default: fatalError("Unknown number of sections")
        }
    }
    
    
    func getTableViewCell(labelText: String)  -> UITableViewCell{
        var tableCell: UITableViewCell = UITableViewCell()
        var cellLabel: UILabel = UILabel()
        tableCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        cellLabel = UILabel(frame: CGRectMake(10, 10, 250, 25))
        cellLabel.text = labelText
        cellLabel.font = getDefaultFont()
        cellLabel = UILabel(frame: CGRectMake(260, 15, 10, 10))
        let userSelectedPrimaryColorData  =  NSUserDefaults.standardUserDefaults().objectForKey("tamilFontColor") as? NSData
        cellLabel.backgroundColor = UIColor.blackColor()
        return tableCell
    }
    
    func getDefaultFont() -> UIFont{
        return UIFont(name: "HelveticaNeue", size: CGFloat(14))!
    }
    
}
