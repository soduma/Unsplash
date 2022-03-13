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
    var searchText = ""
    var images: [Results] = []
    
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
        segment.insertSegment(with: UIImage(systemName: "photo"), at: 0, animated: true)
        segment.insertSegment(with: UIImage(systemName: "person.fill"), at: 1, animated: true)
        segment.tintColor = .systemGray
        segment.selectedSegmentIndex = 0
        segment.addTarget(self, action: #selector(tapSegment(sender:)), for: .valueChanged)
        return segment
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
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
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        return indicator
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
            searchBar.placeholder = "키워드 검색"
        case 1:
            searchBar.placeholder = "작가 검색"
        default:
            return
        }
    }
    
    @objc func tapBack() {
        searchBar.endEditing(true)
    }
    
    @objc func tapSearchButton() {
//        Task {
//            try await afRequest(searchText)
//        }
        fetchImage(searchText)
        
//        let photoViewController = PhotoViewController()
//        navigationController?.pushViewController(photoViewController, animated: true)
    }
}

extension MainViewController {
    func fetchImage(_ keyword: String) {
        guard let url = URL(string: "https://api.unsplash.com/search/photos?query=\(keyword)") else { return }

        let parameters: Parameters = [
            "Authorization" : "Client-ID oqnMOq60UFw7nPf-1c2UDXVw0woMt00hVPQqZbmVvO0"
        ]

        AF
            .request(url, method: .get)
            .responseDecodable(of: UnsplashAPI.self) { response in
                switch response.result {
                case .success(let result):
                    print(result)
                case .failure(let error):
                    print(url)
                    print("☺️\(error.localizedDescription)")
                }
            }
            .resume()
    }
    
//    func afRequest(_ keyword: String) async throws {
//        guard let url = URL(string: "https://api.unsplash.com/search/photos?query=\(keyword)") else { return }
//
//        let parameters: Parameters = [
//            "Authorization": "Client-ID oqnMOq60UFw7nPf-1c2UDXVw0woMt00hVPQqZbmVvO0"
//        ]
//        let dataTask = AF.request(url, method: .get, parameters: parameters).serializingDecodable(UnsplashAPI.self)
//        let value = try await dataTask.value.results
//        images = value
//    }
        
    func layout() {
        [logoLabel, segment, searchBar, searchButton, indicator]
            .forEach { view.addSubview($0) }
        
        logoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        segment.snp.makeConstraints {
            $0.top.equalTo(logoLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(100)
            $0.centerX.equalToSuperview()
        }
                
        searchBar.snp.makeConstraints {
            $0.top.equalTo(segment.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        searchButton.snp.makeConstraints {
            $0.top.equalTo(searchBar.snp.bottom).offset(50)
            $0.leading.trailing.equalTo(segment)
            $0.height.equalTo(40)
        }
        
        indicator.snp.makeConstraints {
            $0.centerY.equalTo(searchButton)
            $0.trailing.equalTo(searchButton).inset(20)
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        self.searchText = searchText
        
    }
}
