//
//  ConstraintsHelper.swift
//  panicbutton
//
//  Created by E. Toledo on 7/8/16.
//  Copyright © 2016 Sosafe. All rights reserved.
//

import UIKit

struct ConstraintInfo {
    var attribute: NSLayoutAttribute = .Left
    var secondAttribute: NSLayoutAttribute = .NotAnAttribute
    var constant: CGFloat = 0
    var identifier: String?
    var relation: NSLayoutRelation = .Equal
}

infix operator >>>- { associativity left precedence 150 }

typealias Constraint = NSLayoutAttribute

func >>>- <T: UIView> (left: (T, T), @noescape block: (inout ConstraintInfo) -> ()) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)
    info.secondAttribute = info.secondAttribute == .NotAnAttribute ? info.attribute : info.secondAttribute
    
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

func >>>- <T: UIView> (left: T, @noescape block: (inout ConstraintInfo) -> ()) -> NSLayoutConstraint {
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

func >>>- <T: UIView> (left: (T, T, T), @noescape block: (inout ConstraintInfo) -> ()) -> NSLayoutConstraint {
    var info = ConstraintInfo()
    block(&info)
    info.secondAttribute = info.secondAttribute == .NotAnAttribute ? info.attribute : info.secondAttribute
    
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
        for attribute: Constraint in [.Top, .Bottom, .Leading, .Trailing] {
            (superView, self) >>>- { $0.attribute = attribute }
        }
    }
    
    func centeredHorizontally(to superView: UIView) {
        (superView, self) >>>- { $0.attribute = .CenterX }
    }
    func centeredVertically(to superView: UIView) {
        (superView, self) >>>- { $0.attribute = .CenterY }
    }
    func contraintCentered(to superView: UIView) {
        self.centeredHorizontally(to: superView)
        self.centeredVertically(to: superView)
    }
    
    func constraintTop(to superView: UIView, margin: CGFloat = 0) {
        (superView, self) >>>- { $0.attribute = .Top; $0.constant = margin }
    }
    func constraintBottom(to superView: UIView, margin: CGFloat = 0) {
        (superView, self) >>>- { $0.attribute = .Bottom; $0.constant = -margin }
    }
    func constraintLeading(to superView: UIView, margin: CGFloat = 0) {
        (superView, self) >>>- { $0.attribute = .Leading; $0.constant = margin }
    }
    func constraintTrailing(to superView: UIView, margin: CGFloat = 0) {
        (superView, self) >>>- { $0.attribute = .Trailing; $0.constant = -margin }
    }
    
    func constraint(height height: CGFloat, width: CGFloat) {
        constraint(height: height)
        constraint(width: width)
    }
    
    func constraint(height height: CGFloat) {
        self >>>- { $0.attribute = .Height; $0.constant = height }
    }
    func constraint(width width: CGFloat) {
        self >>>- { $0.attribute = .Width; $0.constant = width }
    }
}

extension UIViewController {
    func constraintTopLayoutGuide(view view: UIView, margin: CGFloat = 0) {
        let constraint = NSLayoutConstraint(
            item: view,
            attribute: .Top,
            relatedBy: .Equal,
            toItem: self.topLayoutGuide,
            attribute: .Bottom,
            multiplier: 1,
            constant: margin
        )
        self.view.addConstraint(constraint)
    }
}
