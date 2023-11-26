//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 09/11/2023.
//

import Foundation

public struct PackageToken: Codable {
    public var token: String? // came in login
    public var access: String? // came in refresh token
    public var latestRefreshedDate: Date?
}
