//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 09/11/2023.
//

import Foundation

protocol IdentificationAPI {
    func setSampleRemoteId(rId: String, sId: String, success: @escaping(IdentificationResponse) ->(), failure: @escaping(Error)->())
}

extension IdentificationAPI {

    func setSampleRemoteId(rId: String, sId: String, success: @escaping(IdentificationResponse) ->(), failure: @escaping(Error)->()) {

        let requestBody = [
             "remoteId": rId
        ] as [String : Any]

        let urlSession = URLSession.shared
        let request = EndPoint.identification(sampleId: sId).request(body: requestBody)
        urlSession.dataTask(request: request, success:success, failure: failure)

    }

}
