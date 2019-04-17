import Foundation

public extension Heyou {
    @objc public class Button: NSObject, ElementProtocol {
        public typealias Handler = ((Button) -> Void)

        public let text: String
        public let style: Heyou.ButtonStyle
        let handler: Handler?

        public init(text: String, style: Heyou.ButtonStyle, handler: Handler? = nil) {
            self.text = text
            self.style = style
            self.handler = handler
        }

        public func renderize() -> UIView {
            let button = UIButton(type: .system)
            button.heightAnchor.constraint(equalToConstant: Heyou.Style.normalButtonHeight).isActive = true
            button.setTitle(text, for: UIControl.State.normal)
            button.addTarget(self, action: #selector(onButtonTap), for: .touchUpInside)
            switch style {
            case .main:
                Heyou.StyleDefaults.styleMainButton(button)
            default:
                Heyou.StyleDefaults.styleNormalButton(button)
            }
            return button
        }

        @objc func onButtonTap() {
            handler?(self)
        }
    }
}
