//
//  HistoricalData.swift
//  CanadianCovid19
//
//  Created by Tai Chin Huang on 2021/9/26.
//

import Foundation

struct HistoricalData: Codable {
    let country: String
    let timeline: TimeLine
}

struct TimeLine: Codable {
    let cases: [String: Int]
    let deaths: [String: Int]
}

struct NewCase {
    let newCase: [Int]
}
