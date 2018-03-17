//
//  HYAlertView.swift
//  HYAlertView
//
//  Created by E. Toledo on 6/18/16.
//  Copyright © 2016 eToledo. All rights reserved.
//

import UIKit

extension Heyou {
    final class AlertView: UIView {

        private let rootStackView: UIStackView = {
            
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.alignment = .fill
            stackView.distribution = .fill

            return stackView
        }()

        private let elements: [ElementProtocol]

        private var buttonActions: [UIButton: Button] = [:]

        init(elements: [ElementProtocol]) {
            self.elements = elements

            super.init(frame: CGRect.zero)

            configureView()
            configureStackView()
            configureHerarchy()
            createLayout()
        }

        required init?(coder aDecoder: NSCoder) {
            self.elements = []
            super.init(coder: aDecoder)
        }

        @objc func onBackgroundTap(_ tap: UITapGestureRecognizer) {}

        fileprivate func createLayout() {
            widthAnchor.constraint(equalToConstant: CGFloat(StyleDefaults.alertWidth)).isActive = true
        }

        private func viewForElement(_ element: ElementProtocol) -> UIView {
            return element.renderize()
        }

        private func configureView() {
            addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBackgroundTap(_:))))
            translatesAutoresizingMaskIntoConstraints = false
            backgroundColor = .clear
            layer.cornerRadius = 10
            layer.masksToBounds = true
        }

        private func configureHerarchy() {
            elements.forEach {
                configure(element: $0)
            }
        }

        private func configure(element: ElementProtocol) {
            let view = element.renderize()
            if let button = view as? UIButton, let buttonElement = element as? Button {
                configureButtonTargetAction(for: button, with: buttonElement)
            }
            rootStackView.addArrangedSubview(view)
        }

        private func configureButtonTargetAction(for button: UIButton, with element: Button) {
            button.addTarget(self, action: #selector(buttonPressed(sender:)), for: .touchUpInside)
            buttonActions[button] = element
        }

        @objc func buttonPressed(sender: UIButton) {
            guard let buttonElement = buttonActions[sender] else {
                return
            }
            buttonElement.handler?(buttonElement)
        }

        private func configureStackView() {
            addSubview(rootStackView)
            NSLayoutConstraint.activate([
                rootStackView.topAnchor.constraint(equalTo: topAnchor),
                rootStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
                rootStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
                rootStackView.bottomAnchor.constraint(equalTo: bottomAnchor)
            ])
        }
    }
}
