//
//  PhotoViewController.swift
//  Unsplash
//
//  Created by 장기화 on 2022/03/13.
//

import UIKit

class PhotoViewController: UIViewController {
    var imageList: [Results]
    var searchText: String
    let manager = Manager()
    
    private lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.separatorStyle = .none
        tableView.allowsSelection = false
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(PhotoTableViewCell.self, forCellReuseIdentifier: "photo")
        return tableView
    }()
    
    init(images: [Results], text: String) {
        self.imageList = images
        self.searchText = text
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .systemBackground
        
        Task {
            print("fetch start🥶")
            await fetch()
            print("😍 \(imageList)")
            
            view.addSubview(tableView)
            tableView.snp.makeConstraints {
                $0.edges.equalToSuperview()
            }
        }
    }

    func fetch() async {
        let result = await manager.fetchWithAsync(searchText)
        imageList = result
    }
}

extension PhotoViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return imageList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "photo", for: indexPath) as? PhotoTableViewCell else { return UITableViewCell() }
        let image = imageList[indexPath.row].urls.raw
        let placeHolder = imageList[indexPath.row].blurHash
        
        cell.setupImage(imageURL: image, placeHolder: placeHolder)
        cell.layoutIfNeeded()
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return view.bounds.width
    }
}
