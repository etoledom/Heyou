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
    static let sideMarging: CGFloat = 16
    static let topMarging: CGFloat = 12
    static let bottomMarging: CGFloat = 12
    //Labels
    static let labelSeparation: CGFloat = 10
    //Buttons
    static let mainButtonMarging: CGFloat = 16
    static let mainButtonHeight: CGFloat = 44
    static let mainButtonWidth: CGFloat = 250
    static let normalButtonHeight: CGFloat = 44
    static let buttonsSeparation: CGFloat = 8
}

public struct HYAlertStyleDefaults {

    //Globals
    static var alertWidth  = 300
    static var backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
    static var cornerRadius = 10

    //Labels
    static var titleFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.headline)
    static var titleTextColor = UIColor(red:0.20, green:0.27, blue:0.30, alpha:1.0)
    static var subTitleFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.subheadline)
    static var subTitleTextColor = UIColor(red:0.20, green:0.27, blue:0.30, alpha:1.0)
    static var descriptionFont = UIFont.preferredFont(forTextStyle: UIFontTextStyle.body)
    static var descriptionTextColor = UIColor(red:0.20, green:0.27, blue:0.30, alpha:1.0)

    //Buttons
    static var mainButtonCornerRadius = 0
    static var mainButtonObal = true
    static var mainButtonBackgroundColor = UIColor(red:0.00, green:0.45, blue:1.00, alpha:1.0)
    static var mainButtonFont = UIFont.boldSystemFont(ofSize: 16)
    static var mainButtonTextColor = UIColor.white

    static var normalButtonFont = UIFont.boldSystemFont(ofSize: 16)
    static var normalButtonTextColor = UIColor(red:0.00, green:0.45, blue:1.00, alpha:1.0)

    //Extras
    static var separatorColor = UIColor(white: 0.85, alpha: 1)
    static var separatorMarging: CGFloat = 8

    //Applaying style

    static func style(_ label: UILabel, type: HYAlertElement) {
        switch type {
        case .title:
            label.numberOfLines = 2
            label.font  = HYAlertStyleDefaults.titleFont
            label.textColor = HYAlertStyleDefaults.titleTextColor
            label.textAlignment = .center
        case .subTitle:
            label.numberOfLines = 2
            label.font  = HYAlertStyleDefaults.subTitleFont
            label.textColor = HYAlertStyleDefaults.subTitleTextColor
            label.textAlignment = .center
        case .description:
            label.numberOfLines = 5
            label.font  = HYAlertStyleDefaults.descriptionFont
            label.textColor = HYAlertStyleDefaults.descriptionTextColor
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
    open var elements  = [HYAlertElement]()
    ///Array of buttons titles. This is not compatible with 'self.buttons'
    open var buttonsTitles = [String]()
    ///Layout of buttons. If it's set to .horizontal but the total width of all buttons is too big,
    ///it will be automatically resetted to .vertical. Default: .vertical
    open var buttonsLayout = HYAlertButtonsLayout.vertical
    ///Closure to call when a button is tapped. The return indicates if the alert should be dismissed after pressing the button.
    open var onButtonTap: (_ index: Int, _ title: String) -> Bool = {_, _ in return true }

    ///Closure to call after the completion animation is finished when the dismiss is trigered by a button press.
    ///Dismiss triggered by tapping the background does not trigger this closure
    open var onDismissCompletion: (_ index: Int, _ title: String) -> Void = {_, _ in return }
    ///True if the last button acts as a "Cancel" button, automatically dismissing the Alert.

    ///Default: true
    open var dismissOnLastButton = true

    /// Default: true
    open var drawLineSeparator = true

    open func addAction(_ action: HYAlertAction) {
        buttons.append(action)
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
        guard let view = alertView else { assertionFailure("alertView is nil"); return UIView() }
        return view
    }
    var backgroundView: UIView {
        return view
    }
    var alertView: HYAlertView?
    var animator = HYModalAlertAnimator()

    fileprivate var buttons = [HYAlertAction]()
    fileprivate weak var presentingVC: UIViewController?

    override open func viewDidLoad() {
        super.viewDidLoad()
        createAlertView()
        setBackground()
    }

    func setBackground() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)) )
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addGestureRecognizer(tap)
    }

    func createAlertView() {
        let alertView = HYAlertView(buttonsLayout: buttonsLayout, actions: buttons)
        self.alertView = alertView
        alertView.elements = elements
        alertView.buttonActions = buttons

        alertView.buttons.forEach {
            $0.addTarget(self, action: #selector(onButtonPressed(sender:)), for: .touchUpInside)
        }

        alertView.drawSeparator = drawLineSeparator
        alertView.onButtonPressed = {[weak self] (index, title) in
            guard let weakSelf = self else { return }

            let showldDismiss = weakSelf.onButtonTap(index, title)
            if showldDismiss {
                weakSelf.dismiss {
                    weakSelf.onDismissCompletion(index, title)
                }
            }
        }

        view.addSubview(alertView)

        alertView.constraintCentered(to: view)
    }

    func dismiss(completion: (() -> Void)? = nil) {
        presentingViewController?.dismiss(animated: true, completion: completion)
    }

    @objc func onTap(_ tap: UITapGestureRecognizer) {
        dismiss()
    }

    /**
     Make the alert be presendted by the given view controller. Use this method to use the custom presentation animation.

     - parameter vc: View Controller that will present this alert.
     */
    open func show(onViewController viewController: UIViewController) {
        presentingVC = viewController
        viewController.definesPresentationContext = true
        self.transitioningDelegate = self
        animator.presenting = true
        modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        presentingVC?.present(self, animated: true, completion: nil)
    }

    open func show() {
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }

            show(onViewController: topController)
            // topController should now be your topmost view controller
        }
    }

    @objc private func onButtonPressed(sender: UIButton) {
        let action = buttons[sender.tag]
        if let handler = action.handler {
            handler(action)
        } else {
            dismiss()
        }
    }
}

extension HYAlertController: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        return animator
    }
}
