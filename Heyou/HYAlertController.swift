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
    static var titleFont            = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline).withSize(20)
    static var titleTextColor       = UIColor.black
    static var subTitleFont         = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline).withSize(16)
    static var subTitleTextColor    = UIColor.black
    static var descriptionFont      = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    static var descriptionTextColor = UIColor.black
    
    //Buttons
    static var mainButtonCornerRadius    = 0
    static var mainButtonObal            = true
    static var mainButtonBackgroundColor = UIColor.blue
    static var mainButtonFont            = UIFont.boldSystemFont(ofSize: 16)
    static var mainButtonTextColor       = UIColor.white
    
    static var normalButtonFont      = UIFont.boldSystemFont(ofSize: 16)
    static var normalButtonTextColor = UIColor.black
    
    //Extras
    static var separatorColor            = UIColor(white: 0.85, alpha: 1)
    static var separatorMarging: CGFloat = 8
    
    //Applaying style
    
    static func style(_ label: UILabel, type: HYAlertElement) {
        switch type {
        case .title:
            label.numberOfLines = 2
            label.font          = HYAlertStyleDefaults.titleFont
            label.textColor     = HYAlertStyleDefaults.titleTextColor
            label.textAlignment = .center
        case .subTitle:
            label.numberOfLines = 2
            label.font          = HYAlertStyleDefaults.subTitleFont
            label.textColor     = HYAlertStyleDefaults.subTitleTextColor
            label.textAlignment = .center
        case .description:
            label.numberOfLines = 5
            label.font          = HYAlertStyleDefaults.descriptionFont
            label.textColor     = HYAlertStyleDefaults.descriptionTextColor
            label.textAlignment = .center
        default:
            assertionFailure("\(type) case not implemented")
        }
    }

    static func styleMainButton(_ button: UIButton) {
        button.titleLabel?.font = HYAlertStyleDefaults.mainButtonFont
        button.backgroundColor = HYAlertStyleDefaults.mainButtonBackgroundColor
        let textColor = HYAlertStyleDefaults.mainButtonTextColor
        button.setTitleColor(textColor, for: UIControlState())

        
        if HYAlertStyleDefaults.mainButtonObal {
            button.layer.cornerRadius = CGFloat(HYAlertStyle.mainButtonHeight) / 2
        } else {
            button.layer.cornerRadius = CGFloat(HYAlertStyleDefaults.mainButtonCornerRadius)
        }
        
        button.layer.masksToBounds = true
    }
    
    static func styleNormalButton(_ button: UIButton) {
        button.titleLabel?.font = HYAlertStyleDefaults.normalButtonFont
        let textColor = HYAlertStyleDefaults.normalButtonTextColor
        button.setTitleColor(textColor, for: UIControlState())
    }
}



open class HYAlertController: UIViewController, HYPresentationAnimatable {
    
    ///Array of UI Elements to show
    open var elements      = [HYAlertElement]()
    ///Array of buttons titles. This is not compatible with 'self.buttons'
    open var buttonsTitles = [String]()
    /// Array of buttons with its style. This is not compatible with 'self.buttonsTitles'
    open var buttons = [HYAlertButtonStyle]()
    ///Layout of buttons. If it's set to .horizontal but the total width of all buttons is too big, 
    ///it will be automatically resetted to .vertical. Default: .vertical
    open var buttonsLayout = HYAlertButtonsLayout.vertical
    ///Closure to call when a button is tapped. The return indicates if the alert should be dismissed after pressing the button.
    open var onButtonTap: (_ index: Int, _ title: String) -> Bool = {_,_ in return true }
    ///True if the last button acts as a "Cancel" button, automatically dismissing the Alert.
    ///Default: true
    open var dismissOnLastButton = true
    
    open var drawLineSeparator = true
    
    open var onDismissCompletion: ((Int, String) -> ())?
    
    
    open func addNormalButton(name: String) {
        buttons.append(.normal(name))
    }
    
    open func addMainButton(name: String) {
        buttons.append(.main(name))
    }
    
    open func addTitle(_ title: String) {
        elements.append(.title(title))
    }
    
    open func addSubtitle(_ subtitle: String) {
        elements.append(.subTitle(subtitle))
    }
    
    open func addImage(name: String) {
        elements.append(.image(named: name))
    }
    
    open func addDescription(_ description: String) {
        elements.append(.description(description))
    }
    
    
    
    var topView: UIView {
        get {
            guard let view = alertView else { assertionFailure("alertView is nil"); return UIView() }
            return view
        }
    }
    var backgroundView: UIView {
        get { return view }
    }
    var alertView: HYAlertView?
    var animator = HYModalAlertAnimator()
    
    fileprivate weak var presentingVC: UIViewController?

    override open func viewDidLoad() {
        super.viewDidLoad()
        
        let alertView = HYAlertView(buttonsLayout: buttonsLayout)
        self.alertView = alertView
        alertView.elements = elements
        alertView.buttonsTitles = buttonsTitles
        alertView.buttons = buttons
        alertView.drawSeparator = drawLineSeparator
        alertView.onButtonPressed = {[weak self] (index, title) in
            guard let weakSelf = self else { return }
            
            let showldDismiss = weakSelf.onButtonTap(index, title)
            if showldDismiss {
                weakSelf.dismiss(index: index, title: title)
            }
        }
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)) )
        view.backgroundColor = UIColor.black
        view.addSubview(alertView)
        
        alertView.constraintCentered(to: view)
        
        if #available(iOS 8.0, *)
        {
            view.backgroundColor = UIColor.clear
            let effect = UIBlurEffect(style: .dark)
            let effectView = UIVisualEffectView(effect: effect)
            effectView.frame = view.bounds
            view.insertSubview(effectView, at: 0)
            effectView.addGestureRecognizer(tap)

        }
        else //Use black translusent background for iOS 7
        {
            let screenshot = takeScreenshot()
            let screenshotView = UIView(frame: view.bounds)
            screenshotView.backgroundColor = UIColor(patternImage: screenshot)
            view.insertSubview(screenshotView, at: 0)
            
            let dimView = UIView(frame: view.bounds)
            dimView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            view.insertSubview(dimView, at: 1)
            dimView.addGestureRecognizer(tap)
        }
    }
    
    func dismiss(index: Int, title: String) {
        onDismissCompletion?(index, title)
        presentingViewController?.dismiss(animated: true, completion: nil)
    }
    
    func onTap(_ tap: UITapGestureRecognizer) {
        dismiss(index: -1, title: "")
    }
    
    
    /**
     Make the alert be presendted by the given view controller. Use this method to use the custom presentation animation.
     
     - parameter vc: View Controller that will present this alert.
     */
    func showOnViewController(_ vc: UIViewController)
    {
        presentingVC = vc
        vc.definesPresentationContext = true
        self.transitioningDelegate = self
        animator.presenting = true
        if #available(iOS 8.0, *){
            self.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        } else {
            self.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        }
        presentingVC?.present(self, animated: true, completion: nil)
    }
    
    func show() {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            
            showOnViewController(topController)
            // topController should now be your topmost view controller
        }
    }
}

extension HYAlertController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        return animator
    }
    
    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning?
    {
        animator.presenting = false
        return animator
    }
}

private func takeScreenshot() -> UIImage
{
    let layer = UIApplication.shared.keyWindow!.layer
    let scale = UIScreen.main.scale
    UIGraphicsBeginImageContextWithOptions(layer.frame.size, false, scale);
    
    layer.render(in: UIGraphicsGetCurrentContext()!)
    return UIGraphicsGetImageFromCurrentImageContext()!
}
