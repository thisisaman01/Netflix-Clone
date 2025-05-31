////
////  DownloadsViewController.swift
////  Netflix clone
////
////  Created by AMAN K.A on 21/08/23.
////
//
//import UIKit
//
//class DownloadsViewController: UIViewController {
//    
//    private var titles: [TitleItem] = [TitleItem]()
//    
//    private let downloadedTable: UITableView = {
//       
//        let table = UITableView()
//        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
//        return table
//    }()
//
//
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        
//        view.backgroundColor = .systemBackground
//        title = "Downloads"
//        view.addSubview(downloadedTable)
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationController?.navigationItem.largeTitleDisplayMode = .always
//        downloadedTable.delegate = self
//        downloadedTable.dataSource = self
//        
//        fetchLocalStorageForDownload()
//        
//        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
//            self.fetchLocalStorageForDownload()
//        }
//    }
//    
//    private func fetchLocalStorageForDownload() {
//        
//        
//        DataPersistenceManager.shared.fetchingTitlesFromDatabase { [weak self] result in
//            switch result {
//            case .success(let titles):
//                self?.titles = titles
//                
//                DispatchQueue.main.async {
//                    self?.downloadedTable.reloadData()
//
//                }
//                
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//                
//            }
//        }
//    }
//    
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        downloadedTable.frame = view.bounds
//    }
//    
//}
//
//extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return titles.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        
//        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
//            return UITableViewCell()
//        }
//        
//        let title = titles[indexPath.row]
//        cell.configure(with: TitleViewModel(titleName: (title.orignal_title ?? title.orignal_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
//        return cell
//    }
//
//        
//        func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//            return 140
//        }
//        
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        switch editingStyle {
//        case .delete:
//            
//            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result  in
//                switch result {
//                case .success():
//                    print("Deleted from the database")
//                case .failure(let error):
//                    print(error.localizedDescription)
//                }
//                self?.titles.remove(at: indexPath.row)
//
//                tableView.deleteRows(at: [indexPath], with: .fade)
//
//            }
//        default:
//            break;
//        }
//    }
//    
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        
//        let title = titles[indexPath.row]
//        
//        guard let titleName = title.orignal_title ?? title.orignal_name else { return }
//        
//        
//        APICaller.shared.getMovie(with: titleName) { [weak self] result in
//            switch result {
//            case .success(let videoElement):
//                DispatchQueue.main.async {
//                    let vc = TitlePreviewViewController()
//                    
//                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }
//
//                
//            case . failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//    }
//
//}
//
//
//
//
//


// 1


//
//
//import UIKit
//
//class DownloadsViewController: UIViewController {
//    
//    // MARK: - Properties
//    private var titles: [TitleItem] = []
//    
//    private let downloadedTable: UITableView = {
//        let table = UITableView()
//        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
//        return table
//    }()
//
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupTableView()
//        fetchLocalStorageForDownload()
//        setupNotificationObserver()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        downloadedTable.frame = view.bounds
//    }
//    
//    // MARK: - Setup Methods
//    private func setupUI() {
//        view.backgroundColor = .systemBackground
//        title = "Downloads"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
//        view.addSubview(downloadedTable)
//    }
//    
//    private func setupTableView() {
//        downloadedTable.delegate = self
//        downloadedTable.dataSource = self
//    }
//    
//    private func setupNotificationObserver() {
//        NotificationCenter.default.addObserver(
//            forName: NSNotification.Name("downloaded"),
//            object: nil,
//            queue: nil
//        ) { [weak self] _ in
//            self?.fetchLocalStorageForDownload()
//        }
//    }
//    
//    // MARK: - Data Methods
//    private func fetchLocalStorageForDownload() {
//        DataPersistenceManager.shared.fetchingTitlesFromDatabase { [weak self] result in
//            switch result {
//            case .success(let titles):
//                self?.titles = titles
//                DispatchQueue.main.async {
//                    self?.downloadedTable.reloadData()
//                }
//            case .failure(let error):
//                print("❌ Failed to fetch downloads: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    // MARK: - Helper Methods
//    private func getTitleName(from titleItem: TitleItem) -> String {
//        // Use the correct property names from your Core Data model
//        return titleItem.orignal_title ??
//               titleItem.orignal_name ??
//               "Unknown Title"
//    }
//    
//    private func deleteTitleAt(indexPath: IndexPath) {
//        let titleToDelete = titles[indexPath.row]
//        
//        DataPersistenceManager.shared.deleteTitleWith(model: titleToDelete) { [weak self] result in
//            switch result {
//            case .success():
//                print("✅ Deleted from database")
//                DispatchQueue.main.async {
//                    self?.titles.remove(at: indexPath.row)
//                    self?.downloadedTable.deleteRows(at: [indexPath], with: .fade)
//                }
//            case .failure(let error):
//                print("❌ Failed to delete: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    private func presentTitlePreview(for titleItem: TitleItem) {
//        let titleName = getTitleName(from: titleItem)
//        
//        APICaller.shared.getMovie(with: titleName) { [weak self] result in
//            switch result {
//            case .success(let videoElement):
//                DispatchQueue.main.async {
//                    let vc = TitlePreviewViewController()
//                    let viewModel = TitlePreviewViewModel(
//                        title: titleName,
//                        youtubeView: videoElement,
//                        titleOverview: titleItem.overview ?? "No overview available."
//                    )
//                    vc.configure(with: viewModel)
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }
//            case .failure(let error):
//                print("❌ Failed to get movie trailer: \(error.localizedDescription)")
//            }
//        }
//    }
//    
//    // MARK: - Deinit
//    deinit {
//        NotificationCenter.default.removeObserver(self)
//    }
//}
//
//// MARK: - UITableViewDataSource & UITableViewDelegate
//extension DownloadsViewController: UITableViewDataSource, UITableViewDelegate {
//    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return titles.count
//    }
//    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        guard let cell = tableView.dequeueReusableCell(
//            withIdentifier: TitleTableViewCell.identifier,
//            for: indexPath
//        ) as? TitleTableViewCell else {
//            return UITableViewCell()
//        }
//        
//        let title = titles[indexPath.row]
//        let titleName = getTitleName(from: title)
//        let posterPath = title.poster_path ?? ""
//        
//        let viewModel = TitleViewModel(
//            titleName: titleName,
//            posterURL: posterPath
//        )
//        
//        cell.configure(with: viewModel)
//        return cell
//    }
//    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 140
//    }
//    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//        let titleItem = titles[indexPath.row]
//        presentTitlePreview(for: titleItem)
//    }
//    
//    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        switch editingStyle {
//        case .delete:
//            deleteTitleAt(indexPath: indexPath)
//        default:
//            break
//        }
//    }
//    
//    // Optional: Add swipe actions for better UX
//    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
//        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] _, _, completion in
//            self?.deleteTitleAt(indexPath: indexPath)
//            completion(true)
//        }
//        
//        deleteAction.backgroundColor = .systemRed
//        deleteAction.image = UIImage(systemName: "trash")
//        
//        return UISwipeActionsConfiguration(actions: [deleteAction])
//    }
//}



