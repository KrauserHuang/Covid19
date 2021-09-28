//
//  ViewController.swift
//  CanadianCovid19
//
//  Created by Tai Chin Huang on 2021/8/23.
//

import UIKit

class ViewController: UIViewController {
    
    var cases = [CaseResponse]()
    
    @IBOutlet weak var caseLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let urlString = "https://api.covid19tracker.ca/summary"
        guard let url = URL(string: urlString) else {
            print("URL invalid")
            return
        }
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            let decoder = JSONDecoder()
            if let data = data {
                do {
                    let searchResponse = try decoder.decode(Cases.self, from: data)
                    self.cases = searchResponse.data
                } catch {
                    print(error)
                }
            }
        }.resume()
        
        print(cases.count)
    }


}

