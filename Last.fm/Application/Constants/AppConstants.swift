//
//  AppConstants.swift
//  Last.fm
//
//  Created by Shawn Li on 8/31/20.
//  Copyright © 2020 Amol Prakash. All rights reserved.
//

import UIKit

enum AppConstants {
    // MARK: - Storyboard
    enum ImageName {
        static let checkedSystemImageViewName = "checkmark.square.fill"
        static let uncheckedSystemImageViewName = "square.fill"
        static let checkedImageViewName = "checked"
        static let uncheckedImageViewName = "unchecked"
        static let eyeOpenSystemImageViewName = "eye"
        static let eyeClosedSystemImageViewName = "eye.slash"
        static let eyeOpenImageViewName = "eye_open"
        static let eyeClosedImageViewName = "eye_closed"
        static let singerImageViewName = "SingerExample"
        static let errorCoverImageViewName = "ComeBackLater"
        static let unfetchedImageName = "unfetchedImage"
    }
    // MARK: - LastFMAPI URL and Parameters
    enum LastFMAPI {
        static let forgetPasswordUrl = "https://www.last.fm/settings/lostpassword"
        static let registerUrl = "https://www.last.fm/join?next=/"
        static let apiRootUrl = "https://ws.audioscrobbler.com/2.0/"
        static let apiKey = "1d7f7a0a7bb5a1bd972a6d108a76cc9a"
        static let sharedSecret = "cb4a668c04adfadaf8b96212753b9873"
        static let trackBackUp = "Believe"
        static let singerBackUp = "Cher"
        static let format = "json"
        static let limitTen = "10"
        static let limitTwenty = "20"
        static let limitThirty = "30"
        static let limitForty = "40"
        static let country = "United States"
        static let topTrackCountry = "India"
        static let backUpTag = "Waltz"
        static let backTag = "Disco"
    }
    // MARK: - LastFMAPI Methods
    enum LastFMAPIMethod {
        // login methods
        static let getMobileSession = "auth.getMobileSession"
        // GEO Methods
        static let getGEOTopArtists = "geo.gettopartists"
        static let getTopTracks = "geo.getTopTracks"
        // Artist Methods
        static let getArtistInfo = "artist.getinfo"
        static let getArtistTopAlbums = "artist.gettopalbums"
        static let getArtistTopTracks = "artist.gettoptracks"
        static let getArtistSimilar = "artist.getsimilar"
        static let getArtistSearch = "artist.search"
        // User Methods
        static let getUserInfo = "user.getinfo"
        static let getUserRecentTracks = "user.getrecenttracks"
        static let getUserTopArtists = "user.gettopartists"
        static let getUserTopTracks = "user.gettoptracks"
        static let getUserTopAlbums = "user.getTopAlbums"
        // Track Methods
        static let getSimiliar = "track.getSimilar"
        static let search = "track.search"
        // Tag Methods
        static let getTagTopAlbums = "tag.getTopAlbums"
    }
    // MARK: - Login Key for KVC
    enum LoginKey {
        static let loginStatusKey = "loginStatus"
        static let rememberStatusKey = "isRemember"
        static let usernameKey = "username"
        static let sessionKey = "sessionKey"
    }
    // MARK: - Storyboard Identifier
    enum StoryboardID {
        static let mainStoryboard = "Main"
        static let mainTabBarController = "MainTabBarViewController"
        //Login Page
        static let loginViewController = "LoginViewController"
        //Discover Page
        static let discoverNavigationController = "DiscoverNavigationController"
        static let discoverViewController = "DiscoverViewController"
        //Album Page
        static let albumNavigationController = "AlbumNavigationController"
        static let albumDetailViewController = "AlbumDetailViewController"
        //Artist Page
        static let topArtistsNavigationController = "TopArtistsNavigationController"
        static let topArtistsViewController = "TopArtistsViewController"
        //Segue ID
        static let showArtistDetailSegue = "ShowArtistDetailSegue"
        //Artist Detail Page
        static let artistDetailViewController = "ArtistDetailViewController"
        //Profile Page
        static let profileNavigationController = "ProfileNavigationController"
        static let profileViewController = "ProfileViewController"
        //Music Player Page
        static let musicPlayerViewController = "MusicPlayeViewController"
    }
    
    // MARK: - Artist Detail Page
    enum ArtistDetail {
        static let heightForHeader: CGFloat = 80
        static let artistDetailViewForHeaderName = "ViewForHeaderInSection"
    }
}
