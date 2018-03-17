//
//  Button.swift
//  Heyou
//
//  Created by Eduardo Toledo on 2/25/18.
//

import Foundation

public extension Heyou {

    public enum ButtonStyle {
        case cancel
        case `default`
        case destructive
        case action
    }

    public struct Button: ElementProtocol {

        public typealias Handler = ((Button) -> Void)
        
        let text: String
        let style: ButtonStyle
        internal let handler: Handler?

        public init(text: String, style: ButtonStyle = .default, handler: Handler? = nil) {
            self.text = text
            self.style = style
            self.handler = handler
        }

        public func renderize() -> UIView {
            let button = UIButton(type: .system)
            button.heightAnchor.constraint(equalToConstant: Style.normalButtonHeight).isActive = true
            button.setTitle(text, for: UIControlState.normal)
            switch style {
            case .action:
                StyleDefaults.styleActionButton(button)
            case .default:
                StyleDefaults.styleNormalButton(button)
            case .cancel:
                StyleDefaults.styleCancelButton(button)
            case .destructive:
                StyleDefaults.styleDestructiveButton(button)
            }
            return button
        }
    }
}
