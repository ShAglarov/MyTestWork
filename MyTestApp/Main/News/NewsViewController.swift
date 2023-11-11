//
//  NewsViewController.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 03.11.2023.
//

import UIKit
import SnapKit
import Combine

class NewsViewController: UIViewController {
    
    var viewModel: NewsViewModel
    var cancellables: Set<AnyCancellable> = []
    let appView = AppView()
    
    private lazy var collectionView: UICollectionView = {
        appView.collectionView(
            cellType: NewsCollectionViewCell.self,
            cellIdentifier: "NewsViewCell",
            delegate: self,
            dataSource: self
        )
    }()
    
    private lazy var searchedNewsTF: UITextField = {
        appView.textField(placeholder: "Поиск")
    }()
    
    init(viewModel: NewsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()
        
        bindViewModel()
    }
    
//    @objc func textFieldDidChange(_ textField: UITextField) {
//        // Запускаем поиск, когда текст изменяется.
//        if let searchText = textField.text, !searchText.isEmpty {
//            viewModel.fetchNews(searchQuery: searchText)
//        }
//    }

    private func setupUI() {
        
        collectionView.register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: "NewsViewCell")
        
        view.addSubview(searchedNewsTF)
        view.addSubview(collectionView)
        
        searchedNewsTF.delegate = self
        //searchedNewsTF.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        searchedNewsTF.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(0)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide).inset(10)
            make.height.equalToSuperview().multipliedBy(0.06)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(searchedNewsTF.snp.bottom).offset(10)
            make.leading.trailing.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    private func bindViewModel() {
        viewModel.$news
            .receive(on: DispatchQueue.main)
            .sink { [weak self] news in
                self?.collectionView.reloadData()
                news.forEach { print("title: \($0.title ?? "")\nauthor: \($0.author ?? "")") }
            }
            .store(in: &cancellables)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension NewsViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.news.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "NewsViewCell", for: indexPath) as? NewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        let news = viewModel.news[indexPath.item]
        cell.configure(with: news)
        return cell
    }
}

// MARK: - UITextFieldDelegate
extension NewsViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Запускаем поиск, когда пользователь нажимает кнопку "return" на клавиатуре.
        if let searchText = textField.text, !searchText.isEmpty {
            viewModel.fetchNews(searchQuery: searchText)
        }
        textField.resignFirstResponder() // Скрываем клавиатуру
        return true
    }
}
// MARK: - UICollectionViewDelegateFlowLayout
extension NewsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = collectionView.bounds.width - (collectionView.contentInset.left + collectionView.contentInset.right)
        return CGSize(width: width, height: 100)
    }
}
