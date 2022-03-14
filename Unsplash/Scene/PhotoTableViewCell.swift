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
    
    func setupImage(imageURL: String, placeHolder: String?) {
//        guard let url = URL(string: imageURL) else { return }
//        if let data = try? Data(contentsOf: url) {
//            photoImageView.image = UIImage(data: data)
//        }
        
        guard let url = URL(string: imageURL),
              let placeHolder = placeHolder else { return }
        let holder = UIImage(blurHash: placeHolder, size: CGSize(width: 32, height: 32))
        photoImageView.kf.setImage(with: url, placeholder: holder, options: [.forceRefresh])
    }
}
