//
//  ConstraintsHelper.swift
//  panicbutton
//
//  Created by E. Toledo on 7/8/16.
//  Copyright © 2016 Sosafe. All rights reserved.
//

import UIKit

struct ConstraintInfo {
    var attribute: NSLayoutAttribute = .left
    var secondAttribute: NSLayoutAttribute = .notAnAttribute
    var constant: CGFloat = 0
    var identifier: String?
    var relation: NSLayoutRelation = .equal
    var priority: UILayoutPriority = UILayoutPriorityRequired
}

precedencegroup constOp {
    associativity: left
    higherThan: AssignmentPrecedence
}

infix operator >>>- : constOp


typealias Constraint = NSLayoutAttribute

@discardableResult
func >>>- <T: UIView> (left: (T, T), block: (inout ConstraintInfo) -> ()) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)
    info.secondAttribute = info.secondAttribute == .notAnAttribute ? info.attribute : info.secondAttribute
    
    let constraint = NSLayoutConstraint(item: left.1,
                                        attribute: info.attribute,
                                        relatedBy: info.relation,
                                        toItem: left.0,
                                        attribute: info.secondAttribute,
                                        multiplier: 1,
                                        constant: info.constant)

    constraint.identifier = info.identifier
    constraint.priority = info.priority
    left.0.addConstraint(constraint)
    return constraint
}

@discardableResult
func >>>- <T: UIView> (left: T, block: (inout ConstraintInfo) -> ()) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)
    
    let constraint = NSLayoutConstraint(item: left,
                                        attribute: info.attribute,
                                        relatedBy: info.relation,
                                        toItem: nil,
                                        attribute: info.attribute,
                                        multiplier: 1,
                                        constant: info.constant)
    constraint.identifier = info.identifier
    constraint.priority = info.priority
    left.addConstraint(constraint)
    return constraint
}

@discardableResult
func >>>- <T: UIView> (left: (T, T, T), block: (inout ConstraintInfo) -> ()) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)
    info.secondAttribute = info.secondAttribute == .notAnAttribute ? info.attribute : info.secondAttribute
    
    let constraint = NSLayoutConstraint(item: left.1,
                                        attribute: info.attribute,
                                        relatedBy: info.relation,
                                        toItem: left.2,
                                        attribute: info.secondAttribute,
                                        multiplier: 1,
                                        constant: info.constant)
    constraint.identifier = info.identifier
    left.0.addConstraint(constraint)
    return constraint
}

extension UIView {
    func constraintEdges(to superView: UIView) {
        for attribute: NSLayoutAttribute in [.top, .bottom, .leading, .trailing] {
            (superView, self) >>>- { $0.attribute = attribute; return }
        }
    }
    
    func constraintCenteredHorizontally(to superView: UIView, space: CGFloat = 0) {
        (superView, self) >>>- { $0.attribute = .centerX; $0.constant = space; return }
    }
    func constraintCenteredVertically(to superView: UIView, space: CGFloat = 0) {
        (superView, self) >>>- { $0.attribute = .centerY; $0.constant = space; return }
    }
    func constraintCentered(to superView: UIView, space: (x: CGFloat, y: CGFloat) = (x: 0, y: 0)) {
        self.constraintCenteredHorizontally(to: superView, space: space.x)
        self.constraintCenteredVertically(to: superView, space: space.y)
    }
    
    func constraintTop(to superView: UIView, margin: CGFloat = 0) {
        (superView, self) >>>- { $0.attribute = .top; $0.constant = margin; return }
    }
    @discardableResult
    func constraintBottom(to superView: UIView, margin: CGFloat = 0) -> NSLayoutConstraint {
        return (superView, self) >>>- { $0.attribute = .bottom; $0.constant = -margin; return }
    }
    @discardableResult
    func constraintLeading(to superView: UIView, margin: CGFloat = 0) -> NSLayoutConstraint {
        return (superView, self) >>>- { $0.attribute = .leading; $0.constant = margin; return }
    }
    func constraintTrailing(to superView: UIView, margin: CGFloat = 0) {
        (superView, self) >>>- { $0.attribute = .trailing; $0.constant = -margin; return }
    }
    
    func constraint(height: CGFloat, width: CGFloat) {
        constraint(height: height)
        constraint(width: width)
    }
    
    @discardableResult
    func constraint(height: CGFloat) -> NSLayoutConstraint {
        return self >>>- { $0.attribute = .height; $0.constant = height; return }
    }
    @discardableResult
    func constraint(width: CGFloat) -> NSLayoutConstraint {
        return self >>>- { $0.attribute = .width; $0.constant = width; return }
    }
    
    func constraint(to view: UIView, attribute: NSLayoutAttribute, constant: CGFloat = 0) {
        (view, self) >>>- { $0.attribute = attribute; $0.constant = constant; return }
    }
    
    
    func constraintSubviewsHorizontally(left: UIView, right: UIView, space: CGFloat = 0) {
        (self, left, right) >>>- {
            $0.attribute = .trailing
            $0.secondAttribute = .leading
            $0.constant = -space
            return
        }
    }
    @discardableResult
    func constraintSubviewsVertically(top: UIView, bottom: UIView, space: CGFloat = 0) -> NSLayoutConstraint {
        return (self, top, bottom) >>>- {
            $0.attribute = .bottom
            $0.secondAttribute = .top
            $0.constant = -space
            return
        }
    }
    func constraintSubviewsCenteredHorizontally(subViews:(UIView,UIView), space: CGFloat = 0) {
        (self, subViews.0, subViews.1) >>>- {
            $0.attribute = .centerX
            $0.constant = space
            return
        }
    }
    func constraintSubviewsCenteredVertically(subViews:(UIView,UIView), space: CGFloat = 0) {
        (self, subViews.0, subViews.1) >>>- {
            $0.attribute = .centerY
            $0.constant = space
            return
        }
    }
    
    func constraintSubviews(attribute: NSLayoutAttribute, first: UIView, second: UIView) {
        (self, first, second) >>>- {
            $0.attribute = attribute
            return
        }
    }
    func constraintSubviewsCentered(subViews:(UIView,UIView), space: (x:CGFloat, y:CGFloat) = (x: 0,y: 0)) {
        constraintSubviewsCenteredHorizontally(subViews: subViews, space: space.x)
        constraintSubviewsCenteredVertically(subViews: subViews, space: space.y)
    }
}

extension UIViewController {
    func constraintTopLayoutGuide(view: UIView, margin: CGFloat = 0) {
        let constraint = NSLayoutConstraint(
            item: view,
            attribute: .top,
            relatedBy: .equal,
            toItem: self.topLayoutGuide,
            attribute: .bottom,
            multiplier: 1,
            constant: margin
        )
        self.view.addConstraint(constraint)
    }
    func constraintBottomLayoutGuide(view: UIView, margin: CGFloat = 0) {
        let constraint = NSLayoutConstraint(
            item: view,
            attribute: .bottom,
            relatedBy: .equal,
            toItem: self.bottomLayoutGuide,
            attribute: .top,
            multiplier: 1,
            constant: margin
        )
        self.view.addConstraint(constraint)
    }
}
