
# iOS App - SpaceX Exercise

The SpaceX Exercise app is a small application that fetches and displays a list of SpaceX launches and company related data from [SpaceX API](https://github.com/r-spacex/SpaceX-API). The app is built using Swift, SwiftUI and Combine.

## Environment Requirements
- Swift 5+
- Xcode 13.2+
- iOS 15.0+

## Dependency Management & Dependencies

The project uses Swift Package Manager as its dependency manager.

### Dependencies
- [Resolver](https://github.com/hmlongco/Resolver) (Dependency Injection)

- [Rapide](https://github.com/rorodriguez116/Rapide) (Networking)

- [Kingfisher](https://github.com/onevcat/Kingfisher) (Image Download)

## Dependency Injection

The project uses Resolver as its dependency injection system. For unit testing Resolver is configured to use mock version of some objects to perform testing.  

## SwiftUI Previews
Most if not all views have SwiftUI Previews enabled, to preview them please choose SpaceX-Dev build scheme as SpaceX build scheme is not prepared for previews.

## Features
The app displays company details and a list of launches fetched from the API. 
- Load launches from SpaceX API.
- Match launches with their rocket data.
- Filter launches based on status and year.
- Sort launches. 
- Watch launch webcast.
- Open the wikipedia page of a selected launch.
- Open a web article on a selected launch.


## UnitTests
The project has unit test coverage for all Models, ViewModels and Repositories.
  

## UITests
The project has UI tests written for main flows, such as filtering launches based on year and opening pages related to a launch, like a video.

