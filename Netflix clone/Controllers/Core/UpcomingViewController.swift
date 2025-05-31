//
//  UpcomingViewController.swift
//  Netflix clone
//
//  Created by AMAN K.A on 21/08/23.
//



//import UIKit
//
//class UpcomingViewController: UIViewController {
//    
//    // MARK: - Properties
//    private var titles: [Title] = []
//    
//    private let upcomingTable: UITableView = {
//        let table = UITableView()
//        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
//        table.showsVerticalScrollIndicator = true
//        return table
//    }()
//    
//    // MARK: - Lifecycle
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        setupUI()
//        setupTableView()
//        fetchUpcoming()
//    }
//    
//    override func viewDidLayoutSubviews() {
//        super.viewDidLayoutSubviews()
//        upcomingTable.frame = view.bounds
//    }
//    
//    // MARK: - Setup Methods
//    private func setupUI() {
//        view.backgroundColor = .systemBackground
//        title = "Upcoming"
//        navigationController?.navigationBar.prefersLargeTitles = true
//        navigationItem.largeTitleDisplayMode = .always
//        
//        view.addSubview(upcomingTable)
//    }
//    
//    private func setupTableView() {
//        upcomingTable.delegate = self
//        upcomingTable.dataSource = self
//    }
//    
//    // MARK: - API Methods
//    private func fetchUpcoming() {
//        APICaller.shared.getUpcomingMovies { [weak self] result in
//            switch result {
//            case .success(let titles):
//                self?.titles = titles
//                DispatchQueue.main.async {
//                    self?.upcomingTable.reloadData()
//                }
//            case .failure(let error):
//                print("❌ Failed to fetch upcoming movies: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self?.showErrorAlert(message: "Failed to load upcoming movies. Please try again.")
//                }
//            }
//        }
//    }
//    
//    // MARK: - Helper Methods
//    private func getTitleName(from title: Title) -> String {
//        // Use the computed property from the model for cleaner code
//        return title.original_title ?? "AMAN"
//    }
//    
//    private func showErrorAlert(message: String) {
//        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
//        alert.addAction(UIAlertAction(title: "OK", style: .default))
//        present(alert, animated: true)
//    }
//    
//    private func presentTitlePreview(for title: Title) {
//        let titleName = getTitleName(from: title)
//        
//        APICaller.shared.getMovie(with: titleName) { [weak self] result in
//            switch result {
//            case .success(let videoElement):
//                DispatchQueue.main.async {
//                    let vc = TitlePreviewViewController()
//                    let viewModel = TitlePreviewViewModel(
//                        title: titleName,
//                        youtubeView: videoElement,
//                        titleOverview: title.overview ?? "No overview available."
//                    )
//                    vc.configure(with: viewModel)
//                    self?.navigationController?.pushViewController(vc, animated: true)
//                }
//            case .failure(let error):
//                print("❌ Failed to fetch movie trailer: \(error.localizedDescription)")
//                DispatchQueue.main.async {
//                    self?.showErrorAlert(message: "Could not load movie trailer.")
//                }
//            }
//        }
//    }
//}
//
//// MARK: - UITableViewDataSource & UITableViewDelegate
//extension UpcomingViewController: UITableViewDataSource, UITableViewDelegate {
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
//        
//        let title = titles[indexPath.row]
//        presentTitlePreview(for: title)
//    }
//    
//    // Optional: Add pull-to-refresh functionality
//    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
//        let offsetY = scrollView.contentOffset.y
//        let contentHeight = scrollView.contentSize.height
//        let height = scrollView.frame.size.height
//        
//        if offsetY > contentHeight - height {
//            // User scrolled to bottom - could implement pagination here
//        }
//    }
//}
//
//// MARK: - Pull to Refresh (Optional Enhancement)
//extension UpcomingViewController {
//    
//    func addPullToRefresh() {
//        let refreshControl = UIRefreshControl()
//        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
//        upcomingTable.refreshControl = refreshControl
//    }
//    
//    @objc private func refreshData() {
//        fetchUpcoming()
//        
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
//            self.upcomingTable.refreshControl?.endRefreshing()
//        }
//    }
//}




//
//  UpcomingViewController.swift
//  Netflix Clone
//
//  Created by Amr Hossam on 04/11/2021.
//

import UIKit

class UpcomingViewController: UIViewController {
    
    
    private var titles: [Title] = [Title]()
    
    private let upcomingTable: UITableView = {
       
        let table = UITableView()
        table.register(TitleTableViewCell.self, forCellReuseIdentifier: TitleTableViewCell.identifier)
        return table
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        title = "Upcoming"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationItem.largeTitleDisplayMode = .always
        
        
        view.addSubview(upcomingTable)
        upcomingTable.delegate = self
        upcomingTable.dataSource = self
        
        fetchUpcoming()
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        upcomingTable.frame = view.bounds
    }
    
    
    
    private func fetchUpcoming() {
        APICaller.shared.getUpcomingMovies { [weak self] result in
            switch result {
            case .success(let titles):
                self?.titles = titles
                DispatchQueue.main.async {
                    self?.upcomingTable.reloadData()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}


extension UpcomingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        guard let cell = tableView.dequeueReusableCell(withIdentifier: TitleTableViewCell.identifier, for: indexPath) as? TitleTableViewCell else {
            return UITableViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: TitleViewModel(titleName: (title.original_title ?? title.original_name) ?? "Unknown title name", posterURL: title.poster_path ?? ""))
        return cell
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }
    

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        
        guard let titleName = title.original_title ?? title.original_name else {
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
