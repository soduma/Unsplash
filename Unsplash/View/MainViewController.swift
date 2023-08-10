//
//  MainViewController.swift
//  Unsplash
//
//  Created by 장기화 on 2022/02/25.
//

import UIKit
import SnapKit

class MainViewController: UIViewController {
    private var photoSize: PhotoSize = .regular
    private var keyword = ""
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Unsplash"
        label.font = .systemFont(ofSize: 100, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .label
        return label
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "RAW", at: 0, animated: true)
        segment.insertSegment(withTitle: "Regular", at: 1, animated: true)
        segment.insertSegment(withTitle: "Small", at: 2, animated: true)
        segment.tintColor = .systemGray
        segment.selectedSegmentIndex = 1
        segment.addTarget(self, action: #selector(tapSegment(sender:)), for: .valueChanged)
        return segment
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.text = keyword
        bar.placeholder = "키워드"
        bar.searchBarStyle = .minimal
        bar.delegate = self
        return bar
    }()
    
    private lazy var searchButton: UIButton = {
        let button = UIButton()
        button.setTitle("검색", for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.setTitleColor(.systemGray, for: .disabled)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        button.backgroundColor = .systemYellow
        if #available(iOS 15.0, *) {
            button.contentVerticalAlignment = .top
            button.contentEdgeInsets.top = 18
        } else {
            button.layer.cornerRadius = 12
        }
        button.isEnabled = false
        button.addTarget(self, action: #selector(tapSearchButton), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        searchBar.becomeFirstResponder()
    }
    
    func setLayout() {
        [logoLabel, segmentedControl, searchBar, searchButton]
            .forEach { view.addSubview($0) }
        
        logoLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.leading.trailing.equalToSuperview().inset(40)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.top.equalTo(logoLabel.snp.bottom).offset(50)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.centerX.equalToSuperview()
        }
                
        searchBar.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(5)
            $0.leading.trailing.equalToSuperview().inset(20)
        }
        
        searchButton.snp.makeConstraints {
            if #available(iOS 15.0, *) {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.keyboardLayoutGuide)
                $0.height.equalTo(80)
            } else {
                $0.top.equalTo(searchBar.snp.bottom).offset(40)
                $0.leading.trailing.equalToSuperview().inset(24)
                $0.height.equalTo(60)
            }
        }
        
        let backGesture = UITapGestureRecognizer(target: self, action: #selector(tapBack))
        view.addGestureRecognizer(backGesture)
    }
    
    @objc func tapSegment(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            photoSize = .raw
        case 1:
            photoSize = .regular
        default:
            photoSize = .small
        }
    }
    
    @objc func tapBack() {
        searchBar.endEditing(true)
        
        if #available(iOS 15.0, *) {
            searchButton.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(view.keyboardLayoutGuide)
                $0.height.equalTo(80)
            }
        }
    }
    
    @objc func tapSearchButton() {
        if keyword.isEmpty == false {
            searchBar.resignFirstResponder()
            
            let vc = PhotoViewController(keyword: keyword, photoSize: photoSize)
            navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension MainViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        if #available(iOS 15.0, *) {
            searchButton.snp.remakeConstraints {
                $0.leading.trailing.equalToSuperview()
                $0.bottom.equalTo(self.view.keyboardLayoutGuide.snp.top)
                $0.height.equalTo(80)
            }
            
            UIView.animate(withDuration: 0) {
                self.searchButton.snp.updateConstraints {
                    $0.height.equalTo(60)
                }
            }
        }
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText.isEmpty {
            searchButton.isEnabled = false
        } else {
            searchButton.isEnabled = true
        }
        
        let searchText = searchText.replacingOccurrences(of: " ", with: "")
        keyword = searchText
    }
}
