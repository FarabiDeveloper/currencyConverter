//
//  Api.swift
//  Currency Converter
//
//  Created by User on 25.06.2018.
//  Copyright © 2018 FarabiCorporation. All rights reserved.
//


import Foundation
import Moya
import Result
import SwiftyJSON

enum Api {
    case latest()
}

extension Api: TargetType {
 
    var accessKey : String {
        return "b129b6df7570d70ece9e6a238601f73a"
    }
    
    var baseURL: URL {
        return URL(string: "http://data.fixer.io/api/")!
    }
    var path: String {
        switch self {
        case .latest():
            return "latest"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .latest():
            return .get
        }
    }
    
    var parameters: [String: Any]? {
        return ["access_key" : accessKey]
    }
    
    var task: Task {
        switch self {
        case .latest(let info):
            return .requestParameters(parameters: self.parameters!, encoding: URLEncoding.default)
        }
    }
    
    var sampleData: Data {
        return Data()
    }
    
    var headers: [String : String]? {
        return ["Content-Typer" : "application/json"]
    }
    
    var parameterEncoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
