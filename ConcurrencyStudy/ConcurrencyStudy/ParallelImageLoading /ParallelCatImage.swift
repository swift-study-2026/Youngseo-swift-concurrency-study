//
//  ParallelCatImage.swift
//  ConcurrencyStudy
//
//  Created by youngseo on 6/16/26.
//

import UIKit

struct ParallelCatImage: Decodable {
    let url: String
    var image: UIImage?
    
    enum CodingKeys: String, CodingKey {
        case url
    }
}
