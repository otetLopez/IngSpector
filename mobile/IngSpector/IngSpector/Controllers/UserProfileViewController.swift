//
//  UserProfileViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/9/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

class UserProfileViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
    }
    
    func configureView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationItem.hidesBackButton = true
        self.navigationController?.setToolbarHidden(false, animated: true)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
