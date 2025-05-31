


import UIKit
import EventKit
import EventKitUI

enum Sections: Int {
    case TrendingMovies = 0
    case TrendingTv = 1
    case Popular = 2
    case Upcoming = 3
    case TopRated = 4
}

class HomeViewController: UIViewController  {
    
    private var randomTrendingMovie: Title?
    private var headerView: HeroHeaderUIView?
    
    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
    
    private let homeFeedTable: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(homeFeedTable)
        homeFeedTable.delegate = self
        homeFeedTable.dataSource = self
        
        configureNavbar()
        
        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
        homeFeedTable.tableHeaderView = headerView
        configureHeroHeaderView()
    }
    
    private func configureHeroHeaderView() {
        APICaller.shared.getTrendingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                let selectedTitle = titles.randomElement()
                
                DispatchQueue.main.async {
                    self?.randomTrendingMovie = selectedTitle
                    self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }

    private func configureNavbar() {
        if let originalImage = UIImage(named: "netflixLogo") {
            let targetSize = CGSize(width: 25, height: 25)
            UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
            originalImage.draw(in: CGRect(origin: .zero, size: targetSize))
            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            if let resizedImage = resizedImage {
                let logoImage = resizedImage.withRenderingMode(.alwaysOriginal)
                navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: self, action: nil)
            }
        } else {
            // Fallback
            var image = UIImage(named: "netflixLogo")
            image = image?.withRenderingMode(.alwaysOriginal)
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
        }
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: #selector(openProfile)),
            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
        ]
        
        // Make navigation bar icons adaptive to light/dark mode
        updateNavigationBarAppearance()
    }
    
    @objc private func openProfile() {
        let profileViewController = ProfileViewController()
        let navigationController = UINavigationController(rootViewController: profileViewController)
        present(navigationController, animated: true)
    }
    
    private func updateNavigationBarAppearance() {
        if traitCollection.userInterfaceStyle == .dark {
            navigationController?.navigationBar.tintColor = .white
        } else {
            navigationController?.navigationBar.tintColor = .black
        }
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Update navigation bar appearance when switching between light/dark mode
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            updateNavigationBarAppearance()
        }
    }
    
    // Helper function to resize images
    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(origin: .zero, size: newSize)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        homeFeedTable.frame = view.bounds
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sectionTitles.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
            return UITableViewCell()
        }
        
        cell.delegate = self

        switch indexPath.section {
        case Sections.TrendingMovies.rawValue:
            APICaller.shared.getTrendingMovies { result in
                switch result {
                case .success(let titles):
                    DispatchQueue.main.async {
                        cell.configure(with: titles)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TrendingTv.rawValue:
            APICaller.shared.getTrendingTvs { result in
                switch result {
                case .success(let titles):
                    DispatchQueue.main.async {
                        cell.configure(with: titles)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Popular.rawValue:
            APICaller.shared.getPopular { result in
                switch result {
                case .success(let titles):
                    DispatchQueue.main.async {
                        cell.configure(with: titles)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.Upcoming.rawValue:
            APICaller.shared.getUpcomingMovies { result in
                switch result {
                case .success(let titles):
                    DispatchQueue.main.async {
                        cell.configure(with: titles)
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
            
        case Sections.TopRated.rawValue:
            APICaller.shared.getTopRated { result in
                switch result {
                case .success(let titles):
                    DispatchQueue.main.async {
                        cell.configure(with: titles)
                    }
                case .failure(let error):
                    print(error)
                }
            }
            
        default:
            return UITableViewCell()
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 200
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {return}
        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
        
        header.textLabel?.textColor = .label
        
        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitles[section]
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let defaultOffset = view.safeAreaInsets.top
        let offset = scrollView.contentOffset.y + defaultOffset
        
        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
    }
}

extension HomeViewController: CollectionViewTableViewCellDelegate {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
        DispatchQueue.main.async { [weak self] in
            let vc = TitlePreviewViewController()
            vc.configure(with: viewModel)
            self?.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension HomeViewController {
    
    func showMovieReminderOptions(for movieTitle: String) {
        let actionSheet = UIAlertController(
            title: "Set Reminder for \(movieTitle)",
            message: "Choose how you'd like to be reminded",
            preferredStyle: .actionSheet
        )
        
        let tonight = UIAlertAction(title: "🌙 Tonight at 8 PM", style: .default) { [weak self] _ in
            self?.createQuickReminder(for: movieTitle, type: .tonight)
        }
        
        let tomorrow = UIAlertAction(title: "☀️ Tomorrow at 7 PM", style: .default) { [weak self] _ in
            self?.createQuickReminder(for: movieTitle, type: .tomorrow)
        }
        
        let weekend = UIAlertAction(title: "🎉 This Weekend", style: .default) { [weak self] _ in
            self?.createQuickReminder(for: movieTitle, type: .weekend)
        }
        
        let openCalendar = UIAlertAction(title: "📅 Open Calendar App", style: .default) { [weak self] _ in
            self?.openCalendarApp()
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        actionSheet.addAction(tonight)
        actionSheet.addAction(tomorrow)
        actionSheet.addAction(weekend)
        actionSheet.addAction(openCalendar)
        actionSheet.addAction(cancel)
        
        // For iPad
        if let popover = actionSheet.popoverPresentationController {
            popover.sourceView = view
            popover.sourceRect = CGRect(x: view.bounds.midX, y: view.bounds.midY, width: 0, height: 0)
        }
        
        present(actionSheet, animated: true)
    }
    
    private enum ReminderType {
        case tonight, tomorrow, weekend
    }
    
    private func createQuickReminder(for movieTitle: String, type: ReminderType) {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            DispatchQueue.main.async {
                guard granted else {
                    self?.showCalendarPermissionAlert()
                    return
                }
                
                let event = EKEvent(eventStore: eventStore)
                event.title = "Watch: \(movieTitle) 🎬"
                event.notes = "Time to watch \(movieTitle) on Netflix!"
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                switch type {
                case .tonight:
                    event.startDate = self?.getTonightAt8PM() ?? Date()
                case .tomorrow:
                    event.startDate = self?.getTomorrowAt7PM() ?? Date()
                case .weekend:
                    event.startDate = self?.getThisWeekend() ?? Date()
                }
                
                event.endDate = event.startDate.addingTimeInterval(7200) // 2 hours
                let alarm = EKAlarm(relativeOffset: -900) // 15 minutes before
                event.addAlarm(alarm)
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    self?.showSuccessAlert(for: movieTitle, date: event.startDate)
                } catch {
                    self?.showErrorAlert(message: "Could not save event: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func openCalendarApp() {
        if let calendarURL = URL(string: "calshow://") {
            if UIApplication.shared.canOpenURL(calendarURL) {
                UIApplication.shared.open(calendarURL, options: [:], completionHandler: nil)
            } else if let fallbackURL = URL(string: "calendar://") {
                UIApplication.shared.open(fallbackURL, options: [:], completionHandler: nil)
            } else {
                showErrorAlert(message: "Cannot open Calendar app.")
            }
        }
    }
    
    private func getTonightAt8PM() -> Date {
        let calendar = Calendar.current
        let today = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: today)
        components.hour = 20
        components.minute = 0
        return calendar.date(from: components) ?? today
    }
    
    private func getTomorrowAt7PM() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        var components = calendar.dateComponents([.year, .month, .day], from: tomorrow)
        components.hour = 19
        components.minute = 0
        return calendar.date(from: components) ?? tomorrow
    }
    
    private func getThisWeekend() -> Date {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        let daysUntilSaturday = (7 - weekday + 1) % 7
        let saturday = calendar.date(byAdding: .day, value: daysUntilSaturday == 0 ? 7 : daysUntilSaturday, to: today) ?? today
        
        var components = calendar.dateComponents([.year, .month, .day], from: saturday)
        components.hour = 14
        components.minute = 0
        return calendar.date(from: components) ?? saturday
    }
    
    private func showSuccessAlert(for movieTitle: String, date: Date) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        let alert = UIAlertController(
            title: "Reminder Set! 🎉",
            message: "You'll be reminded to watch '\(movieTitle)' on \(formatter.string(from: date))",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Great!", style: .default))
        present(alert, animated: true)
    }
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    private func showCalendarPermissionAlert() {
        let alert = UIAlertController(
            title: "Calendar Access Needed",
            message: "To set reminders, please allow calendar access in Settings.",
            preferredStyle: .alert
        )
        
        let settings = UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(settings)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}

extension HomeViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true) {
            switch action {
            case .saved:
                let alert = UIAlertController(title: "Event Saved! 🎉", message: "Your Netflix reminder has been added to your calendar", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Awesome!", style: .default))
                self.present(alert, animated: true)
            case .canceled, .deleted:
                break
            @unknown default:
                break
            }
        }
    }
}






























// deafult -


////
//import UIKit
//
//enum Sections: Int {
//    case TrendingMovies = 0
//    case TrendingTv = 1
//    case Popular = 2
//    case Upcoming = 3
//    case TopRated = 4
//}
//
//class HomeViewController: UIViewController  {
//
//    private var randomTrendingMovie: Title?
//    private var headerView: HeroHeaderUIView?
//
//    let sectionTitles: [String] = ["Trending Movies", "Trending Tv", "Popular", "Upcoming Movies", "Top rated"]
//
//    private let homeFeedTable: UITableView = {
//        let table = UITableView(frame: .zero, style: .grouped)
//        table.register(CollectionViewTableViewCell.self, forCellReuseIdentifier: CollectionViewTableViewCell.identifier)
//        return table
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.backgroundColor = .systemBackground
//        view.addSubview(homeFeedTable)
//        homeFeedTable.delegate = self
//        homeFeedTable.dataSource = self
//
//        configureNavbar()
//
//        headerView = HeroHeaderUIView(frame: CGRect(x: 0, y: 0, width: view.bounds.width, height: 500))
//        homeFeedTable.tableHeaderView = headerView
//        configureHeroHeaderView()
//    }
//
//    private func configureHeroHeaderView() {
//        APICaller.shared.getTrendingMovies { [weak self] result in
//            switch result {
//            case .success(let titles):
//                let selectedTitle = titles.randomElement()
//
//                // ✅ FIXED: Move UI updates to main thread
//                DispatchQueue.main.async {
//                    self?.randomTrendingMovie = selectedTitle
//                    self?.headerView?.configure(with: TitleViewModel(titleName: selectedTitle?.original_title ?? "", posterURL: selectedTitle?.poster_path ?? ""))
//                }
//
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//    private func configureNavbar() {
//        // Fix Netflix logo with proper sizing and positioning
//        if let originalImage = UIImage(named: "netflixLogo") {
//            // Create proper size for navigation bar
//            let targetSize = CGSize(width: 25, height: 25)
//            UIGraphicsBeginImageContextWithOptions(targetSize, false, 0.0)
//            originalImage.draw(in: CGRect(origin: .zero, size: targetSize))
//            let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
//            UIGraphicsEndImageContext()
//
//            if let resizedImage = resizedImage {
//                let logoImage = resizedImage.withRenderingMode(.alwaysOriginal)
//                navigationItem.leftBarButtonItem = UIBarButtonItem(image: logoImage, style: .plain, target: self, action: nil)
//            }
//        } else {
//            // Fallback
//            var image = UIImage(named: "netflixLogo")
//            image = image?.withRenderingMode(.alwaysOriginal)
//            navigationItem.leftBarButtonItem = UIBarButtonItem(image: image, style: .done, target: self, action: nil)
//        }
//
//        navigationItem.rightBarButtonItems = [
//            UIBarButtonItem(image: UIImage(systemName: "person"), style: .done, target: self, action: nil),
//            UIBarButtonItem(image: UIImage(systemName: "play.rectangle"), style: .done, target: self, action: nil)
//        ]
//
//        // Make navigation bar icons adaptive to light/dark mode
//        updateNavigationBarAppearance()
//    }
//
//    private func updateNavigationBarAppearance() {
//        if traitCollection.userInterfaceStyle == .dark {
//            navigationController?.navigationBar.tintColor = .white
//        } else {
//            navigationController?.navigationBar.tintColor = .black
//        }
//    }
//
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//
//        // Update navigation bar appearance when switching between light/dark mode
//        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            updateNavigationBarAppearance()
//        }
//    }
//
//    // Helper function to resize images
//    private func resizeImage(image: UIImage, targetSize: CGSize) -> UIImage {
//        let size = image.size
//        let widthRatio  = targetSize.width  / size.width
//        let heightRatio = targetSize.height / size.height
//
//        let newSize: CGSize
//        if widthRatio > heightRatio {
//            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
//        } else {
//            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
//        }
//
//        let rect = CGRect(origin: .zero, size: newSize)
//
//        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
//        image.draw(in: rect)
//        let newImage = UIGraphicsGetImageFromCurrentImageContext()
//        UIGraphicsEndImageContext()
//
//        return newImage ?? image
//    }
//
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        homeFeedTable.frame = view.bounds
//    }
//}
//
//extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func numberOfSections(in tableView: UITableView) -> Int {
//        return sectionTitles.count
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return 1
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: CollectionViewTableViewCell.identifier, for: indexPath) as? CollectionViewTableViewCell else {
//            return UITableViewCell()
//        }
//
//        cell.delegate = self
//
//        switch indexPath.section {
//        case Sections.TrendingMovies.rawValue:
//            APICaller.shared.getTrendingMovies { result in
//                switch result {
//                case .success(let titles):
//                    // ✅ FIXED: Move UI updates to main thread
//                    DispatchQueue.main.async {
//                        cell.configure(with: titles)
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//
//        case Sections.TrendingTv.rawValue:
//            APICaller.shared.getTrendingTvs { result in
//                switch result {
//                case .success(let titles):
//                    // ✅ FIXED: Move UI updates to main thread
//                    DispatchQueue.main.async {
//                        cell.configure(with: titles)
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//
//        case Sections.Popular.rawValue:
//            APICaller.shared.getPopular { result in
//                switch result {
//                case .success(let titles):
//                    // ✅ FIXED: Move UI updates to main thread
//                    DispatchQueue.main.async {
//                        cell.configure(with: titles)
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//
//        case Sections.Upcoming.rawValue:
//            APICaller.shared.getUpcomingMovies { result in
//                switch result {
//                case .success(let titles):
//                    // ✅ FIXED: Move UI updates to main thread
//                    DispatchQueue.main.async {
//                        cell.configure(with: titles)
//                    }
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//            }
//
//        case Sections.TopRated.rawValue:
//            APICaller.shared.getTopRated { result in
//                switch result {
//                case .success(let titles):
//                    // ✅ FIXED: Move UI updates to main thread
//                    DispatchQueue.main.async {
//                        cell.configure(with: titles)
//                    }
//                case .failure(let error):
//                    print(error)
//                }
//            }
//
//        default:
//            return UITableViewCell()
//        }
//
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 200
//    }
//
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 40
//    }
//
//    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
//        guard let header = view as? UITableViewHeaderFooterView else {return}
//        header.textLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
//        header.textLabel?.frame = CGRect(x: header.bounds.origin.x + 20, y: header.bounds.origin.y, width: 100, height: header.bounds.height)
//
//        // Use label color that automatically adapts to light/dark mode
//        header.textLabel?.textColor = .label
//
//        header.textLabel?.text = header.textLabel?.text?.capitalizeFirstLetter()
//    }
//
//    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return sectionTitles[section]
//    }
//
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let defaultOffset = view.safeAreaInsets.top
//        let offset = scrollView.contentOffset.y + defaultOffset
//
//        navigationController?.navigationBar.transform = .init(translationX: 0, y: min(0, -offset))
//    }
//}
//
//extension HomeViewController: CollectionViewTableViewCellDelegate {
//    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel) {
//        DispatchQueue.main.async { [weak self] in
//            let vc = TitlePreviewViewController()
//            vc.configure(with: viewModel)
//            self?.navigationController?.pushViewController(vc, animated: true)
//        }
//    }
//}

