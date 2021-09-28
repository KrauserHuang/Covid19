//
//  Covid19Model.swift
//  CanadianCovid19
//
//  Created by Tai Chin Huang on 2021/9/26.
//

import Foundation
import UIKit

protocol Covid19ModelDelegate {
    func covid19DataRetrieved(_ caseData: Covid19Data)
}

class Covid19Model {
    var deldgate: Covid19ModelDelegate?
    
    func fetchData(_ country: String) {
        let urlString = "https://corona.lmao.ninja/v3/covid-19/countries/\(country)"
        // iOS SDK: URLSession
        // check the URL is valid
        guard let url = URL(string: urlString) else {
            fatalError("Error fetching data!")
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    // URL解析的JSON資料會以Covid19Data型別存入caseResponse裡
                    let caseResponse = try decoder.decode(Covid19Data.self, from: data)
                    // 抓到的資料要直接顯示在UI上，所以直接套進DispatchQueue.main
                    DispatchQueue.main.async {
                        self.deldgate?.covid19DataRetrieved(caseResponse)
                    }
                } catch {
                    print("fail to decode data")
                }
            }
        }.resume()
    }
    
//    func presentAlert() {
//        let alertController = UIAlertController(title: "Fail!", message: "what you type do not exist", preferredStyle: .alert)
//        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
//        
//    }
    
    
}
