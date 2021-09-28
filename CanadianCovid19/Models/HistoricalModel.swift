//
//  HistoricalModel.swift
//  CanadianCovid19
//
//  Created by Tai Chin Huang on 2021/9/26.
//

import Foundation

protocol HistoricalModelDelegate {
    // 因為同時有多筆資料，所以存在array裡
    func turnGraph(_ newCases: NewCase)
}

class HistoricalModel {
    var delegate: HistoricalModelDelegate?
    // model主要功能就是將JSON檔案抓下來，然後match到我們自訂的data上(?)
    func fetchData(_ country: String) {
        let urlString = "https://corona.lmao.ninja/v3/covid-19/historical/\(country)?lastdays=8"
        
        guard let url = URL(string: urlString) else {
            fatalError("Error fetching data!")
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let data = data {
                let decoder = JSONDecoder()
                do {
                    let caseResponse = try decoder.decode(HistoricalData.self, from: data)
                    let cases = caseResponse.timeline.cases
                    var date = Array(cases.keys)
                    date.sort()
                    date.removeFirst()
                    var caseNumber = Array(cases.values)
                    caseNumber.sort()
                    
                    var newCase = [Int]()
                    for i in 1..<caseNumber.count {
                        let result = caseNumber[i] - caseNumber[i-1]
                        newCase.append(result)
                    }
                    // 要將JSON HistoricalData轉成[Int]的NewCase
                    let newCaseNumber = NewCase(newCase: newCase)
                    // decode完，將執行protocol上面的method將資料轉化成圖表
                    DispatchQueue.main.async {
                        self.delegate?.turnGraph(newCaseNumber)
                    }
                } catch {
                    print("Fail to decode data")
                }
            }
        }.resume()
    }
}
