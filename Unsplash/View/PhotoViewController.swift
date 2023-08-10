//
//  PhotoViewController.swift
//  Unsplash
//
//  Created by 장기화 on 2022/03/13.
//

import UIKit

class PhotoViewController: UIViewController {
    let viewModel = PhotoViewModel()
    var photoList = [Results]()
    
    let keyword: String
    let photoSize: PhotoSize
    
    init(keyword: String, photoSize: PhotoSize) {
        self.keyword = keyword
        self.photoSize = photoSize
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        
        Task {
            viewModel.isFetching = true
            photoList = await viewModel.getPhoto(keyword: keyword)
            tableView.reloadData()
        }
    }
    
    private func setLayout() {
        title = keyword
        view.backgroundColor = .systemBackground
        
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension PhotoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return photoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoCell.identifier, for: indexPath) as? PhotoCell else { return UITableViewCell() }
        let photo = photoList[indexPath.row]
        cell.setImage(photoSize: photoSize, photo: photo)
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
                photoList += await viewModel.getPhoto(keyword: keyword)
                tableView.reloadData()
            }
        }
    }
}
