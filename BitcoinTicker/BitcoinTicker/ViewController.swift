//
//  ViewController.swift
//  BitcoinTicker
//
//  Created by Dan on 9/28/18.
//  Copyright © 2018 London App Brewery. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let baseURL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    let currencyMark = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    var finalURL = ""

    //Pre-setup IBOutlets
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
       
    }

    
    //TODO: Place your 3 UIPickerView delegate methods here
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        finalURL = baseURL + currencyArray[row]
        let currency = currencyMark[row]
        getBitcoinData(url: finalURL, currencyMark: currency)
    }
 
//    //MARK: - Networking
//    /***************************************************************/
//    
    func getBitcoinData(url: String, currencyMark: String) {
        
        Alamofire.request(url, method: .get)
            .responseJSON { response in
                if response.result.isSuccess {

                    print("Sucess! Got the bitcoin value")
                    let bitcoinValueJSON : JSON = JSON(response.result.value!)
                    print(JSON(response.result.value))
                    self.updateBitcoinValue(json: bitcoinValueJSON, currencyMark: currencyMark)

                } else {
                    print("Error: \(String(describing: response.result.error))")
                    self.bitcoinPriceLabel.text = "Connection Issues"
                }
            }

    }

//    //MARK: - JSON Parsing
//    /***************************************************************/
//    
    func updateBitcoinValue(json : JSON, currencyMark: String) {

        if let priceResult = json["open"]["day"].double {

            bitcoinPriceLabel.text = "\(currencyMark) \(priceResult)"
        } else {
            bitcoinPriceLabel.text = "Price unavailable"
        }
    }





}

