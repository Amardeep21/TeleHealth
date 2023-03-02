//
//  SocketIOManager.swift
//  SocketChat
//
//  Created by Gabriel Theodoropoulos on 1/31/16.
//  Copyright © 2016 AppCoda. All rights reserved.
//

import UIKit
import SocketIO

class SocketHelper {

    static let shared = SocketHelper()
    var socket: SocketIOClient!

    let manager:SocketManager?

    private init() {
       manager = SocketManager(socketURL: URL(string:SOCKET_URL)!, config: [.log(true), .compress,.connectParams(["token" : "\(token)"])])
        socket = manager?.defaultSocket
    }

    func connectSocket(completion: @escaping(Bool) -> () ) {
        disconnectSocket()
        socket.on(clientEvent: .connect) {[weak self] (data, ack) in
            print("socket connected")
            self?.socket.removeAllHandlers()
            completion(true)
        }
        socket.connect()
    }

    func disconnectSocket() {
        socket.removeAllHandlers()
        socket.disconnect()
        print("socket Disconnected")
    }

    func checkConnection() -> Bool {
        if socket.manager?.status == .connected {
            return true
        }
        return false

    }

    enum Events {
        
        case addUser
        case userAdded
        case sendMessage
        case newMessage
        case UpdateStatusToOnline
        case ReadMessage
        case typing
        case removeTyping
        case DisplayTyping
        case removeTypingMessage
        case statusOnline
        case getOnlineStatus
        case DeactiveChat
        case chatDeactivated
        var emitterName: String {
            switch self {
            case .addUser:
                return "addUser"
            case .userAdded:
                return "userAdded"
            case .sendMessage:
                return "sendMessage"
            case .newMessage:
                return "newMessage"
            case .UpdateStatusToOnline:
                return "UpdateStatusToOnline"
            case .ReadMessage:
                return "ReadMessage"
            case .typing:
                return "typing"
            case .removeTyping:
                return "removeTyping"
            case .DisplayTyping:
                return "DisplayTyping"
            case .removeTypingMessage:
                return "removeTypingMessage"
            case .statusOnline:
                return "statusOnline"
            case .getOnlineStatus:
                return "getOnlineStatus"
            case .DeactiveChat:
                return "DeactiveChat"
            case .chatDeactivated:
                return "chatDeactivated"
            }
        }
        
        //        var listnerName: String {
        //            switch self {
        //            case .search:
        //                return "filtered_tags"
        //            }
        //        }
        
        func emit(params: [String : Any]) {
            SocketHelper.shared.socket.emit(emitterName, params)
        }
        
       
        
        func listen(completion: @escaping (Any) -> Void) {
            SocketHelper.shared.socket.on(emitterName) { (response, emitter) in
                
                completion(response[0])
            }
        }
        
        func off() {
            SocketHelper.shared.socket.off(emitterName)
        }
    }
}
//class SocketIOManager: NSObject {
//    static let sharedInstance = SocketIOManager()
//    private var manager: SocketManager
//    private var socket: SocketIOClient
//
//
//    override init() {
//        manager = SocketManager(socketURL: URL(string: "http://13.233.208.36:5137")!, config: [.log(true), .compress,.forceWebsockets(true),.forcePolling(false)])
//        socket = manager.defaultSocket
//        socket.disconnect()
//    }
//
//    func connectSocket(completion: @escaping(Bool) -> () ) {
//        socket.disconnect()
//        socket.on(clientEvent: .connect) {[weak self] (data, ack) in
//            print("socket connected")
//            self?.socket.removeAllHandlers()
//            completion(true)
//        }
//        socket.connect()
//    }
//    func establishConnection() {
//        socket.connect()
//        print("status",manager.status)
//    }
//
//    func addUser(){
//        let parameter = ["senderId":"107",
//        "receiverId":"160"] as [String:Any]
//        let data = self.jsonToString(json: parameter as AnyObject)
//
//        socket.emitWithAck("addUser","\(data)".data(using: .utf8)!).timingOut(after: 2) {data in
//          print(data)
//        }
//    }
//
////    func listen(completion: @escaping (Any) -> Void) {
////        socket.on("userAdded") { (response, emitter) in
////            print(response)
////            completion(response)
////        }
////    }
////
//    func checkConnection() -> Bool {
//           if socket.manager?.status == .connected {
//               return true
//           }
//           return false
//
//       }
//
//    func closeConnection() {
//        socket.disconnect()
//    }
//
//    func sendMessage(message: String, withNickname nickname: String) {
//     socket.emitWithAck("TestEmit","Shahrukh").timingOut(after: 2) {data in
//          print(data)
//        }
//
//    }
//
//    func jsonToString(json: AnyObject){
//        do {
//            let data1 =  try JSONSerialization.data(withJSONObject: json, options: JSONSerialization.WritingOptions.prettyPrinted) // first of all convert json to the data
//            let convertedString = String(data: data1, encoding: String.Encoding.utf8) // the data will be converted to the string
//            print(convertedString) // <-- here is ur string
//
//        } catch let myJSONError {
//            print(myJSONError)
//        }
//
//    }
//}
