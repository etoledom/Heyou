//
//  HYAlertView.swift
//  HYAlertView
//
//  Created by E. Toledo on 6/18/16.
//  Copyright © 2016 eToledo. All rights reserved.
//

import UIKit

final class HYAlertView: UIView {
    
    private let topView     = UIView()
    private let buttonsView = UIView()

    let buttonsLayout : HYAlertButtonsLayout
    
    var onButtonPressed: (index: Int, title: String) -> () = {_,_ in}
    var elements: [HYAlertElement] = [] {
        didSet { createSubviews() }
    }
    
    var buttonsTitles = [String]() {
        didSet{ createButtonsView(buttonsLayout) }
    }
    var buttons = [HYAlertButtonStyle]() {
        didSet{ createButtonsView(buttonsLayout) }
    }
    
    
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
    
    func onBackgroundTap(tap: UITapGestureRecognizer) {}
    
    func onButtonTap(sender: UIButton) {
        onButtonPressed(index: sender.tag, title: sender.titleLabel?.text ?? "")
        print("Button Pressed at Index: \(sender.tag)")
    }
    
    private func createLayout() {
        self >>>- { $0.attribute =  .Width; $0.constant = CGFloat(HYAlertStyleDefaults.alertWidth) }
    }
    
    private func createSubviews() {
        createTopView()
        createSeparator()
    }
    
    private func createTopView() {
        // TOP VIEW
        topView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(topView)
        
        topView.backgroundColor = UIColor.clearColor()
        for attribute in [Layout .Top, Layout .Leading, Layout .Trailing] {
            (first: self, second: topView) >>>- { $0.attribute = attribute }
        }
        
        func createLabel(type: HYAlertElement, text: String) -> UIView {
            let label = UILabel()
            label.translatesAutoresizingMaskIntoConstraints = false
            topView.addSubview(label)
            label.text = text
            HYAlertStyleDefaults.style(label, type: type)
            label.sizeToFit()
            return label
        }
        
        func imageView(name: String) -> UIView {
            let imageView = UIImageView(image: UIImage(named: name))
            imageView.translatesAutoresizingMaskIntoConstraints = false
            imageView.contentMode = .ScaleAspectFit
            topView.addSubview(imageView)
            return imageView
        }
        
        func viewForElement(element: HYAlertElement) -> UIView {
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
        for (index, element) in elements.enumerate() {
            let view = viewForElement(element)
            
            let isFirstElement = (index == 0)
            if isFirstElement {
                view.constraintTop(to: topView, margin: HYAlertStyle.topMarging)
            } else {
                let previousView = createdViews[index - 1]
                (base:topView, first: previousView, second: view) >>>- {
                    $0.attribute =  .Bottom
                    $0.secondAttribute =  .Top
                    $0.constant = -CGFloat(HYAlertStyle.labelSeparation)
                }
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
    
    private func createSeparator() {
        let separator = UIView()
        separator.backgroundColor = HYAlertStyleDefaults.separatorColor
        separator.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.addSubview(separator)
        
        separator.constraint(height: 1)
        separator.constraintLeading(to: buttonsView, margin: HYAlertStyleDefaults.separatorMarging)
        separator.constraintTrailing(to: buttonsView, margin: HYAlertStyleDefaults.separatorMarging)
        separator.constraintTop(to: buttonsView)
        
        (buttonsView, separator) >>>- { $0.attribute = .CenterX }
    }
    
    private func createButtonsView(layout: HYAlertButtonsLayout) {
        
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(buttonsView)
        
        buttonsView.backgroundColor = UIColor.clearColor()
        
         (self, topView, buttonsView) >>>- {
            $0.attribute =  .Bottom
            $0.secondAttribute =  .Top
        }
        buttonsView.constraintBottom(to: self)
        buttonsView.constraintLeading(to: self)
        buttonsView.constraintTrailing(to: self)
        
        createButtons(layout)
    }
    
    private func mainButton(index: Int) -> UIButton {
        let button = normalButton(0)
        HYAlertStyleDefaults.styleMainButton(button)
        button.removeConstraints(button.constraints)
        button.constraint(height: 44)
        button.tag = index
        return button
    }
    
    private func normalButton(index: Int) -> UIButton {
        let button = UIButton(type: .System)
        HYAlertStyleDefaults.styleNormalButton(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        buttonsView.addSubview(button)
        button.addTarget(self, action: #selector(onButtonTap(_:)), forControlEvents: .TouchUpInside)
        button.constraint(height: HYAlertStyle.normalButtonHeight)

        button.tag = index
        return button
    }
    
    private func createButtons(layout: HYAlertButtonsLayout) {
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
                 (base: buttonsView, first: view, second: buttonsCreated.first!) >>>- {
                    $0.attribute =  .Width
                }
            }
        }
    }
    

    
    private func createButton(index: Int, topView: UIView?, bottomView: UIView? = nil) -> UIButton {
        
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
                (first: buttonsView, second: button) >>>- { $0.attribute = .CenterX }
                
            }
        }
        button.setTitle(buttonTitle, forState: .Normal)
        
        
        if let topView = topView  {
             (base: buttonsView, first: topView, second: button) >>>- {
                $0.attribute =   .Bottom
                $0.secondAttribute =  .Top
                $0.constant = -HYAlertStyle.buttonsSeparation
            }
        } else {
            button.constraintTop(to: buttonsView, margin: HYAlertStyle.mainButtonMarging)
        }
        if let bottomView = bottomView {
            button.constraintBottom(to: bottomView, margin: HYAlertStyle.bottomMarging)
        }
        
        return button
    }
    
    private func createButton(index: Int, leftView: UIView?, rightView: UIView? = nil) -> UIButton {
        
        let button = normalButton(index)
        let title = buttonsTitles[index]
        button.setTitle(title, forState: .Normal)
        
        button.constraintBottom(to: buttonsView, margin: HYAlertStyle.bottomMarging)
        button.constraintTop(to: buttonsView, margin: HYAlertStyle.topMarging)

        if let left = leftView {
             (base: buttonsView, first: left, second: button) >>>- {
                $0.attribute =  .Trailing
                $0.secondAttribute =  .Leading
            }
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
