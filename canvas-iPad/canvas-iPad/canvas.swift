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
    var tool = 1
    var color:UIColor! = UIColor.blackColor()
    var lineWidth:CGFloat! = CGFloat(5.0)
    var texture:UIImage!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        universalCanvas = self
        if tool == 2 {
            texture = UIImage(named: "brush2.png")
        }
        if tool == 3 {
            texture = UIImage(named: "brush3.png")
        }
        self.multipleTouchEnabled = false
        self.backgroundColor = UIColor.whiteColor()
        path = UIBezierPath()
        path.lineWidth = lineWidth
    }
    
    func setTexture() {
        if tool == 2 {
            texture = UIImage(named: "brush2.png")
        }
        if tool == 3 {
            texture = UIImage(named: "brush3.png")
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        println("hi")
        //texture = texture.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate)
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
        if tool == 1 {
            color.setStroke()
            path.lineCapStyle = kCGLineCapRound
            incrementalImage.drawInRect(rect)
            path.stroke()
        }
        println("drawRect")
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        var touch:UITouch = touches.anyObject() as UITouch
        var p:CGPoint = touch.locationInView(self)
        if tool == 1 {
            ctr = 0
            pts[0] = p
        }
        println("touchesBegan")
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        var touch:UITouch = touches.anyObject() as UITouch
        var p:CGPoint = touch.locationInView(self)
        
        if tool == 1 {
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
            UIGraphicsBeginImageContext(self.frame.size)
            
            var iv = UIImageView(frame: CGRect(x: p.x-25, y: p.y-25, width: 50, height: 50))
            iv.image = texture
            self.addSubview(iv)
            
            UIGraphicsEndImageContext()
        }
        println("touchesMoved")
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        if tool == 1 {
            self.drawBitmap(touches)
            self.setNeedsDisplay()
            path.removeAllPoints()
            ctr = 0
        }
        else{
            UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 2.0)
            self.layer.renderInContext(UIGraphicsGetCurrentContext())
            var image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            for view in self.subviews {
                view.removeFromSuperview()
            }
            var newView:UIImageView = UIImageView(image: image)
            self.addSubview(newView)
            self.sendSubviewToBack(newView)
        }
        println("touchesEnded")
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        self.touchesEnded(touches, withEvent: event)
        println("touchesCancelled")
    }
    
    func drawBitmap(touches: NSSet) {
        if tool == 1 {
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
