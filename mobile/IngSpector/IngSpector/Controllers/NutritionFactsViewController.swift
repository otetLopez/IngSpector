//
//  NutritionFactsViewController.swift
//  IngSpector
//
//  Created by DKU on 16.04.2020.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit

class NutritionFactsViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var weightOfFood: UITextField!
    
    
    
    var incomingFoodName = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        infoLabel.text = "Just enter the weight of \(incomingFoodName) to learn percentage of daily needs"
        
    }
    
    
    @IBAction func checkPercentageButton(_ sender: UIButton) {
    }
    
}
