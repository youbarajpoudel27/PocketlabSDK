//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 09/11/2023.
//

import Foundation

struct IdentificationResponse: Codable {
    let id: String?
    let remoteId: String?
    let creatorId: String?
    let ownerOrgId: Int
    let description: String?
    let createdAt: String?
    let updatedAt: String?
    let taintedAt: String?
    let originScenarioInstanceId: Int
    let originPastActionId: String?
    let userFacingDeletion: Bool
    let userFacingNonValidated: Bool
    let userHiddenSuspiciousData: Bool

}
