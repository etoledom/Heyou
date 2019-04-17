//
//  HYAlertViewController.swift
//  HYAlertView
//
//  Created by E. Toledo on 6/14/16.
//  Copyright © 2016 eToledo. All rights reserved.
//

import UIKit

typealias Layout = NSLayoutConstraint.Attribute

extension Heyou {
    public enum ButtonStyle {
        case main
        case normal
    }
}


public extension Heyou {
    struct Style {
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
}

public extension Heyou {
    public struct StyleDefaults {

        //Globals
        static var alertWidth  = 300
        static var backgroundColor = UIColor(red:0.95, green:0.95, blue:0.95, alpha:1.0)
        static var cornerRadius = 10

        //Labels
        static var titleFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        static var titleTextColor = UIColor(red:0.20, green:0.27, blue:0.30, alpha:1.0)
        static var subTitleFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        static var subTitleTextColor = UIColor(red:0.20, green:0.27, blue:0.30, alpha:1.0)
        static var descriptionFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
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

        static func styleMainButton(_ button: UIButton) {
            button.titleLabel?.font = StyleDefaults.mainButtonFont
            button.backgroundColor = StyleDefaults.mainButtonBackgroundColor
            let textColor = StyleDefaults.mainButtonTextColor
            button.setTitleColor(textColor, for: UIControl.State())

            if StyleDefaults.mainButtonObal {
                button.layer.cornerRadius = CGFloat(Style.mainButtonHeight) / 2
            } else {
                button.layer.cornerRadius = CGFloat(StyleDefaults.mainButtonCornerRadius)
            }

            button.layer.masksToBounds = true
        }

        static func styleNormalButton(_ button: UIButton) {
            let textColor = StyleDefaults.normalButtonTextColor
            button.setTitleColor(textColor, for: UIControl.State())
        }
    }

}

open class Heyou: UIViewController {

    ///Array of UI Elements to show
    let elements: [ElementProtocol]
    ///Closure to call when a button is tapped. The return indicates if the alert should be dismissed after pressing the button.
    open var onButtonTap: (_ index: Int, _ title: String) -> Bool = {_, _ in return true }

    ///Closure to call after the completion animation is finished when the dismiss is trigered by a button press.
    ///Dismiss triggered by tapping the background does not trigger this closure
    open var onDismissCompletion: (_ index: Int, _ title: String) -> Void = {_, _ in return }

    var animator = HYModalAlertAnimator()
    private var alertView: AlertView?

    private weak var presentingVC: UIViewController?

    // MARK: - ViewController life cycle

    public init(elements: [Section]) {
        self.elements = elements
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        self.elements = []
        super.init(coder: aDecoder)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        configureAlertView()
        configureBackground()
    }

    func configureBackground() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap(_:)) )
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        view.addGestureRecognizer(tap)
    }

    func configureAlertView() {
        let alertView = AlertView(elements: elements)
        self.alertView = alertView

        view.addSubview(alertView)

        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: alertView.centerYAnchor),
        ])
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
        }
    }
}

extension Heyou: HYPresentationAnimatable {
    var topView: UIView {
        guard let view = alertView else { assertionFailure("alertView is nil"); return UIView() }
        return view
    }
    var backgroundView: UIView {
        return view
    }
}

extension Heyou: UIViewControllerTransitioningDelegate {
    public func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return animator
    }

    public func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.presenting = false
        return animator
    }
}
