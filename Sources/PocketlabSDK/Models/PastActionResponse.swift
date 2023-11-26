//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 09/11/2023.
//

import Foundation

struct PastActionResponse: Codable {
    let originPastActionId: String?
    
    enum CodingKeys: String, CodingKey {
         case originPastActionId = "id"
    }
    
}
