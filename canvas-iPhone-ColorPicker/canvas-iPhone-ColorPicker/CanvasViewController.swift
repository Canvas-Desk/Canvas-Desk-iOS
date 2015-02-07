//
//  ViewController.swift
//  canvas-iPad
//
//  Created by Jaehyun Jeon on 2/6/15.
//  Copyright (c) 2015 Jaehyun Jeon. All rights reserved.
//

import UIKit

class CanvasViewController: UIViewController, FCColorPickerViewControllerDelegate {

    override func viewDidAppear(animated: Bool) {
        var colorPicker:FCColorPickerViewController = FCColorPickerViewController.colorPicker()
        
        colorPicker.tintColor = UIColor(red: 45.0, green: 47.0, blue: 56.0, alpha: 1.0)
        colorPicker.modalPresentationStyle = UIModalPresentationStyle.CurrentContext
        colorPicker.delegate = self
        self.presentViewController(colorPicker, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        println("loaded")
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func colorPickerViewController(colorPicker: FCColorPickerViewController!, didSelectColor color: UIColor!) {
        println("changePaletteColor")
        var colors = CGColorGetComponents(color.CGColor)
        io.emit("changePaletteColor", [Int(colors[0]*255.0), Int(colors[1]*255.0), Int(colors[2]*255.0)])
        println("changePaletteColor")
    }
    
    func colorPickerViewControllerDidCancel(colorPicker: FCColorPickerViewController!) {
        return
    }

}

