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
        self.title = "Color"
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
            case 0: return NUMBER_OF_ROWS   // section 0 has 2 rows
            default: fatalError("Unknown number of sections")
        }
    }
    
    // Return the row for the corresponding section and row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return getTableViewCell("Tamil")
            case 1: return getTableViewCell("English")
            default: fatalError("Unknown row in section 0")
            }
        default: fatalError("Unknown section")
        }
    }
    
    
    func getTableViewCell(labelText: String)  -> UITableViewCell{
        var tableViewCell: UITableViewCell = UITableViewCell()
        var textLabel: UILabel = UILabel()
        var colorLabel: UILabel = UILabel()
        
        tableViewCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        textLabel = UILabel(frame: CGRectMake(10, 10, 250, 25))
        textLabel.text = labelText
        textLabel.font = getDefaultFont()
        tableViewCell.addSubview(textLabel)
        
        colorLabel = UILabel(frame: CGRectMake(260, 15, 10, 10))
        let userSelectedPrimaryColorData  =  NSUserDefaults.standardUserDefaults().objectForKey("tamilFontColor") as? NSData
        colorLabel.backgroundColor = UIColor.blackColor()
        tableViewCell.addSubview(colorLabel)
        
        return tableViewCell
    }
    
    func getDefaultFont() -> UIFont{
        return UIFont(name: "HelveticaNeue", size: CGFloat(14))!
    }
    
}
