//
//  ParallelGalleryViewModel.swift
//  ConcurrencyStudy
//
//  Created by youngseo on 6/16/26.
//

import UIKit

final class ParallelGalleryViewModel {
    
    func fetchCatImages() async throws -> [ParallelCatImage] {
        let url = URL(string: "https://api.thecatapi.com/v1/images/search?limit=20")!
        
        let (data, _) = try await URLSession.shared.data(from: url)
        
        return try JSONDecoder().decode([ParallelCatImage].self, from: data)
    }
    
    func fetchImagesInParallel(_ catImages: [ParallelCatImage]) async -> [ParallelCatImage] {
        await withTaskGroup(of: (Int, ParallelCatImage).self) { group in
            
            // 이미지 URL 20개를 하나씩 group에 추가
            // addTask가 호출될 때마다 새로운 비동기 작업이 만들어짐
            for (index, catImage) in catImages.enumerated() {
                group.addTask {
                    var newCatImage = catImage
                    
                    guard let url = URL(string: catImage.url) else {
                        return (index, newCatImage)
                    }
                    
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        
                        // 이미지 다운로드가 끝나면 UIImage로 변환해서 모델에 저장
                        newCatImage.image = UIImage(data: data)
                        
                    } catch {
                        print(error)
                    }
                    
                    return (index, newCatImage)
                }
            }
            
            // TaskGroup은 먼저 끝난 작업부터 결과가 들어오기 때문에
            // 원래 배열 순서를 보장하려면 index 기준으로 다시 넣어줘야 함
            var result = catImages
            
            for await (index, catImage) in group {
                result[index] = catImage
            }
            
            return result
        }
    }
}
