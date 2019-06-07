import UIKit

typealias Layout = NSLayoutConstraint.Attribute

open class Heyou: UIViewController {

    ///Array of UI Elements to show
    let elements: [Element]

    var animator = HYModalAlertAnimator()
    private let alertView: AlertView

    private weak var presentingVC: UIViewController?

    // MARK: - ViewController life cycle

    public init(elements: [Element]) {
        self.elements = elements
        alertView = AlertView(elements: elements)
        super.init(nibName: nil, bundle: nil)
    }

    required public init?(coder aDecoder: NSCoder) {
        elements = []
        alertView = AlertView(elements: elements)
        super.init(coder: aDecoder)
    }

    override open func viewDidLoad() {
        super.viewDidLoad()
        configureAlertView()
        configureBackground()
    }

    func configureBackground() {
        view.backgroundColor = UIColor.black.withAlphaComponent(0.4)
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.onTap))
        tap.delegate = self
        view.addGestureRecognizer(tap)
    }

    func configureAlertView() {
        view.addSubview(alertView)

        NSLayoutConstraint.activate([
            view.centerXAnchor.constraint(equalTo: alertView.centerXAnchor),
            view.centerYAnchor.constraint(equalTo: alertView.centerYAnchor)
        ])
    }

    func dismiss(completion: (() -> Void)? = nil) {
        presentingViewController?.dismiss(animated: true, completion: completion)
    }

    @objc func onTap(_ tap: UITapGestureRecognizer) {
        dismiss()
    }

    /// Make the alert be presendted by the given view controller. Use this method to use the custom presentation animation.
    ///
    /// - Parameter viewController: View Controller that will present this alert.
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
        return alertView
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

extension Heyou: UIGestureRecognizerDelegate {
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        return !alertView.frame.contains(touch.location(in: view))
    }
}
