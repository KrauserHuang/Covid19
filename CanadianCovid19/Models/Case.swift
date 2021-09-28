//
//  Case.swift
//  CanadianCovid19
//
//  Created by Tai Chin Huang on 2021/8/24.
//

import Foundation

struct Cases: Codable {
    var data: [CaseResponse]
    var last_updated: String?
}

struct CaseResponse: Codable {
    var change_cases: String?
    var change_fatalities: String?
    var change_recoveries: String?
    
    var total_cases: String?
    var total_fatalities: String?
    var total_recoveries: String?
}
