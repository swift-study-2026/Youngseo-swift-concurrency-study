//
//  GalleryView.swift
//  ConcurrencyStudy
//
//  Created by youngseo on 6/9/26.
//

import UIKit

import SnapKit
import Then

final class GalleryView: UIView {
    
    // MARK: - UI Components
    
    private(set) var collectionView = UICollectionView(frame: .zero,collectionViewLayout: UICollectionViewFlowLayout()
        .then {
                $0.itemSize = CGSize(width: 120, height: 120)
            }
        ).then {
            $0.backgroundColor = .clear

            $0.register(
                GalleryCollectionViewCell.self,
                forCellWithReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier
            )
        }
        
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setUI() {
        addSubview(collectionView)
    }
    
    private func setLayout() {
        collectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
