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
    private let viewModel = GalleryViewModel()
    private var catImages: [CatImage] = []
    
    // MARK: - Lifecycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.setNavigationBarHidden(true, animated: false) // 상단 공백 제거 (없을 시, 투명 네비바 영역 존재)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUI()
        fetchCatImages()
    }
    
    // MARK: - Setup Methods
    
    private func setUI() {
        rootView.collectionView.dataSource = self
    }
    
    private func fetchCatImages() {
        Task {
            do {
                catImages = try await viewModel.fetchCatImages()
                rootView.collectionView.reloadData()
            } catch {
                print(error)
            }
        }
    }
}

// MARK: - Extensions

extension GalleryViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int)
    -> Int {
        catImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: GalleryCollectionViewCell.reuseIdentifier,
            for: indexPath
        ) as! GalleryCollectionViewCell
        
        let imageURLString = catImages[indexPath.item].url // 현재 셀이 보여줄 이미지 URL을 가져옴
        
        // 기존 코드는 아래와 같았음
        //
        // Task {
        //     guard let url = URL(string: imageURLString) else { return }
        //
        //     let (data, _) = try await URLSession.shared.data(from: url)
        //     let image = UIImage(data: data)
        //
        //     await MainActor.run {
        //         cell.configure(image: image)
        //     }
        // }
        //
        // 위 방식도 이미지를 정상적으로 표시할 수는 있지만,
        // Task를 별도로 저장하거나 관리하지 않기 때문에 한 번 시작되면 끝까지 실행된다.
        //
        // 따라서 사용자가 빠르게 스크롤하여 셀이 재사용되더라도,
        // 기존 다운로드 작업은 계속 진행된다.
        //
        // 예를 들어,
        // 1. 셀이 A 이미지를 다운로드 시작
        // 2. 스크롤로 인해 해당 셀이 B 데이터용 셀로 재사용
        // 3. A 다운로드가 늦게 완료됨
        // 4. 현재 B를 보여주고 있는 셀에 A 이미지가 표시됨
        //
        // 이처럼 셀 재사용으로 인해 이미지가 잘못 표시되는 문제가 발생할 수 있다.
        //
        // 따라서 이미지 다운로드 책임을 셀로 이동하고,
        // 셀 내부에서 Task를 저장한 뒤 prepareForReuse()에서 cancel() 하도록 변경한다.
        
        cell.loadImage(from: imageURLString)
        
        return cell
    }
}

//1. willDisplay는 이미지 로딩 로직이 cellForItemAt와 분리되어 코드 흐름을 따라가기 어렵고 관리가 복잡해질 수 있다.
//2. cellForItemAt → configure() 패턴은 셀 생성과 데이터 바인딩을 한 곳에서 처리할 수 있어 직관적이며, Kingfisher·Nuke 같은 실무 라이브러리들도 이 방식을 주로 사용한다.
//3. 앨렌 예제는 실무 패턴을 보여주기보다 Swift Concurrency와 셀 재사용 문제를 설명하기 위한 코드로, willDisplay와 Task.sleep(1초)을 사용해 이미지 꼬임 현상을 의도적으로 관찰할 수 있게 만들었다.
