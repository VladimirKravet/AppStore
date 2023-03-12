//
//  AppsCompositionalView.swift
//  AppStore
//
//  Created by Vladimir Kravets on 13.02.2023.
//

import SwiftUI


class CompositionalController: UICollectionViewController {
    
    init() {
        
        
        //        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        //
        //        item.contentInsets.bottom = 16
        //        item.contentInsets.trailing = 16
        //
        //        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
        //
        //        let section = NSCollectionLayoutSection(group: group)
        //        // action add scrolling vertical
        //        section.orthogonalScrollingBehavior = .groupPaging
        //        section.contentInsets.leading = 32
        
        //        let layout = UICollectionViewCompositionalLayout(section: section)
        
        let layout = UICollectionViewCompositionalLayout { (sectionNumber, _) ->  NSCollectionLayoutSection? in
            
            if sectionNumber == 0 {
                // First section
                return CompositionalController.topSection()
                
            } else {
                
                // Second section
                return CompositionalController.secondSection()
                
            }
        }
        super.init(collectionViewLayout: layout)
    }
    
    static func topSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1)))
        
        item.contentInsets.bottom = 16
        item.contentInsets.trailing = 16
        
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        // action add scrolling vertical
        section.orthogonalScrollingBehavior = .groupPaging
        section.contentInsets.leading = 16
        return section
    }
    
    static func secondSection() -> NSCollectionLayoutSection {
        let item = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .fractionalHeight(1/3)))
        
        item.contentInsets = .init(top: 0, leading: 0, bottom: 16, trailing: 16)
        
        let group = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(0.8), heightDimension: .absolute(300)), subitems: [item])
        
        let section = NSCollectionLayoutSection(group: group)
        
        section.orthogonalScrollingBehavior = .continuous
        section.contentInsets.leading = 16
        
        
        let kind = UICollectionView.elementKindSectionHeader
        section.boundarySupplementaryItems = [
            .init(layoutSize: .init(widthDimension: .fractionalWidth(1), heightDimension: .absolute(50)), elementKind: kind, alignment: .topLeading)]
        
        return section
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: headerId, for: indexPath) as! CompositionalHeader
        
        var title: String?
        if indexPath.section == 1 {
            title = freeApps?.feed.title
        } else {
            title = topBooks?.feed.title
        }
        header.label.text = title
        return header
    }
    
    var socialApps = [SocialApp]()
    var freeApps: AppGroup?
    var topBooks: AppGroup?
    
    private func fetchApps() {
        Service.shared.fetchSocialApps { (apps, error) in
            if let error = error {
                print(error)
                return
            }
            self.socialApps = apps ?? []
            
            Service.shared.topFreeApps { (appGroup, error) in
                if let error = error {
                    print(error)
                    return
                }
                self.freeApps = appGroup
                
                Service.shared.topBooks { (appGroup, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    self.topBooks = appGroup
                    
                    DispatchQueue.main.async {
                        
                        self.collectionView.reloadData()
                    }
                }
            }
        }
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        0
    }
    
    //    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    //
    //        if section == 0 {
    //            return socialApps.count
    //        } else if section == 1 {
    //            return freeApps?.feed.results.count ?? 0
    //        } else {
    //            return topBooks?.feed.results.count ?? 0
    //        }
    //    }
    
    //    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    //
    //// just two different ways to write a code
    //
    ////        let appId: String
    ////
    ////        if indexPath.section == 0 {
    ////            appId = socialApps[indexPath.item].id
    ////
    ////        } else {
    ////           appId = freeApps?.feed.results[indexPath.item].id ?? ""
    ////        }
    ////        let appeDetailController = AppDetailController(appId: appId)
    ////        navigationController?.pushViewController(appeDetailController, animated: true)
    ////    }
    //
    //
    //        if indexPath.section == 0 {
    //            let appId = socialApps[indexPath.item].id
    //            let appeDetailController = AppDetailController(appId: appId)
    //
    //            navigationController?.pushViewController(appeDetailController, animated: true)
    //        } else if indexPath.section == 1 {
    //            guard let appId = freeApps?.feed.results[indexPath.item].id else { return }
    //            let appeDetailController = AppDetailController(appId: appId)
    //
    //            navigationController?.pushViewController(appeDetailController, animated: true)
    //        } else if indexPath.section == 2{
    //            guard let appId = topBooks?.feed.results[indexPath.item].id else {return}
    //            let appeDetailController = AppDetailController(appId: appId)
    //        }
    //    }
    
    //    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    //
    //        switch indexPath.section {
    //        case 0:
    //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
    //
    //            let socialApp = self.socialApps[indexPath.item]
    //            cell.titleLabel.text = socialApp.tagline
    //            cell.imageView.sd_setImage(with: URL(string: socialApp.imageUrl))
    //            cell.companyLabel.text = socialApp.name
    //
    //            return cell
    //        default:
    //            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppsRowCell
    //            if indexPath.section == 1 {
    //                let freeApp = freeApps?.feed.results[indexPath.item]
    //                cell.imageView.sd_setImage(with: URL(string: freeApp?.artworkUrl100 ?? ""))
    //                cell.nameLabel.text = freeApp?.name
    //                cell.companyLabel.text = freeApp?.artistName
    //
    //                return cell
    //
    //            } else {
    //                let topBooks = topBooks?.feed.results[indexPath.item]
    //                cell.imageView.sd_setImage(with: URL(string: topBooks?.artworkUrl100 ?? ""))
    //                cell.nameLabel.text = topBooks?.name
    //                cell.companyLabel.text = topBooks?.artistName
    //
    //                return cell
    //            }
    //
    //        }
    //    }
    
    
    class CompositionalHeader: UICollectionReusableView {
        
        let label = UILabel(text: "Editor's Choise Game", font: .boldSystemFont(ofSize: 32))
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            addSubview(label)
            label.fillSuperview()
        }
        
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    let headerId = "headerId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(CompositionalHeader.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: headerId)
        
        collectionView.register(AppsHeaderCell.self, forCellWithReuseIdentifier: "cellId")
        
        collectionView.register(AppsRowCell.self, forCellWithReuseIdentifier: "smallCellId")
        
        collectionView.backgroundColor = .white
        navigationItem.title = "Apps"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        navigationItem.rightBarButtonItem = .init(title: "Fetch Top Free", style: .plain , target: self, action: #selector(handleFetchTopFree))
        
        collectionView.refreshControl = UIRefreshControl()
        collectionView.refreshControl?.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        
        
        //        fetchApps()
        
        setupDiffableDatasource()
        
    }
    
    @objc fileprivate func handleRefresh() {
        collectionView.refreshControl?.endRefreshing()
        
        var snapshot = diffableDataSource.snapshot()
        
        snapshot.deleteSections([.topFree])
        
        diffableDataSource.apply(snapshot)
    }
    
    @objc fileprivate func handleFetchTopFree() {
        Service.shared.fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/us/apps/top-free/25/apps.json") { (appGroup, error) in
            if let error = error {
                print(error)
                return
            }
            var snapshot = self.diffableDataSource.snapshot()
            snapshot.insertSections([.topFree], afterSection: .topSocial)
            
            snapshot.appendItems(appGroup?.feed.results ?? [], toSection: .topFree)
            
            self.diffableDataSource.apply(snapshot)
        }
    }
    
    enum AppSection {
        case topSocial
        case topApps
        case topBooks
        case topFree
    }
    
    lazy var diffableDataSource: UICollectionViewDiffableDataSource<AppSection, AnyHashable> = .init(collectionView: self.collectionView) { (collectionView, indexPath, object) -> UICollectionViewCell? in
        
        if let object = object as? SocialApp {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cellId", for: indexPath) as! AppsHeaderCell
            
            cell.app = object
            
            return cell
        } else if let object = object as? FeedResult {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCellId", for: indexPath) as! AppsRowCell
            cell.app = object
            
            cell.getButton.addTarget(self, action: #selector(self.handleGet), for: .primaryActionTriggered)
            return cell
        }
        
        return nil
    }
    
    @objc func handleGet(button: UIView) {
        
        var superview = button.superview
        // i want to reach the parent cell of the get button
        
        while superview != nil {
            if let cell = superview as? UICollectionViewCell {
                guard let indexPath = self.collectionView.indexPath(for: cell) else {return}
                
                guard let objectIClicedOn = diffableDataSource.itemIdentifier(for: indexPath) else {return}
                
                var snapshot = diffableDataSource.snapshot()
                snapshot.deleteItems([objectIClicedOn])
                diffableDataSource.apply(snapshot)
                
            }
            superview = superview?.superview
        }
        
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let object = diffableDataSource.itemIdentifier(for: indexPath)
        object
        
        if let object = object as? SocialApp {
            let appDetailController = AppDetailController(appId: object.id)
            
            navigationController?.pushViewController(appDetailController, animated: true)
        } else if let object = object as? FeedResult {
            let appDetailController = AppDetailController(appId: object.id)
            navigationController?.pushViewController(appDetailController, animated: true)
        }
    
        

    }
    
    private func setupDiffableDatasource() {
        
        diffableDataSource.supplementaryViewProvider = .some({ collectionView, kind, indexPath in
            let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: self.headerId, for: indexPath) as! CompositionalHeader
            
            let snapshot = self.diffableDataSource.snapshot()
            let object = self.diffableDataSource.itemIdentifier(for: indexPath)
            
            let section = snapshot.sectionIdentifier(containingItem: object!) as! AppSection
            
            if section == .topBooks {
                header.label.text = "Top Books"
            } else if section == .topApps {
                header.label.text = "Top Apps"
            } else {
                header.label.text = "Top Free"
            }
            
        
            
            return header
        })
        
        // add data
        
        
        //                snapshot.appendItems([
        //                    SocialApp(id: "id0", name: "Facebook", imageUrl: "", tagline: "Whatever tagline you want"),
        //                    SocialApp(id: "id1", name: "Instagram", imageUrl: "", tagline: "tagline0")
        //                ], toSection: .topSocial)
        
        
        
        collectionView.dataSource = diffableDataSource
        
        Service.shared.fetchSocialApps { (socialApps, error) in
            if let error = error {
                print(error)
                return
            }
            Service.shared.topFreeApps { (appGroup, error) in
                if let error = error {
                    print(error)
                    return
                }
                
                Service.shared.topBooks { (booksGroup, error) in
                    if let error = error {
                        print(error)
                        return
                    }
                    
                    var snapshot = self.diffableDataSource.snapshot()
                    
                    // top social
                    snapshot.appendSections([.topSocial, .topApps, .topBooks])
                    
                    snapshot.appendItems(socialApps ?? [], toSection: .topSocial)
                    
                    // top Grossinf
                    //                snapshot.appendSections([.grossing])
                    let objects = appGroup?.feed.results ?? []
                    snapshot.appendItems(objects, toSection: .topApps)
                    
                    snapshot.appendItems(booksGroup?.feed.results ?? [], toSection: .topBooks)
                    
                    self.diffableDataSource.apply(snapshot)
                }
            }
        }
    }
}

struct AppsView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
//        let redController = UIViewController()
//        redController.view.backgroundColor = .red
        
        let controller = CompositionalController()
        
        return UINavigationController(rootViewController: controller)
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = UIViewController
    
    
}


struct AppsCompositionalView_Previews: PreviewProvider {
    static var previews: some View {
        AppsView()
            .edgesIgnoringSafeArea(.all)
    }
    
}
