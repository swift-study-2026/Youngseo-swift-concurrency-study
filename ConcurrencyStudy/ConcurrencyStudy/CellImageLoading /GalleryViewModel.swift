//
//  GalleryViewModel.swift
//  ConcurrencyStudy
//
//  Created by youngseo on 6/9/26.
//

import Foundation

struct CatImage: Decodable {
    let url: String
}

final class GalleryViewModel {
    
    func fetchCatImages() async throws -> [CatImage] {
        let url = URL(
            string: "https://api.thecatapi.com/v1/images/search?limit=40"
        )!
        
        var request = URLRequest(url: url)
        request.setValue(
            APIKey.catAPI,
            forHTTPHeaderField: "x-api-key" // 이 값을 HTTP 헤더의 x-api-key라는 칸에 넣어달라는 뜻
        )
        
        let (data, _) = try await URLSession.shared.data(for: request)
        
        return try JSONDecoder().decode([CatImage].self, from: data)
    }
}
