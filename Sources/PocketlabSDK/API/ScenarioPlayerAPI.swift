//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 09/11/2023.
//

import Foundation


protocol ScenarioPlayerAPI {

    func createPastAction(id: Int, success: @escaping (PastActionResponse) -> (), failure: @escaping (Error) -> ())
    func createSample(Id: Int, pId: String, success: @escaping (SampleResponse) -> (), failure: @escaping (Error) -> ())
    func setTargetSampleId(sId: String, pId: String, success: @escaping (TargetSampleIdResponse) -> (), failure: @escaping (Error) -> ())
    func createAcquisition(Id: Int, pId: String, sId: String, success: @escaping (AcquisitionResponse) -> (), failure: @escaping (Error) -> ())

 }


extension ScenarioPlayerAPI {

    func createPastAction(id: Int, success: @escaping (PastActionResponse) -> (), failure: @escaping (Error) -> ()){
        let metadata = [
            "appVersion": "",
            "osName": "",
            "osVersion": "",
            "manufacturer": "",
        ]
        let requestBody = [
            "originScenarioInstanceId": id,
            "metadata": metadata
        ] as [String : Any]

        let urlSession = URLSession.shared
        let request = EndPoint.pastaction.request(body: requestBody)
        urlSession.dataTask(request: request, success:success, failure: failure)
    }


    func createSample(Id: Int, pId: String, success: @escaping (SampleResponse) -> (), failure: @escaping (Error) -> ()){

        let requestBody = [
            "originScenarioInstanceId": Id,
            "originPastActionId": pId
        ] as [String : Any]

        let urlSession = URLSession.shared
        let request = EndPoint.sample.request(body: requestBody)
        urlSession.dataTask(request: request, success:success, failure: failure)


    }

    func setTargetSampleId(sId: String, pId: String, success: @escaping (TargetSampleIdResponse) -> (), failure: @escaping (Error) -> ()){

        let requestBody = [
            "targetSampleId": sId,
         ] as [String : Any]

        let urlSession = URLSession.shared
        let request = EndPoint.targetsample(pastActionId: pId).request(body: requestBody)
         urlSession.dataTask(request: request, success:success, failure: failure)


    }

    func createAcquisition(Id: Int, pId: String, sId: String, success: @escaping (AcquisitionResponse) -> (), failure: @escaping (Error) -> ()){

        let requestBody = [
            "originScenarioInstanceId": Id,
            "originPastActionId": pId,
            "sampleId": sId
        ] as [String : Any]

        let urlSession = URLSession.shared
        let request = EndPoint.acquisition.request(body: requestBody)
        urlSession.dataTask(request: request, success:success, failure: failure)
    }

}
