//
//  ViewController.swift
//  MalariaNetSwift
//
//  Created by Kartik Kumar on 05/10/19.
//  Copyright © 2019 Kartik Kumar. All rights reserved.
//

import UIKit
import CoreML
import Vision

var flag: String!
var image1: CIImage!

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var cellImage: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func uploadButtonPressed(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        let actionSheet = UIAlertController(title: "Image Source", message: "Choose an image", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .camera
            flag = "cam"
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            flag = "lib"
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel , handler: nil))
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[.editedImage] as! UIImage
        cellImage.image = image
        guard let convCIImage = CIImage(image: image) else {
            fatalError("Image cannot be converted to CIImage")
        }
        detect(image: convCIImage)
        picker.dismiss(animated: true, completion: nil)
    }
    
    func detect(image: CIImage) {
        guard let model = try? VNCoreMLModel(for: malaria().model) else {
            fatalError("Cannot import the model")
        }
        let request = VNCoreMLRequest(model: model) { (request, error) in
            let clf = request.results?.first as? VNClassificationObservation
            if clf!.identifier == "1" {
                self.resultLabel.text = "Uninfected"
            }
            else if clf!.identifier == "0" {
                self.resultLabel.text = "Parasitized"
            }
        }
        if flag == "cam" {
            
            let currentCIImage = image

            let filter = CIFilter(name: "CIColorMonochrome")
            filter?.setValue(currentCIImage, forKey: "inputImage")

            // set a gray value for the tint color
            filter?.setValue(CIColor(red: 0.7, green: 0.7, blue: 0.7), forKey: "inputColor")

            filter?.setValue(1.0, forKey: "inputIntensity")
            guard let outputImage = filter?.outputImage else { return }

            let context = CIContext()

            if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
                let processedImage = UIImage(cgImage: cgimg)
                image1 = CIImage(image: processedImage)!
                print(processedImage.size)
            }
        }
        else {
            image1 = image
        }
        let handler = VNImageRequestHandler(ciImage: image1)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
}

