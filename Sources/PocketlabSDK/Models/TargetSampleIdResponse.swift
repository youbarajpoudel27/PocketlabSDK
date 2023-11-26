//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 09/11/2023.
//

import Foundation


struct TargetSampleIdResponse: Codable {
    let id: String
    let originScenarioInstanceId: Int
    
}

struct Metadata: Codable {
    let osName: String?
    let osVersion: String?
    let appVersion: String?
    let manufacturer: String?
}
