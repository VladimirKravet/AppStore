  //
//  AppsSearchControllerCollectionViewController.swift
//  AppStore
//
//  Created by Vladimir Kravets on 09.11.2022.
//

import UIKit
import SDWebImage

class AppsSearchController: BaseListController, UICollectionViewDelegateFlowLayout, UISearchBarDelegate {
    
    fileprivate let cellId = "Cell"
    
    fileprivate let searchController = UISearchController(searchResultsController: nil)
    
    fileprivate let enterSearchTermLabel: UILabel = {
        let label = UILabel()
        label.text = "Please enter search term above..."
        label.textAlignment = .center
        label.font = UIFont.boldSystemFont(ofSize: 20)
        return label
    }()
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let appId = String(appResults[indexPath.item].trackId)
        let appDetailController = AppDetailController(appId: appId)
        
//        let appId = appResults[indexPath.item].trackId
//        appDetailController.appId = String(appId)
        navigationController?.pushViewController(appDetailController, animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.backgroundColor = .white
        
        collectionView.register(SearchResultCell.self, forCellWithReuseIdentifier: cellId)
        
        collectionView.addSubview(enterSearchTermLabel)
        enterSearchTermLabel.fillSuperview(padding: .init(top: 100, left: 50, bottom: 0, right: 50))
        
        setupSearchBar()
        
        
//        fetchITunesApp()
        
    }
    
    // searchBar
    fileprivate func setupSearchBar() {
        definesPresentationContext = true
        navigationItem.searchController = self.searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        searchController.searchBar.delegate = self
        
        
    }
    
    var timer: Timer?
    
    // cheaking changes when typing is searchBar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(withTimeInterval: 0.5, repeats: false, block: { (_) in
            // this is actualy fire my search
            
            Service.shared.fetchApps(searchTerm: searchText) { res, error in
                self.appResults = res
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
        })
    }
    
    fileprivate var appResults = [Result]()
    
    fileprivate func fetchITunesApp() {
        
        Service.shared.fetchApps(searchTerm: "Twitter") {(results, error)  in
            
            if let error = error {
                print(error)
                return
            }
            
            self.appResults = results
            DispatchQueue.main.async {
            self.collectionView.reloadData()
            }
        }

    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 350)
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        enterSearchTermLabel.isHidden = appResults.count != 0
        return appResults.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! SearchResultCell
        
        let appResult = appResults[indexPath.item]
        cell.appResult = appResult
        
//        cell.nameLabel.text = appResult.trackName
//        cell.categoryLabel.text = appResult.primaryGenreName
//        cell.ratingsLabel.text = "Rating: \(appResult.averageUserRating ?? 0)"
//        let url = URL(string: appResult.artworkUrl100)
//        cell.appIconImageView.sd_setImage(with: url)
//        
//        cell.screenshot1ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[0]))
//        if appResult.screenshotUrls.count > 1 {
//            cell.screenshot2ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[1]))
//        }
//        if appResult.screenshotUrls.count > 2 {
//            cell.screenshot3ImageView.sd_setImage(with: URL(string: appResult.screenshotUrls[2]))
//        }
        return cell
    }
    
}
