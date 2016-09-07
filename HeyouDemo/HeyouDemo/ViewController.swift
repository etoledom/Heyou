//
//  ViewController.swift
//  Heyou
//
//  Created by E. Toledo on 9/6/16.
//  Copyright © 2016 eToledo. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    @IBAction func onShowAlertPress(sender: UIButton) {
        let controller = HYAlertController()
        
        switch sender.tag {
        case 0:
            controller.elements = [
                .title("Title"),
                .description("Description text")
            ]
            controller.buttons = [
                .main("First main"),
                .main("Second main"),
                .normal("Normal button"),
                .main("Last button")
            ]

        case 1:
            controller.elements = [
                .title("Title"),
                .description("Description text")
            ]
            controller.buttonsTitles = [
                "First button",
                "Second button"
            ]
            controller.buttonsLayout = .horizontal
            
        case 2:
            controller.elements = [
                .title("Title"),
                .subTitle("A Subtitle"),
                .description("Description text")
            ]
            controller.buttonsTitles = [
                "First button",
                "Second button"
            ]
        default:
            controller.elements = [
                .title("Title"),
                .image(named: "house"),
                .subTitle("A Subtitle"),
                .description("Description text")
            ]
            controller.buttonsTitles = [
                "Print",
                "Dismiss"
            ]
            controller.onButtonTap = { (index,_) in
                if index == 0 {
                    print("Printing")
                    return false
                }
                return true
            }
        }
        
        controller.showOnViewController(self)
        
    }
}

