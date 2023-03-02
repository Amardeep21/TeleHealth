//
//  ChatModel.swift
//  socketIOChatDemo
//
//  Created by Apple on 09/09/20.
//  Copyright © 2020 Apple. All rights reserved.
//
import ObjectMapper
import Foundation


class GetChatModel: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {
        success <- map["success"]
        message <- map["message"]
        data <- map["data"]
        meta <- map["meta"]
        isChatDeactivated <- map["isChatDeactivated"]
    }
    public var success: Bool?
    public var message: String?
    public var data: [ChatModel]?
    public var meta:MetaDataModel?
     public var isChatDeactivated:Int?
  
}

class ChatModel: Mappable {
    required init?(map: Map) {}
    
    init(message: String,type: Int,senderId:Int,receiverId:Int,createdAt:String) {
        self.message = message
        self.type = type
        self.senderId = senderId
        self.receiverId = receiverId
        self.createdAt = createdAt
    }
    
    func mapping(map: Map) {
        message <- map["message"]
        type <- map["type"]
        senderId <- map["senderId"]
        receiverId <- map["receiverId"]
        createdAt <- map["createdAt"]
        messageId <- map["messageId"]
        }
    
    public var type: Int?
    public var message: String?
    public var senderId: Int?
    public var receiverId: Int?
    public var createdAt: String?
    public var wholeDate: String?
    public var messageId: Int?
}
class GetChatSuceesModel: Mappable {
 
    required init?(map: Map) {}
        func mapping(map: Map) {
               success <- map["success"]
                message <- map["message"]
                data <- map["data"]
                 meta <- map["meta"]
           }
         public var success: Bool?
         public var message: String?
         public var data: [ChatListModel]?
         public var meta:MetaDataModel?
}

class ChatListModel: Mappable {
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        userId <- map["userId"]
        username <- map["username"]
        profile <- map["profile"]
        message <- map["message"]
        unseenMessage <- map["unseenMessage"]
        isOnline <- map["isOnline"]
        time <- map["time"]
        type <- map["type"]
        }
    
    public var userId: Int?
    public var username: String?
    public var profile: String?
    public var message: String?
    public var unseenMessage: Int?
    public var isOnline: Int?
    public var time: String?
    public var type: Int?
}
