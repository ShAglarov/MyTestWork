//
//  CombinationUserCell.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 29.10.2023.
//

import Foundation
import UIKit
import SDWebImage

class CombinedUserViewCell: UICollectionViewCell {
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private var postTitleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .systemFont(ofSize: 14)
        return label
    }()
    
    private var customImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        customImageView.sd_cancelCurrentImageLoad()
        customImageView.image = nil
    }
    
    private func setupUI() {
        addSubview(nameLabel)
        addSubview(postTitleLabel)
        addSubview(customImageView)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        postTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.right.equalTo(nameLabel)
        }
        
        customImageView.snp.makeConstraints { make in
            make.top.equalTo(postTitleLabel.snp.bottom).offset(10)
            make.left.right.equalTo(nameLabel)
            make.height.equalTo(60)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with combinedUser: CombinedUser) {
        
        nameLabel.text = combinedUser.user.name
        postTitleLabel.text = combinedUser.posts.first?.title
        
        // Очищаем изображение перед установкой нового
        customImageView.image = nil
        
        if let photoURL = combinedUser.photos.first?.url, let url = URL(string: photoURL) {
            customImageView.sd_setImage(with: url, placeholderImage: UIImage(named: "placeholder"))
        }
    }
}
