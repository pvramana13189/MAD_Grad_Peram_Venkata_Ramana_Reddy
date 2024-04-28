//
//  PredictionController.swift
//  MAD_Grad_Peram_Venkata_Ramana_Reddy
//
//  Created by Ramana on 4/26/24.
//

import UIKit
import CoreML
import Vision


class PredictionController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
    @IBOutlet weak var uilabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    let imagePicker = UIImagePickerController()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        imagePicker.allowsEditing = false
    }
    
    // This function gets image from user's camera and send it to the detect Image function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        if let userPickedimage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            imageView.image = userPickedimage
            
            guard let ciimage = CIImage(image: userPickedimage)  else {
                fatalError("Could not convert to CIImage")
            }
            detectImage(image: ciimage)
            
        }
        
        imagePicker.dismiss(animated: true, completion: nil)
        
    }
    
    // The detect function detects image and calls the .mlmodel for prediction
    func detectImage(image: CIImage) {
        
        guard let model = try? VNCoreMLModel(for: BoxCarClassification_1().model) else {
            fatalError("Loading CoreML is failed")
        }
        
        let request = VNCoreMLRequest(model: model) { (request, error) in
            guard let results = request.results as? [VNClassificationObservation] else {
                fatalError("Model failed to process the image")
            }
            
            if let firstResult = results.first {
                //self.navigationItem.title = firstResult.identifier.description
                self.uilabel.text = "Predicted Class: " + firstResult.identifier.description
            }
        }
        
        let handler = VNImageRequestHandler(ciImage: image)
        
        do {
            try handler.perform([request])
        }
        catch {
            print(error)
        }
    }
    
    // This IBAction is used to capture the image and given to the UIimage picker controller
    @IBAction func cameraTapped(_ sender: UIBarButtonItem) {
        present(imagePicker, animated: true, completion: nil)
    }
    
}
