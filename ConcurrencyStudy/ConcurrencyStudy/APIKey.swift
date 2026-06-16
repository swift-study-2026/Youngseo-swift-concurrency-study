//
//  APIKey.swift
//  ConcurrencyStudy
//
//  Created by youngseo on 6/14/26.
//

import Foundation

enum APIKey {
    
    static let catAPI: String = {
        Bundle.main.object(
            forInfoDictionaryKey: "CAT_API_KEY"
        ) as? String ?? ""
    }()
}
