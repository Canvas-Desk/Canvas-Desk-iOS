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
        io.emit("identify", "iPad")
//        overlapView.hidden = false
//        overlapView.hidden = true
    }
    
    io.on("disconnect") {data in
        println("disconnected")
    }
    
    io.on("updateBrushSize") {data in
        println("updateBrushSize")
        universalCanvas.lineWidth = data as CGFloat
    }
    
    io.on("updateColor") {data in
        println("updateColor")
        var rgb:[CGFloat] = data as [CGFloat]
        println(rgb)
        universalCanvas.color = UIColor(red: rgb[0]/255.0, green: rgb[1]/255.0, blue: rgb[2]/255.0, alpha: 1.0)
    }
    
    io.on("updateBrush") {data in
        println("updateBrush")
        universalCanvas.tool = data as Int
        universalCanvas.setTexture()
    }
    
    io.on("updateImageData") {data in
        println("updateImageData")
        
        var nsdata = NSData(base64EncodedString: data as String, options: NSDataBase64DecodingOptions.allZeros)
        var image = UIImage(data: nsdata!)
        universalCanvas.tool = 5
        universalCanvas.texture = image
    }
    
    io.on("clear") {data in
        viewController.clearCanvas()
    }
}