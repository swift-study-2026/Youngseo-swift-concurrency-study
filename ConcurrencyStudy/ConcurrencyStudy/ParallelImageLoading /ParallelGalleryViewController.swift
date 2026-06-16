//
//  ParallelGalleryViewController.swift
//  ConcurrencyStudy
//
//  Created by youngseo on 6/16/26.
//

import UIKit

final class ParallelGalleryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = GalleryView()
    private let viewModel = ParallelGalleryViewModel()
    private var catImages: [ParallelCatImage] = []
    
    // 병렬 다운로드 전체 작업을 저장
    // 화면이 사라지거나 ViewController가 해제될 때 취소할 수 있음
    private var fetchTask: Task<Void, Never>?
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        fetchCatImages()
    }
    
    deinit {
        fetchTask?.cancel()
    }
    
    // MARK: - Setup Methods
    
    private func setUI() {
        rootView.collectionView.dataSource = self
    }
    
    private func fetchCatImages() {
        fetchTask?.cancel()
        
        fetchTask = Task {
            do {
                // 1. 고양이 이미지 URL 20개 받아오기
                let catImages = try await viewModel.fetchCatImages()
                
                if Task.isCancelled {
                    return
                }
                
                // 2. 받아온 URL 20개를 병렬로 이미지 다운로드
                let downloadedCatImages = await viewModel.fetchImagesInParallel(catImages)
                
                if Task.isCancelled {
                    return
                }
                
                // 3. 병렬 다운로드가 끝난 뒤 화면 갱신
                await MainActor.run {
                    self.catImages = downloadedCatImages
                    self.rootView.collectionView.reloadData()
                }
                
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - UICollectionViewDataSource

extension ParallelGalleryViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        catImages.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: ParallelGalleryCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! ParallelGalleryCollectionViewCell
        
        let catImage = catImages[indexPath.item]
        
        // 이미 fetchImagesInParallel에서 다운로드가 끝난 이미지를 표시만 함
        // 셀이 직접 다운로드하지 않으므로 셀 내부 imageTask cancel은 필요 없음
        cell.configure(image: catImage.image)
        
        return cell
    }
}
