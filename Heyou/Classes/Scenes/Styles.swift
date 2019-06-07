public extension Heyou {
    struct Style {
        //Globals
        static let sideMarging: CGFloat = 16
        static let topMarging: CGFloat = 12
        static let bottomMarging: CGFloat = 12
        //Labels
        static let labelSeparation: CGFloat = 10
        //Buttons
        static let mainButtonMarging: CGFloat = 16
        static let mainButtonHeight: CGFloat = 44
        static let mainButtonWidth: CGFloat = 250
        static let normalButtonHeight: CGFloat = 44
        static let buttonsSeparation: CGFloat = 8
    }
}

public extension Heyou {
    struct StyleDefaults {

        //Globals
        static var alertWidth = 300
        static var backgroundColor = UIColor(red: 0.95, green: 0.95, blue: 0.95, alpha: 1.0)
        static var cornerRadius = 10

        //Labels
        static var titleFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.headline)
        static var titleTextColor = UIColor(red: 0.20, green: 0.27, blue: 0.30, alpha: 1.0)
        static var subTitleFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.subheadline)
        static var subTitleTextColor = UIColor(red: 0.20, green: 0.27, blue: 0.30, alpha: 1.0)
        static var descriptionFont = UIFont.preferredFont(forTextStyle: UIFont.TextStyle.body)
        static var descriptionTextColor = UIColor(red: 0.20, green: 0.27, blue: 0.30, alpha: 1.0)

        //Buttons
        static var mainButtonCornerRadius = 0
        static var mainButtonObal = true
        static var mainButtonBackgroundColor = UIColor(red: 0.00, green: 0.45, blue: 1.00, alpha: 1.0)
        static var mainButtonFont = UIFont.boldSystemFont(ofSize: 16)
        static var mainButtonTextColor = UIColor.white

        static var normalButtonFont = UIFont.boldSystemFont(ofSize: 16)
        static var normalButtonTextColor = UIColor(red: 0.00, green: 0.45, blue: 1.00, alpha: 1.0)

        //Extras
        static var separatorColor = UIColor(white: 0.85, alpha: 1)
        static var separatorMarging: CGFloat = 8

        static func styleMainButton(_ button: UIButton) {
            button.titleLabel?.font = StyleDefaults.mainButtonFont
            button.backgroundColor = StyleDefaults.mainButtonBackgroundColor
            let textColor = StyleDefaults.mainButtonTextColor
            button.setTitleColor(textColor, for: UIControl.State())
            button.heightAnchor.constraint(equalToConstant: Heyou.Style.mainButtonHeight).isActive = true
            button.contentEdgeInsets = UIEdgeInsets(top: -50, left: 0, bottom: -50, right: 0)
            if StyleDefaults.mainButtonObal {
                button.layer.cornerRadius = CGFloat(Style.mainButtonHeight) / 2
            } else {
                button.layer.cornerRadius = CGFloat(StyleDefaults.mainButtonCornerRadius)
            }

            button.layer.masksToBounds = true
        }

        static func styleNormalButton(_ button: UIButton) {
            let textColor = StyleDefaults.normalButtonTextColor
            button.setTitleColor(textColor, for: UIControl.State())
            button.heightAnchor.constraint(equalToConstant: Heyou.Style.normalButtonHeight).isActive = true
        }
    }
}
