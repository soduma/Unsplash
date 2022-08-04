//
//  PhotoViewController.swift
//  Unsplash
//
//  Created by 장기화 on 2022/03/13.
//

import UIKit

class PhotoViewController: UIViewController {
    private let networkManager = NetworkManager()
    private var searchText: String
    private var segmentIndex: ImageSize
    
    private var imageList: [Results] = []
    private var loadedPage = 1
    private var isLoading = false
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: PhotoTableViewCell.identifier)
        return tableView
    }()
    
    init(text: String, segmentIndex: ImageSize) {
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
            isLoading = false
            setLayout()
//            print("😍 \(imageList)")
        }
    }

    private func fetch() async {
        isLoading = true
        let result = await networkManager.fetchWithAsync(keyword: searchText, page: loadedPage)
        
        switch result {
        case .success(let data):
            imageList += data.results
            tableView.reloadData()
        case.failure(let error):
            print(error.localizedDescription)
        }
    }
    
    private func setLayout() {
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
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PhotoTableViewCell.identifier, for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
        
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
        guard loadedPage < 3, !isLoading else { return }
        
        let contentHeight = scrollView.contentSize.height - scrollView.bounds.height
        if scrollView.contentOffset.y >= contentHeight {
            Task {
                loadedPage += 1
                print(loadedPage)
                await fetch()
                isLoading = false
            }
        }
    }
}
