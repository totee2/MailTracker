//
//  Item.swift
//  Mail tracker
//
//  Created by Antonia Schmidt-Lademann on 13/11/2016.
//  Copyright © 2016 Antonia Schmidt-Lademann. All rights reserved.
//

import UIKit

class Item: NSObject, NSCoding {
    // MARK: Properties
    
    var name: String
    var photo: UIImage?
    var sent = Int()
    var date:NSDate = NSDate()
    
    //MARK: Archiving Paths
    static let DocumentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL  = DocumentsDirectory.appendingPathComponent("items")
    
    // MARK: Types
    struct PropertyKey{
        static let nameKey = "name"
        static let photoKey = "photo"
        static let sentKey = "sent"
        static let dateKey = "date"
    }
    
    // MARK: Initialisation
    
    init?(name: String, photo: UIImage?, sent: Int, sentDate: NSDate?){
        self.name = name
        self.photo = photo
        self.sent = sent
        self.date = sentDate!
        super.init()
        //Initialisation should fail if there is no name or if the sent value is not 1 or 0
        if name.isEmpty || (sent != 0 && sent != 1){
            return nil
        }
    }
    
    //MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: PropertyKey.nameKey)
        aCoder.encode(photo, forKey: PropertyKey.photoKey)
        aCoder.encode(sent, forKey: PropertyKey.sentKey)
        aCoder.encode(date, forKey: PropertyKey.dateKey)
        
    }
    
    required convenience init?(coder aDecoder: NSCoder){
        let name = aDecoder.decodeObject(forKey: PropertyKey.nameKey) as! String
        // Because photo is an optional property of Item, use conditional cast
        let photo = aDecoder.decodeObject(forKey: PropertyKey.photoKey) as? UIImage
        let sent = aDecoder.decodeInteger(forKey: PropertyKey.sentKey)
        let decodedDate = aDecoder.decodeObject(forKey: PropertyKey.dateKey) as? NSDate
        // Must call designated initializer
        self.init(name: name, photo: photo, sent: sent, sentDate: decodedDate)
    }
}
