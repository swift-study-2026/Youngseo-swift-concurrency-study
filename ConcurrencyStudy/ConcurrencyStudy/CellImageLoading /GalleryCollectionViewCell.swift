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
    
    /// 셀 내부에서 이미지 다운로드 Task를 저장해두기 위한 프로퍼티
    /// Task를 저장해둬야 셀이 재사용될 때 cancel() 할 수 있음
    private var imageTask: Task<Void, Never>?
    
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
    
    // 셀 재사용 막도록 셀이 재사용되기 전에 그 셀이 담고 있던 걸 취소함
    // 정확히는 셀 재사용 자체를 막는 게 아니라,
    // 재사용되기 전에 이전 이미지 다운로드 작업을 취소해서 이미지 꼬임을 방지하는 것
    override func prepareForReuse() {
        super.prepareForReuse()

        imageTask?.cancel()
        imageTask = nil

        imageView.image = nil
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Public Methods
    
    func configure(image: UIImage?) {
        imageView.image = image
    }
    
    func loadImage(from urlString: String) {
        // 혹시 기존에 진행 중이던 이미지 다운로드 Task가 있다면 먼저 취소
        imageTask?.cancel()
        
        // 새 이미지 다운로드 Task를 생성하고 셀 내부 프로퍼티에 저장
        // 이렇게 저장해둬야 prepareForReuse()에서 cancel() 할 수 있음
        imageTask = Task {
            guard let url = URL(string: urlString) else { return }
            
            do {
                let (data, _) = try await URLSession.shared.data(from: url)
                
                // cancel()이 호출되었더라도 Task 내부 코드가 바로 멈추지 않을 수 있으므로
                // 다운로드 이후 한 번 더 취소 여부를 확인
                if Task.isCancelled {
                    return
                }
                
                let image = UIImage(data: data)
                
                await MainActor.run {
                    self.configure(image: image)
                }
            } catch {
                print(error)
            }
        }
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
