//
//  APIProtocol.swift
//  PARAGO
//
//  Created by leedonggi on 2020/06/12.
//  Copyright © 2020 DaeduckSoftwareMeisterHighSchool. All rights reserved.
//

import Foundation

protocol API {
    
    func getPath() -> String
    
}

public enum MainAPI: API {
    case signIn
    case signUp
    case getSearchResult
    
    func getPath() -> String {
        switch self {
        case .signIn:
            return "account_api/login/"
        case .signUp:
            return "account_api/account/"
        case .getSearchResult:
            return "search_api/search/"
        }
    }
}
