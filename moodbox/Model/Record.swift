//
//  Record.swift
//  moodbox
//
//  Created by 牧云踏歌 on 2023/3/17.
//

import Combine
import CoreImage
import CoreData

class Record:NSManagedObject , Identifiable{
    
    @NSManaged var id: String
    @NSManaged var happy_type: Int16
    @NSManaged var create: Date
    @NSManaged var content: String?
    @NSManaged var image: Data?
    
}
