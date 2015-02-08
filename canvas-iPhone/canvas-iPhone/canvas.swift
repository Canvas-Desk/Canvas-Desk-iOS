//
//  canvas.swift
//  canvas-iPad
//
//  Created by Jaehyun Jeon on 2/6/15.
//  Copyright (c) 2015 Jaehyun Jeon. All rights reserved.
//

import UIKit

var universalCanvas:canvas!

class canvas: UIView {
    var path:UIBezierPath!
    var incrementalImage:UIImage! = UIImage()
    var pts:[CGPoint]! = [CGPoint(), CGPoint(), CGPoint(), CGPoint(), CGPoint()]
    var ctr = 0
    var color:UIColor! = UIColor(red: 0.0, green: 0.0, blue: 1.0, alpha: 0.2)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        universalCanvas = self
        self.multipleTouchEnabled = false
        self.backgroundColor = UIColor.whiteColor()
        path = UIBezierPath()
        path.lineWidth = 40.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        universalCanvas = self
        self.multipleTouchEnabled = false
        self.backgroundColor = UIColor.whiteColor()
        path = UIBezierPath()
        path.lineWidth = 40.0
    }
    
    override init() {
        super.init()
        universalCanvas = self
        self.multipleTouchEnabled = false
        self.backgroundColor = UIColor.whiteColor()
        path = UIBezierPath()
        path.lineWidth = 40.0
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    override func drawRect(rect: CGRect) {
        color.setStroke()
        path.lineCapStyle = kCGLineCapRound
        incrementalImage.drawInRect(rect)
        path.stroke()
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        ctr = 0
        var touch:UITouch = touches.anyObject() as UITouch
        var p:CGPoint = touch.locationInView(self)
        pts[0] = p
        
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var touch:UITouch = touches.anyObject() as UITouch
        var p:CGPoint = touch.locationInView(self)
        ctr++
        pts[ctr] = p
        if ctr == 4 {
            pts[3] = CGPointMake((pts[2].x + pts[4].x)/2.0, (pts[2].y + pts[4].y)/2.0)
            path.moveToPoint(pts[0])
            path.addCurveToPoint(pts[3], controlPoint1: pts[1], controlPoint2: pts[2])
            self.setNeedsDisplay()
            pts[0] = pts[3]
            pts[1] = pts[4]
            ctr = 1
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        self.drawBitmap(touches)
        self.setNeedsDisplay()
        path.removeAllPoints()
        ctr = 0
    }
    
    func getAverageColor(location:CGPoint) {
        println(location)
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 1.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var cropped:CGImageRef = CGImageCreateWithImageInRect(image.CGImage, CGRect(x: location.x-4, y: location.y-4, width: 8, height: 8))
        var croppedUI:UIImage = UIImage(CGImage: cropped)!
        
        //UIImageWriteToSavedPhotosAlbum(croppedUI, nil, nil, nil)
        println(croppedUI.size)
        getPixelColor(location, image: croppedUI)
        
    }
    
    func getPixelColor(pos: CGPoint, image:UIImage){
        var pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)

        var totalR = UInt32(0)
        var totalG = UInt32(0)
        var totalB = UInt32(0)
        var totalA = UInt32(0)
        var count = UInt32(0)
        
//        var pixelInfo: Int = ((Int(image.size.width) * Int(pos.y)) + Int(pos.x)) * 4
//        println(pos)
//        println(data[pixelInfo+1])
//        println(data[pixelInfo+2])
//        println(data[pixelInfo])
        var r = 0
        var b = 0
        var g = 0
        var a = 0
        println(CFDataGetLength(pixelData))
        for (var i = 0; i < 4*8*8; i = i+4) {
                
                r = Int(data[i+2])
                g = Int(data[i+1])
                b = Int(data[i])
                a = Int(data[i+3])
                
                if (r==255 && g==255 && b==255) {
                    
                }
                else{
                    totalR = totalR + r
                    totalG = totalG + g
                    totalB = totalB + b
                    totalA = totalA + a
            
                    count++
                }
        }
        
        var red = Float(totalR)/Float(count)
        var green = Float(totalG)/Float(count)
        var blue = Float(totalB)/Float(count)
        var alpha = Float(totalA)/Float(count)
        
        //println(UIColor(red: red, green: green, blue: blue, alpha: alpha))
        println(red)
        println(green)
        println(blue)
        if !red.isNaN && !green.isNaN && !blue.isNaN {
            io.emit("mixedColor", [red, green, blue])
        }
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        self.touchesEnded(touches, withEvent: event)
    }
    
    func drawBitmap(touches: NSSet) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        if((incrementalImage) != nil) {
            var rectpath:UIBezierPath = UIBezierPath(rect: self.bounds)
            UIColor.whiteColor().setFill()
            rectpath.fill()
        }
        incrementalImage.drawAtPoint(CGPointZero)
        color.setStroke()
        path.stroke()
        var touch:UITouch = touches.anyObject() as UITouch
        getAverageColor(touch.locationInView(self))
        incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
