//
//  GameListCollectionViewCell.swift
//  Final-Project
//
//  Created by Yavuz Alp GÜLER on 27.05.2021.
//

import UIKit
import SDWebImage
import CoreData

class GameListCollectionViewCell: UICollectionViewCell {
    
    
    @IBOutlet weak var scoreContainer: UIView!
    @IBOutlet weak var tagCollectionView: UICollectionView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var scoreView: UIView!
    @IBOutlet private weak var scoreLabel: UILabel!
    @IBOutlet private weak var detailView: DetailView!
    @IBOutlet private weak var gameNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var wishlistView: UIView!
    
    private var resultsArray: [Result]?
    
    private var isWishlist = false
    
    
    private var results: Result?
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareCollectionView()
        prepareContainerView()
        
    }
    
    private func prepareContainerView() {
        containerView.layer.cornerRadius = 8.0
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.masksToBounds = true
        
    }
    
    private func prepareCollectionView() {
        tagCollectionView.dataSource = self
        tagCollectionView.delegate = self
        
        tagCollectionView.register(cellType: TagViewCollectionViewCell.self)
    }
    
    
    
    func configure(results: Result) {
        gameNameLabel.text = results.name
        prepareImageView(with: results.backgroundImage)
        prepareDetailView(releaseDate: results.released, genre: results.genres, playTime: results.playtime)
        prepareScoreLabel(with: results.metacritic)
        self.results = results
        self.resultsArray = [results]
        
    }
    
    private func prepareImageView(with urlString: String?){
        if let imageUrlString = urlString, let url = URL(string: imageUrlString){
            imageView.sd_setImage(with: url)
            containerView.layer.cornerRadius = 20
        }
    }
    
    private func prepareScoreLabel(with metacritic: Int?){
        if let metacritic = metacritic {
            scoreLabel.text = String(metacritic)
            scoreView.layer.borderWidth = 1
            scoreView.layer.cornerRadius = 4
            
            if (metacritic > 75) {
                scoreLabel.textColor = .green
                scoreView.layer.borderColor = UIColor.green.cgColor
            }else if (metacritic <= 75) && (metacritic > 50) {
                scoreLabel.textColor = .yellow
                scoreView.layer.borderColor = UIColor.yellow.cgColor
            }else {
                scoreLabel.textColor = .red
                scoreView.layer.borderColor = UIColor.red.cgColor
            }
        }
    }
    
    private func prepareDetailView(releaseDate: String?,
                                   genre: [Genre]?,
                                   playTime: Int?){
        if let releaseDate = releaseDate, let genre = genre, let playTime = playTime{
            detailView.configure(releaseDate: releaseDate, genre: genre, playTime: playTime)
        }
        
    }
    
    
    
    
    @IBAction func insertWishlist(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        self.isWishlist = !self.isWishlist
        
        if self.isWishlist == true {
            
            let newGame = NSEntityDescription.insertNewObject(forEntityName: "Wishlist", into: context)
            newGame.setValue(gameNameLabel.text, forKey: "gameName")
            let newGameImage = imageView.image?.jpegData(compressionQuality: 0.5)
            newGame.setValue(newGameImage, forKey: "gameImage")
            
            do {
                try context.save()
            }catch {
                print("Kaydedilemedi")
            }
            
            self.wishlistView.backgroundColor = .green
            
        }else {
            
            //            let nameToDelete = gameNameLabel.text
            //            let imageToDelete = imageView.image
            //            context.delete(objects[1])
            //
            //            do {
            //                try context.save()
            //            } catch {
            //                print("Silinemedi")
            //            }
            
            
            
            self.wishlistView.backgroundColor = .red
        }
        
    }
}


extension GameListCollectionViewCell: UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        results?.parentPlatforms?.count ?? .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeCell(cellType: TagViewCollectionViewCell.self, indexPath: indexPath)
        if let platforms = results?.parentPlatforms?[indexPath.item]{
            
            cell.configure(parentPlatform: platforms )
        }
        
        return cell
    }
}

extension GameListCollectionViewCell: UICollectionViewDelegate{
    
}

extension GameListCollectionViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 2
        
    }
    
    
}


