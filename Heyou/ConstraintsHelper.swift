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
}

infix operator >>>- { associativity left precedence 150 }

typealias Constraint = NSLayoutAttribute

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
    left.0.addConstraint(constraint)
    return constraint
}

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
    left.addConstraint(constraint)
    return constraint
}

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
        for attribute: Constraint in [.top, .bottom, .leading, .trailing] {
            (superView, self) >>>- { $0.attribute = attribute }
        }
    }
    
    func centeredHorizontally(to superView: UIView) {
        (superView, self) >>>- { $0.attribute = .centerX }
    }
    func centeredVertically(to superView: UIView) {
        (superView, self) >>>- { $0.attribute = .centerY }
    }
    func contraintCentered(to superView: UIView) {
        self.centeredHorizontally(to: superView)
        self.centeredVertically(to: superView)
    }
    
    func constraintTop(to superView: UIView, margin: CGFloat = 0) {
        (superView, self) >>>- { $0.attribute = .top; $0.constant = margin }
    }
    func constraintBottom(to superView: UIView, margin: CGFloat = 0) {
        (superView, self) >>>- { $0.attribute = .bottom; $0.constant = -margin }
    }
    func constraintLeading(to superView: UIView, margin: CGFloat = 0) {
        (superView, self) >>>- { $0.attribute = .leading; $0.constant = margin }
    }
    func constraintTrailing(to superView: UIView, margin: CGFloat = 0) {
        (superView, self) >>>- { $0.attribute = .trailing; $0.constant = -margin }
    }
    
    func constraint(height: CGFloat, width: CGFloat) {
        constraint(height: height)
        constraint(width: width)
    }
    
    func constraint(height: CGFloat) {
        self >>>- { $0.attribute = .height; $0.constant = height }
    }
    func constraint(width: CGFloat) {
        self >>>- { $0.attribute = .width; $0.constant = width }
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
}
