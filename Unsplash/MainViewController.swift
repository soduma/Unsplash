//
//  MainViewController.swift
//  Unsplash
//
//  Created by 장기화 on 2022/02/25.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
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
        return button
    }()
    
    private lazy var indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()
        indicator.startAnimating()
        return indicator
    }()
    
//    private let stackView: UIStackView = {
//        let stackView = UIStackView()
//        stackView.axis = .vertical
//        stackView.alignment = .center
//        stackView.distribution = .fillEqually
//        return stackView
//    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        view.addGestureRecognizer(backGesture)

//        stackView.addArrangedSubview(logoLabel)
//        stackView.addArrangedSubview(segment)
//        [logoLabel, segment]
//            .forEach { stackView.addArrangedSubview($0) }
//        layout()
        
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
        view.endEditing(true)
    }
    
    func layout() {
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
    }
}
