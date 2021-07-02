//
//  SmallCardCollectionViewCell.swift
//  Final-Project
//
//  Created by Yavuz Alp GÜLER on 6.06.2021.
//

import UIKit
import SDWebImage
import CoreData


public var isWishlist = false

class SmallCardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var gameNameLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var wishlistView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        prepareContainerView()
        
    }
    
    func configure(results: Result) {
        gameNameLabel.text = results.name
        prepareImageView(with: results.backgroundImage)
    }
    
    func configureWishlist(names: String?, images: Data?) {
        gameNameLabel.text = names
        imageView.image = UIImage(data: images!)
        //prepareImageView(with: wishes.backgroundImage)
    }
    
    
    private func prepareImageView(with urlString: String?){
        if let imageUrlString = urlString, let url = URL(string: imageUrlString){
            imageView.sd_setImage(with: url)
        }
    }
    
    private func prepareContainerView() {
        containerView.layer.cornerRadius = 4.0
        containerView.layer.borderWidth = 1.0
        containerView.layer.borderColor = UIColor.clear.cgColor
        containerView.layer.masksToBounds = true
        
    }
    
    @IBAction func insertWishlist(_ sender: Any) {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        
        isWishlist = !isWishlist
        
        if isWishlist == true {
            
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


//extension HomeViewController: UICollectionViewDelegate {
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        if isWishlist == false {
//
//            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
//            let context = appDelegate.persistentContainer.viewContext
//
//            context.delete(objects[indexPath.item])
//
//            do {
//                try context.save()
//            } catch {
//                print("Silinemedi")
//            }
//
//
//
//
//        }
//    }
//}

