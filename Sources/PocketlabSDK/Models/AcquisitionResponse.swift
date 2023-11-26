//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 09/11/2023.
//

import Foundation

struct AcquisitionResponse : Codable {
    let acquisitionId: String
    
    enum CodingKeys: String, CodingKey {
         case acquisitionId = "id"
    }
}
