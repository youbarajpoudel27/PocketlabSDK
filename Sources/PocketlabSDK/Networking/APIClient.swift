//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 09/11/2023.
//

import Foundation

private var apiQueue: [APICall] = []
fileprivate var timerRunCount = 0
var timer: Timer?

extension URLSession {
    
    struct File {
        let name: String
        let fileName: String
        let data: Data
        let contentType: String
    }
    
    @discardableResult
       func dataTask<T:Codable>(request: APIRequest, success: @escaping (T) -> (), failure: @escaping (Error) -> ()) -> APICall {
           let apiCall = APICall(task: { error in
               if let error = error {
                   failure(error)
                   return nil
               }else {
                   let task = self.dataTask(with: request.request) { [weak self] (data, response, error) in
                       self?.handle(request: request, data: data, response: response, error: error, success: { (successData: T) in
                           request.cache(data: successData)
                           success(successData)
                       }, failure: { error in
                           if (error as NSError).code == -1009,
                              let cached: SingleContainer<T> = request.cached() {
                               return success(cached.data!)
                           }
                           failure(error)
                       })
                   }
                   task.resume()
                   return task
               }
           })
           
           let currentDate = Date()
           let calendar = Calendar.current
           let fiveMinutes: TimeInterval = 30
           let userAccessTokenExpiryDate = currentDate.addingTimeInterval(fiveMinutes)
         
           
           if request.endPoint.needsAuthorization {
               if GlobalConstants.KeyValues.token?.token == nil {
                   apiCall.execute(explicitError: GlobalConstants.Error.oops)
               }
               if timerRunCount == 0 {
                   timer = Timer.scheduledTimer(timeInterval: 25 * 60, target: self, selector: #selector(tokenRefresh), userInfo: nil, repeats: true)
                   timerRunCount += 1
                   NotificationCenter.default.addObserver(self, selector: #selector(timerUpdate(_:)), name: .timer, object: nil)
               }
               //                        if userAccessTokenExpiryDate < Date() {
               //                            apiQueue.append(apiCall)
               //                            RefreshImplemenation().refreshToken(token: GlobalConstants.KeyValues.token?.token ?? "",success: { newToken in
               //                                GlobalConstants.KeyValues.token?.token = newToken.access
               //                                GlobalConstants.KeyValues.token?.access = newToken.access
               //
               //                            }, failure: failureRefreshingToken)
               //                            return apiCall
               //                        }
               
           }
        
           apiCall.execute()
           return apiCall
       }
    
    class RefreshImplemenation: PackageRefreshTokenAPI {
    }
    
    @objc func timerUpdate(_ notification: Notification) {
            //        if let notification = notification.object as? Bool {
            timer?.invalidate()
        }
       
       @objc func tokenRefresh() {
           RefreshImplemenation().refreshToken(token: GlobalConstants.KeyValues.token?.token ?? "",success: { newToken in
               print("refresh finished...\(String(describing: newToken.token))")
               
               GlobalConstants.KeyValues.token?.token = newToken.access
               GlobalConstants.KeyValues.token?.access = newToken.access
               GlobalConstants.KeyValues.token?.latestRefreshedDate = Date()
           }, failure: failureRefreshingToken)
       }
    

    @discardableResult
    func upload<T: Codable>(request: APIRequest, params: [String: String], files: [File], success: @escaping (T) -> (), failure: @escaping (Error) -> ()) -> URLSessionUploadTask {
        let boundary = UUID().uuidString
        var urlRequest = request.request
        urlRequest.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        let data = createBodyWithParameters(parameters: params, files: files, boundary: boundary)
        
        let task = uploadTask(with: urlRequest, from: data) { [weak self] (data, response, error) in
            self?.handle(request: request, data: data, response: response, error: error, success: { (successData: T) in
                success(successData)
            }, failure: failure)
        }
        task.resume()
        return task
    }
    
    private func createBodyWithParameters(parameters: [String: String], files: [File], boundary: String) -> Data {
        var body = Data()
        for (key, value) in parameters {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
            body.append("\(value)\r\n".data(using: .utf8)!)
        }
        for file in files {
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            body.append("Content-Disposition: form-data; name=\"\(file.name)\"; filename=\"\(file.fileName)\"\r\n".data(using: .utf8)!)
            body.append("Content-Type: \(file.contentType)\r\n\r\n".data(using: .utf8)!)
            body.append(file.data)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
    
    private func handle<T: Codable>(request: APIRequest, data: Data?, response: URLResponse?, error: Error?, success: @escaping (T)->(), failure: @escaping (Error) -> ()) {
            func send(error: Error) {
                DispatchQueue.main.async {
                    failure(error)
                }
            }
            
            func send(object: T) {
                DispatchQueue.main.async {
                    success(object)
                }
            }
            
            if (error as NSError?)?.code == -999 { return }
            if let error = error {
                debugPrint(error)
                return send(error: error)
                
            }
            
            print("URL: \n\(request.request.url?.absoluteString ?? "")\n Header:\n")
            
            request.request.allHTTPHeaderFields?.forEach { key, value in
                print("\(key): \(value)")
            }
//            print("Body: \n\(String(data: request.request.httpBody ?? Data(), encoding: .utf8) ?? "")\n Response: \n\(data?.jsonString ?? "")")
            var status: Int?
            if let data = data {
                do {
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    let dict = json as? Dictionary<String, Any>
                    status = dict?["code"] as? Int ?? 200
                    
                    let decoder = JSONDecoder()
                    
                    switch status ?? 200 {
                    case 200...300:
                        let container = try decoder.decode(T.self, from: data)
                        return send(object: container)
                    case 401:
                        let container = try decoder.decode(ErrorResponse.self, from: data)
                        DispatchQueue.main.async {
                            NotificationCenter.default.post(name: .logout, object: true)
                               }
                        return send(error: errorMessage(errorResponse: container))
                        break
                    case 300...500 :
                        let container = try decoder.decode(ErrorResponse.self, from: data)
                        return send(error: errorMessage(errorResponse: container))
                        
                    default:
                        let container = try decoder.decode(T.self, from: data)
                        return send(object: container)
                    }
                } catch let parsingError {
                    debugPrint(parsingError)
                    send(error: parsingError)
                }
            }
            
            return send(error: GlobalConstants.Error.oops)
        }
        
        func successRefreshingToken() {
            apiQueue.forEach {
                $0.execute()
            }
        }
        
        func failureRefreshingToken(error: Error) {
            apiQueue.forEach({
                $0.execute(explicitError: error)
            })
            
        }
        
        func errorMessage(errorResponse: ErrorResponse) -> Error{
            return  NSError(domain: errorResponse.message ?? "Something went wrong!", code: errorResponse.code ?? 500, userInfo: [NSLocalizedDescriptionKey: errorResponse.message ?? "Something went wrong!"])
        }
}

class APICall: Equatable {
    private let id = UUID()
    private var task: ((Error?) -> URLSessionDataTask?)?
    private var actualDataTask: URLSessionDataTask?
    
    init(task: @escaping (Error?) -> URLSessionDataTask?) {
        self.task = task
    }
    
    init() {
        self.task = nil
    }
    
    func cancel() {
        actualDataTask?.cancel()
        apiQueue.removeAll(where: {$0 == self})
    }
    
    func execute(explicitError error: Error? = nil) {
        actualDataTask = task?(error)
        apiQueue.removeAll(where: {$0 == self})
    }
    
    static func ==(lhs: APICall, rhs: APICall) -> Bool {
        return lhs.id == rhs.id
    }
}
