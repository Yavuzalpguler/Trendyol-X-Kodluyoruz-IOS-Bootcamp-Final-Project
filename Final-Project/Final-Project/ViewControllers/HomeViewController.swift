//
//  ViewController.swift
//  Final-Project
//
//  Created by Yavuz Alp GÜLER on 27.05.2021.
//

import UIKit
import CoreApi


extension HomeViewController {
    fileprivate enum Constants {
        static let cellWidth: CGFloat = 358
        static var cellDescriptionViewHeight: CGFloat = 159
        static var cellBannerImageViewAspectRatio: CGFloat = 201/358
        static let leftPadding: CGFloat = 16
        static let rightPadding: CGFloat = 16
    }
}




class HomeViewController: UIViewController {
    let networkManager: NetworkManager<HomeEndpointItem> = NetworkManager()
    
    var isLayoutChanged = false
    
    @IBOutlet weak var GameListCollectionView: UICollectionView!
    @IBOutlet weak var layoutButton: UIBarButtonItem!
    
    private var home: HomeResponse?
    private var results: [Result]? = []
    private var nextPage: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareCollectionView()
        fetchGames()
        prepareSearchController()
        prepareNavigationBar()
        
        //        let bigLayout = UIImage(named: "smallLayoutButton")
        //        let smallLayout = UIImage(named: "gift")
        //
        //        if self.isLayoutChanged == true{
        //            self.layoutButton.setBackgroundImage(smallLayout, for: .normal, barMetrics: .default)
        //        }else {
        //            self.layoutButton.setBackgroundImage(bigLayout, for: .normal, barMetrics: .default)
        //
        //        }
    }
    
    
    
    private func prepareCollectionView() {
        GameListCollectionView.dataSource = self
        GameListCollectionView.delegate = self
        if isLayoutChanged == true{
            GameListCollectionView.register(cellType: SmallCardCollectionViewCell.self)
        }else {
            GameListCollectionView.register(cellType: GameListCollectionViewCell.self)
            
            
        }
    }
    
    private func prepareNavigationBar(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 0.94)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
    private func prepareSearchController() {
        let searchController = UISearchController(searchResultsController: nil)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).tintColor = UIColor.white
        searchController.searchResultsUpdater = self
        
    }
    
    private func fetchGames() {
        networkManager.request(endpoint: .homepage(query: ""), type: HomeResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.home = response
                self?.results = response.results
                self?.nextPage = response.next
                self?.GameListCollectionView.reloadData()
                //print(response)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    private func paginate(next: String) {
        networkManager.request(endpoint: .pagination(query: next), type: HomeResponse.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.results?.append(contentsOf: response.results ?? [])
                self?.nextPage = response.next
                self?.GameListCollectionView.reloadData()
                //print(response)
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    
    private func fetchSuggestions(keyword: String) {
        networkManager.request(endpoint: .suggestions(keyword: keyword), type: HomeResponse.self){ [weak self](result) in
            switch result {
            case .success(let suggestion):
                self?.results = suggestion.results
                self?.GameListCollectionView.reloadData()
                break
            case .failure(let error):
                print(error)
                break
            }
            
        }
        
    }
    
    private func calculateCellHeight() -> CGFloat {
        if isLayoutChanged {
            let cellWidth = (GameListCollectionView.frame.width - (Constants.leftPadding + Constants.rightPadding + Constants.rightPadding)) / 2
            let bannerImageHeight = cellWidth * 1
            let cellHeight = 72 + bannerImageHeight
            return cellHeight
            
        }else {
            let cellWidth = GameListCollectionView.frame.width - (Constants.leftPadding + Constants.rightPadding)
            let bannerImageHeight = cellWidth * Constants.cellBannerImageViewAspectRatio
            let cellHeight = Constants.cellDescriptionViewHeight + bannerImageHeight
            
            return cellHeight
        }
    }
    
    private func calculateCellWidth() -> CGFloat {
        if isLayoutChanged {
            let cellWidth = (GameListCollectionView.frame.width - (Constants.leftPadding + Constants.rightPadding + Constants.rightPadding)) / 2
            return cellWidth
        }else {
            let cellWidth = GameListCollectionView.frame.width - (Constants.leftPadding + Constants.rightPadding)
            return cellWidth
        }
    }
    
    
    
    
    
    @IBAction func layoutButtonTapped(_ sender: Any) {
        self.isLayoutChanged = !self.isLayoutChanged
        prepareCollectionView()
        fetchGames()
    }
    
}

extension HomeViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        results?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if isLayoutChanged == true {
            let cell = collectionView.dequeCell(cellType: SmallCardCollectionViewCell.self, indexPath: indexPath)
            if let results = results?[indexPath.item]{
                cell.configure(results: results)
            }
            return cell
        }else {
            let cell = collectionView.dequeCell(cellType: GameListCollectionViewCell.self, indexPath: indexPath)
            if let results = results?[indexPath.item]{
                cell.configure(results: results)
            }
            return cell
        }
    }
}

extension HomeViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: calculateCellWidth(), height: calculateCellHeight())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 16 , left: Constants.leftPadding, bottom: 16, right: Constants.rightPadding)
    }
}

extension HomeViewController: UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let results = results else {return }
        if indexPath.item == (results.count - 2) {
            paginate(next: nextPage ?? "")
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print("tapped")
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        if let detailVC = storyBoard.instantiateViewController(withIdentifier: "DetailVC") as? GameDetailViewController {
            detailVC.query = results?[indexPath.item].id ?? 0
            detailVC.indexPath = indexPath.item
            self.navigationController?.pushViewController(detailVC, animated: true)
        }
    }
}
extension HomeViewController: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        fetchSuggestions(keyword: "\(searchController.searchBar.text ?? "")")
        if !searchController.isActive {
            fetchGames()
        }
    }
}


