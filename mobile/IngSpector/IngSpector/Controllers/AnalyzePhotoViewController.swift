//
//  AnalyzePhotoViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/16/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SVProgressHUD
import TesseractOCR
import GPUImage

class AnalyzePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var scanBtn: UIButton!
    
    var internetConnection : InternetConnection = InternetConnection()
    var serverConnection : ServerConnection = ServerConnection()
    var defaultsAccess : DefaultsAccess = DefaultsAccess()
    var allergenList : [String] = [String]()

    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        scanBtn.isEnabled = false
        photoView.layer.cornerRadius=15;
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureView()
        retrieveAllergenList()
    }
    
    @IBAction func cameraBtnPressed(_ sender: UIButton) {
        resultLbl.text = ""
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
        showProgress(msg: "Scanning photo...")
        resultLbl.text = ""
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.analyzeFoodLabel(foodLabel : self.performImageRecognition(self.photoView.image!))
        }
       
     
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            showToastMsg(msg: "No Image To Scan.", seconds: 2)
            return
        }
        print("DEBUG: imagePickerController  We have an image")
        photoView.image = image
        scanBtn.isEnabled = true
        
    }
    
    func performImageRecognition(_ image: UIImage) -> String {
       
        showProgress(msg: "Scanning photo...")
        var txt : String = ""
        let scaledImage = image.scaledImage(1000) ?? image
        let preprocessedImage = scaledImage.preprocessedImage() ?? scaledImage

        if let tesseract = G8Tesseract(language: "eng+fra") {
            tesseract.engineMode = .tesseractCubeCombined
            tesseract.pageSegmentationMode = .auto

            tesseract.image = preprocessedImage
            tesseract.recognize()
            txt =  tesseract.recognizedText ?? ""
            print("DEBUG: Recognized Text --> \(txt)")
        }
        return "txt"
    }
    
    func retrieveAllergenList() {
        let email : String = defaultsAccess.getEmailFromDefaults()
        let url : String = serverConnection.getURLinfo() + email + "/get"
        
        if (!internetConnection.isConnected()) {
            showToastMsg(msg: "Not connected to internet.  Try Again.", seconds: 3)
        } else {
            AF.request(url, method: .get).responseJSON {
            response in
                SVProgressHUD.dismiss()
                switch response.result {
                    case let .success(value):
                        let dataJSON : JSON = JSON(value)
                        let user = self.serverConnection.parseUserInfo(dataJSON: dataJSON)
                        self.defaultsAccess.setAllergenListToDefaults(allergenList: user.getAllergens())
                        self.allergenList = user.getAllergens()
                    case let .failure(error):
                        self.showToastMsg(msg: "Cannot Connect To Server.  Please Try Again.", seconds: 3)
                        print(error)
                }
            }
        }
    }
    
    func analyzeFoodLabel(foodLabel: String) {
        var isAllergic : Bool = false
        allergenList = defaultsAccess.getAllergenListFromDefaults()
        for allergen in allergenList {
            if foodLabel.lowercased().contains(allergen.lowercased()) {
                SVProgressHUD.dismiss()
                promptFoodName(allergen: allergen)
                isAllergic = true
                break
            }
        }
        if isAllergic == false {
            SVProgressHUD.dismiss()
            resultLbl.text = "This is safe for you.  Bon Appétit!"
        }
    }
    
    func promptFoodName(allergen: String) {
        let alertController = UIAlertController(title: "Contains \(allergen)!", message: "Save food to your list", preferredStyle: .alert)
        
        alertController.addTextField { (nFoodName) in
            nFoodName.placeholder = "Food Name"
        }
        
        let saveFoodAction = UIAlertAction(title: "Save", style: .default) { (action) in
            let textField = alertController.textFields![0]
            var foodName : String = ""
            if textField.text!.isEmpty {
                foodName = allergen
            } else { foodName = textField.text! }
            
            self.addFood(newFood: foodName)
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        alertController.addAction(saveFoodAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func addFood(newFood: String) {
        if isFoodRecorded(newFood: newFood) == false {
            var foodList : [String] = defaultsAccess.getFoodListFromDefaults()
           
            /* Add to user defaults */
            foodList.append(newFood)
            defaultsAccess.setFoodListToDefaults(foodList: foodList)
           
            /* Add to server */
            let email : String = defaultsAccess.getEmailFromDefaults()
            let url : String = serverConnection.getURLAddFood() + "\(email)/\(newFood.replacingOccurrences(of: " ", with: "%20").uppercased())"
            print("DEBUG: addFood food to user details \(url)")

            if (!internetConnection.isConnected()) {
                showToastMsg(msg: "Not connected to internet.  Try Again.", seconds: 3)
            }  else {
                AF.request(url, method: .get).responseJSON {
                    response in
                    switch response.result {
                        case .success(_):
                            print("DEBUG: Added New Food")
                        case let .failure(error):
                            //self.showToastMsg(msg: "Cannot Connect To Server.  Please Try Again.", seconds: 2)
                            print(error)
                    }
                }
            }
        } else { showToastMsg(msg: "This is already in your food list", seconds: 2) }
        
    }
       
    func isFoodRecorded(newFood: String) -> Bool {
       let foodList : [String] = defaultsAccess.getFoodListFromDefaults()
       for food in foodList {
           if food == newFood {
               return true
           }
       }
       return false
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
    
    func configureView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.titleView?.isHidden = true
        self.navigationController?.setToolbarHidden(true, animated: true)
        resultLbl.text = ""
        
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
