//
//  OverlayView.swift
//  ChimangoDemo
//
//  Created by Dario on 27/04/2021.
//

import UIKit
import ChimangoAI

class OverlayView: UIView {

    var detectionOverlays: [ObjectDetectionOverlay] = [] {
        didSet { showButtons() }
    }

    var didTapButtonOnObjectDetection : ( (ObjectDetection) -> Void )?

    func showButtons() {
        // remove buttons previously added
        subviews.forEach { subview in
            subview.removeFromSuperview()
        }

        // add new buttons
        detectionOverlays.forEach { overlay in
            drawButton(in: overlay.rectangle, objectDetection: overlay.objectDetection)
        }
    }


    // MARK: - Private Section -
    private enum Constants {
        static let circleRadius: CGFloat = 22.0
    }


    private func drawRectangle(_ rect: CGRect) {
        let rectanglePath = UIBezierPath(rect: rect)
        rectanglePath.lineWidth = 3.0
        UIColor.yellow.setStroke()
        rectanglePath.stroke()
    }


    private func drawCircle(_ rect: CGRect) {
        let radius = Constants.circleRadius
        let origin = CGPoint(x: rect.midX - radius, y: rect.midY - radius)
        let circleRect = CGRect(origin: origin, size: CGSize(width: radius * 2.0, height: radius * 2.0))
        let circlePath = UIBezierPath(ovalIn: circleRect)
        circlePath.lineWidth = 3.0
        UIColor.green.setStroke()
        circlePath.stroke()
    }


    private func drawButton(in rect: CGRect, objectDetection: ObjectDetection) {
        let radius = Constants.circleRadius
        let origin = CGPoint(x: rect.midX - radius, y: rect.midY - radius)
        let circleRect = CGRect(origin: origin, size: CGSize(width: radius * 2.0, height: radius * 2.0))


        let button = VSOverlayButton(frame: circleRect)
        button.objectDetection = objectDetection
        button.addTarget(self, action: #selector(buttonAction(sender:)), for: .touchUpInside)

        addSubview(button)
    }


    @objc private func buttonAction(sender: UIButton) {
        guard let overlayButton = sender as? VSOverlayButton,
              let objectDetection = overlayButton.objectDetection else { return }

        didTapButtonOnObjectDetection?(objectDetection)
    }
}
