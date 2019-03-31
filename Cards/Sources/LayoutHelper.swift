//
//  Lay.swift
//  Cards
//
//  Created by Paolo on 15/10/17.
//  Copyright © 2017 Apple. All rights reserved.
//

import Foundation
import UIKit

open class LayoutHelper {

    let rect: CGRect

    public init(rect: CGRect) {
        self.rect = rect
    }

    open func X(_ percentage: CGFloat) -> CGFloat {
        return percentage * rect.width / 100
    }

    open func Y(_ percentage: CGFloat) -> CGFloat {
        return percentage * rect.height / 100
    }

    open func X(_ percentage: CGFloat, from: UIView) -> CGFloat {
        return X(percentage) + from.frame.maxX
    }

    open func Y(_ percentage: CGFloat, from: UIView) -> CGFloat {
        return Y(percentage) + from.frame.maxY
    }

    open func RevX(_ percentage: CGFloat, width: CGFloat) -> CGFloat {
        return (rect.width - X(percentage)) - width
    }

    open func RevY(_ percentage: CGFloat, height: CGFloat) -> CGFloat {
        return (rect.height - Y(percentage)) - height
    }

    open func RevY(_ percentage: CGFloat, height: CGFloat, from: UIView) -> CGFloat {
        return from.frame.minY - Y(percentage) - height
    }
    
    static public func Width(_ percentage: CGFloat, of view: UIView) -> CGFloat {
        return view.frame.width * (percentage / 100)
    }
    
    static public func Height(_ percentage: CGFloat, of view: UIView) -> CGFloat {
        return view.frame.height * (percentage / 100)
    }

    static public func XScreen(_ percentage: CGFloat) -> CGFloat {
            return percentage * UIScreen.main.bounds.width / 100
    }

    static public func YScreen(_ percentage: CGFloat) -> CGFloat {
            return percentage * UIScreen.main.bounds.height / 100
    }

}

extension CGRect {
    
    var center: CGPoint {
        return CGPoint(x: width/2 + minX, y: height/2 + minY)
    }
}
