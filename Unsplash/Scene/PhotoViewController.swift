//
//  PhotoViewController.swift
//  Unsplash
//
//  Created by 장기화 on 2022/03/13.
//

import UIKit

enum ImageSize: String {
    case raw
    case full
    case small
}

class PhotoViewController: UIViewController {
    private var imageList: [Results]
    private var searchText: String
    private var currentPage = 1
    private var segmentIndex: ImageSize
    private let manager = Manager()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "photo")
        return tableView
    }()
    
    init(images: [Results], text: String, segmentIndex: ImageSize) {
        self.imageList = images
        self.searchText = text
        self.segmentIndex = segmentIndex
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            await fetch()
            layout()
            print("😍 \(imageList)")
        }
    }

    private func fetch() async {
        let result = await manager.fetchWithAsync(keyword: searchText, page: currentPage)
        
        switch result {
        case .success(let data):
            imageList += data.results
            tableView.reloadData()
        case.failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func layout() {
        view.backgroundColor = .systemBackground
        view.addSubview(tableView)
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}

extension PhotoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photo", for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
        
        switch segmentIndex {
        case .raw:
            let image = imageList[indexPath.row].urls.raw
            let placeHolder = imageList[indexPath.row].blurHash
            cell.setupImage(imageURL: image, placeHolder: placeHolder)
            return cell
            
        case .full:
            let image = imageList[indexPath.row].urls.regular
            let placeHolder = imageList[indexPath.row].blurHash
            cell.setupImage(imageURL: image, placeHolder: placeHolder)
            return cell
            
        case .small:
            let image = imageList[indexPath.row].urls.small
            let placeHolder = imageList[indexPath.row].blurHash
            cell.setupImage(imageURL: image, placeHolder: placeHolder)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.width
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentHeight = tableView.contentSize.height - tableView.frame.height
        
        if tableView.contentOffset.y >= contentHeight {
            print(currentPage)
            
            Task {
                currentPage += 1
                await fetch()
            }
        }
    }
}
