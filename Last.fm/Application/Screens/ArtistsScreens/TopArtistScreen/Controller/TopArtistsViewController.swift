//
//  TopArtistsViewController.swift
//  Last.fm
//
//  Created by Tong Yi on 8/14/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import SVProgressHUD
import UIKit

class TopArtistsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    //Stored Property
    var viewModel = TopArtistViewModel()
    var searchController = UISearchController(searchResultsController: nil)
    //Computed Property
    var isSearchBarEmpty: Bool {
       searchController.searchBar.text?.isEmpty ?? true
    }
    var isSearching: Bool {
       searchController.isActive && !isSearchBarEmpty
    }
    
    @IBOutlet weak private var collectionView: UICollectionView!
    @IBOutlet weak private var searchButton: UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // set up
        setupUI()
        setupData()
        setupCollectionViewFlowLayout()
    }
    
    @IBAction private func searchButtonTapped(_ sender: UIBarButtonItem) {
        searchController = UISearchController(searchResultsController: nil)

        // Set any properties (in this case, don't hide the nav bar and don't show the emoji keyboard option)
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.keyboardType = UIKeyboardType.asciiCapable
        searchController.searchBar.barStyle = .black
        searchController.searchBar.backgroundColor = .init(red: 24 / 255, green: 27 / 255, blue: 43 / 255, alpha: 1)
        searchController.searchBar.tintColor = UIColor.white.withAlphaComponent(0.8)
        searchController.searchBar.textContentType = .name

        // Make this class the delegate and present the search
        self.searchController.searchBar.delegate = self
        present(searchController, animated: true, completion: nil)
    }
    
    func setupUI() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.view.backgroundColor = .init(red: 24 / 255, green: 27 / 255, blue: 43 / 255, alpha: 1)
        //SVPProgressHUD set container view
        SVProgressHUD.setContainerView(self.view)
        //SVPProgressHUD show
        SVProgressHUD.show()
    }
    
    func setupData() {
        //fetch data
        viewModel.fetchTopArtistData { [weak self] error in
            guard let weakSelf = self else { return }
            
            DispatchQueue.main.async {
                if error != nil {
                    AlertManager.alert(forWhichPage: weakSelf, alertType: .serviceError, alertMessage: error?.localizedDescription, handler: nil)
                }
                
                weakSelf.collectionView.reloadData()
                //SVPProgressHUD dismiss
                SVProgressHUD.dismiss()
            }
        }
    }
    
    func setupCollectionViewFlowLayout() {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: (self.view.bounds.width - 80) / 2, height: 90)
        layout.sectionInset = UIEdgeInsets(top: 20, left: 30, bottom: 20, right: 30)
        layout.minimumLineSpacing = 20
        layout.minimumLineSpacing = 20
        collectionView.collectionViewLayout = layout
        collectionView.backgroundColor = .init(red: 24 / 255, green: 27 / 255, blue: 43 / 255, alpha: 1)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isSearching {
            return viewModel.filteredArtists.count
        } else {
            return viewModel.dataSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TopArtistsCollectionViewCell.reuseIdentifier, for: indexPath) as? TopArtistsCollectionViewCell
        guard let artistCell = cell else { return UICollectionViewCell() }
        let artist = viewModel.dataSource[indexPath.row]
        
        if isSearching {
            let filterArtist = viewModel.filteredArtists[indexPath.row]
            cell?.configureCell(artist: filterArtist)
        } else {
            cell?.configureCell(artist: artist)
        }
        
        return artistCell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = viewModel.dataSource[indexPath.row]
        performSegue(withIdentifier: AppConstants.StoryboardID.showArtistDetailSegue, sender: item)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let item = sender as? Artist else { return }
        if segue.identifier == AppConstants.StoryboardID.showArtistDetailSegue {
            guard let artistVC = segue.destination as? ArtistDetailViewController else { return }
            artistVC.artist = item
        }
    }
}

extension TopArtistsViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.filteredArtists = viewModel.dataSource.filter { $0.name.prefix(searchText.count) == searchText }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        navigationItem.searchController = nil
        collectionView.reloadData()
    }
}
