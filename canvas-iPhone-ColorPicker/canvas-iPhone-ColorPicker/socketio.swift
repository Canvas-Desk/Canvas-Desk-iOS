//
//  socketio.swift
//  blurt
//
//  Created by Jaehyun Jeon on 1/30/15.
//  Copyright (c) 2015 Jaehyun Jeon. All rights reserved.
//
import UIKit
import Foundation

var io = SocketIOClient(socketURL: "http://104.236.192.49:8080")

func ioDelegates(){
    io.on("connect") {data in
        println("connected")
        io.emit("identify","picker")
    }
    
    io.on("disconnect") {data in
        println("disconnected")
    }
    

}