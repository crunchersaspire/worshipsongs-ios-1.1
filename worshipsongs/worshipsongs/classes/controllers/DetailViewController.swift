//
//  DetailViewController.swift
//  worshipsongs
//
//  Created by Seenivasan Sankaran on 3/31/15.
//  Copyright (c) 2015 mCruncher. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController, UISplitViewControllerDelegate, NSXMLParserDelegate {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    var verseOrderList: NSMutableArray = NSMutableArray()
    var parser: NSXMLParser = NSXMLParser()
    
    var element: String = String()
    var verseOrder : NSMutableArray = NSMutableArray()
    var attribues : NSDictionary = NSDictionary()
    var listDataDictionary : NSMutableDictionary = NSMutableDictionary()
    var parsedVerseOrderList: NSMutableArray = NSMutableArray()
    
    var detailSong : Songs!
    
    var detailItem: Songs? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }

    func configureView() {
        // Update the user interface for the detail item.
        
        if let detail = self.detailItem as Songs! {
            println("Detail view title:\(detail.title)..")
            self.navigationItem.title = detail.title
            var lyrics: NSData = detail.lyrics.dataUsingEncoding(NSUTF8StringEncoding)!
            parser = NSXMLParser(data: lyrics)
            parser.delegate = self
            parser.parse()
            if(verseOrderList.count < 1){
                verseOrderList = parsedVerseOrderList
            }
           // println("Verse order list:\(verseOrderList)");
          //  println("List data dictinory:\(listDataDictionary)")
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        println("Detail view ..\(detailSong)")
        
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
        tableView.dataSource = self
        self.tableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    // MARK: - Table View
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return verseOrderList.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as UITableViewCell
        
        
        var key: String = (verseOrderList[indexPath.row] as String).lowercaseString
        let dataText: NSString? = listDataDictionary[key] as? NSString;
        cell.textLabel!.numberOfLines = 0
        cell.textLabel!.lineBreakMode = NSLineBreakMode.ByWordWrapping;
        cell.textLabel?.text = dataText
       // dataCell!.textLabel!.attributedText = customTextSettingService.getAttributedString(dataText!);
        return cell
    }
    
    
    // MARK: - NSXMLParserDelegate methods
    
    func parser(parser: NSXMLParser!, didStartElement elementName: String!, namespaceURI: String!, qualifiedName qName: String!, attributes attributeDict: [NSObject : AnyObject]!) {
        element = elementName
        attribues = attributeDict
    }
    
    func parser(parser: NSXMLParser!, foundCharacters string: String!) {
        let data = string.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet())
        if (!data.isEmpty) {
            if element == "verse" {
                var verseType = (attribues.objectForKey("type") as String).lowercaseString
                var verseLabel = attribues.objectForKey("label") as String
                //lyricsData.append(data);
                listDataDictionary.setObject(data as String, forKey: verseType + verseLabel)
                if(verseOrderList.count < 1){
                    parsedVerseOrderList.addObject(verseType + verseLabel)
                }
            }
        }
    }



}

