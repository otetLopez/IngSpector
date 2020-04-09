//
//  FirstPageViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/7/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

class LogInViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        /* TODO*/
        /* OTET: We need to check if the user is logged in, if so, there is no need to display this page
                 and we will proceed to Home Page*/
        
        /* OTET: configureView() functions configure the view controller views every time it will appear on screen */
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    func configureView() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
        self.navigationController?.setToolbarHidden(true, animated: true)
    }


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         if let reg_delegate = (segue.destination as! UINavigationController).topViewController as? RegisterViewController {
//            reg_delegate.log_delegate = self
//        }
//    }
    

}
