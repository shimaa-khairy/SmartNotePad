//
//  NoteModel.swift
//  SmartNotepad
//
//  Created by shimaa_khairy on 6/1/21.
//

import Foundation
import RealmSwift
import CoreLocation
class NoteModel : Object{
    
    @objc dynamic var title : String?
    @objc dynamic var body : String?
    @objc dynamic var imageString : String?
    @objc dynamic var noteTimeStamp : String?
    @objc dynamic var location : String?
    @objc dynamic var nearest = 0
    @objc dynamic var lat : Double = 0
    @objc dynamic var long : Double = 0
    
    
}
