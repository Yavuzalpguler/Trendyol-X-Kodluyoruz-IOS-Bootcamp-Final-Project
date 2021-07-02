//
//  WishListViewController.swift
//  Final-Project
//
//  Created by Yavuz Alp GÜLER on 6.06.2021.
//

import UIKit
import CoreData


public var objects = [NSManagedObject]() // Cirkin bir cozum oldu ama zaman kisitindan oturu hizlica yapmak istedim :(


extension WishListViewController {
    fileprivate enum Constants {
        static let cellWidth: CGFloat = 358
        static var cellDescriptionViewHeight: CGFloat = 159
        static var cellBannerImageViewAspectRatio: CGFloat = 201/358
        static let leftPadding: CGFloat = 16
        static let rightPadding: CGFloat = 16
    }
}

class WishListViewController: UIViewController {
    
    @IBOutlet weak var wishlistCollectionView: UICollectionView!
    
    private var wishes: [Wishes]?
    
    private var names = [String]()
    private var images = [Data]()

    override func viewDidLoad() {
        super.viewDidLoad()
        fetchWishlistData()
        prepareCollectionView()
        prepareNavigationBar()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        fetchWishlistData()
    }
    
    private func prepareNavigationBar(){
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 29/255, green: 29/255, blue: 29/255, alpha: 0.94)
        appearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.standardAppearance = appearance
        navigationItem.scrollEdgeAppearance = appearance
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        
    }
    
    private func prepareCollectionView() {
        wishlistCollectionView.dataSource = self
        wishlistCollectionView.delegate = self
        wishlistCollectionView.register(cellType: SmallCardCollectionViewCell.self)
        
    }
    
    private func fetchWishlistData() {
        names.removeAll()
        images.removeAll()
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Wishlist")
        
        do {
            let results = try context.fetch(fetchRequest)

            if results.count > 0 {
                for result in results as! [NSManagedObject] {
                    guard let gameName = result.value(forKey: "gameName") as? String else { return }
                    guard let gameImage = result.value(forKey: "gameImage") as? Data else {
                        return
                    }
                    objects.append(result)
                    

                    //wishes = [Wishes.init(names: gameName, backgroundImage: gameImage)]
                    names.append(gameName)
                    images.append(gameImage)
                }
                self.wishlistCollectionView.reloadData()
            }else {
                //TODO:
            }
        } catch {
            print("error")
        }
    }
    
    private func calculateCellHeight() -> CGFloat {
        let cellWidth = (wishlistCollectionView.frame.width - (Constants.leftPadding + Constants.rightPadding + Constants.rightPadding)) / 2
        let bannerImageHeight = cellWidth * 1
        let cellHeight = 72 + bannerImageHeight
        
        return cellHeight
        
        
    }
    
    private func calculateCellWidth() -> CGFloat {
        let cellWidth = (wishlistCollectionView.frame.width - (Constants.leftPadding + Constants.rightPadding + Constants.rightPadding)) / 2
        
        return cellWidth
    }
    
   
    
}

extension WishListViewController: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        names.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeCell(cellType: SmallCardCollectionViewCell.self, indexPath: indexPath)
       
        cell.configureWishlist(names: names[indexPath.item], images: images[indexPath.item])
    
        
        return cell
    }
}

extension WishListViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        .init(width: calculateCellWidth(), height: calculateCellHeight())
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        .init(top: 16 , left: Constants.leftPadding, bottom: 16, right: Constants.rightPadding)
    }
}

extension WishListViewController: UICollectionViewDelegate{
    
}
