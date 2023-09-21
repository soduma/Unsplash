//
//  MainViewController.swift
//  Unsplash
//
//  Created by 장기화 on 2022/02/25.
//

import UIKit
import SnapKit
import RxSwift

class MainViewController: UIViewController {
    let viewModel = PhotoViewModel()
    let disposeBag = DisposeBag()
    
    private lazy var searchButton = MovableBottomButton()
    
    private lazy var logoBaseView: UIView = {
        let view = UIView()
        view.backgroundColor = .red.withAlphaComponent(0.8)
        view.layer.cornerRadius = 40
        view.clipsToBounds = true
        return view
    }()
    
    private lazy var logoLabel: UILabel = {
        let label = UILabel()
        label.text = "Unsplash"
        label.textColor = .systemTeal
        label.font = .systemFont(ofSize: 100, weight: .heavy)
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
    
    private lazy var segmentedControl: UISegmentedControl = {
        let segment = UISegmentedControl()
        segment.insertSegment(withTitle: "RAW", at: 0, animated: true)
        segment.insertSegment(withTitle: "Regular", at: 1, animated: true)
        segment.insertSegment(withTitle: "Small", at: 2, animated: true)
        segment.tintColor = .systemGray
        segment.selectedSegmentIndex = 1
        return segment
    }()
    
    private lazy var searchBar: UISearchBar = {
        let bar = UISearchBar()
        bar.text = ""
        bar.placeholder = "Keyword"
        bar.searchBarStyle = .minimal
        return bar
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
//        searchBar.becomeFirstResponder()
    }
    
    func setLayout() {
        [logoBaseView, logoLabel, segmentedControl, searchBar]
            .forEach { view.addSubview($0) }
        
        logoBaseView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(40)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(100)
        }
        
        logoLabel.snp.makeConstraints {
            $0.center.equalTo(logoBaseView)
            $0.leading.trailing.equalTo(logoBaseView).inset(20)
        }
        
        segmentedControl.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(logoLabel.snp.bottom).offset(20)
            $0.leading.trailing.equalToSuperview().inset(28)
            $0.height.equalTo(40)
        }
                
        searchBar.snp.makeConstraints {
            $0.top.equalTo(segmentedControl.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(20)
            $0.height.equalTo(40)
        }
        
        searchButton = setBottomButtonMove(title: "SEARCH", initialEnable: false, view: view, bag: disposeBag)
    }
    
    private func bind() {
        let backGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(backGesture)
        backGesture.rx.event.bind(onNext: { _ in
            self.searchBar.endEditing(true)
        }).disposed(by: disposeBag)
        
        searchBar.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { text in
                if text.isEmpty {
                    self.searchButton.isEnabled = false
                } else {
                    self.searchButton.isEnabled = true
                    self.viewModel.keyword = text
                }
                
            }).disposed(by: disposeBag)
        
        searchBar.rx.searchButtonClicked
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                searchBar.resignFirstResponder()
                
                let vc = PhotoViewController(viewModel: viewModel)
                navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        searchButton.rx.tap
            .bind(onNext: { [weak self] in
                guard let self else { return }
                searchBar.resignFirstResponder()
                
                let vc = PhotoViewController(viewModel: viewModel)
                navigationController?.pushViewController(vc, animated: true)
            }).disposed(by: disposeBag)
        
        segmentedControl.rx.selectedSegmentIndex
            .subscribe(onNext: { [weak self] index in
                guard let self else { return }
                switch index {
                case 0:
                    viewModel.photoSize = .raw
                case 1:
                    viewModel.photoSize = .regular
                default:
                    viewModel.photoSize = .small
                }
            }).disposed(by: disposeBag)
    }
}
