//
//  SectionElement.swift
//  Heyou
//
//  Created by Eduardo Toledo on 2/25/18.
//

import Foundation

public extension Heyou {

    public struct Section: SectionProtocol, ElementProtocol {
        
        let elements: [ElementProtocol]

        public init(elements: [ElementProtocol]) {
            self.elements = elements
        }
        
        public func renderize() -> UIView {
            let view = createView()
            let stackView = createStackView()
            view.addSubview(stackView)

            configureLayout(view: view, stackView: stackView)
            addElements(to: stackView)

            return view
        }

        //MARK: - Helpers

        private func createStackView() -> UIStackView {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
//            stackView.layoutMargins = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
            stackView.isLayoutMarginsRelativeArrangement = true

            return stackView
        }

        private func createView() -> UIView {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = StyleDefaults.backgroundColor
//            view.layer.cornerRadius = CGFloat(StyleDefaults.cornerRadius)
//            view.layer.masksToBounds = true
            return view
        }

        private func addElements(to stackView: UIStackView) {
            elements.forEach {
                let view = $0.renderize()
                stackView.addArrangedSubview(view)
            }
        }

        private func configureLayout(view: UIView, stackView: UIStackView) {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: view.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            ])
        }
    }
}
