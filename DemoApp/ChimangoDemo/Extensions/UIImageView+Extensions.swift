//
//  UIImageView+Extensions.swift
//  IBSDemo
//
//  Created by Dario on 27/04/2021.
//

import UIKit

extension UIImageView {

    /// Returns the `CGRect` enclosing the contained image in .aspectFit mode
    var containedImageRect: CGRect {
        guard let image = image else { return bounds }
        guard contentMode == .scaleAspectFit else { return bounds }
        guard image.size.width > 0 && image.size.height > 0 else { return bounds }

        let widthScale = bounds.width / image.size.width
        let heightScale = bounds.height / image.size.height
        let aspect = fmin(widthScale, heightScale)

        let size = CGSize(width: image.size.width * aspect, height: image.size.height * aspect)

        let xOrigin = (bounds.width - size.width) / 2
        let yOrigin = (bounds.height - size.height) / 2

        return CGRect(x: xOrigin, y: yOrigin, width: size.width, height: size.height)
    }
}
