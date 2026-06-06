<div align="center">

# 🏆 Sportiva App ⚽🏀🎾🏏
**"Your Ultimate Pocket Companion for the World's Greatest Sports!"**

[![Swift](https://img.shields.io/badge/Swift-5.0-FA7343.svg?style=for-the-badge&logo=swift)](https://swift.org)
[![UIKit](https://img.shields.io/badge/UIKit-Compositional%20Layouts-007AFF.svg?style=for-the-badge&logo=apple)](https://developer.apple.com/ios/)
[![MVP Architecture](https://img.shields.io/badge/Architecture-MVP-success.svg?style=for-the-badge)]()
[![CoreData](https://img.shields.io/badge/Database-CoreData-yellow.svg?style=for-the-badge)]()
[![Testing](https://img.shields.io/badge/Coverage-%3E90%25%20XCTest-red.svg?style=for-the-badge)]()

<br><br>

</div>

<div align="center">
  <table style="border: none;">
    <tr>
      <td align="center" width="100">
        <img src="https://img.icons8.com/color/96/000000/stadium-.png" width="85" alt="Sports App Mascot" />
      </td>
      <td align="left">
        <strong>A robust, cleanly architected iOS sports tracking application.</strong><br>
        Designed, engineered, tested, and shipped by the duo: <strong>Mazen Amr</strong> & <strong>Ahmed Tayseer</strong>.
      </td>
    </tr>
  </table>
</div>

<br>

---

## 🤝 The Dream Team (Developer Credentials)

This project is the result of intensive pair programming and a shared passion for clean code. Every aspect of this repository was carefully crafted by Mazen Amr and Ahmed Tayseer:

* **💻 Architecture & Engineering:** Implemented strict MVP (Model-View-Presenter) architecture, ensuring zero business logic in the UI layer.
* **🎨 UI/UX & Asset Design:** Built using a mix of Storyboards, modular XIBs, and advanced `UICollectionViewCompositionalLayout` for complex, highly responsive scrolling sections.
* **💾 Data Management:** Seamless integration of Alamofire for networking, paired with Core Data for persistent local storage of user favorites.
* **🧪 Documentation & Quality Assurance:** Achieved **>90% Unit Test Coverage** across Presenters and Services using XCTest, Mock Views, and Custom URLProtocols.

---

## 📸 App Showcase

### 🌙 Dark Mode

| Onboarding | Home (Sports) | Leagues List |
| :---: | :---: | :---: |
| <img src="https://via.placeholder.com/250x500.png?text=Onboarding+Screen" alt="Onboarding" width="250"> | <img src="https://via.placeholder.com/250x500.png?text=Home+Screen" alt="Home Screen" width="250"> | <img src="https://via.placeholder.com/250x500.png?text=Leagues+Search" alt="Leagues Search" width="250"> |

| League Details | Team / Player Profile | Favorites (CoreData) |
| :---: | :---: | :---: |
| <img src="https://via.placeholder.com/250x500.png?text=Compositional+Layout" alt="League Details" width="250"> | <img src="https://via.placeholder.com/250x500.png?text=Team+Details" alt="Team Details" width="250"> | <img src="https://via.placeholder.com/250x500.png?text=Saved+Favorites" alt="Favorites" width="250"> |

### ☀️ Light Mode & Localization (Arabic RTL)

| Settings | Arabic RTL Mode | Empty States |
| :---: | :---: | :---: |
| <img src="https://via.placeholder.com/250x500.png?text=Settings+Screen" alt="Settings" width="200"> | <img src="https://via.placeholder.com/250x500.png?text=Arabic+Layout" alt="Arabic RTL" width="200"> | <img src="https://via.placeholder.com/250x500.png?text=No+Network/Data" alt="Empty States" width="200"> |

---

## 📜 The Playbook (Core Features)

* **🌍 Real-Time Sports Data:** Live fetching of Leagues, Upcoming Fixtures, Latest Results, and Team Rosters via the AllSports API.
* **🎾 Dedicated Tennis Engine:** Custom parsing and UI logic specifically tailored for Tennis players, showcasing complex statistics and tournament histories.
* **💾 Offline Favorites (Core Data):** Save your favorite leagues with a tap. Data is securely cached locally, grouped by sport, and accessible even without a network connection.
* **🔍 Instant Search & Filtering:** Filter through hundreds of global leagues instantly with a highly optimized local search algorithm.
* **⚙️ Dynamic Localization & Settings:** Switch between English (LTR) and Arabic (RTL) seamlessly with smooth `UIView.transition` animations. Toggle Dark/Light mode instantly, with all preferences saved safely in `UserDefaults`.
* **🚫 Bulletproof Error Handling:** Elegant Empty States and Reachability checks ensure the user is always informed if the network drops or an API returns an empty array.

---

## ⚙️ The Game Engine (Architecture & Tech Stack)

The codebase strictly adheres to the **Model-View-Presenter (MVP)** design pattern to ensure ultimate scalability, testability, and separation of concerns.

### 🔄 The Data Flow (MVP Architecture)

1. **View (`ViewController`):** Entirely passive. It handles UIKit rendering, intercepts user actions (taps, swipes, typing), and immediately passes them to the Presenter via Protocols.
2. **Presenter:** The "Brain". It receives view events, requests data from the Services, processes the raw data (e.g., grouping players by position, filtering completed vs. upcoming matches), and formats it into Enum-driven UI states.
3. **Services (Network & Local):**
   * **NetworkService:** Utilizes **Alamofire** with Generic Decodables (`<T: Decodable>`) to fetch and parse JSON payloads.
   * **CoreDataManager:** Handles all SQLite persistent storage (Save, Fetch, Delete) for favorite leagues.

### 🧰 Tech Stack

| Category | Technology |
| :--- | :--- |
| **Language** | Swift 5 |
| **UI Toolkit** | UIKit (Storyboards, XIBs, `UICollectionViewCompositionalLayout`) |
| **Architecture** | MVP (Model-View-Presenter) |
| **Networking** | Alamofire (5.10.2) |
| **Image Caching** | SDWebImage (5.21.7) |
| **Local Persistence** | CoreData, UserDefaults |
| **Network Monitoring** | Reachability |
| **Testing** | XCTest, MockURLProtocol |

### 🏗️ Package Structure

```text
SportsApp
│
├── App                 // AppDelegate, SceneDelegate, Constants
├── Services            // NetworkService, CoreDataManager, UserDefaultsManaging
├── Models              // LeagueModel, TeamModel, EventModel, TennisPlayerModel
├── Utils               // Extensions, Localization Helpers
│
├── Modules             // Feature-Based Modules
│   ├── OnBoarding      // PageViewController logic
│   ├── HomeScreen      // Grid of available sports
│   ├── LeaguesScreen   // Searchable list of leagues
│   ├── LeagueDetails   // Complex Compositional Layout (Teams, Upcoming, Latest)
│   ├── TeamDetails     // Roster grouped by position (Goalkeeper, Defender, etc.)
│   ├── TennisPlayer    // Specialized layout for Tennis stats/tournaments
│   ├── Favourites      // CoreData fetched results grouped by sport
│   └── Settings        // Dark Mode & App Language toggles
│
└── SportsAppTests      // 90%+ Coverage (Mocks, Presenter Tests, Service Tests)
    ├── MockServices
    ├── HomeTest
    ├── LeaguesTest
    ├── LeagueDetailsTest
    ├── TeamDetailsTest
    ├── TennisPlayerTest
    ├── FavouritesTest
    └── SettingsTest
```

---

## 🎨 Modern Interfaces (Bespoke UI Design)

Instead of relying on basic TableViews, we engineered dynamic and engaging interfaces using Apple's modern layout systems.

* **Compositional Layouts:** The `LeagueDetails` and `TennisPlayer` screens utilize `UICollectionViewCompositionalLayout` to seamlessly mix orthogonal scrolling carousels, group paging, and vertical lists on a single screen.
* **Reusable XIBs:** Cells like `LeagueTableViewCell` and `PlayerTableViewCell` are modularized into `.xib` files for DRY (Don't Repeat Yourself) reusability across multiple ViewControllers.
* **Data-Driven Enums:** UI States are strictly driven by Swift Enums with Associated Values (e.g., `case emptyState(title: String)`), entirely preventing out-of-bounds crashes.

---

## 🧪 The Debugger (Testing Strategy)

To ensure maximum stability, this project features a rigorous Unit Testing suite achieving over **90% Code Coverage** across all Presenters and Services.

* **Mocking the Internet:** Created a custom `MockURLProtocol` to intercept Alamofire requests. This allows us to inject pure JSON strings into the tests, perfectly simulating API Success, Empty Arrays, and 404/Timeout Failures without ever hitting the real network.
* **Mock Views:** Every Presenter test uses a lightweight `MockView` (conforming to the `ViewProtocol`) to assert that the Presenter is commanding the UI correctly (e.g., `XCTAssertTrue(mockView.isShowLoadingCalled)`).
* **Core Data Testing:** Verified DAO layers (Save, Delete, Fetch) without corrupting actual user data.

---

## 🚀 Installation & Setup

**1. Clone the repository:**
```bash
git clone https://github.com/YOUR_GITHUB_USERNAME/SportsApp.git
```

**2. Install Dependencies:** Open the project folder in terminal (Ensure CocoaPods is installed):
```bash
pod install
```

**3. Open the Workspace:** Open the `SportsApp.xcworkspace` file in Xcode 15+ (Do **NOT** open the `.xcodeproj` file).

**4. API Key Setup:** Navigate to `Constants.swift` and insert your AllSports API Key:
```swift
static let apiKey = "YOUR_API_KEY_HERE"
```

**5. Build & Run:** Select an iOS Simulator or physical device (iOS 13.0+) and hit Run (`Cmd + R`).

---

<div align="center">
  Made by <strong>Ahmed Tayseer</strong> & <strong>Mazen Amr</strong>
</div>
