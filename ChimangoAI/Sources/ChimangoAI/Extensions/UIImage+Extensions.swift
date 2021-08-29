//
//  UIImage+Extensions.swift
//  
//
//  Created by Dario on 05/03/2021.
//

import UIKit

extension UIImage {

    /// Returns a normalized version of this UIImage
    ///
    /// Normalized in this context means rotated to match the `.up` orientation. For example: if the image was created by taking a picture with the back camera of an iPhone, it will usually have the `.right` orientation, in which case we need to rotate it 90 degrees to be able to perform certain operations on it (draw an overlay layer for example).
    /// - Note: Performance-wise other alternatives may be better, for example using Core Images orientation transform as mentioned here: https://chibicode.org/?p=208
    var normalizedImage: UIImage? {
        if imageOrientation == .up {
            return self
        }

        UIGraphicsBeginImageContextWithOptions(size, false, scale)

        self.draw(in: CGRect(origin: CGPoint(x: 0, y: 0), size: size))
        let normalizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return normalizedImage
    }
}
