//
//  ImageCutter.swift
//  
//
//  Created by Dario on 20/04/2021.
//

import UIKit


/// Cuts an image into one or more resulting cropped images
final class ImageCutter {
    static func cut(_ image: UIImage, using rects: [CGRect]) -> [CGImage] {

        let croppedImages = generateCroppedImages(from: image, with: rects)

        return croppedImages
    }

    // MARK: - Private Section -

    static private func generateCroppedImages(from image: UIImage, with rects: [CGRect]) -> [CGImage] {
        var croppedImages = [CGImage]()

        guard let normalizedCGImage = image.normalizedImage?.cgImage else {
            assertionFailure("Unable to obtain normalized UIImage")
            return croppedImages
        }

        for rect in rects {
            if let croppedImage = normalizedCGImage.cropping(to: rect) {
                croppedImages.append(croppedImage)
            }
        }

        return croppedImages
    }
}
