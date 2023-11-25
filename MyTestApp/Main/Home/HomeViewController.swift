//
//  HomeViewController.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 28.10.2023.
//

import UIKit
import Combine

final class HomeViewController: UIViewController {

    private var viewModel = HomeViewModel()
    private let appView = AppView()

    init(viewModel: HomeViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var cancellables = Set<AnyCancellable>()
    
    private lazy var collectionView: UICollectionView = {
        appView.collectionView(
            cellType: CombinedUserViewCell.self,
            cellIdentifier: "CombinedUserCell",
            delegate: self,
            dataSource: self
        )
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white

        setupUI()

        // Настраиваем привязку к ViewModel
        bindViewModel()

        // Запрашиваем данные
        viewModel.fetchData()
    }

    private func setupUI() {
        
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalTo(view.safeAreaLayoutGuide)
        }
    }

    private func bindViewModel() {
        viewModel.$combinedUsers
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)

        viewModel.$error
            .receive(on: DispatchQueue.main)
            .sink { [weak self] error in
                if let error = error {
                    self?.showAlert(with: "Error", message: error)
                }
            }
            .store(in: &cancellables)
    }

    private func showAlert(with title: String, message: String, completion: (() -> Void)? = nil) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
            completion?()
        })
        present(alert, animated: true)
    }
}

// MARK: - UICollectionViewDelegate, UICollectionViewDataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.combinedUsers.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CombinedUserCell", for: indexPath) as? CombinedUserViewCell else {
            return UICollectionViewCell()
        }
        let combinedUser = viewModel.combinedUsers[indexPath.item]
        cell.configure(with: combinedUser)
        return cell
    }
}
