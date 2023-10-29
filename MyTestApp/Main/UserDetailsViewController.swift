//
//  UserDetailsViewController.swift
//  MyTestApp
//
//  Created by Shamil Aglarov on 28.10.2023.
//

import Foundation
import UIKit
import Moya



//class UserDetailsViewController: UIViewController, UICollectionViewDataSource {
//    var user: User?
//    
//    private lazy var collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.estimatedItemSize = CGSize(width: view.frame.size.width, height: 50)
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.dataSource = self
//        collectionView.register(UserDetailCell.self, forCellWithReuseIdentifier: UserDetailCell.identifier)
//        collectionView.backgroundColor = .white
//        return collectionView
//    }()
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupCollectionView()
//    }
//    
//    private func setupCollectionView() {
//        view.addSubview(collectionView)
//        collectionView.snp.makeConstraints { make in
//            make.edges.equalToSuperview()
//        }
//    }
//    
//    // MARK: - UICollectionView DataSource
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return 8 // Зависит от того, сколько у вас атрибутов в модели User
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: UserDetailCell.identifier, for: indexPath) as? UserDetailCell else {
//            fatalError("Could not dequeue UserDetailCell")
//        }
//        
//        switch indexPath.row {
//        case 0:
//            cell.configure(title: "Name", detail: user?.name ?? "-")
//        case 1:
//            cell.configure(title: "Username", detail: user?.username ?? "-")
//        case 2:
//            cell.configure(title: "Email", detail: user?.email ?? "-")
//        case 3:
//            cell.configure(title: "Phone", detail: user?.phone ?? "-")
//        case 4:
//            cell.configure(title: "Website", detail: user?.website ?? "-")
//        case 5:
//            cell.configure(title: "Address", detail: "\(user?.address?.street ?? "-"), \(user?.address?.city ?? "-")")
//        case 6:
//            cell.configure(title: "Company", detail: user?.company?.name ?? "-")
//        // ... добавьте больше случаев для других атрибутов
//        default:
//            break
//        }
//        
//        return cell
//    }
//}
