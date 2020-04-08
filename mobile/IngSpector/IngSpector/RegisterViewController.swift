//
//  RegisterViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/7/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

class RegisterViewController: UIViewController {

    weak var log_delegate: FirstPageViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        //self.navigationController?
        

        // Do any additional setup after loading the view.
    }
    

    

//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if let mapDelegate = segue.destination as? MapViewController {
//                   mapDelegate.delegate = self
//               }
//    }
    

}
