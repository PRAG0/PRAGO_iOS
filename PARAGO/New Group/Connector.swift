//
//  Connector.swift
//  PARAGO
//
//  Created by leedonggi on 2020/06/12.
//  Copyright © 2020 DaeduckSoftwareMeisterHighSchool. All rights reserved.
//

//
//  Connector.swift
//  DMS_SwiftUI
//
//  Created by leedonggi on 2020/03/10.
//  Copyright © 2020 leedonggi. All rights reserved.
//

import Foundation
import RxSwift
import RxAlamofire
import Alamofire

public class Connector {
    
    public static let instance = Connector()
       
    private let basePath = "http://10.156.145.205:8080/"
    private init(){ }
    
    func getRequest(_ subPath: API, method: RequestMethod, params: [String : Any]? = nil) -> URLRequest{
        var urlStr = basePath + subPath.getPath()
        
        if method == .get{
            var query = params?.map{ "\($0)=\($1)" }.reduce(""){ f, s -> String in "\(f)&\(s)" } ?? ""
            var encodedString = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
            if !query.isEmpty{ encodedString.removeFirst(); urlStr += ("?" + encodedString) }
        }
        print(urlStr)
        var request = URLRequest(url: URL(string: urlStr)!)
        request.httpMethod = method.rawValue
        
        if method != .get, params != nil{
            let jsonData = try? JSONSerialization.data(withJSONObject: params!)
            request.httpBody = jsonData
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        return request
    }
}

public extension URLRequest{
    
    func decodeData<T>(_ type: T.Type) -> Observable<(Int, String, [String: Any])> where T: Decodable{
        return requestData(self)
            .single()
            .map{ ($0.0.statusCode, $0.1) }
            .map{ (code, data) in
                let str = String(decoding: data, as: UTF8.self)
                var jsonSerialization = [String: Any]()
                if str == "" {
                    jsonSerialization = ["": ""]
                } else {
                    jsonSerialization = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                }
                
                return (code, str, jsonSerialization)
            }
            .filter{ (code, _, _) in
                if code == 500{ print("오류") }
                return code != 500
            }
    }
    
}

public enum RequestMethod: String{
    
    case get = "GET"
    case post = "POST"
    case delete = "DELETE"
    
}
