//
//  TitleElement.swift
//  Heyou
//
//  Created by Eduardo Toledo on 2/25/18.
//

import Foundation

public extension Heyou {
    public struct Title: ElementProtocol {
        let text: String
        public init(text: String) {
            self.text = text
        }

        public func renderize() -> UIView {
            let label = UILabel()
            label.text = text
            label.textAlignment = .center
            label.numberOfLines = 0
            label.font = UIFont.preferredFont(forTextStyle: .headline)
            if #available(iOS 10.0, *) {
                label.adjustsFontForContentSizeCategory = true
            }
            label.setContentHuggingPriority(.required, for: .vertical)
            return label
        }
    }
}



