public extension Heyou {
    struct ButtonsSection: Element {

        let buttons: [Button]

        public init(buttons: [Button]) {
            self.buttons = buttons
        }

        public func renderize() -> UIView {
            let view = createView()
            let stackView = createStackView()
            view.addSubview(stackView)

            configureLayout(view: view, stackView: stackView)
            addElements(to: stackView)

            return view
        }

        // MARK: - Helpers

        private func createStackView() -> UIStackView {
            let stackView = UIStackView()
            stackView.translatesAutoresizingMaskIntoConstraints = false
            stackView.axis = .vertical
            stackView.isLayoutMarginsRelativeArrangement = true

            return stackView
        }

        private func createView() -> UIView {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.backgroundColor = StyleDefaults.backgroundColor
            return view
        }

        private func createSeparator() -> UIView {
            let view = UIView()
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 1).isActive = true
            view.backgroundColor = UIColor(red: 234.0/255.0, green: 237.0/255.0, blue: 238.0/255.0, alpha: 1.0)
            return view
        }

        private func addElements(to stackView: UIStackView) {
            buttons.forEach {
                stackView.addArrangedSubview(createSeparator())
                let button = $0.renderize()
                stackView.addArrangedSubview(button)
            }
        }

        private func configureLayout(view: UIView, stackView: UIStackView) {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: view.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
            ])
        }
    }
}
