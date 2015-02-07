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
        io.emit("identify","iPhone")
    }
    
    io.on("disconnect") {data in
        println("disconnected")
    }
    
    io.on("paletteColor") {data in
        println("paletteColor")
        var rgb:[CGFloat] = data as [CGFloat]
        println(rgb)
        universalCanvas.color = UIColor(red: rgb[0]/255.0, green: rgb[1]/255.0, blue: rgb[2]/255.0, alpha: 1.0)
    }
}