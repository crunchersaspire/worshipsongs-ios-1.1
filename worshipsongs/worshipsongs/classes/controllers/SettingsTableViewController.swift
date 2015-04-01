//
//  SettingsTableViewController.swift
//  worshipsongs
//
//  Created by Seenivasan Sankaran on 4/1/15.
//  Copyright (c) 2015 mCruncher. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Settings"
 
    }

    // MARK: - Table view data source

     override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 4
    }

     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 1    // section 0 has 2 rows
        case 1: return 1    // section 1 has 1 row
        case 2: return 1    // section 2 has 1 row
        case 3: return 1
        default: fatalError("Unknown number of sections")
        }
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return getTableViewCell("Font")    // section 0, row 0 is the fontSettingsCell
            default: fatalError("Unknown row in section 0")
            }
        case 1:
            switch(indexPath.row) {
            case 0: return getTableViewCell("Color") // section 1, row 0 is the keepAwakeCell option
            default: fatalError("Unknown row in section 1")
            }
        case 2:
            switch(indexPath.row) {
            case 0: return getTableViewCell("Display") // section 2, row 0 is the restoreSettingCell option
            default: fatalError("Unknown row in section 0")
            }
        case 3:
            switch(indexPath.row) {
            case 0: return getTableViewCell("Other") // section 2, row 0 is the restoreSettingCell option
            default: fatalError("Unknown row in section 0")
            }
            
            
        default: fatalError("Unknown section")
        }
    }
    
    
    func getTableViewCell(labelText: String)  -> UITableViewCell{
        var tableCell: UITableViewCell = UITableViewCell()
        var cellLabel: UILabel = UILabel()
        tableCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        cellLabel = UILabel(frame: CGRectInset(tableCell.contentView.bounds, 30, 0))
        cellLabel.text = labelText
        //  self.fontSettingsLabel.font = textAttributeService.getDefaultFont()
        tableCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        var fontImage = UIImage(named: "Font-icon.png");
        //  fontImageView.image = fontImage;
        //  self.fontSettingsCell.addSubview(fontImageView)
        tableCell.addSubview(cellLabel)
        return tableCell
    }


    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
