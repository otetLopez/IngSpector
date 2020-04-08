//
//  FirstPageViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/7/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

class FirstPageViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.setNavigationBarHidden(true, animated: true)

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    


//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//         if let reg_delegate = (segue.destination as! UINavigationController).topViewController as? RegisterViewController {
//            reg_delegate.log_delegate = self
//        }
//    }
    

}
