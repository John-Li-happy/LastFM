# LastFM
LastFM is a open source music player application built in iOS enviroment, allows user enjoy or scrobble multi-directional music.

## IDE
Xcode 11.6

Swift 5.3

Objective-C 2.0

Better deployed on iPhone 8 or later version

## Features
### Launch Screen
 - Animation, as well as static logo is implemented in launch screen
### Login Screen
 - Allow user input user-name and password to get assess into lastFM APIs
 - Hide user sensitive imformation (e.g. password)
 - Allow user to create new account by going to the website
### Top Track Screen
 - Display user-interest-directional songs
 - Display most-popular songs
 - Search feature is avaliable at navigation bar
 - Dynamic constraints is applied
 - SkeletonView is implemented
 - MusicPlayer screen is attached into each-tap
### Album Screen
 - Display user-interest-directional albums
 - Display most-popular albums
 - ViewAll is available to show user more information of current catogory
 - Search feature is avaliable at navigation bar
 - Album-detail screen is attached into each-tap
### Artist Screen
 - Display most-popular artists
 - Allow filter based on user-interest
 - Artist-detail screen is attached into each-tap
### User Detail Screen
 - Display user basic info (e.g. avatar, gender, age, country)
 - Logout feature is implemented 
 - Display list of user-recent-tracks
 - Display user-faverate artists
 - Display top-songs that user listened
 - Detail screens are attached to all-taps
### Search Screen
 - Display song list based on user-typed keyword(s)
 - Display album list based on user-typed keyword(s)
### Music Player Screen
 - Play music based on user-chosen
 - Allow user to share this song link through multiple-social media
 - Basic song info is displayed on animated UI
 - Multiple cycle is allowed to choose: sequencial, single, shuffle
 - NotificationCenter & ControlCenter is displaying music info, and both allow user control the play state
 - Landscape is forbidden in this screen
 - EsternEgg is implemented in this screen
 - Volume control is activated in
## API References

> https://www.last.fm/api

> https://developers.deezer.com/

## Technologies
- Model-View-ViewModel (MVVM)
- Singleton
- Observation
- Delegation

## Frameworks
- SwiftyGif
- UIkit
- AVAudioPlayer
- MediaPlayer
- SafariServices
- SkeletonView

## Contribution
[John-Li-happy](https://github.com/John-Li-happy) takes responsibility of top-track-screen and its attached screens; music-player-screen; top-album-screen and its attached screens; search-result-screen and its attached screens, artist attached screens designing;

[DevShawnX](https://github.com/DevShawnX) takes responsibility of launch-screen; user-detail-screen desinging.

[ShawnLiii](https://github.com/ShawnLiii) takes responsibility of login-screen desinging.

[lvbeauty](https://github.com/lvbeauty) takes responsibility of artist-screen desinging

## Permission

The main purpose of this project is to bring enjoyment to those who enjoys music, also to offer a good chance for developers who is also interested in iOS developing to discuss. This is an open source project, but it is not allowed to use it as any commercial-purposes.


