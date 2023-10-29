//
//  UserDetailCell.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 28.10.2023.
//

import UIKit

class UserDetailCell: UITableViewCell {
    
    private var nameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    private var usernameLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .italicSystemFont(ofSize: 14)
        return label
    }()
    
    private var emailLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
    }()
    
    private var userImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 30
        imageView.clipsToBounds = true
        return imageView
    }()
    
    // Инициализатор
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [nameLabel, usernameLabel, emailLabel, userImageView].forEach { addSubview($0) }
        
        userImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.width.height.equalTo(60)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(userImageView)
            make.left.equalTo(userImageView.snp.right).offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        
        usernameLabel.snp.makeConstraints { make in
            make.top.equalTo(nameLabel.snp.bottom).offset(5)
            make.left.right.equalTo(nameLabel)
        }
        
        emailLabel.snp.makeConstraints { make in
            make.top.equalTo(usernameLabel.snp.bottom).offset(5)
            make.left.right.equalTo(nameLabel)
            make.bottom.equalToSuperview().offset(-10)
        }
    }
    
    func configure(with user: User) {
        nameLabel.text = user.name
        usernameLabel.text = "@" + (user.username ?? "")
        emailLabel.text = user.email
    }
}
