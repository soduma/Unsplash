//
//  PhotoTableViewCell.swift
//  Unsplash
//
//  Created by 장기화 on 2022/03/14.
//

import UIKit
import SnapKit
import Kingfisher

class PhotoTableViewCell: UITableViewCell {
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
            $0.height.equalTo(photoImageView.snp.width)
        }
    }
    
    func setupImage(imageURL: String) {
        let url = URL(string: imageURL)!
        let data = try? Data(contentsOf: url)
        photoImageView.image = UIImage(data: data!)
    }
}
