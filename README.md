# Bilibili API iOS
iOS version of the Bilibili API project
## Current version
- 1.0

## Getting started
### Prerequisites
- Xcode 9.0
- iOS 11
- Swift 4

Note: not fully tested on iOS 10 or below, but most features should be compatible.
### Run
- Open the project in Xcode, or by double-clicking `BilibiliAPI.xcodeproj`.
- Run on any iPhone simulator or a real iPhone (again, iOS 11 is recommended).

## Instructions
Introduction to some major scenes.
### Start up
- Tab container is used
- Navigation container is used 
### Video / User Main Controller Scene
- Load favorite videos / users with `UserDefault`
- Swipe to delete
- Tap searching field or video / user in the table to segue to Video / User Search Scene
- Table view delegate is used
### Video / User Search Controller Scene
- Visit multiple bilibili.com APIs to load information upon tapping the Search button
- Tap the star icon to add current video / user to the favorite list (or remove)
- Tap any table cell with a disclosure indicator to segue to another scene
- `draw` function is used in `UserLevelInfoView` to draw the experience bar
- Animation is also used on `UserLevelInfoView` when it is loaded
### WebKit Controller Scene
- Visit the webpage of a given video ID
- Progress bar is used to display the loading progress of the webpage
### Setting Controller Scene
- Set whether or not to download images
- Clear favorite video / user list


## Develop
There are more features being added to this app.
- Optimize "database"
- Enable tapping after Video / User Search Scene is fully loaded
- More settings
- ...
