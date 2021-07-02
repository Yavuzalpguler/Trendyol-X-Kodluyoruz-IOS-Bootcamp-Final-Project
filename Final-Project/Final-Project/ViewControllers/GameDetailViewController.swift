//
//  GameDetailViewController.swift
//  Final-Project
//
//  Created by Yavuz Alp GÜLER on 6.06.2021.
//

import UIKit
import CoreApi
class GameDetailViewController: UIViewController {

    let networkManager: NetworkManager<HomeEndpointItem> = NetworkManager()

    @IBOutlet weak var bannerImage: UIImageView!
    @IBOutlet weak var gameName: UILabel!
    @IBOutlet weak var descriptionField: UITextView!
    
    @IBOutlet weak var ReleaseLabel: UILabel!
    @IBOutlet weak var GenreLabel: UILabel!
    @IBOutlet weak var PlayTimeLabel: UILabel!

    
    @IBOutlet weak var ReleaseInfoLabel: UILabel!
    @IBOutlet weak var GenreInfoLabel: UILabel!
    @IBOutlet weak var PlayTimeInfoLabel: UILabel!
    
    @IBOutlet weak var thinLineView1: UIView!
    @IBOutlet weak var thinLineView2: UIView!
    
    @IBOutlet weak var releaseView: UIView!
    @IBOutlet weak var genresView: UIView!
    @IBOutlet weak var playTimeView: UIView!
    
    @IBOutlet weak var firstDividerView: UIView!
    @IBOutlet weak var secondDividerView: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchGames()
    }
    
    
    var query: Int?
    var indexPath: Int?

    private var results: Result?
    
  
    

    private func fetchGames() {
        networkManager.request(endpoint: .detail(query: String(query ?? 0)), type: Result.self) { [weak self] result in
            switch result {
            case .success(let response):
                self?.results = response
                break
            case .failure(let error):
                print(error)
                break
            }
        }
    }
    
    func configure(results: Result) {
        gameName.text = results.name
    }

}

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */


