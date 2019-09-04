//
//  ViewController.swift
//  Bitcoin Price Tracker
//
//  Created by gekongfei on 2019/9/3.
//  Copyright © 2019 gekongfei. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var usdLabel: UILabel!
    
    @IBOutlet weak var chineseLabel: UILabel!
    
    @IBOutlet weak var euLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        getDefaultPrices()
        getPrice()
    }
    
    func getDefaultPrices() {
        let usdPrice = UserDefaults.standard.double(forKey: "USD")
        if usdPrice != 0.0 {
            usdLabel.text = doubleToMoneyString(price: usdPrice, currencyCode: "USD")
        }
        
        let cnyPrice = UserDefaults.standard.double(forKey: "CNY")
        if cnyPrice != 0.0 {
            chineseLabel.text = doubleToMoneyString(price: cnyPrice, currencyCode: "CNY")
        }
        
        let euPrice = UserDefaults.standard.double(forKey: "EUR")
        if euPrice != 0.0 {
            euLabel.text = doubleToMoneyString(price: euPrice, currencyCode: "EUR")
        }
    }
    
    
    @IBAction func refreshTapped(_ sender: Any) {
        getPrice()
    }
    
    func doubleToMoneyString(price: Double, currencyCode: String) -> String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = currencyCode
        
        return formatter.string(from: NSNumber(value: price))
    }
    
    func getPrice() {
        if let url = URL(string: "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms=USD,CNY,EUR") {
            URLSession.shared.dataTask(with: url) { (data, response, error) in
                if let data = data {
                    if let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String:Double] {
                        
                        DispatchQueue.main.async {
                            if let usdPrice = json["USD"] {
                                
                                self.usdLabel.text = self.doubleToMoneyString(price: usdPrice, currencyCode: "USD")
                                
                                UserDefaults.standard.set(usdPrice, forKey: "USD")
                            }
                            
                            if let chinesePrice = json["CNY"] {
                                self.chineseLabel.text = self.doubleToMoneyString(price: chinesePrice, currencyCode: "CNY")
                                
                                UserDefaults.standard.set(chinesePrice, forKey: "CNY")
                            }
                            
                            if let euPrice = json["EUR"] {
                                self.euLabel.text = self.doubleToMoneyString(price: euPrice, currencyCode: "EUR")
                                
                                UserDefaults.standard.set(euPrice, forKey: "EUR")
                            }
                            
                            UserDefaults.standard.synchronize()
                        }
                    }
                } else {
                    print("something went wrong")
                }
            }.resume()
        }
    }
}

