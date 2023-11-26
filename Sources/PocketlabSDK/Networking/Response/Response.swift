//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 09/11/2023.
//

import Foundation

struct Response<T: Decodable>: Decodable {
    var data: T
    var statusCode: Int
    var errors: [ErrorResponse]?
    
}


