//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 09/11/2023.
//

import Foundation

struct NetworkingResponse<T> {
    
    let data: Data?
    let object: T?
    let urlRequest: URLRequest
    let urlResponse: URLResponse?
//    let router: NetworkingRouter
    let statusCode: Int
    
    init( data: Data?, request: URLRequest, response: URLResponse, object: T?) {
//        self.router = router
        self.data = data
        self.object = object
        self.urlRequest = request
        self.urlResponse = response
        
        if let httpURLResponse = response as? HTTPURLResponse {
            statusCode = httpURLResponse.statusCode
        } else {
            statusCode = 0
        }
    }
    
}
