# SportsEvents

iOS app built with Swift and UIKit, showing live sports events categorized by sport types. The user can navigate vertically and horizontally through the sports and events, they can also favorite/unfavorite events, collapse/open sports categories. 
## Features

- Display sports events organized by categories, such as Soccer, Basketball, and Tennis.
- Collapsible sections for each sports category.
- Horizontal scrolling of events within each section.
  - Display upcoming events and those that occurred within the past day.
- Favorite/unfavorite events and reordering events to show favorite first.
- Countdown timer for each event.
  - Notify users when the event starts.
  - Display events that are currently ongoing or took place earlier today.
- Toast messages to notify the user when events are added or removed from favorites.
  
## Architecture

The app use the MVVM (Model-View-ViewModel) architecture pattern.

## Technologies Used

- Swift
- UIKit
- Combine
- Dependency Injection
- Async/Await

# Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/luizvasconcellos/SportsEvents.git
2. **Open the project in Xcode**
   ```bash
   cd SportsEventsApp
   open SportsEventsApp.xcodeproj
3. **Build and run the app**
   - Choose the simulator or device
   - Run the project

# Screenshots

<img src="https://github.com/luizvasconcellos/SportsEvents/blob/main/SportsEvents/SportsEvents.gif" align="center" height="543" width="251"/>

# Licence
This project is licensed under the MIT License. See the LICENSE file for more details.
