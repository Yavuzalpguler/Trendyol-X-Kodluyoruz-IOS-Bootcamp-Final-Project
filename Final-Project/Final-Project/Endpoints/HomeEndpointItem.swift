//
//  HomeEndPointItem.swift
//  Final-Project
//
//  Created by Yavuz Alp GÜLER on 27.05.2021.
//

import Foundation
import CoreApi

enum HomeEndpointItem: Endpoint {
    case homepage(query: String)
    case suggestions(keyword: String)
    case pagination(query: String)
    case detail(query: String)
    
    // Burayi boyle igrenc bir seye donusturdum ne yazik ki :( bunlar hep zamanin az kalmasindan...
    
    var baseUrl: String { "" }
    var path: String {
        switch self {
        case .homepage(let query): return "https://api.rawg.io/api/games?key=9f5b0b0169974db4a393ea67487e36df\(query)"
        case .suggestions(let keyword):
            return  "https://api.rawg.io/api/games?key=9f5b0b0169974db4a393ea67487e36df&search=\(keyword)"
        case .pagination(let query): return "\(query)"
        case .detail(let query): return "https://api.rawg.io/api/games/\(query)?key=9f5b0b0169974db4a393ea67487e36df"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .homepage: return .get
        case .suggestions: return .get
        case .pagination: return .get
        case .detail: return .get
        }
    }
    
    
}
    
