//
//  NewsViewCell.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 03.11.2023.
//

import Foundation
import UIKit

class NewsCollectionViewCell: UICollectionViewCell {
    
    private var articleTitleLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    private var articleAuthorLbl: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        label.font = .boldSystemFont(ofSize: 16)
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        addSubview(articleTitleLbl)
        addSubview(articleAuthorLbl)
        
        articleTitleLbl.numberOfLines = 0
        
        articleTitleLbl.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(10)
            make.left.equalToSuperview().offset(10)
            make.right.equalToSuperview().offset(-10)
        }
        articleAuthorLbl.snp.makeConstraints { make in
            make.top.equalTo(articleTitleLbl.snp.bottom).offset(10)
            make.left.right.equalTo(articleTitleLbl)
        }
    }
    
    func configure(with article: OneNews) {
        articleTitleLbl.text = article.title
        articleAuthorLbl.text = article.author
    }
}
