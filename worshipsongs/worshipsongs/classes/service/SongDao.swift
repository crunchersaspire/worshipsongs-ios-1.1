//
//  DatabaseHelper.swift
//  worshipsongs
//
//  Created by Seenivasan Sankaran on 12/19/14.
//  Copyright (c) 2014 Seenivasan Sankaran. All rights reserved.
//

import UIKit

let sharedInstance = SongDao()

class SongDao {
    
    var database: FMDatabase? = nil
    var resultSet: FMResultSet? = nil
   
    
     class var instance: SongDao {
        let commonService:CommonService = CommonService()
        sharedInstance.database = FMDatabase(path: commonService.getDocumentDirectoryPath("songs.sqlite"))
        var path = commonService.getDocumentDirectoryPath("songs.sqlite")
        return sharedInstance
    }
    
    func getSongList() -> [(Songs)] {
        initSetup()
        var songModel = [Songs]()
        var resultSet1: FMResultSet? = sharedInstance.database!.executeQuery("SELECT * FROM songs ORDER BY title", withArgumentsInArray: nil)
        var titles: String = "title"
        var lyrics: String = "lyrics"
        var verseOrder: String = "verse_order"
        var titleList : NSMutableArray = []
        var lyricsList : NSMutableArray = []
        var verseOrderList : NSMutableArray = []
        var songArray : NSMutableArray = []
        if (resultSet1 != nil)
        {
            while resultSet1!.next() {
                songModel.append(Songs(title: resultSet1!.stringForColumn(titles), lyrics: resultSet1!.stringForColumn(lyrics),verse_order: resultSet1!.stringForColumn(verseOrder)))
            }
        }
        return songModel
    }
    
    func initSetup()
    {
        sharedInstance.database!.open()
    }
    
}
