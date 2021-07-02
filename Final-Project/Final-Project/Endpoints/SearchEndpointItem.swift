//
//  SearchEndpointItem.swift
//  Final-Project
//
//  Created by Yavuz Alp GÜLER on 5.06.2021.
//

import CoreApi

enum SearchEndpointItem: Endpoint {
    case suggestions(keyword: String)
    
    var baseUrl: String {"https://api.rawg.io/api/games?"}
    
    var path: String {
        switch self {
        case .suggestions(let keyword):
            return  "key=9f5b0b0169974db4a393ea67487e36df&query=\(keyword)"
        default:
            break
       }
        
    }
    
    var method: HTTPMethod { .get }

}
