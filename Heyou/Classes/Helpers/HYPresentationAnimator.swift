import UIKit

protocol HYPresentationAnimatable {
    var topView: UIView { get }
    var backgroundView: UIView { get }
    var animator: HYModalAlertAnimator { get set }
}

class HYModalAlertAnimator: NSObject, UIViewControllerAnimatedTransitioning {

    let duration = 0.4
    var presenting  = true
    var originFrame = CGRect.zero

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return duration
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let containerView = transitionContext.containerView

        let toViewController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to)
        let fromController = transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)
        let toView = toViewController?.view

        let _modalVC = presenting ?
            transitionContext.viewController(forKey: UITransitionContextViewControllerKey.to) :
            transitionContext.viewController(forKey: UITransitionContextViewControllerKey.from)

        guard let modalVC = _modalVC as? HYPresentationAnimatable else { fatalError("Wrong VC to present") }

        let backgroundView = modalVC.backgroundView

        let alertView = modalVC.topView
        alertView.layer.anchorPoint = CGPoint(x: 0.5, y: 0.5)

        originFrame = alertView.frame

        if #available(iOS 8.0, *) {
            if let toView = toView, presenting == true {
                containerView.addSubview(toView)
            }
        } else {
            if let toView = toView {
                containerView.insertSubview(toView, at: 0)
            }
        }

        if presenting {
            fromController?.definesPresentationContext = true
            presentAnimation(backgroundView: backgroundView, alertView: alertView, containerView: containerView, context: transitionContext)
        } else {
            dismissAnimation(backgroundView: backgroundView, alertView: alertView, containerView: containerView, context: transitionContext)
        }

    }

    fileprivate func presentAnimation(backgroundView: UIView, alertView: UIView, containerView: UIView, context: UIViewControllerContextTransitioning) {

        alertView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        alertView.center = CGPoint(x: originFrame.midX,
                                   y: originFrame.midY)
        alertView.clipsToBounds = true
        alertView.alpha = 0
        backgroundView.alpha = 0
        containerView.bringSubviewToFront(backgroundView)

        UIView.animate(withDuration: 0.1, animations: {
                backgroundView.alpha = CGFloat(1)
        }, completion: nil)

        UIView.animate(withDuration: duration, delay:0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [], animations: {
            alertView.transform = CGAffineTransform.identity
            alertView.alpha = 1
        }, completion: { _ in
            context.completeTransition(true)
        })
    }

    fileprivate func dismissAnimation(backgroundView: UIView, alertView: UIView, containerView: UIView, context: UIViewControllerContextTransitioning) {
        // let scaleAnimation = POP
        UIView.animate(withDuration: duration * 0.8, delay:0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [], animations: {
            alertView.alpha = 0
        }, completion: nil)

        UIView.animate(withDuration: duration * 0.8, delay: 0, options: [], animations: {
                backgroundView.alpha = CGFloat(0)
        }, completion: { _ in
            context.completeTransition(true)
        })
    }
}
