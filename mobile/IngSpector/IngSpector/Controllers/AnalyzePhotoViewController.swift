//
//  AnalyzePhotoViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/16/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import SVProgressHUD

class AnalyzePhotoViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var scanBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
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
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)

        guard let image = info[.editedImage] as? UIImage else {
            print("No image found")
            return
        }
        photoView.image = image
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
        
        cameraBtn.layer.cornerRadius = 10
        scanBtn.layer.cornerRadius = 10
    }
}
