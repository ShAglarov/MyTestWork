//
//  CombinedUserCell.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 29.10.2023.
//

import UIKit

class CombinedUserCell: UITableViewCell {
    
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
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(nameLabel)
        addSubview(postTitleLabel)
        addSubview(customImageView)
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalTo(customImageView.snp.left).offset(-10)
        }
        
        postTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(10)
            make.left.right.equalTo(nameLabel)
        }
        
        customImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-10)
            make.centerY.equalTo(nameLabel)
            make.width.height.equalTo(40)
        }
    }
    
    func configure(with combinedUser: CombinedUser) {
        nameLabel.text = combinedUser.user.name
        postTitleLabel.text = combinedUser.posts.first?.title
    }
}
