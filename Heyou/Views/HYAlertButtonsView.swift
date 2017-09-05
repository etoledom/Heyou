//
//  HYAlertButtonsView.swift
//  Heyou
//
//  Created by eToledom on 8/25/17.
//  Copyright © 2017 eToledoM. All rights reserved.
//

import UIKit
class HYAlertButtonsView: UIView {
    var buttons: [UIButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
    }
    init() {
        super.init(frame: CGRect.zero)
        translatesAutoresizingMaskIntoConstraints = false
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        translatesAutoresizingMaskIntoConstraints = false
    }

    func addButtons(actions: [HYAlertAction]) {
        actions.forEach(addButton)
    }

    private func addButton(action: HYAlertAction) {
        let button = createButton(style: action.style)
        button.setTitle(action.title, for: UIControlState.normal)
        button.tag = buttons.count
        buttons.append(button)
    }

    fileprivate func createButton(style: HYAlertActionStyle ) -> UIButton {
        let button = UIButton(type: .system)
        button.translatesAutoresizingMaskIntoConstraints = false
        styleButton(button, style: style)
        addSubview(button)
        layoutButtonVertically(button)
        return button
    }

    func layoutButtonHorizontally(_ button: UIButton) {
        button.constraint(height: HYAlertStyle.normalButtonHeight)
        if let lastButton = buttons.last {
            constraintSubviewsHorizontally(left: lastButton, right: button, space: 1)
            if let trailingConstraint = lastButton.constraintsAffectingLayout(for: UILayoutConstraintAxis.horizontal)
                .filter ({ $0.firstAttribute == NSLayoutAttribute.trailing }).first {
                lastButton.removeConstraint(trailingConstraint)
            }
        } else {
            button.constraintLeading(to: self, margin: 0)
            button.constraintTop(to: self)
            button.constraintBottom(to: self)
        }
        button.constraintTrailing(to: self)
    }

    func layoutButtonVertically(_ button: UIButton) {
        button.constraint(height: HYAlertStyle.normalButtonHeight)
        if let lastButton = buttons.last {
            if let bottomConstraint = self.constraints
                .filter ({ $0.firstAttribute == NSLayoutAttribute.bottom && !($0.secondItem is UIButton) }).first {
                self.removeConstraint(bottomConstraint)
            }
            constraintSubviewsVertically(top: lastButton, bottom: button, space: HYAlertStyle.buttonsSeparation)
            button.constraintCenteredHorizontally(to: self)
        } else {
            button.constraintTop(to: self, margin: HYAlertStyle.topMarging)
        }
        button.constraintLeading(to: self, margin: HYAlertStyle.sideMarging)
        button.constraintTrailing(to: self, margin: HYAlertStyle.sideMarging)
        button.constraintBottom(to: self, margin: HYAlertStyle.bottomMarging)
    }

    func styleButton(_ button: UIButton, style: HYAlertActionStyle) {
        switch style {
        case .default:
            HYAlertStyleDefaults.styleNormalButton(button)
        default:
            HYAlertStyleDefaults.styleMainButton(button)
        }
    }
}
