import Foundation

public extension Heyou {
    struct Image: ElementProtocol {

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
