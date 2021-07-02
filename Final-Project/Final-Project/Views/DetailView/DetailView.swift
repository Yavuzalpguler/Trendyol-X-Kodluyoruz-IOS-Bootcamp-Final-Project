//
//  DetailView.swift
//  Final-Project
//
//  Created by Yavuz Alp GÜLER on 27.05.2021.
//

import UIKit

final class DetailView: NibView{
    
    @IBOutlet weak var ReleaseLabel: UILabel!
    @IBOutlet weak var GenreLabel: UILabel!
    @IBOutlet weak var PlayTimeLabel: UILabel!

    
    @IBOutlet weak var ReleaseInfoLabel: UILabel!
    @IBOutlet weak var GenreInfoLabel: UILabel!
    @IBOutlet weak var PlayTimeInfoLabel: UILabel!
    
    @IBOutlet weak var releaseView: UIView!
    @IBOutlet weak var genresView: UIView!
    @IBOutlet weak var playTimeView: UIView!
    
    @IBOutlet weak var firstDividerView: UIView!
    @IBOutlet weak var secondDividerView: UIView!
    
    
    
    func configure(releaseDate: String? ,
                   genre: [Genre]? ,
                   playTime: Int? ){
        
        
        // TODO: Thinlinelar icin de isHidden ekle
        
        if let releaseDate = releaseDate {
            ReleaseInfoLabel?.text = releaseDate
        } else {
            releaseView.isHidden = true
            firstDividerView.isHidden = true
        }
        
        if let genre = genre {
            var arr2 = [String]()
            for genres in genre{
                arr2.append(genres.name ?? "")
            }
            self.GenreInfoLabel?.text = arr2.map{ $0 }.joined(separator: ",")

            
        } else {
            genresView.isHidden = true
            firstDividerView.isHidden = true
        }
        
        if let playTime = playTime {
            PlayTimeInfoLabel?.text = String(playTime) + " Hours"
        } else{
            playTimeView.isHidden = true
            secondDividerView.isHidden = true
        }
        
        
    }
       
            
}

