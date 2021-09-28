//
//  Covid19Data.swift
//  CanadianCovid19
//
//  Created by Tai Chin Huang on 2021/9/26.
//

import Foundation

struct Covid19Data: Codable {
    let country: String
    let countryInfo: CountryInfo
    let cases: Int
    let todayCases: Int
    let deaths: Int
    let todayDeaths: Int
}

struct CountryInfo: Codable {
    let flag: String?
}
