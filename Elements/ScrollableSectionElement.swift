//
//  ScrollableSectionElement.swift
//  Heyou
//
//  Created by Eduardo Toledo on 3/17/18.
//

import Foundation

public extension Heyou {

    public struct ScrollableSection: SectionProtocol, ElementProtocol {

        let subSections: [ElementProtocol & SectionProtocol]

        public init(sections: [ElementProtocol & SectionProtocol]) {
            self.subSections = sections
        }

        public func renderize() -> UIView {
            let view = createScrollView()
            let stackView = createStackView()
            view.addSubview(stackView)

            subSections.forEach {
                let view = $0.renderize()
                stackView.addArrangedSubview(view)
            }

            configureLayout(scrollView: view, subView: stackView)

            return view
        }

        //MARK: - Helpers

        private func createScrollView() -> UIScrollView {
            let scrollView = UIScrollView()
            scrollView.translatesAutoresizingMaskIntoConstraints = false
            scrollView.alwaysBounceHorizontal = false
            return scrollView
        }

        private func createStackView() -> UIStackView {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.distribution = .equalCentering
            return stackView
        }

        private func configureLayout(scrollView: UIScrollView, subView: UIView) {
            let height = scrollView.heightAnchor.constraint(equalTo: subView.heightAnchor)
            height.priority = UILayoutPriority.defaultLow
            let minHeight = scrollView.heightAnchor.constraint(greaterThanOrEqualToConstant: 200)
            minHeight.priority = .required

            NSLayoutConstraint.activate([
                scrollView.topAnchor.constraint(equalTo: subView.topAnchor),
                scrollView.bottomAnchor.constraint(equalTo: subView.bottomAnchor),
                scrollView.leadingAnchor.constraint(equalTo: subView.leadingAnchor),
                scrollView.trailingAnchor.constraint(equalTo: subView.trailingAnchor),
                scrollView.widthAnchor.constraint(equalTo: subView.widthAnchor),
                height,
                minHeight
            ])
        }
    }
}
