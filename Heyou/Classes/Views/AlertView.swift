import UIKit

extension Heyou {
    final class AlertView: UIView {
        private let elements: [Element]

        private var buttonActions: [UIButton: Button] = [:]

        init(elements: [Element]) {
            self.elements = elements

            super.init(frame: CGRect.zero)

            configureView()
            configureHerarchy()
        }

        required init?(coder aDecoder: NSCoder) {
            self.elements = []
            super.init(coder: aDecoder)
        }

        private func configureView() {
            translatesAutoresizingMaskIntoConstraints = false
            backgroundColor = StyleDefaults.backgroundColor
            layer.cornerRadius = 10
            layer.masksToBounds = true
        }

        private func configureHerarchy() {
            let rootSection = createRootSection()
            addSubview(rootSection)
            configureLayout(view: self, stackView: rootSection)
        }

        private func createRootSection() -> UIView {
            let rootSection = Heyou.Section(elements: elements).renderize()
            rootSection.layoutMargins = UIEdgeInsets(
                top: 0,
                left: Style.sideMarging,
                bottom: 0,
                right: Style.sideMarging
            )
            return rootSection
        }

        private func configureLayout(view: UIView, stackView: UIView) {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: view.topAnchor),
                stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
                stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
                stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
                widthAnchor.constraint(equalToConstant: CGFloat(StyleDefaults.alertWidth))
            ])
        }
    }
}
