//
//  Button.swift
//  Heyou
//
//  Created by Eduardo Toledo on 2/25/18.
//

import Foundation

public extension Heyou {
    public struct Button: ElementProtocol {

        public typealias Handler = ((Button) -> Void)
        
        let text: String
        let style: Heyou.ButtonStyle
        internal let handler: Handler?

        public init(text: String, style: Heyou.ButtonStyle, handler: Handler? = nil) {
            self.text = text
            self.style = style
            self.handler = handler
        }

        public func renderize() -> UIView {
            let button = UIButton(type: .system)
            button.heightAnchor.constraint(equalToConstant: Heyou.Style.normalButtonHeight).isActive = true
            button.setTitle(text, for: UIControl.State.normal)
            switch style {
            case .main:
                Heyou.StyleDefaults.styleMainButton(button)
            default:
                Heyou.StyleDefaults.styleNormalButton(button)
            }
            return button
        }
    }
}
