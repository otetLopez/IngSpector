//
//  NutritionFactsViewController.swift
//  IngSpector
//
//  Created by DKU on 16.04.2020.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import Alamofire
import SVProgressHUD
import SwiftyJSON

class NutritionFactsViewController: UIViewController {

    @IBOutlet weak var infoLabel: UILabel!
    @IBOutlet weak var weightOfFood: UITextField!
    
    @IBOutlet weak var resultLabel: UILabel!
    
    var defaultsAccess = DefaultsAccess()
    
    var height = 0.0
    var weight = 0.0
    
    
    var incomingFoodName = "";
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        infoLabel.text = "Just enter the weight of \(incomingFoodName) to learn percentage of daily needs"
        height = (defaultsAccess.getHeightFromDefaults() as NSString).doubleValue
        weight = (defaultsAccess.getWeightFromDefaults() as NSString).doubleValue
    }
    
   // https://api.edamam.com/search?q=chicken%20enchilada&app_id=76aa016a&app_key=e8d45d0585903b93a99c367f41020243&from=0&to=1
    @IBAction func checkPercentageButton(_ sender: UIButton) {
      
        if(weightOfFood.text != ""){
            let  searchString = incomingFoodName.replacingOccurrences(of: " ", with: "%20")
             let apiUrl = "https://api.edamam.com/search?q=\(searchString)&app_id=76aa016a&app_key=e8d45d0585903b93a99c367f41020243&from=0&to=1"
              
            AF.request(apiUrl, method: .get).responseJSON {
            response in
                print("girdi")
              print(apiUrl)
                switch response.result {
                    case let .success(value):
                        let dataJSON : JSON = JSON(value)
                  print(dataJSON)
                
                        let calorie  = dataJSON["hits"][0]["recipe"]["calories"].stringValue
                        let totalWeight  = dataJSON["hits"][0]["recipe"]["totalWeight"].stringValue
                 
                  
                        if(calorie != ""){
                          let doubleValueOfCalorie = (calorie as NSString).doubleValue
                      
                          let doubleValueOfTotalWeight = (totalWeight as NSString).doubleValue
          
                          let doubleValueOfInput = (self.weightOfFood.text! as NSString).doubleValue
                      
                          let gramCalorie = doubleValueOfCalorie/doubleValueOfTotalWeight
                          let totalCalorie = gramCalorie*doubleValueOfInput
                         
                          let basalMetabolicRate = ((10*self.weight) + (6.25*self.height) - (5*30) + 5) * 1.2
                         
                          let percentage = (totalCalorie/basalMetabolicRate) * 100
                          let doubleStr = Double(String(format: "%.2f", percentage))
                          
                            self.resultLabel.text = "%\n \(doubleStr!) \n Of Your Daily \n Calorie Needs"
                            
                          
                      }
                  
                        else{
                          //notfound
                          
                  }
                  
                      
                        
                    case let .failure(error):
                        print(error)
                    }
                }
                      
            }
        }
    
       
        

}
