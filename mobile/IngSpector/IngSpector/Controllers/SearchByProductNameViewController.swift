//
//  SearchByProductNameViewController.swift
//  IngSpector
//
//  Created by DKU on 14.04.2020.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class SearchByProductNameViewController: UIViewController {

    @IBOutlet weak var checkAllegensBtnOutlet: UIButton!
    @IBOutlet weak var searchText: UITextField!
    
    var defaultsAccess = DefaultsAccess()
    var allergensOfUser : [String] = [String]()
    var allergicIngredients : [String] = [String]()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        checkAllegensBtnOutlet.layer.cornerRadius = 5
        // Do any additional setup after loading the view.
        allergensOfUser = defaultsAccess.getAllergenListFromDefaults()
        print(allergensOfUser);
    }
//    http://www.recipepuppy.com/api/?q=gyro&p=1

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

    @IBAction func checkAllergensButton(_ sender: Any) {
        
        var searchString : String = searchText.text!;
        searchString = searchString.replacingOccurrences(of: " ", with: "%20")
    
        let apiUrl : String = "http://www.recipepuppy.com/api/?q=\(searchString)&p=1"
        
           AF.request(apiUrl, method: .get).responseJSON {
             response in
                // SVProgressHUD.dismiss()
                 switch response.result {
                     case let .success(value):
                         let dataJSON : JSON = JSON(value)
                         
                         if let ingredientsOfSearchedProduct = dataJSON["results"][0]["ingredients"].string{
                            let ingredientArray = ingredientsOfSearchedProduct.components(separatedBy: ",")
                            
                            print(ingredientArray);
                           
                            for i in self.allergensOfUser{

                                let searchStr = i
                                let lowerCasedStr = searchStr.lowercased();
                                    for i in 0...ingredientArray.count-1{
                                        print("aaa")
                                        print(lowerCasedStr);
                                        print(ingredientArray[i])
                                        if(lowerCasedStr.contains(ingredientArray[i])){
                                            self.allergicIngredients.append(searchStr)
                                }
                            }
                        }
                    }
                         
                        //if not found
                         else{
                            print("not found")
                         }
      
                   
                         
                         
                     case let .failure(error):
                         print(error)
                 }
             }
    }
}
