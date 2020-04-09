//
//  HomeViewController.swift
//  IngSpector
//
//  Created by otet_tud on 4/8/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var analyzeFoodBtn: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        /* OTET: configureView() functions configure the view controller views every time it will appear on screen */
        configureView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureView()
    }
    
    func configureView() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
        self.navigationController?.setToolbarHidden(false, animated: true)
      
//        analyzeFoodBtn.imageEdgeInsets = UIEdgeInsets(top: 100,left: 100, bottom: 100,right: 100)
        
        //mageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10)
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
