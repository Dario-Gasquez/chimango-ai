//
//  VSOverlayButton.swift
//  
//
//  Created by Dario on 03/05/2021.
//

import UIKit

/// A custom button that is drawn on top of an `ObjectDetection`
public class VSOverlayButton: UIButton {

    public var objectDetection: ObjectDetection?

    required init?(coder: NSCoder) {
        super.init(coder: coder)

        borderSetup()
    }

    public override init(frame: CGRect) {
        super.init(frame: frame)

        borderSetup()
    }

    public override func layoutSubviews() {
        super.layoutSubviews()
        updateCornerRadius()
    }


    public override var isEnabled: Bool {
        didSet {
            let color = isEnabled ? Constants.enabledColor : Constants.disabledColor
            titleLabel?.textColor = color
            layer.borderColor = color.cgColor
        }
    }

    // MARK: - Private Section -
    private enum Constants {
        static let disabledColor = UIColor.gray
        static let enabledColor = UIColor.green
    }

    private func borderSetup() {
        layer.borderWidth = 2.0
        layer.borderColor = Constants.enabledColor.cgColor
        layer.backgroundColor = Constants.enabledColor.withAlphaComponent(0.3).cgColor

    }

    /// Updates the layer's radius.
    ///
    /// Execute this method when the bounds might change to maintain the round border
    /// - Important: in order to get a round button, height and width must be the same.
    private func updateCornerRadius() {
        layer.cornerRadius = bounds.width * 0.5
    }
}
