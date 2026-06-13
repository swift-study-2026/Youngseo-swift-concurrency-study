//
//  GalleryCollectionViewCell.swift
//  ConcurrencyStudy
//
//  Created by youngseo on 6/9/26.
//

import UIKit

import SnapKit
import Then

final class GalleryCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "GalleryCollectionViewCell"
    
    // MARK: - UI Components
    
    private let imageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.clipsToBounds = true
    }
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setUI()
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Methods
    
    private func setUI() {
        contentView.addSubview(imageView)
    }
    
    private func setLayout() {
        imageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
