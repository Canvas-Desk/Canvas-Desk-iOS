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
    var tool = "bezier"
    var color:UIColor! = UIColor.blackColor()
    var lineWidth:CGFloat! = CGFloat(5.0)
    var prevPoint:CGPoint!
    var currentPoint:CGPoint!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        universalCanvas = self
        self.multipleTouchEnabled = false
        self.backgroundColor = UIColor.whiteColor()
        path = UIBezierPath()
        path.lineWidth = lineWidth
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        universalCanvas = self
        self.multipleTouchEnabled = false
        path = UIBezierPath()
        path.lineWidth = lineWidth
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    */
    override func drawRect(rect: CGRect) {
        //UIColor(patternImage: UIImage(named: "brush.png")!).setStroke()
        if tool == "bezier" {
            color.setStroke()
            path.lineCapStyle = kCGLineCapRound
            incrementalImage.drawInRect(rect)
            path.stroke()
        } else {
            incrementalImage.drawInRect(rect)
            if (currentPoint != nil && prevPoint != nil) {
            //UIGraphicsBeginImageContext(self.frame.size)
            var texture:UIImage = UIImage(named: "brush.png")!
            var vector:CGPoint = CGPointMake(currentPoint.x-prevPoint.x, currentPoint.y-prevPoint.y)
            var distance:CGFloat = CGFloat(hypotf(Float(vector.x), Float(vector.y)))
            vector.x /= distance
            vector.y /= distance
            var point:CGPoint!
            for (var i:CGFloat = 0.0; i < distance; i += 1.0) {
                point = CGPointMake(currentPoint.x + i * vector.x, currentPoint.y + i * vector.y)
                //texture.drawInRect(CGRect(origin: CGPoint(x: point.x-5,y: point.y-5), size: CGSize(width: 10.0, height: 10.0)))
                texture.drawAtPoint(point, blendMode: kCGBlendModeNormal, alpha: 1.0)
            }
            //UIGraphicsEndImageContext()
            prevPoint = currentPoint
                //move to here
            
            }
            
        }
        println("drawRect")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch:UITouch = touches.anyObject() as UITouch
        var p:CGPoint = touch.locationInView(self)
        if tool == "bezier" {
            ctr = 0
            pts[0] = p
        } else {
            prevPoint = p
        }
        println("touchesBegan")
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var touch:UITouch = touches.anyObject() as UITouch
        var p:CGPoint = touch.locationInView(self)
        
        if tool == "bezier" {
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
        } else {
            self.setNeedsDisplay()
            currentPoint = p
        }
        println("touchesMoved")
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if tool == "bezier" {
            self.drawBitmap(touches)
            self.setNeedsDisplay()
            path.removeAllPoints()
            ctr = 0
        }
        println("touchesEnded")
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        self.touchesEnded(touches, withEvent: event)
        println("touchesCancelled")
    }
    
    func drawBitmap(touches: NSSet) {
        if tool == "bezier" {
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, true, 0.0)
            if((incrementalImage) != nil) {
                var rectpath:UIBezierPath = UIBezierPath(rect: self.bounds)
                UIColor.whiteColor().setFill()
                rectpath.fill()
            }
            incrementalImage.drawAtPoint(CGPointZero)
            
            //UIColor(patternImage: UIImage(named: "brush.png")!).setStroke()
            color.setStroke()
            path.stroke()
            incrementalImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
    }
}
