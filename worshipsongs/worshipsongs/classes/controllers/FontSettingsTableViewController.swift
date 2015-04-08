//
//  FontSettingsTableViewController.swift
//  worshipsongs
//
//  Created by Seenivasan Sankaran on 4/1/15.
//  Copyright (c) 2015 mCruncher. All rights reserved.
//

import UIKit

class FontSettingsTableViewController: UITableViewController, UIPickerViewDelegate,UIPickerViewDataSource, UITextFieldDelegate, UIActionSheetDelegate {
    
    let userDefaults = NSUserDefaults.standardUserDefaults()
    var pickerView:UIPickerView = UIPickerView()
    var fontNameCell: UITableViewCell = UITableViewCell()
    var fontNameTextfield: UITextField = UITextField()
    var fontSizeSliderCell: UITableViewCell = UITableViewCell()
    var fontSizeSlider: UISlider = UISlider()
    var fontSizeLabel: UILabel = UILabel()
    var fontNames: Array<String> = Array()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Font"
        
        let path = NSBundle.mainBundle().pathForResource("fontsList", ofType: "plist")
        let pListArray = NSArray(contentsOfFile: path!)
        if let colorPalettePlistFile = pListArray {
            fontNames = colorPalettePlistFile as [String]
        }
        
        
        // construct font setting cell, section 0, row 0
        self.fontNameCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.fontNameTextfield = UITextField(frame: CGRectInset(self.fontNameCell.contentView.bounds, 15, 0))
       // self.fontNameTextfield.text = settingDataManager.getFontName
        self.fontNameTextfield.placeholder = "Select font"
        self.fontNameTextfield.font = getFont()
        self.fontNameTextfield.inputView = pickerView
        self.fontNameTextfield.delegate = self
        self.fontNameTextfield.tintColor=UIColor.clearColor()
        //  self.fontNameTextfield. = false
        self.fontNameCell.addSubview(self.fontNameTextfield)
        
        self.fontSizeSliderCell.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.5)
        self.fontSizeSlider = UISlider(frame: CGRectInset(self.fontSizeSliderCell.contentView.bounds, 50, 0))
        self.fontSizeSlider.maximumValue = 50;
        self.fontSizeSlider.minimumValue = 10;
        self.fontSizeSlider.continuous = true;
        self.fontSizeSlider.addTarget(self, action: "sliderChanged:", forControlEvents: UIControlEvents.ValueChanged)
        self.fontSizeLabel = UILabel(frame: CGRectInset(self.fontSizeSliderCell.contentView.bounds, 20, 0))
     //   let fontSize = CGFloat(settingDataManager.getFontSize)
       // let strFontSize = String(format: "%.0f", Double(fontSize))
       // self.fontSizeSlider.setValue(Float(fontSize), animated: true)
        //self.fontSizeLabel.text = strFontSize
        self.fontSizeSliderCell.addSubview(fontSizeLabel)
        self.fontSizeSliderCell.addSubview(self.fontSizeSlider)
        
        self.pickerView.dataSource = self
        self.pickerView.delegate = self
        self.pickerView.showsSelectionIndicator = true
        self.pickerView.hidden = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 2
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        switch(section) {
        case 0: return 1    // section 0 has 2 rows
        case 1: return 1    // section 1 has 1 row
        default: fatalError("Unknown number of sections")
        }
    }

    // Return the row for the corresponding section and row
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        switch(indexPath.section) {
        case 0:
            switch(indexPath.row) {
            case 0: return self.fontNameCell    // section 0, row 0 is the fontSettingsCell
            default: fatalError("Unknown row in section 0")
            }
        case 1:
            switch(indexPath.row) {
            case 0: return self.fontSizeSliderCell // section 1, row 0 is the keepAwakeCell option
            default: fatalError("Unknown row in section 1")
            }
            
        default: fatalError("Unknown section")
        }
    }
    
    // Customize the section headings for each section
    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch(section) {
        case 0: return "Font name"
        case 1: return "Font size"
        default: fatalError("Unknown section")
        }
    }
    
    
    // Configure the row selection code for any cells that you want to customize the row selection
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func sliderChanged(sender:UISlider){
        fontSizeLabel.text = String(format: "%.0f", fontSizeSlider.value)
      //  SettingsDataManager.sharedInstance.saveData(fontSizeSlider.value, key: "fontSize")
    }
    
    func getFont() -> UIFont{
        return UIFont(name: "HelveticaNeue", size: CGFloat(12))!
    }
    
    
    // returns the number of 'columns' to display.
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
        
    }
    
    // returns the # of rows in each component..
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return fontNames.count
    }
    
    func pickerView(pickerView: UIPickerView!, titleForRow row: Int, forComponent component: Int) -> String
    {
        return fontNames[row]
    }
    
    func pickerView(pickerView: UIPickerView!, didSelectRow row: Int, inComponent component: Int)
    {
        fontNameTextfield.text = fontNames[row]
       // SettingsDataManager.sharedInstance.saveData(fontNames[row], key: "fontName")
        pickerView.hidden = true
    }
    
    
    
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        pickerView.hidden = false
        return true
    }
    
    func resizeImage(image : UIImage) -> UIImage
    {
        var newSize:CGSize = CGSize(width: 24,height: 24)
        let rect = CGRectMake(0,0, newSize.width, newSize.height)
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        
        // image is a variable of type UIImage
        image.drawInRect(rect)
        
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage
    }

}
