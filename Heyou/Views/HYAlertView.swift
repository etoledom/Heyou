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
    fileprivate let buttonsView = HYAlertButtonsView()
    var buttons: [UIButton] {
        get { return buttonsView.buttons }
    }
    let buttonsLayout : HYAlertButtonsLayout
    
    var onButtonPressed: (_ index: Int, _ title: String) -> () = {_,_ in}
    var elements: [HYAlertElement] = [] {
        didSet { createSubviews() }
    }
    
    var buttonActions: [HYAlertAction] = []
    var drawSeparator = true
    
    init(buttonsLayout layout: HYAlertButtonsLayout, actions: [HYAlertAction]) {
        buttonsLayout = layout
        super.init(frame: CGRect.zero)
        
        self.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(self.onBackgroundTap(_:))))
        self.translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = HYAlertStyleDefaults.backgroundColor
        layer.cornerRadius = CGFloat(HYAlertStyleDefaults.cornerRadius)
        layer.masksToBounds = true
        
        createLayout()
        createSubviews()
        createButtonsView(actions)
        buttonActions = actions
    }
    
    required init?(coder aDecoder: NSCoder) {
        buttonsLayout = .horizontal
        super.init(coder: aDecoder)
    }
    
    @objc func onBackgroundTap(_ tap: UITapGestureRecognizer) {}
    
    @objc func onButtonTap(_ sender: UIButton) {
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
    fileprivate var separatorView: UIView = {
        let separator = UIView()
        separator.backgroundColor = HYAlertStyleDefaults.separatorColor
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }()
    
    fileprivate func createSeparator() {
        addSubview(separatorView)
        
        separatorView.constraint(height: 1)
        separatorView.constraintLeading(to: self, margin: HYAlertStyleDefaults.separatorMarging)
        separatorView.constraintTrailing(to: self, margin: HYAlertStyleDefaults.separatorMarging)
        constraintSubviewsVertically(top: topView, bottom: separatorView, space: 0)
    }
    
    fileprivate func createButtonsView(_ buttons: [HYAlertAction]) {
        buttonsView.addButtons(actions: buttons)
        addSubview(buttonsView)
        
        constraintSubviewsVertically(top: separatorView, bottom: buttonsView)
        buttonsView.constraintBottom(to: self)
        buttonsView.constraintLeading(to: self)
        buttonsView.constraintTrailing(to: self)
    }
}
