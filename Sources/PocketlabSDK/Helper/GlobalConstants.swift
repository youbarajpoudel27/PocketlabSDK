//
//  File.swift
//  
//
//  Created by Youbaraj POUDEL on 09/11/2023.
//

import Foundation
import UIKit
import CoreLocation

struct GlobalConstants {
     static var baseUrl = "https://api.staging.inarix.com"
    
    struct Image {
        static let placeholder: UIImage = UIImage(named: "logo") ?? UIImage()
    }
    
    struct KeyValues {
    
        static var token: PackageToken? {
            get {
                return decode(key: "token")
            }
            set {
                encodeAndSave(key: "token", value: newValue)
            }
        }
        
        
        static func apiCache<T: Codable>(key: String) -> T? {
            let cache = UserDefaults.standard.dictionary(forKey: "URLCache") as? [String: Data]
            guard let data = cache?[key] else {return nil}
            do {
                return try JSONDecoder().decode(T.self, from: data)
            }catch {
                debugPrint(error)
                return nil
            }
        }
        
        static func apiCache<T: Codable>(key: String, data: T) {
            var cache = (UserDefaults.standard.dictionary(forKey: "URLCache") as? [String: Data]) ?? [:]
            cache[key] = try? JSONEncoder().encode(data)
            UserDefaults.standard.set(cache, forKey: "URLCache")
        }
        
        static private func encodeAndSave<T: Encodable>(key: String, value: T) {
            if let encoded = try? JSONEncoder().encode(value) {
                UserDefaults.standard.set(encoded, forKey: key)
            }
        }
        
        
        static private func decode<T: Decodable>(key: String) -> T? {
            if let data = UserDefaults.standard.object(forKey: key) as? Data {
                return try? JSONDecoder().decode(T.self, from: data)
            }
            return nil
        }
    }
    
    struct Error {
        static var oops: NSError { NSError(domain: "API_ERROR", code: 500, userInfo: [NSLocalizedDescriptionKey: "Something went wrong"])}

        
        static var emptyData: NSError { NSError(domain: "Data Empty", code: 205, userInfo: [NSLocalizedDescriptionKey: "Data is Empty."])}
        
        static var successful: NSError { NSError(domain: "Sucessful", code: 200, userInfo: [NSLocalizedDescriptionKey: "Sucessful"])}
        static var tokenExpired: NSError { NSError(domain: "Unauthorized user", code: 500, userInfo: [NSLocalizedDescriptionKey: "Your session has expired"])}
    }
    
    struct Strings {
        static var checkinSuccess: String = ""
        static var bookSuccess: String = ""
        static var supportMessageSuccess: String = ""
    }
    
    struct version {
        static var appStoreVersion = ""
        static var apiAppVersion = 0.0
        static var majorUpdate = false
        static var minorUpdate = false
    }
}

func appName() -> String {
    let appName = Bundle.main.displayName ?? ""
    return "iOS\(appName.removeWhiteSpace)"
}

func displayName() -> String {
    return Bundle.main.displayName ?? ""
}

struct UserLocation: Codable {
    var lat: Double?
    var Long: Double?
    var annotation : String?
}

struct CurrentHeaderBodyParameter {
    static var request: URLRequest?
    static var body: [String: Any]?
}



class SharedData {
    static var shared = SharedData()
     init() { }
     var token : PackageToken?
    var error : ErrorResponse?
    
}

public enum AnnotationType {
    case remoteId,variety,proteinRate,
         customRemoteId(id: String),
         customVariety(name: String),
         customProteinRate(percent: Double)
 }
