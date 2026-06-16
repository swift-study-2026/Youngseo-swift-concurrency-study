//
//  ParallelGalleryCollectionViewCell.swift
//  ConcurrencyStudy
//
//  Created by youngseo on 6/16/26.
//

import UIKit

import SnapKit
import Then

final class ParallelGalleryCollectionViewCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ParallelGalleryCollectionViewCell"
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        // 셀이 직접 다운로드하지 않고 이미 완성된 이미지만 표시하므로
        // 취소할 imageTask는 없음
        imageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Public Methods
    
    func configure(image: UIImage?) {
        imageView.image = image
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
