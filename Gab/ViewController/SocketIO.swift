//
//  SocketIO.swift
//  Gab
//
//  Created by 심상갑 on 2021/11/11.
//

import Foundation
import UIKit
import SocketIO
import SwiftyJSON


class SocketIO: NSObject{
    static let shared = SocketIO()
    var manager = SocketManager(socketURL: URL(string: "https://devsol6.club5678.com:5555")!, config: [.reconnects(false)])
    var socket: SocketIOClient!
 
    override init(){
        super.init()
        socket = self.manager.socket(forNamespace: "/")
        print("socekt init complete")
        
    }

    func getSocket() -> SocketIOClient {
         return socket
     }
    func socketConnetion(){
        socket.connect()
        print("socket connect..")
    }
    
    func closeConnection(){
        socket.disconnect()
        print("socket disconnect...")
    }

    
    func enterChatLive(_ mem_id: String, _ chat_name: String, _ mem_photo: String){
        
        socket.emitWithAck("message", ["cmd" : "reqRoomEnter", "mem_id" : "\(mem_id)","chat_name": "\(chat_name)", "mem_photo" : "\(mem_photo)"]).timingOut(after: 2){ ack in
        }
    }
    
    func reqRoomOut(){
        closeConnection()
    }
    
    func sendLike(){
        socket.emit("message", ["cmd" : "sendLike"])
    }
    
    func sendMsg(_ message : String){
        socket.emit("message", ["cmd" : "sendChatMsg", "msg" : "\(message)"])
    }
}
