//
//  HYAlertViewController.swift
//  HYAlertView
//
//  Created by E. Toledo on 6/14/16.
//  Copyright © 2016 eToledo. All rights reserved.
//

import UIKit

typealias Layout = NSLayoutAttribute

public enum HYAlertButtonsLayout {
    case horizontal
    case vertical
}

public enum HYAlertElement {
    case title(String)
    case subTitle(String)
    case description(String)
    case image(named: String)
}

public enum HYAlertButtonStyle {
    case main(String)
    case normal(String)
}

struct HYAlertStyle {
    //Globals
    static let sideMarging:   CGFloat = 8
    static let topMarging:    CGFloat = 12
    static let bottomMarging: CGFloat = 12
    //Labels
    static let labelSeparation: CGFloat = 10
    //Buttons
    static let mainButtonMarging:  CGFloat = 16
    static let mainButtonHeight:   CGFloat = 44
    static let mainButtonWidth:    CGFloat = 250
    static let normalButtonHeight: CGFloat = 44
    static let buttonsSeparation:  CGFloat = 8
}

public struct HYAlertStyleDefaults {
    
    //Globals
    static var alertWidth      = 300
    static var backgroundColor = UIColor(white: 0.95, alpha: 1)
    static var cornerRadius    = 10
    
    //Labels
    static var titleFont            = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).fontWithSize(20)
    static var titleTextColor       = UIColor.blackColor()
    static var subTitleFont         = UIFont.preferredFontForTextStyle(UIFontTextStyleHeadline).fontWithSize(16)
    static var subTitleTextColor    = UIColor.blackColor()
    static var descriptionFont      = UIFont.preferredFontForTextStyle(UIFontTextStyleBody)
    static var descriptionTextColor = UIColor.blackColor()
    
    //Buttons
    static var mainButtonCornerRadius    = 0
    static var mainButtonObal            = true
    static var mainButtonBackgroundColor = UIColor.blueColor()
    static var mainButtonFont            = UIFont.boldSystemFontOfSize(16)
    static var mainButtonTextColor       = UIColor.whiteColor()
    
    static var normalButtonFont      = UIFont.boldSystemFontOfSize(16)
    static var normalButtonTextColor = UIColor.blackColor()
    
    //Extras
    static var separatorColor            = UIColor(white: 0.85, alpha: 1)
    static var separatorMarging: CGFloat = 8
    
    //Applaying style
    
    static func style(label: UILabel, type: HYAlertElement) {
        switch type {
        case .title:
            label.numberOfLines = 2
            label.font          = HYAlertStyleDefaults.titleFont
            label.textColor     = HYAlertStyleDefaults.titleTextColor
            label.textAlignment = .Center
        case .subTitle:
            label.numberOfLines = 2
            label.font          = HYAlertStyleDefaults.subTitleFont
            label.textColor     = HYAlertStyleDefaults.subTitleTextColor
            label.textAlignment = .Center
        case .description:
            label.numberOfLines = 5
            label.font          = HYAlertStyleDefaults.descriptionFont
            label.textColor     = HYAlertStyleDefaults.descriptionTextColor
            label.textAlignment = .Center
        default:
            assertionFailure("\(type) case not implemented")
        }
    }

    static func styleMainButton(button: UIButton) {
        button.titleLabel?.font = HYAlertStyleDefaults.mainButtonFont
        button.backgroundColor = HYAlertStyleDefaults.mainButtonBackgroundColor
        let textColor = HYAlertStyleDefaults.mainButtonTextColor
        button.setTitleColor(textColor, forState: .Normal)

        
        if HYAlertStyleDefaults.mainButtonObal {
            button.layer.cornerRadius = CGFloat(HYAlertStyle.mainButtonHeight) / 2
        } else {
            button.layer.cornerRadius = CGFloat(HYAlertStyleDefaults.mainButtonCornerRadius)
        }
        
        button.layer.masksToBounds = true
    }
    
    static func styleNormalButton(button: UIButton) {
        button.titleLabel?.font = HYAlertStyleDefaults.normalButtonFont
        let textColor = HYAlertStyleDefaults.normalButtonTextColor
        button.setTitleColor(textColor, forState: .Normal)
    }
}



public class HYAlertViewController: UIViewController {
    
    ///Array of UI Elements to show
    public var elements      = [HYAlertElement]()
    ///Array of buttons titles
    public var buttonsTitles = [String]()
    public var buttons = [HYAlertButtonStyle]()
    ///Layout of buttons. If it's set to .horizontal but the total width of all buttons is too big, 
    ///it will be automatically resetted to .vertical. Default: .vertical
    public var buttonsLayout = HYAlertButtonsLayout.vertical
    ///Closure to call when a button is tapped. The return indicates if the alert should be dismissed after pressing the button.
    public var onButtonTap: (index: Int, title: String) -> Bool = {_,_ in return true }
    ///True if the last button acts as a "Cancel" button, automatically dismissing the Alert.
    ///Default: true
    public var dismissOnLastButton = true
    
    private var alertView: HYAlertView?
    
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        let alertView = HYAlertView(buttonsLayout: buttonsLayout)
        alertView.elements = elements
        alertView.buttonsTitles = buttonsTitles
        alertView.buttons = buttons
        alertView.onButtonPressed = {[weak self] (index, title) in
            guard let weakSelf = self else { return }
            
            let showldDismiss = weakSelf.onButtonTap(index: index, title: title)
            if showldDismiss {
                weakSelf.dismiss()
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)) )
        view.addGestureRecognizer(tap)
        view.backgroundColor = UIColor.blackColor()
        view.addSubview(alertView)
        
        for attribute in [Layout.CenterX, Layout.CenterY] {
            (first: view, second: alertView) >>>- { $0.attribute = attribute }
        }
    }
    
    func dismiss() {
        presentingViewController?.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func onTap(tap: UITapGestureRecognizer) {
        dismiss()
    }
}
