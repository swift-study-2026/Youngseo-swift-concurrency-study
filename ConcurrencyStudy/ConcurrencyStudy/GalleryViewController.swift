//
//  GalleryViewController.swift
//  ConcurrencyStudy
//
//  Created by youngseo on 6/6/26.
//

import UIKit

final class GalleryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = GalleryView()
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.setNavigationBarHidden(true, animated: false) // 상단 공백 제거 !
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(APIKey.catAPI)

        setUI()
        setLayout()
    }
    
    // MARK: - Setup Methods
    
    private func setUI() {
        rootView.collectionView.dataSource = self
    }
    
    private func setLayout() {}
}

// MARK: - Extensions

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        20
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier,
            for: indexPath
        )
        
        cell.backgroundColor = .red
        
        return cell
    }
}
