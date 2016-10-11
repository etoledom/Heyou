//
//  HYAlertView.swift
//  HYAlertView
//
//  Created by E. Toledo on 6/18/16.
//  Copyright © 2016 eToledo. All rights reserved.
//

import UIKit

final class HYAlertView: UIView {
    
    fileprivate let topView     = UIView()
    fileprivate let buttonsView = UIView()

    let buttonsLayout : HYAlertButtonsLayout
    
    var onButtonPressed: (_ index: Int, _ title: String) -> () = {_,_ in}
    var elements: [HYAlertElement] = [] {
        didSet { createSubviews() }
    }
    
    var buttonsTitles = [String]() {
        didSet{ createButtonsView(buttonsLayout) }
    }
    var buttons = [HYAlertButtonStyle]() {
        didSet{ createButtonsView(buttonsLayout) }
    }
    
    var drawSeparator = true
    
    
    init(buttonsLayout layout: HYAlertButtonsLayout) {
        buttonsLayout = layout
        super.init(frame: CGRect.zero)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBackgroundTap(_:))))
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = HYAlertStyleDefaults.backgroundColor
        layer.cornerRadius = CGFloat(HYAlertStyleDefaults.cornerRadius)
        layer.masksToBounds = true
        
        createLayout()
        createSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        buttonsLayout = .horizontal
        super.init(coder: aDecoder)
    }
    
    func onBackgroundTap(_ tap: UITapGestureRecognizer) {}
    
    func onButtonTap(_ sender: UIButton) {
        onButtonPressed(sender.tag, sender.titleLabel?.text ?? "")
        print("Button Pressed at Index: \(sender.tag)")
    }
    
    fileprivate func createLayout() {
        self.constraint(width: CGFloat(HYAlertStyleDefaults.alertWidth))
    }
    
    fileprivate func createSubviews() {
        createTopView()
        if drawSeparator {
            createSeparator()
        }
    }
    
    fileprivate func createTopView() {
        // TOP VIEW
        topView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topView)
        
        topView.backgroundColor = UIColor.clear

        topView.constraintLeading(to: self)
        topView.constraintTrailing(to: self)
        topView.constraintTop(to: self)
        
        func createLabel(_ type: HYAlertElement, text: String) -> UIView {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            topView.addSubview(label)
            label.text = text
            HYAlertStyleDefaults.style(label, type: type)
            label.sizeToFit()
            return label
        }
        
        func imageView(_ name: String) -> UIView {
            let imageView = UIImageView(image: UIImage(named: name))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .scaleAspectFit
            topView.addSubview(imageView)
            return imageView
        }
        
        func viewForElement(_ element: HYAlertElement) -> UIView {
            switch element {
            case .title(let content):
                return createLabel(element, text: content)
            case .subTitle(let content):
                return createLabel(element, text: content)
            case .description(let content):
                return createLabel(element, text: content)
            case .image(let content):
                return imageView(content)
            }
        }
        
        var createdViews = [UIView]()
        for (index, element) in elements.enumerated() {
            let view = viewForElement(element)
            
            let isFirstElement = (index == 0)
            if isFirstElement {
                view.constraintTop(to: topView, margin: HYAlertStyle.topMarging)
            } else {
                let previousView = createdViews[index - 1]
                topView.constraintSubviewsVertically(top: previousView, bottom: view, space: CGFloat(HYAlertStyle.labelSeparation))
            }
            
            let isLastElement = (index + 1 == elements.count)
            if isLastElement {
                view.constraintBottom(to: topView, margin: HYAlertStyle.bottomMarging)
            }
            view.constraintLeading(to: topView, margin: HYAlertStyle.sideMarging)
            view.constraintTrailing(to: topView, margin: HYAlertStyle.sideMarging)

            createdViews.append(view)
        }
    }
    
    fileprivate func createSeparator() {
        let separator = UIView()
        separator.backgroundColor = HYAlertStyleDefaults.separatorColor
        separator.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.addSubview(separator)
        
        separator.constraint(height: 1)
        separator.constraintLeading(to: buttonsView, margin: HYAlertStyleDefaults.separatorMarging)
        separator.constraintTrailing(to: buttonsView, margin: HYAlertStyleDefaults.separatorMarging)
        separator.constraintTop(to: buttonsView)
        
        separator.constraintCenteredHorizontally(to: buttonsView)
    }
    
    fileprivate func createButtonsView(_ layout: HYAlertButtonsLayout) {
        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonsView)
        
        buttonsView.backgroundColor = UIColor.clear
        
        self.constraintSubviewsVertically(top: topView, bottom: buttonsView)
        buttonsView.constraintBottom(to: self)
        buttonsView.constraintLeading(to: self)
        buttonsView.constraintTrailing(to: self)
        
        createButtons(layout)
    }
    
    fileprivate func mainButton(_ index: Int) -> UIButton {
        let button = normalButton(0)
        HYAlertStyleDefaults.styleMainButton(button)
        button.removeConstraints(button.constraints)
        button.constraint(height: 44)
        button.tag = index
        return button
    }
    
    fileprivate func normalButton(_ index: Int) -> UIButton {
        let button = UIButton(type: .system)
        HYAlertStyleDefaults.styleNormalButton(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.addSubview(button)
        button.addTarget(self, action: #selector(onButtonTap(_:)), for: .touchUpInside)
        button.constraint(height: HYAlertStyle.normalButtonHeight)

        button.tag = index
        return button
    }
    
    fileprivate func createButtons(_ layout: HYAlertButtonsLayout) {
        let buttonsCount = buttons.count + buttonsTitles.count
        guard buttonsCount > 0 else { return }
        var buttonsCreated = [UIButton]()
        for index in 1...buttonsCount {
            let previous: UIView? = buttonsCreated.last ?? nil
            let next: UIView? = (index == buttonsCount) ? buttonsView : nil
            let button: UIButton
            switch layout {
            case .horizontal:
                button = createButton(index - 1, leftView: previous, rightView: next)
            case .vertical:
                button = createButton(index - 1, topView: previous, bottomView: next)
            }
            buttonsCreated.append(button)
        }
        
        if layout == .horizontal && buttonsCount > 1 {
            for view in buttonsCreated where view != buttonsCreated.first! {
                buttonsView.constraintSubviews(attribute: .width, first: view, second: buttonsCreated.first!)
            }
        }
    }
    

    
    fileprivate func createButton(_ index: Int, topView: UIView?, bottomView: UIView? = nil) -> UIButton {
        
        let button: UIButton
        let buttonTitle: String
        if (buttonsTitles.count > 0) {
            button = normalButton(index)
            buttonTitle = buttonsTitles[index]
            button.constraintLeading(to: buttonsView, margin: HYAlertStyle.sideMarging)
            button.constraintTrailing(to: buttonsView, margin: HYAlertStyle.sideMarging)
        } else {
            switch buttons[index] {
            case .normal(let title):
                button = normalButton(index)
                buttonTitle = title
                button.constraintLeading(to: buttonsView, margin: HYAlertStyle.sideMarging)
                button.constraintTrailing(to: buttonsView, margin: HYAlertStyle.sideMarging)
                
            case .main(let title):
                button = mainButton(index)
                buttonTitle = title
                button.constraint(width: HYAlertStyle.mainButtonWidth)
                button.constraintCenteredHorizontally(to: buttonsView)
            }
        }
        button.setTitle(buttonTitle, for: UIControlState())
        
        
        if let topView = topView  {
            buttonsView.constraintSubviewsVertically(top: topView, bottom: button, space: HYAlertStyle.buttonsSeparation)
        } else {
            button.constraintTop(to: buttonsView, margin: HYAlertStyle.mainButtonMarging)
        }
        if let bottomView = bottomView {
            button.constraintBottom(to: bottomView, margin: HYAlertStyle.bottomMarging)
        }
        
        return button
    }
    
    fileprivate func createButton(_ index: Int, leftView: UIView?, rightView: UIView? = nil) -> UIButton {
        
        let button = normalButton(index)
        let title = buttonsTitles[index]
        button.setTitle(title, for: UIControlState())
        
        button.constraintBottom(to: buttonsView, margin: HYAlertStyle.bottomMarging)
        button.constraintTop(to: buttonsView, margin: HYAlertStyle.topMarging)

        if let left = leftView {
            buttonsView.constraintSubviewsHorizontally(left: left, right: button)
        } else {
            button.constraintLeading(to: buttonsView, margin: HYAlertStyle.sideMarging)
        }
        if let lastView = rightView {
            button.constraintTrailing(to: lastView, margin: HYAlertStyle.sideMarging)
        }
        button.constraint(height: HYAlertStyle.normalButtonHeight)
        
        return button
    }
}
