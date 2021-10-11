//
//  ViewController.swift
//  ChimangoDemo
//
//  Created by Dario on 29/08/2021.
//

import UIKit
import AVFoundation
import ChimangoAI

class ViewController: UIViewController, UINavigationControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

        imagePickerController.modalPresentationStyle = .currentContext

        /*
         Assign a delegate for the image picker. The delegate receives
         notifications when the user picks an image or movie, or exits the
         picker interface. The delegate also decides when to dismiss the picker
         interface.
        */
        imagePickerController.delegate = self

        /*
         This app requires use of the device's camera. The app checks for device
         availability using the `isSourceTypeAvailable` method. If the
         camera isn't available (for example on a simulator) then disable the camera button.
         */
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            cameraButton.isEnabled = false
        }

        overlayView.clearsContextBeforeDrawing = true
        overlayView.didTapButtonOnObjectDetection = { objectDetection in
            print("============ user tapped on object ================")
            print(objectDetection)
        }

    }

    // MARK: - Private Section -
    @IBOutlet private var cameraButton: UIBarButtonItem!
    @IBOutlet private var imageView: UIImageView!
    @IBOutlet private var overlayView: OverlayView!

    private let imagePickerController = UIImagePickerController()
    private var capturedImage: UIImage?


    @IBAction private func didTapShowCamera(_ sender: UIBarButtonItem) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)

        if authStatus == AVAuthorizationStatus.denied {
            // The system denied access to the camera. Alert the user.

            /*
             The user previously denied access to the camera. Tell the user this
             app requires camera access.
            */
            let alert = UIAlertController(title: "Unable to access the Camera",
                                          message: "To turn on camera access, choose Settings > Privacy > Camera and turn on Camera access for this app.",
                                          preferredStyle: UIAlertController.Style.alert)

            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alert.addAction(okAction)

            let settingsAction = UIAlertAction(title: "Settings", style: .default, handler: { _ in
                // Take the user to the Settings app to change permissions.
                guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else { return }
                if UIApplication.shared.canOpenURL(settingsUrl) {
                    UIApplication.shared.open(settingsUrl, completionHandler: { (_) in
                        // The resource finished opening.
                    })
                }
            })
            alert.addAction(settingsAction)

            present(alert, animated: true, completion: nil)
        } else if authStatus == AVAuthorizationStatus.notDetermined {
            /*
             The user never granted or denied permission for media capture with
             the camera. Ask for permission.

             Note: The app must provide a `Privacy - Camera Usage Description`
             key in the Info.plist with a message telling the user why the app
             is requesting access to the device’s camera. See this app's
             Info.plist for such an example usage description.
            */
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if granted {
                    DispatchQueue.main.async {
                        self.showImagePicker(sourceType: UIImagePickerController.SourceType.camera, button: sender)
                    }
                }
            })
        } else {
            /*
             The user granted permission to access the camera. Present the
             picker for capture.

             Set the image picker `sourceType` property to
             `UIImagePickerController.SourceType.camera` to configure the picker
             for media capture instead of browsing saved media.
            */
            showImagePicker(sourceType: UIImagePickerController.SourceType.camera, button: sender)
        }
    }


    @IBAction private func didTapShowGallery(_ sender: UIBarButtonItem) {
        showImagePicker(sourceType: .photoLibrary, button: sender)
    }


    private func showImagePicker(sourceType: UIImagePickerController.SourceType, button: UIBarButtonItem) {
        imagePickerController.sourceType = sourceType
        imagePickerController.modalPresentationStyle = (sourceType == .camera) ? .fullScreen : .popover

        let presentationController = imagePickerController.popoverPresentationController
        // Display a popover from the gallery button
        presentationController?.barButtonItem = button
        presentationController?.permittedArrowDirections = .any

        if sourceType == .camera {
            // NOTE: if we had a custom overlay we execute additional code here for example:
            // imagePickerController.showsCameraControls = false
        }

        present(imagePickerController, animated: true, completion: nil)
    }
}


// MARK: - UIImagePickerControllerDelegate
extension ViewController: UIImagePickerControllerDelegate {
    /**
    You must implement the following methods that conform to the
    `UIImagePickerControllerDelegate` protocol to respond to user interactions
    with the image picker.

    When the user taps a button in the camera interface to accept a newly
    captured picture, the system notifies the delegate of the user’s choice by
    invoking the `imagePickerController(_:didFinishPickingMediaWithInfo:)`
    method. Your delegate object’s implementation of this method can perform
    any custom processing on the passed media, and should dismiss the picker.
    The delegate methods are always responsible for dismissing the picker when
    the operation completes.
    */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {

        let info = convertFromUIImagePickerControllerInfoKeyDictionary(info)

        guard let image = info[convertFromUIImagePickerControllerInfoKey(UIImagePickerController.InfoKey.originalImage)] as? UIImage else {
            return
        }

        capturedImage = image

        dismiss(animated: true) { [weak self] in
            guard let this = self else { return }

            this.imageView?.image = this.capturedImage

            do {
                try VisualSearchManager.detectObjectsIn(image: image) { (result) in
                    DispatchQueue.main.async { [weak self] in

                        self?.overlayView.detectionOverlays = []
                        switch result {
                        case .failure(let error):
                            print("detectObjectsIn error: \(error.localizedDescription)")
                            self?.showAlert(title: "Object detection error", message: error.localizedDescription)

                        case .success(let detections):
                            print("OBJECT DETECTION RESULT: ====================")
                            print(detections.debugDescription)
                            self?.showAlert(title: "Object Detection Result", message: detections.debugDescription)
                            self?.drawAfterDetectingObjects(objectDetections: detections)
                        }
                    }
                }
            } catch let error {
                print("failed to detect objects with error: \(error.localizedDescription)")
            }
        }
    }

    /**
    If the user cancels the operation, the system invokes the delegate's
    `imagePickerControllerDidCancel(_:)` method, and you should dismiss the
    picker.
    */
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: {
        /*
         The dismiss method calls this block after dismissing the image picker
         from the view controller stack. Perform any additional cleanup here.
        */
        })
    }


    // MARK: - Private Section -
    private func convertFromUIImagePickerControllerInfoKeyDictionary(_ input: [UIImagePickerController.InfoKey: Any]) -> [String: Any] {
        return Dictionary(uniqueKeysWithValues: input.map { key, value in (key.rawValue, value) })
    }

    private func convertFromUIImagePickerControllerInfoKey(_ input: UIImagePickerController.InfoKey) -> String {
        return input.rawValue
    }


    private func drawAfterDetectingObjects(objectDetections: ObjectDetections) {

        let imageRect = imageView.containedImageRect

        let objectOverlays = objectDetections.detections.compactMap { detection in
            return ObjectDetectionOverlay(objectDetection: detection, imageRect: imageRect)
        }

        if objectOverlays.isEmpty { return }

        overlayView.detectionOverlays = objectOverlays
    }
}