//
//  DownloadsViewController.swift
//  Netflix Clone
//
//  Created by Amr Hossam on 04/11/2021.
//

import UIKit

class DownloadsViewController: UIViewController {
    
    
    private var titles: [TitleItem] = [TitleItem]()
    
    private let downloadedTable: UITableView = {
       
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Downloads"
        view.addSubview(downloadedTable)
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        downloadedTable.delegate = self
        downloadedTable.dataSource = self
        fetchLocalStorageForDownload()
        NotificationCenter.default.addObserver(forName: NSNotification.Name("downloaded"), object: nil, queue: nil) { _ in
            self.fetchLocalStorageForDownload()
        }
    }
    
    
    private func fetchLocalStorageForDownload() {

        
        DataPersistenceManager.shared.fetchingTitlesFromDataBase { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.downloadedTable.reloadData()
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        downloadedTable.frame = view.bounds
    }
    

}


extension DownloadsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.orignal_title ?? title.orignal_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            
            DataPersistenceManager.shared.deleteTitleWith(model: titles[indexPath.row]) { [weak self] result in
                switch result {
                case .success():
                    print("Deleted fromt the database")
                case .failure(let error):
                    print(error.localizedDescription)
                }
                self?.titles.remove(at: indexPath.row)
                tableView.deleteRows(at: [indexPath], with: .fade)
            }
        default:
            break;
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.orignal_title ?? title.orignal_name else {
            return
        }
        
        
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let vc = TitlePreviewViewController()
                    vc.configure(with: TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: title.overview ?? ""))
                    self?.navigationController?.pushViewController(vc, animated: true)
                }

                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
 
    
    
}
