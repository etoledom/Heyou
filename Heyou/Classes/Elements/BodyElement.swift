import Foundation

public extension Heyou {
    struct Body: Element {
        let text: String
        public init(text: String) {
            self.text = text
        }

        public func renderize() -> UIView {
            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = UIFont.preferredFont(forTextStyle: .subheadline)
            if #available(iOS 10.0, *) {
                label.adjustsFontForContentSizeCategory = true
            }
            return label
        }
    }
}
