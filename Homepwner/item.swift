//
//  item.swift
//  Homepwner
//
//  Created by Ethan Schmalz on 9/15/17.
//  Copyright © 2017 Ethan Schmalz. All rights reserved.
//

import Foundation


class Item: NSObject, NSCoding {
    
    var name: String
    var details: String
    var uuid: String
    var drawing: Bool
    var picture: Bool
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(details, forKey:"details")
        aCoder.encode(uuid, forKey:"uuid")
        aCoder.encode(drawing, forKey:"drawing")
        aCoder.encode(picture, forKey:"picture")
    }
    
    required init(coder aDecoder: NSCoder){
        name = aDecoder.decodeObject(forKey: "name") as! String
        details = aDecoder.decodeObject(forKey: "details") as! String
        uuid = aDecoder.decodeObject(forKey: "uuid") as! String
        drawing = aDecoder.decodeBool(forKey: "drawing") 
        picture = aDecoder.decodeBool(forKey: "picture")
        super.init()
    }
    
    
    //designated initializer
    init(name: String, details: String?, uuid: String, drawing: Bool, picture: Bool){
        self.name = name
        self.details = details!
        self.uuid = uuid
        self.drawing = drawing
        self.picture = picture
        super.init()
    }
    
    convenience init(random: Bool = false){
        let tempUUID = UUID().uuidString
        if random{
            self.init(name:"HI", details:"hi", uuid: tempUUID, drawing: false, picture: false)
        }else{
            self.init(name: "", details: "",uuid: tempUUID, drawing: false, picture: false)
        }
    }
    
}
