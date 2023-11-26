//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 09/11/2023.
//

import Foundation


struct APIRequest {
    let request: URLRequest
    let endPoint: EndPoint
    
    func cache<T: Codable>(data: T) {
        if endPoint.shouldCache {
            GlobalConstants.KeyValues.apiCache(key: getKey(url: request.url!), data: data)
        }
    }
    
    func cached<T: Codable>() -> T? {
        if endPoint.shouldCache {
            return GlobalConstants.KeyValues.apiCache(key: getKey(url: request.url!))
        }
        return nil
    }
    
    init(request: URLRequest, endPoint: EndPoint) {
        self.request = request
        self.endPoint = endPoint
    }
    
    private func getKey(url: URL) -> String {
        switch endPoint {
        default:
            return url.absoluteString
        }
        let key = "\(url.scheme!)://\(url.host!)"
        if url.pathComponents.isEmpty {
            return key
        } else {
            return key + "/" + url.pathComponents.dropFirst().joined(separator: "/")
        }
    }
    
}

public enum EndPoint {
    case refresh
    case pastaction
    case sample
    case targetsample(pastActionId: String)
    case identification(sampleId: String)
    case acquisition

    private var path: String {
        switch self {
        case .refresh: return "users/refresh-token"
        case .pastaction: return "samples/past-action"
        case .sample: return "samples/sample"
        case .targetsample(let pastActionId): return "samples/past-action/\(pastActionId)"
        case .identification(let sampleId): return "samples/\(sampleId)"
        case .acquisition: return "samples/acquisition"
 
        }
    }

    private var method: String {
        switch self {
        case .refresh: return "PUT"
        case .pastaction: return "POST"
        case .sample: return "POST"
        case .targetsample: return "PATCH"
        case .identification: return "PATCH"
        case .acquisition: return "POST"
        default: return "GET"
        }
    }

    fileprivate var shouldCache: Bool {
        switch self {
        default:  return false
        }
    }

     var needsAuthorization: Bool {
        switch self {
        case .refresh: return true
        case .pastaction: return true
        case .sample: return true
        case .targetsample: return true
        case .identification: return true
        case .acquisition: return true
         default: return false
        }
    }

    func request(urlString: String, body: [String: Any]? = nil) -> APIRequest {
        let url = URL(string: urlString.replacingOccurrences(of: " ", with: "%20"))!
        debugPrint(url)
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        if method == "POST" || method == "DELETE" || method == "PUT" || method == "PUT" {
           
            if let body = body {
                request.httpBody = try? JSONSerialization.data(withJSONObject: body, options: .prettyPrinted)
            }
        }
        
        if  needsAuthorization {
            if let token = GlobalConstants.KeyValues.token {
                print(token.token)
                request.addValue("Bearer \(token.token ?? "")", forHTTPHeaderField: "Authorization")
                request.addValue("b3be628f-c009-4827-b349-cf99e0021e0d", forHTTPHeaderField: "x-inarix-device-id")
            }
        }
        
        CurrentHeaderBodyParameter.body    = body
        CurrentHeaderBodyParameter.request = request
        return APIRequest(request: request, endPoint: self)
    }

    func request(body: [String: Any]? = nil) -> APIRequest {
        var urlString = GlobalConstants.baseUrl + "/" + path
        return request(urlString: urlString, body: body)
    }
 

}
