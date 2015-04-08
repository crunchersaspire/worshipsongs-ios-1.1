//
//  SettingsTableViewController.swift
//  worshipsongs
//
//  Created by Seenivasan Sankaran on 4/1/15.
//  Copyright (c) 2015 mCruncher. All rights reserved.
//

import UIKit

class SettingsTableViewController: UITableViewController, UIPopoverPresentationControllerDelegate {
    
    var selectedSettingValue:String!
    var settingsMen: [String] = ["Font", "Color", "Rest", "Other"]
    
    var restoreSettingCell: UITableViewCell = UITableViewCell()
    var aboutSettingCell: UITableViewCell = UITableViewCell()
    var versionSettingCell: UITableViewCell = UITableViewCell()
    
    var restoreSettingButton: UIButton = UIButton()
    var aboutSettingButton: UIButton = UIButton()
    var versionLabel: UILabel = UILabel()
    var versionValueLabel: UILabel = UILabel()
    var commonService = CommonService()
    
    override func viewDidLoad() {
        var navBar = UINavigationBar()
        super.viewDidLoad()
        self.view.addSubview(navBar)
        //self.navigatio = "Settings"
        self.navigationItem.title = "Settings"
        //self.tableView.backgroundColor = UIColor.whiteColor()
        
        // construct color setting cell, section 2, row 0
        self.restoreSettingCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.restoreSettingButton = UIButton(frame: CGRectMake(0, 5, 10, 10))
        self.restoreSettingButton.addTarget(self, action: "resetValue:", forControlEvents: UIControlEvents.TouchUpInside)
        self.restoreSettingButton.setTitle("Reset to default", forState: UIControlState.Normal)
        self.restoreSettingButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.restoreSettingButton.sizeToFit()
        self.restoreSettingButton.titleLabel?.font = getDefaultFont()
        self.restoreSettingCell.addSubview(self.restoreSettingButton)
        
        // construct color setting cell, section 3, row 0
        self.versionSettingCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.versionLabel = UILabel(frame: CGRectMake(5, 10, 70, 20))
        self.versionLabel.text = "Version"
        self.versionLabel.textAlignment = NSTextAlignment.Left;
        self.versionLabel.font = getDefaultFont()
        self.versionValueLabel = UILabel(frame: CGRectMake(0, 5, 10, 10))
        self.versionValueLabel.text = "version"
        self.versionLabel.textAlignment = NSTextAlignment.Right;
        self.versionValueLabel.textColor = UIColor.grayColor()
        self.versionValueLabel.numberOfLines = 0;
        self.versionValueLabel.font = getDefaultFont()
        self.versionValueLabel.textAlignment = NSTextAlignment.Right;
        self.versionSettingCell.contentView.addSubview(self.versionLabel)
        self.versionSettingCell.contentView.addSubview(self.versionValueLabel)
        
        self.aboutSettingCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.aboutSettingButton = UIButton(frame: CGRectMake(10, 5, 10, 10))
        self.aboutSettingButton.addTarget(self, action: "goAbout:", forControlEvents: UIControlEvents.TouchUpInside)
        self.aboutSettingButton.setTitle("About", forState: UIControlState.Normal)
        self.aboutSettingButton.setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        self.aboutSettingButton.sizeToFit()
        self.aboutSettingButton.titleLabel?.font = getDefaultFont()
        self.aboutSettingCell.addSubview(self.aboutSettingButton)
    }

    // MARK: - Table view data source

     override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

     override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch(section) {
        case 0: return 2    // section 0 has 2 rows
        case 1: return 3    // section 1 has 1 row
        default: fatalError("Unknown number of sections")
        }
    }

   
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return getTableViewCell("Font")
            case 1: return getTableViewCell("Color")
            default: fatalError("Unknown row in section 0")
            }
        case 1:
            switch(indexPath.row) {
            case 0: return aboutSettingCell
            case 1: return restoreSettingCell
            case 2: return getVersionTableViewCell() // section 2, row 0 is the restoreSettingCell option

            default: fatalError("Unknown row in section 1")
            }
            
        default: fatalError("Unknown section")
        }
    }
    
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        switch(indexPath.section){
        case 0:
            switch(indexPath.row) {
            case 0: selectedSettingValue = "Font"
            case 1: selectedSettingValue = "Color"
            default: fatalError("Unknown number of rows")
            }
        default: fatalError("Unknown number of sections")
        }
        
        if (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone){
            if selectedSettingValue == "Font"{
                performSegueWithIdentifier("segueFontSettings", sender: indexPath)
            }
            else if selectedSettingValue == "Color"{
                performSegueWithIdentifier("segueColorSettings", sender: indexPath)
            }
        }
        
    }
    
    // Customize the section headings for each section
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Appearence"
        case 1: return "General"
        default: fatalError("Unknown section")
        }
    }
    
    func getTableViewCell(labelText: String)  -> UITableViewCell{
        var tableCell: UITableViewCell = UITableViewCell()
        var cellLabel: UILabel = UILabel()
        tableCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        cellLabel = UILabel(frame: CGRectInset(tableCell.contentView.bounds, 30, 0))
        cellLabel.text = labelText
        cellLabel.font = getDefaultFont()
        tableCell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        var fontImage = UIImage(named: "Font-icon.png");
        //  fontImageView.image = fontImage;
        //  self.fontSettingsCell.addSubview(fontImageView)
        tableCell.addSubview(cellLabel)
        return tableCell
    }
    
    func getVersionTableViewCell() -> UITableViewCell{
        var versionTableViewCell : UITableViewCell? = tableView.dequeueReusableCellWithIdentifier("CELL_ID") as? UITableViewCell
        if(versionTableViewCell == nil)
        {
            versionTableViewCell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "CELL_ID")
        }
        versionTableViewCell!.textLabel?.text="Version"
        versionTableViewCell!.detailTextLabel?.text = commonService.getVersionNumber()
        versionTableViewCell!.detailTextLabel?.numberOfLines=0
        versionTableViewCell!.textLabel?.font = getDefaultFont()
        versionTableViewCell!.detailTextLabel?.font = getDefaultFont()
        versionTableViewCell!.selectionStyle = UITableViewCellSelectionStyle.None;
        versionTableViewCell!.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        return versionTableViewCell!
    }


    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Segue: \(segue.identifier)")
        if (segue.identifier == "segueFontSettings") {
            var detailController = segue.destinationViewController as FontSettingsTableViewController;
        }
        else if (segue.identifier == "segueColorSettings") {
            var detailController = segue.destinationViewController as ColorSettingsTableViewController;
        }
    }

    func getDefaultFont() -> UIFont{
        return UIFont(name: "HelveticaNeue", size: CGFloat(14))!
    }

}
