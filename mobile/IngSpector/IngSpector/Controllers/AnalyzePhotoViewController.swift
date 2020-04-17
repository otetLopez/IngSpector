//
//  AnalyzePhotoViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/16/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import SVProgressHUD
import TesseractOCR
import GPUImage

class AnalyzePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var scanBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureValues()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
        configureValues()
    }
    
    @IBAction func cameraBtnPressed(_ sender: UIButton) {
        let vc = UIImagePickerController()
        vc.allowsEditing = true
        vc.delegate = self
        
        if !UIImagePickerController.isSourceTypeAvailable(.camera) {
            showToastMsg(msg: "Device has no camera or App has no access to camera", seconds: 2)
        } else {
            vc.sourceType = .camera
            self.present(vc, animated: true)
        }
    }
    
    @IBAction func ScanBtnPressed(_ sender: UIButton) {
        performImageRecognition(photoView.image!)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        photoView.image = image
        scanBtn.isEnabled = true
    }
    
    func performImageRecognition(_ image: UIImage) {
      let scaledImage = image.scaledImage(1000) ?? image
      let preprocessedImage = scaledImage.preprocessedImage() ?? scaledImage
      
      if let tesseract = G8Tesseract(language: "eng+fra") {
        tesseract.engineMode = .tesseractCubeCombined
        tesseract.pageSegmentationMode = .auto
        
        tesseract.image = preprocessedImage
        tesseract.recognize()
        let txt : String = tesseract.recognizedText ?? ""
        print("DEBUG: Recognized Text --> \(txt)")
      }
    }
    
    func showToastMsg(msg: String, seconds: Double) {
        let alertController = UIAlertController(title: nil, message: msg, preferredStyle: .alert)
        alertController.view.alpha = 0.5
        alertController.view.layer.cornerRadius = 15
        
        self.present(alertController, animated: true)
        
        DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + seconds) {
            alertController.dismiss(animated: true)
        }
    }

    func showProgress(msg: String) {
        SVProgressHUD.setDefaultStyle(.custom)
        SVProgressHUD.setDefaultMaskType(.custom)
        SVProgressHUD.setForegroundColor(UIColor.darkGray)
        SVProgressHUD.setBackgroundColor(UIColor.orange)
        SVProgressHUD.show(withStatus: msg)
    }
    
    func configureValues() {
        
    }
    
    func configureView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.titleView?.isHidden = true
        self.navigationController?.setToolbarHidden(true, animated: true)
        scanBtn.isEnabled = false
        
        cameraBtn.layer.cornerRadius = 10
        scanBtn.layer.cornerRadius = 10
    }
}

// MARK: - UIImage extension
extension UIImage {
  func scaledImage(_ maxDimension: CGFloat) -> UIImage? {
    var scaledSize = CGSize(width: maxDimension, height: maxDimension)

    if size.width > size.height {
      scaledSize.height = size.height / size.width * scaledSize.width
    } else {
      scaledSize.width = size.width / size.height * scaledSize.height
    }

    UIGraphicsBeginImageContext(scaledSize)
    draw(in: CGRect(origin: .zero, size: scaledSize))
    let scaledImage = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    
    return scaledImage
  }
  
  func preprocessedImage() -> UIImage? {
    let stillImageFilter = GPUImageAdaptiveThresholdFilter()
    stillImageFilter.blurRadiusInPixels = 15.0
    let filteredImage = stillImageFilter.image(byFilteringImage: self)
    return filteredImage
  }
}
