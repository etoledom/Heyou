//
//  HYAlertAction.swift
//  HeyouDemo
//
//  Created by eToledom on 8/25/17.
//  Copyright © 2017 eToledoM. All rights reserved.
//

import UIKit

public enum HYAlertActionStyle {
    case `default`
    case cancel
    case destructive
    case main
}

public struct HYAlertAction {
    public var title: String?
    public var style: HYAlertActionStyle
    public var isEnabled: Bool = true

    internal let handler: ((HYAlertAction) -> Void)?

    public init(title: String?, style: HYAlertActionStyle, handler: ((HYAlertAction) -> Void)? = nil) {
        self.handler = handler
        self.title = title
        self.style = style
    }
}
