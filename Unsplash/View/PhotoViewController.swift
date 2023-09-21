//
//  PhotoViewController.swift
//  Unsplash
//
//  Created by 장기화 on 2022/03/13.
//

import UIKit

class PhotoViewController: UIViewController {
    var photoList = [Results]()
    
    let viewModel: PhotoViewModel
    
    init(viewModel: PhotoViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoCell.self, forCellReuseIdentifier: PhotoCell.identifier)
        return tableView
    }()
    
    private lazy var activityIndicator: UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        return view
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        viewModel.isFetching = true
        activityIndicator.startAnimating()
        
        Task {
            photoList = await viewModel.getPhoto(keyword: viewModel.keyword)
            tableView.reloadData()
            activityIndicator.stopAnimating()
        }
    }
    
    private func setLayout() {
        title = viewModel.keyword
        view.backgroundColor = .systemBackground
        
        [tableView, activityIndicator]
            .forEach {view.addSubview($0) }
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        activityIndicator.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}

extension PhotoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else {
            return UITableViewCell() }
        let photo = photoList[indexPath.row]
        cell.setImage(photoSize: viewModel.photoSize, photo: photo)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.width
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageLimit = 3
        guard viewModel.currentPage < pageLimit,
              !viewModel.isFetching else { return }
        
        let contentHeight = scrollView.contentSize.height - scrollView.bounds.height
        if scrollView.contentOffset.y >= contentHeight {
            viewModel.currentPage += 1
            viewModel.isFetching = true
            
            Task {
                photoList += await viewModel.getPhoto(keyword: viewModel.keyword)
                tableView.reloadData()
            }
        }
    }
}
