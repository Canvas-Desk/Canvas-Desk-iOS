//
//  ViewController.swift
//  canvas-iPad
//
//  Created by Jaehyun Jeon on 2/6/15.
//  Copyright (c) 2015 Jaehyun Jeon. All rights reserved.
//

import UIKit

var viewController:CanvasViewController!

class CanvasViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        println("loaded")
        
        viewController = self
//        overlapView = UIWindow()
//        
//        overlapView.windowLevel = UIWindowLevelStatusBar + 1;
//        overlapView.frame = UIApplication.sharedApplication().statusBarFrame;
//        overlapView.backgroundColor = UIColor.greenColor()
//        overlapView.hidden = true
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func clearCanvas() {
        self.view = canvas()
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

