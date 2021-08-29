//
//  ObjectDetectorType.swift
//  
//
//  Created by Dario on 04/03/2021.
//

import UIKit

public protocol ObjectDetectorType: AnyObject {
    func detectFrom(image: UIImage)
}
