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
    static let identifier = "PhotoTableViewCell"
    
    private lazy var photoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private lazy var outerVisualEffectView: UIVisualEffectView = {
        let blurEffect = UIBlurEffect(style: .regular)
        let view = UIVisualEffectView(effect: blurEffect)
        view.clipsToBounds = true
        view.layer.cornerRadius = 12
        return view
    }()
    
    private lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.italicSystemFont(ofSize: 16)
        label.numberOfLines = 0
        return label
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        contentView.addSubview(photoImageView)
        photoImageView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview()
            $0.height.equalTo(photoImageView.snp.width)
        }
        
        photoImageView.addSubview(outerVisualEffectView)
        outerVisualEffectView.snp.makeConstraints {
            $0.bottom.leading.equalToSuperview().inset(20)
            $0.width.lessThanOrEqualTo(safeAreaLayoutGuide).inset(20)
            $0.height.lessThanOrEqualTo(88)
        }
        
        outerVisualEffectView.contentView.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.leading.trailing.equalToSuperview().inset(12)
        }
    }
    
    func setImage(imageURL: String, placeHolder: String?) {
        guard let url = URL(string: imageURL),
              let placeHolder = placeHolder else { return }
        let holder = UIImage(blurHash: placeHolder, size: CGSize(width: 32, height: 32))
        photoImageView.kf.setImage(with: url, placeholder: holder)
    }
    
    func setDescription(data: Results) {
        guard let description = data.description != nil ? data.description : data.altDescription else { return }
        descriptionLabel.text = description
    }
}
