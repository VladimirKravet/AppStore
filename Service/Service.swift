//
//  Service.swift
//  AppStore
//
//  Created by Vladimir Kravets on 01.12.2022.
//

import Foundation

class Service {
    static let shared = Service() //singleton
    
    func fetchApps(searchTerm: String, completion: @escaping ([Result], Error?) -> ()) {
        print("Fetching itunes app from Service layer")
        
        let urlString = "https://itunes.apple.com/search?term=\(searchTerm)&entity=software"
        
        // fetch data from internet
        
        guard let url = URL(string: urlString) else {return}
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                completion([], error)
                return
            }
            
            //success
            guard let data = data else {return}
            //            let jsonString = String(data: data, encoding: .utf8)
            //            print(jsonString)
            
            do {
                let searchResult = try JSONDecoder().decode(SearchResult.self, from: data)
                
                //                self.appResults = searchResult.results
                //
                //                DispatchQueue.main.async {
                //                    self.collectionView.reloadData()
                //                }
                completion(searchResult.results, error)
                
                //searchResult.results.forEach({print($0.trackName, $0.primaryGenreName)})
            }catch{
                print(error)
                completion([], error)
            }
        }.resume() //fire off the request
        
    }
    
    func topSongs(completion: @escaping (AppGroup?, Error?) -> ()) {

        let urlString = "https://rss.applemarketingtools.com/api/v2/us/music/most-played/50/songs.json"
        
        fetchAppGroup(urlString: urlString, completion: completion)
    }
    
    func topFreeApps(completion: @escaping (AppGroup?, Error?) -> ()) {
        fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/tn/apps/top-free/50/apps.json", completion: completion)
    }
    
    func topBooks(completion: @escaping (AppGroup?, Error?) -> ()) {
        fetchAppGroup(urlString: "https://rss.applemarketingtools.com/api/v2/us/books/top-free/50/books.json", completion: completion)
    }
    
    
                      //helper for fetch
    func fetchAppGroup(urlString: String, completion: @escaping (AppGroup?, Error?) -> Void) {
       guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { (data, resp, error) in
            
            if let error = error {
                completion(nil, error)
                print(error)
                return
            }
            //success
            guard let data = data else {return}
            do {
                let appGroup = try JSONDecoder().decode(AppGroup.self, from: data)
                appGroup.feed.results.forEach({print ($0.name)})
                completion(appGroup, nil)
            } catch {
                completion(nil, error)
                print(error)
            }
        }.resume() // this will fire your request
    }
    
    func fetchSocialApps(completion: @escaping ([SocialApp]?, Error?) -> Void) {
        let urlString = "https://api.letsbuildthatapp.com/appstore/social"
        fetchGenericJSONData(urlString: urlString, completion: completion)
    }
  // declare Generic JSON function
    func fetchGenericJSONData<T: Decodable>(urlString: String, completion: @escaping (T?, Error?) -> ()) {
        guard let url = URL(string: urlString) else { return }
         
         URLSession.shared.dataTask(with: url) { (data, resp, error) in
             
             if let error = error {
                 completion(nil, error)
                 print(error)
                 return
             }
             //success
             guard let data = data else {return}
             do {
                 let socialApp = try
                 JSONDecoder().decode(T.self, from: data)
                 completion(socialApp, nil)
             } catch {
                 completion(nil, error)
                 print(error)
             }
         }.resume()
    }
}
