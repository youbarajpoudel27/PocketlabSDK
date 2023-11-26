//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 09/11/2023.
//

import Foundation

struct SampleResponse: Codable {
    let sampleId: String
     
    enum CodingKeys: String, CodingKey {
         case sampleId = "id"
    }
}
