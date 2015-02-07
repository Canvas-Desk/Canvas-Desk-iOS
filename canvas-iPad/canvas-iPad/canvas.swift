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
    var color:UIColor! = UIColor.blackColor()
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        universalCanvas = self
        self.multipleTouchEnabled = false
        self.backgroundColor = UIColor.whiteColor()
        path = UIBezierPath()
        path.lineWidth = 2.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        universalCanvas = self
        self.multipleTouchEnabled = false
        path = UIBezierPath()
        path.lineWidth = 2.0
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    override func drawRect(rect: CGRect) {
        color.setStroke()
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
        var touch:UITouch = touches.anyObject() as UITouch
        getAverageColor(touch.locationInView(self))
        self.drawBitmap()
        self.setNeedsDisplay()
        path.removeAllPoints()
        ctr = 0
        
    }
    
    func getAverageColor(location:CGPoint) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        var cgImage:CGImage = CGImageCreateWithImageInRect(image.CGImage, CGRect(x: location.x-25.0, y: location.y-25.0, width: 50.0, height: 50.0))
        
        var rawData = CGDataProviderCopyData(CGImageGetDataProvider(cgImage))
        
        var buf:UnsafePointer<UInt8> = CFDataGetBytePtr(rawData)
        var length = CFDataGetLength(rawData)
        
        var totalR = Float(0.0)
        var totalG = Float(0.0)
        var totalB = Float(0.0)
        var totalA = Float(0.0)
        var white = 0

        for(var i=0; i<length; i+=4)
        {
            var r = Float(buf[i])
            var g = Float(buf[i+1])
            var b = Float(buf[i+2])
            var a = Float(buf[i+3])
            
            println(g)
            if (r==0 && g==0 && b==0) {
                white++
            }
            
            totalR+=r
            totalG+=g
            totalB+=b
            totalA+=a
        }
        println(totalG)
        println(totalR)
        var red = (totalR/Float(Int(length)/4-white))/255.0
        var green = (totalG/Float(Int(length)/4-white))/255.0
        var blue = (totalB/Float(Int(length)/4-white))/255.0
        var alpha = (totalA/Float(Int(length)/4-white))/255.0
        
        println(green)
        if red > 1 {
            red = 1
        }
        if green > 1 {
            green = 1
        }
        if blue > 1 {
            blue = 1
        }
        if alpha > 1 {
            alpha = 1
        }
        var color:UIColor =  UIColor(red: CGFloat(red), green: CGFloat(green), blue: CGFloat(blue), alpha: CGFloat(alpha))
        
        println(color)
        //self.color = color
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        self.touchesEnded(touches, withEvent: event)
    }
    
    func drawBitmap() {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
        if((incrementalImage) != nil) {
            var rectpath:UIBezierPath = UIBezierPath(rect: self.bounds)
            UIColor.whiteColor().setFill()
            rectpath.fill()
        }
        incrementalImage.drawAtPoint(CGPointZero)
        color.setStroke()
        path.stroke()
        incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
