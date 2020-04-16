//
//  AnalyzePhotoViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/16/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

class AnalyzePhotoViewController: UIViewController {

    @IBOutlet weak var cameraBtn: UIButton!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var resultLbl: UILabel!
    @IBOutlet weak var scanBtn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    @IBAction func cameraBtnPressed(_ sender: UIButton) {
    }
    
    
    @IBAction func ScanBtnPressed(_ sender: UIButton) {
    }
    
    
    func configureView() {
        navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.titleView?.isHidden = true
        self.navigationController?.setToolbarHidden(true, animated: true)
        
        cameraBtn.layer.cornerRadius = 10
        scanBtn.layer.cornerRadius = 10
    }

}
