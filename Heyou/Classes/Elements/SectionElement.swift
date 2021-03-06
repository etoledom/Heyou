public extension Heyou {
    struct Section: Element {

        let elements: [Element]

        public init(elements: [Element]) {
            self.elements = elements
        }

        public func renderize() -> UIView {
            let stackView = createStackView()
            addElements(to: stackView)

            return stackView
        }

        // MARK: - Helpers

        private func createStackView() -> UIStackView {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.isLayoutMarginsRelativeArrangement = true
            stackView.layoutMargins = UIEdgeInsets(
                top: Style.topMarging,
                left: 0,
                bottom: Style.bottomMarging,
                right: 0
            )
            return stackView
        }

        private func addElements(to stackView: UIStackView) {
            elements.forEach {
                let view = $0.renderize()
                stackView.addArrangedSubview(view)
            }
        }
    }
}
