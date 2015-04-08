//
//  ColorSettingsTableViewController.swift
//  worshipsongs
//
//  Created by Seenivasan Sankaran on 4/8/15.
//  Copyright (c) 2015 mCruncher. All rights reserved.
//

import UIKit

class ColorSettingsTableViewController: UITableViewController {
    
    var colorPaletteService = ColorPaletteService()
    var NUMBER_OF_ROWS = 2
    var colorView: UIViewController = UIViewController()
     var languageColor: UIColor = UIColor()

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
        var userSelectedColorData: NSData!
        if labelText == "Tamil"{
             userSelectedColorData  =  NSUserDefaults.standardUserDefaults().objectForKey("tamilFontColor") as? NSData
        }
        else{
            
             userSelectedColorData  =  NSUserDefaults.standardUserDefaults().objectForKey("englishFontColor") as? NSData
        }
        
        colorLabel.backgroundColor = NSKeyedUnarchiver.unarchiveObjectWithData(userSelectedColorData!) as? UIColor
        tableViewCell.addSubview(colorLabel)
        
        return tableViewCell
    }
    
    // Configure the row selection code for any cells that you want to customize the row selection
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        self.title = "Choose color"
        if(indexPath.section == 0 && indexPath.row == 0) {
            self.colorView.view.hidden = false
            makeColorView(1)
        }
        if(indexPath.section == 0 && indexPath.row == 1) {
            self.colorView.view.hidden = false
            makeColorView(2)
        }
    }
    
    func makeColorView(var colorTag:Int){
        var buttonFrame = CGRect(x: 12, y: 100, width: 30, height: 25)
        var colorPalette: Array<String> = Array()
        colorPalette = colorPaletteService.getColorPalette()
        
        var initialColorValue:Int = (colorPalette.count)/10
        var colorCount:Int = 0
        var defauktButtonOrgin = buttonFrame.origin.x
        for index in 0..<initialColorValue{
            for k in 0..<10{
                makeButton(buttonFrame, backGroundColor: colorPaletteService.hexStringToUIColor(colorPalette[colorCount]), colorTag: colorTag)
                colorCount = colorCount+1
                buttonFrame.origin.x = buttonFrame.size.width + buttonFrame.origin.x
            }
            buttonFrame.origin.x = defauktButtonOrgin
            buttonFrame.origin.y = buttonFrame.origin.y + buttonFrame.size.height
        }
        
        self.addChildViewController(colorView)
        self.colorView.view.alpha = 0;
        self.colorView.view.opaque = true;
        self.colorView.didMoveToParentViewController(self)
        self.colorView.view.frame = self.view.frame
        self.view.addSubview(colorView.view)
        UIView.animateWithDuration(0.25, delay: 0.0, options: .CurveLinear, animations: {
            self.colorView.view.alpha = 1;
            }, completion: nil)
    }
    
    func makeButton(buttonFrame:CGRect, backGroundColor:UIColor,colorTag:Int){
        var myButtonFrame = buttonFrame
        var color = backGroundColor
        let aButton = UIButton(frame: myButtonFrame)
        aButton.backgroundColor = color
        aButton.tag = colorTag
        colorView.view.addSubview(aButton)
        aButton.addTarget(self, action: "displayColor:", forControlEvents: UIControlEvents.TouchUpInside)
        
    }
    
    func displayColor(sender:UIButton){
        var r:CGFloat = 0,g:CGFloat = 0,b:CGFloat = 0
        var a:CGFloat = 0
        var h:CGFloat = 0,s:CGFloat = 0,l:CGFloat = 0
        let color = sender.backgroundColor!
        if color.getHue(&h, saturation: &s, brightness: &l, alpha: &a){
            if color.getRed(&r, green: &g, blue: &b, alpha: &a){
                var colorText = NSString(format: "HSB: %4.2f,%4.2f,%4.2f RGB: %4.2f,%4.2f,%4.2f",
                    Float(h),Float(s),Float(b),Float(r),Float(g),Float(b))
                languageColor = UIColor(red: CGFloat(r), green: CGFloat(g), blue: CGFloat(b), alpha: CGFloat(a))
                let tagValue = sender.tag
                let data = NSKeyedArchiver.archivedDataWithRootObject(languageColor)
                if(tagValue == 1)
                {
                    
                    SettingsDataManager.sharedInstance.saveData(data, key: "tamilFontColor")
                    self.tableView.reloadData()
                   // primaryLanguageColorLabel.backgroundColor = userDefaultsSettingsProviderService.getUserDefaultsColor("tamilFontColor")
                }
                else
                {
                    SettingsDataManager.sharedInstance.saveData(data, key: "englishFontColor")
                    //secondaryLanguageColorLabel.backgroundColor = userDefaultsSettingsProviderService.getUserDefaultsColor("englishFontColor")
                    self.tableView.reloadData()
                }
                self.colorView.view.hidden = true
                
            }
        }
        
    }
    
    func getDefaultFont() -> UIFont{
        return UIFont(name: "HelveticaNeue", size: CGFloat(14))!
    }
    
}
