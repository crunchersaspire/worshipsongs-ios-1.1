//
//  UtilitiesService.swift
//  worshipsongs
//
//  Created by Seenivasan Sankaran on 3/31/15.
//  Copyright (c) 2015 mCruncher. All rights reserved.
//

import Foundation

import UIKit
import SystemConfiguration

class UtilitiesService  {
    
    let commonService = CommonService()
    
    func copyDatabaseFile(fileName: NSString) {
        var documentDirectoryPath: String = commonService.getDocumentDirectoryPath(fileName)
        var fileManager = NSFileManager.defaultManager()
        if !fileManager.fileExistsAtPath(documentDirectoryPath) {
            var fromPath: String? = NSBundle.mainBundle().resourcePath?.stringByAppendingPathComponent(fileName)
            fileManager.copyItemAtPath(fromPath!, toPath: documentDirectoryPath, error: nil)
        }
    }
}