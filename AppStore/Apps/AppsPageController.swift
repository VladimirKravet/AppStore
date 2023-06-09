//
//  AppsController.swift
//  AppStore
//
//  Created by Vladimir Kravets on 02.12.2022.
//

import UIKit

class AppsPageController: BaseListController, UICollectionViewDelegateFlowLayout {
    
    let cellId = "id"
    let headerId = "headerId"
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let aiv = UIActivityIndicatorView(style: .whiteLarge)
        aiv.color = .black
        aiv.startAnimating()
        aiv.hidesWhenStopped = true
        return aiv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(AppsGroupCell.self, forCellWithReuseIdentifier: cellId)
        // 1 add header view
        collectionView.register(AppsPageHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        view.addSubview(activityIndicatorView)
        activityIndicatorView.fillSuperview()
        
        fetchData()
    }
    
    //    var editorsChoiceApps: AppGroup?
    var socialApps = [SocialApp]()
    var groups = [AppGroup]()
    
    fileprivate func fetchData() {
        
        var group1: AppGroup?
        var group2: AppGroup?
        var group3: AppGroup?
        
        // help you sync your data fetches together
        let dispatchGroup = DispatchGroup()
        
        
        
        print("Fetching new JSON DATA somehow...")
        dispatchGroup.enter()
        Service.shared.topSongs { (appGroup, error) in
            dispatchGroup.leave()
            print("Done with free games")
            group1 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.topFreeApps { (appGroup, error) in
            dispatchGroup.leave()
            print("Done with top free apps")
            group2 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.topBooks { (appGroup, error) in
            dispatchGroup.leave()
            print("Done with top books")
            group3 = appGroup
        }
        
        dispatchGroup.enter()
        Service.shared.fetchSocialApps { apps, error in
            // should check the error
            if let error = error {
                print(error)
                return
            }
            dispatchGroup.leave()
            
            self.socialApps = apps ?? []
            // elf.collectionView.reloadData()
            
            
        }
        
        // completion
        dispatchGroup.notify(queue: .main) {
            
            print("completed your dispatch group tasks...")
            
            self.activityIndicatorView.stopAnimating()
            
            if let group = group1 {
                self.groups.append(group)
            }
            if let group = group2 {
                self.groups.append(group)
            }
            if let group = group3 {
                if let group = group3 {
                    self.groups.append(group)
                }
            }
            self.collectionView.reloadData()
        }
    }
    
    // 2 add header view
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! AppsPageHeader
        header.appHeaderHorizontalController.socialApps = self.socialApps
        header.appHeaderHorizontalController.collectionView.reloadData()
        return header
    }
    
    
    // 3 add header view
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 300)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return groups.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! AppsGroupCell
        
        let appGroup = groups[indexPath.item]
        
        cell.titleLabel.text = appGroup.feed.title
        cell.horizontalController.appGroup = appGroup
        cell.horizontalController.collectionView.reloadData()
        
        cell.horizontalController.didSelectHandler = { [weak self] feedResult in
            
            let controller = AppDetailController(appId: feedResult.id)
            
//            controller.appId = feedResult.id
            controller.navigationItem.title = feedResult.name
            self?.navigationController?.pushViewController(controller, animated: true)
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return.init(width: view.frame.width, height: 250)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 16, left: 0, bottom: 0, right: 0)
    }
}
