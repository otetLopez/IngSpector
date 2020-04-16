//
//  AnalyzePhotoViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/16/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

class AnalyzePhotoViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.titleView?.isHidden = true
        self.navigationController?.setToolbarHidden(true, animated: true)
    }

}
