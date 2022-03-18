//
//  MainViewController.swift
//  Unsplash
//
//  Created by 장기화 on 2022/02/25.
//

import UIKit
import SnapKit
import Alamofire

class MainViewController: UIViewController {
    var searchText = "korea"
    var images: [Results] = []
    var segmentIndex: ImageSize = .full
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Unsplash"
        label.font = .systemFont(ofSize: 100, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        return label
    }()
    
    private lazy var segment: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "RAW", at: 0, animated: true)
        segment.insertSegment(withTitle: "Full", at: 1, animated: true)
        segment.insertSegment(withTitle: "Small", at: 2, animated: true)
        segment.tintColor = .systemGray
        segment.selectedSegmentIndex = 1
        segment.addTarget(self, action: #selector(tapSegment(sender:)), for: .valueChanged)
        return segment
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.text = "korea"
        bar.placeholder = "키워드 검색"
        bar.searchBarStyle = .minimal
        bar.delegate = self
        return bar
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.tintColor = .white
        button.backgroundColor = .systemPink
        button.layer.cornerRadius = 12
        button.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        view.addGestureRecognizer(backGesture)
        layout()
    }
    
    @objc func tapSegment(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
        switch sender.selectedSegmentIndex {
        case 0:
            segmentIndex = .raw
        case 1:
            segmentIndex = .full
        default:
            segmentIndex = .small
        }
    }
    
    @objc func tapBack() {
        searchBar.endEditing(true)
    }
    
    @objc func tapSearchButton() {
        if searchText != "" {
            let photovc = PhotoViewController(images: images, text: searchText, segmentIndex: segmentIndex)
            navigationController?.pushViewController(photovc, animated: true)
        }
    }
}

extension MainViewController {
    
// MARK: - ordinary
//    func fetchImage(_ keyword: String) {
//        guard let url = URL(string: "https://api.unsplash.com/search/photos/?client_id=oqnMOq60UFw7nPf-1c2UDXVw0woMt00hVPQqZbmVvO0&query=\(keyword)") else { return }
//
//        AF
//            .request(url, method: .get)
//            .responseDecodable(of: UnsplashAPI.self) { response in
//                switch response.result {
//                case .success(let result):
//                    self.images = result.results
//                    print("😁 \(self.images)")
//                case .failure(let error):
//                    print("☺️\(error.localizedDescription)")
//                }
//            }
//            .resume()
//    }
        
    func layout() {
        [logoLabel, segment, searchBar, searchButton,]
            .forEach { view.addSubview($0) }
        
        logoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        segment.snp.makeConstraints {
            $0.top.equalTo(logoLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
        }
                
        searchBar.snp.makeConstraints {
            $0.top.equalTo(segment.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        searchButton.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(40)
            $0.leading.trailing.equalTo(segment)
            $0.height.equalTo(60)
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
//        fetchImage(searchText)
        self.searchText = searchText
    }
}
