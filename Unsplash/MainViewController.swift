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
        let items = ["사진검색", "사용자검색"]
        let segment = UISegmentedControl(items: items)
        segment.selectedSegmentIndex = 0
        return segment
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.placeholder = "키워드 입력"
        bar.searchBarStyle = .minimal
        return bar
    }()
    
    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        stackView.addArrangedSubview(logoLabel)
//        stackView.addArrangedSubview(segment)
//        [logoLabel, segment]
//            .forEach { stackView.addArrangedSubview($0) }
//        layout()
        
        [logoLabel, segment, searchBar]
            .forEach { view.addSubview($0) }
        
        logoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview()
        }
        
        segment.snp.makeConstraints {
            $0.top.equalTo(logoLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(30)
            $0.centerX.equalToSuperview()
        }
        
        segment.addTarget(self, action: #selector(tapSegment(sender:)), for: .valueChanged)
        
        searchBar.snp.makeConstraints {
            $0.top.equalTo(segment.snp.bottom).offset(5)
            $0.leading.trailing.equalTo(segment).inset(-8)
        }
    }
    
    @objc func tapSegment(sender: UISegmentedControl) {
        print(sender.selectedSegmentIndex)
    }
    
    func layout() {
//        title = "Unsplash"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.searchController = searchViewController
//        searchViewController.automaticallyShowsCancelButton = true
    }
    
//    func segment() {
//        let items = ["사진검색", "사용자검색"]
//        let segment = UISegmentedControl(items: items)
//        segment.selectedSegmentTintColor = .red
//        segment.selectedSegmentIndex = 0
//    }
}
