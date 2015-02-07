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
    var color:UIColor! = UIColor(red: 0.3, green: 0.6, blue: 0.9, alpha: 0.5)
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        universalCanvas = self
        self.multipleTouchEnabled = false
        self.backgroundColor = UIColor.whiteColor()
        path = UIBezierPath()
        path.lineWidth = 15.0
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        universalCanvas = self
        self.multipleTouchEnabled = false
        path = UIBezierPath()
        path.lineWidth = 15.0
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
        self.drawBitmap(touches)
        self.setNeedsDisplay()
        path.removeAllPoints()
        ctr = 0
    }
    
    func getAverageColor(location:CGPoint) {
        UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 1.0)
        self.layer.renderInContext(UIGraphicsGetCurrentContext())
        var image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        //UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        
        getPixelColor(location, image: image)
        
    }
    
    func getPixelColor(pos: CGPoint, image:UIImage) -> UIColor {
        var pixelData = CGDataProviderCopyData(CGImageGetDataProvider(image.CGImage))
        var data: UnsafePointer<UInt8> = CFDataGetBytePtr(pixelData)
        
        var totalR = CGFloat()
        var totalG = CGFloat()
        var totalB = CGFloat()
        var totalA = CGFloat()
        var white = CGFloat()
        
        for (var x=pos.x-25; x<(pos.x+25); x++) {
            for (var y=pos.y-25; y<(pos.y+25); y++) {
                var pixelInfo: Int = ((Int(image.size.width) * Int(y)) + Int(x)) * 4
                
                var r = CGFloat(data[pixelInfo])
                var g = CGFloat(data[pixelInfo+1])
                var b = CGFloat(data[pixelInfo+2])
                var a = CGFloat(data[pixelInfo+3])
                
                println(r)
                println(b)
                if (r==0 && g==0 && b==0) {
                    white++
                }
                if (r==255 && g==255 && b==255) {
                    white++
                }
                else{
                totalR = totalR + r
                totalG = totalG + g
                totalB = totalB + b
                totalA = totalA + a
                }
            }
        }
        
        var r = (totalR/(2500-white))/255.0
        var g = (totalG/(2500-white))/255.0
        var b = (totalB/(2500-white))/255.0
        var a = (totalA/(2500-white))/255.0
        
        println(UIColor(red: r, green: g, blue: b, alpha: a))
        return UIColor(red: r, green: g, blue: b, alpha: a)
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
