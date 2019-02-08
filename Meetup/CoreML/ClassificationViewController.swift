//
//  ClassificationViewController.swift
//  Meetup
//
//  Created by Kevin Nguyen on 8/13/18.
//  Copyright © 2018 Kevin Nguyen. All rights reserved.
//

import UIKit
import CoreML
import Vision

class ClassificationViewController: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var classificationLabel: UILabel!
    @IBOutlet weak var carClassificationLabel: UILabel!
    @IBOutlet weak var carClassificationView: UIVisualEffectView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var startingPoint: Date?
    var carStartingPoint: Date?
    
    func performClassifications(for image: UIImage) {
        classificationLabel.text = "Performing classifications..."
        guard let ciImage = CIImage(image: image) else {
            fatalError("Unable to create \(CIImage.self) from \(image)")
        }
        startingPoint = Date()
        carStartingPoint = Date()
        DispatchQueue.global(qos: .userInitiated).async {
            let handler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation(image.imageOrientation))
            do {
                try handler.perform([self.classificationRequest])
            } catch {
                print("Failed to perform classification. \(error.localizedDescription)")
            }
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            let carHandler = VNImageRequestHandler(ciImage: ciImage, orientation: CGImagePropertyOrientation(image.imageOrientation))
            do {
                try carHandler.perform([self.carClassificationRequest])
            } catch {
                print("Failed to perform classification. \(error.localizedDescription)")
            }
        }
    }
    
    lazy var classificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: MobileNet().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processClassifications(for: request, error: error)
                print("MobileNet: \((self?.startingPoint?.timeIntervalSinceNow)! * -1) seconds elapsed")
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    lazy var carClassificationRequest: VNCoreMLRequest = {
        do {
            let model = try VNCoreMLModel(for: CarRecognition().model)
            let request = VNCoreMLRequest(model: model, completionHandler: { [weak self] request, error in
                self?.processCarClassifications(for: request, error: error)
                print("Car: \((self?.carStartingPoint?.timeIntervalSinceNow)! * -1) seconds elapsed")
            })
            request.imageCropAndScaleOption = .centerCrop
            return request
        } catch {
            fatalError("Failed to load Vision ML model: \(error)")
        }
    }()
    
    func processClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.classificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            let classifications = results as! [VNClassificationObservation]
            if classifications.isEmpty {
                self.classificationLabel.text = "Nothing recognized."
            } else {
                let top = classifications.prefix(2)
                let descriptions = top.map({ (classification) in
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                })
                self.carClassificationView.isHidden = false
                self.classificationLabel.text = "Classification:\n" + descriptions.joined(separator: "\n")
            }
        }
    }
    
    func processCarClassifications(for request: VNRequest, error: Error?) {
        DispatchQueue.main.async {
            guard let results = request.results else {
                self.carClassificationLabel.text = "Unable to classify image.\n\(error!.localizedDescription)"
                return
            }
            let classifications = results as! [VNClassificationObservation]
            if classifications.isEmpty {
                self.carClassificationLabel.text = "Nothing recognized."
            } else {
                let top = classifications.prefix(2)
                let descriptions = top.map({ (classification) in
                    return String(format: "  (%.2f) %@", classification.confidence, classification.identifier)
                })
                self.carClassificationLabel.text = "Car:\n" + descriptions.joined(separator: "\n")
            }
        }
    }
}

extension ClassificationViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func takePhoto(_ sender: Any) {
        let photoSelector = UIAlertController()
        let takePhoto = UIAlertAction(title: "Take Photo", style: .default) { [unowned self] _ in
            self.presentPhotoSelector(sourceType: .camera)
        }
        let choosePhoto = UIAlertAction(title: "Choose Photo", style: .default) { [unowned self] _ in
            self.presentPhotoSelector(sourceType: .photoLibrary)
        }
        photoSelector.addAction(takePhoto)
        photoSelector.addAction(choosePhoto)
        photoSelector.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(photoSelector, animated: true)
    }
    
    func presentPhotoSelector(sourceType: UIImagePickerControllerSourceType) {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = sourceType
        present(picker, animated: true)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        picker.dismiss(animated: true)
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        imageView.image = image
        performClassifications(for: image)
    }
}

extension CGImagePropertyOrientation {
    /**
     Converts a `UIImageOrientation` to a corresponding
     `CGImagePropertyOrientation`. The cases for each
     orientation are represented by different raw values.
     
     - Tag: ConvertOrientation
     */
    init(_ orientation: UIImageOrientation) {
        switch orientation {
        case .up: self = .up
        case .upMirrored: self = .upMirrored
        case .down: self = .down
        case .downMirrored: self = .downMirrored
        case .left: self = .left
        case .leftMirrored: self = .leftMirrored
        case .right: self = .right
        case .rightMirrored: self = .rightMirrored
        }
    }
}
