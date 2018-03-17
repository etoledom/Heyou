//
//  ImageElement.swift
//  Heyou
//
//  Created by Eduardo Toledo on 3/14/18.
//

import Foundation

public extension Heyou {
    public struct Image: ElementProtocol {

        let image: UIImage

        public init(image: UIImage) {
            self.image = image
        }

        public func renderize() -> UIView {
            let imageView = UIImageView(image: image)
            imageView.contentMode = .center
            return imageView
        }
    }
}
