//
//  RecordViewModel.swift
//  moodbox
//
//  Created by 牧云踏歌 on 2023/3/23.
//

import Combine
import Foundation

class RecordViewModel:ObservableObject{
    
    
    @Published var happy_type: Int16 = 1
    @Published var create: Date = Date()
    @Published var content: String  = ""
    @Published var image: Data?
    
    var model:Record?
 
    init(){
        
    }
    
    func setRecord(record:Record){
        self.happy_type = record.happy_type
        self.create = record.create
        self.image = record.image        
        
        if let content = record.content {
            self.content = content
        }
        
        self.model = record
    }
    
    func clear(){
        happy_type = 1
        content = ""
        image = nil
        model = nil
    }
    
}
