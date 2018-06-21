//
//  CALayer+PinLayout.swift
//  PinLayout
//
//  Created by Antoine Lamy on 2018-06-20.
//  Copyright © 2018 mcswiftlayyout.mirego.com. All rights reserved.
//

import QuartzCore

extension CALayer: Layoutable {
    public typealias View = CALayer

    public var superview: CALayer? {
        return superlayer
    }

    public var subviews: [CALayer] {
        return sublayers ?? []
    }

    public func getRect(keepTransform: Bool) -> CGRect {
        if keepTransform {
            /*
             To adjust the view's position and size, we don't set the UIView's frame directly, because we want to keep the
             view's transform (UIView.transform).
             By setting the view's center and bounds we really set the frame of the non-transformed view, and this keep
             the view's transform. So view's transforms won't be affected/altered by PinLayout.
             */

            let size = bounds.size
            // See setRect(...) for details about this calculation.
            let origin = CGPoint(x: position.x - (size.width * anchorPoint.x),
                                 y: position.y - (size.height * anchorPoint.y))

            return CGRect(origin: origin, size: size)
        } else {
            return frame
        }
    }

    public func setRect(_ rect: CGRect, keepTransform: Bool) {
        let adjustedRect = Coordinates<View>.adjustRectToDisplayScale(rect)

        if keepTransform {
            /*
             To adjust the view's position and size, we don't set the UIView's frame directly, because we want to keep the
             view's transform (UIView.transform).
             By setting the view's center and bounds we really set the frame of the non-transformed view, and this keep
             the view's transform. So view's transforms won't be affected/altered by PinLayout.
             */

            // NOTE: The center is offset by the layer.anchorPoint, so we have to take it into account.
            position = CGPoint(x: adjustedRect.origin.x + (adjustedRect.width * anchorPoint.x),
                               y: adjustedRect.origin.y + (adjustedRect.height * anchorPoint.y))
            // NOTE: We must set only the bounds's size and keep the origin.
            bounds.size = adjustedRect.size
        } else {
            frame = adjustedRect
        }
    }

    public func isLTR() -> Bool {
        switch Pin.layoutDirection {
        case .auto: return true
        case .ltr:  return true
        case .rtl:  return false
        }
    }
}
