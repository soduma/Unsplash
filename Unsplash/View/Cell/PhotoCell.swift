//
//  PhotoCell.swift
//  Unsplash
//
//  Created by 장기화 on 2022/03/14.
//

import UIKit
import SnapKit
import Kingfisher

class PhotoCell: UITableViewCell {
    static let identifier = "PhotoCell"
    
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
    
    func setImage(photoSize: PhotoSize, photo: Results) {
        var urlString = ""
        
        switch photoSize {
        case .raw:
            urlString = photo.urls.raw
        case .regular:
            urlString = photo.urls.regular
        default:
            urlString = photo.urls.small
        }
        
        guard let url = URL(string: urlString) else { return }
        let blurHash = photo.blurHash
        let placeHolder = UIImage(blurHash: blurHash, size: CGSize(width: 32, height: 32))
        photoImageView.kf.setImage(with: url, placeholder: placeHolder)
        
        guard let description = photo.description != nil ? photo.description : photo.altDescription else { return }
        descriptionLabel.text = description
    }
}
