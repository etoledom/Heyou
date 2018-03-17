//
//  BodyElement.swift
//  Heyou
//
//  Created by Eduardo Toledo on 2/25/18.
//

import Foundation

public extension Heyou {
    public struct Body: ElementProtocol {
        let text: String
        public init(text: String) {
            self.text = text
        }

        public func renderize() -> UIView {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
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
