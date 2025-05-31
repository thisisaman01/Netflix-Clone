//
//  CollectionViewTableViewCell.swift
//  Netflix clone
//
//  Created by AMAN K.A on 06/09/23.
//

//
//import UIKit
//
//
//protocol CollectionViewTableViewCellDelegate: AnyObject {
//    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
//}
//
//class CollectionViewTableViewCell: UITableViewCell {
//
//    static let identifier = "CollectionViewTableViewCell"
//    
//    weak var delegate: CollectionViewTableViewCellDelegate?
//    
//    private var titles: [Title] = [Title]()
//    
//    private let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 140, height: 200)
//        layout.scrollDirection = .horizontal
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
//        return collectionView
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.addSubview(collectionView)
//        
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
//    
//    
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        collectionView.frame = contentView.bounds
//    }
//    
//    
//    public func configure(with titles: [Title]) {
//        self.titles = titles
//        DispatchQueue.main.async { [weak self] in
//            self?.collectionView.reloadData()
//        }
//    }
//    
//    private func downloadTitleAt(indexPath: IndexPath) {
//        
//    
//        DataPersistenceManager.shared.downloadTitleWith(model: titles[indexPath.row]) { result in
//            switch result {
//            case .success():
//                NotificationCenter.default.post(name: NSNotification.Name("downloaded"), object: nil)
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//        }
//        
//
//    }
//}
//
//
//extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        
//        guard let model = titles[indexPath.row].poster_path else {
//            return UICollectionViewCell()
//        }
//        cell.configure(with: model)
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return titles.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        
//        let title = titles[indexPath.row]
//        guard let titleName = title.original_title ?? title.original_name else {
//            return
//        }
//        
//        
//        APICaller.shared.getMovie(with: titleName + " trailer") { [weak self] result in
//            switch result {
//            case .success(let videoElement):
//                
//                let title = self?.titles[indexPath.row]
//                guard let titleOverview = title?.overview else {
//                    return
//                }
//                guard let strongSelf = self else {
//                    return
//                }
//                let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
//                self?.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
//                
//            case .failure(let error):
//                print(error.localizedDescription)
//            }
//            
//        }
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, contextMenuConfigurationForItemAt indexPath: IndexPath, point: CGPoint) -> UIContextMenuConfiguration? {
//        
//        let config = UIContextMenuConfiguration(
//            identifier: nil,
//            previewProvider: nil) {[weak self] _ in
//                let downloadAction = UIAction(title: "Download", subtitle: nil, image: nil, identifier: nil, discoverabilityTitle: nil, state: .off) { _ in
//                    self?.downloadTitleAt(indexPath: indexPath)
//                }
//                return UIMenu(title: "", image: nil, identifier: nil, options: .displayInline, children: [downloadAction])
//            }
//        
//        return config
//    }
//    
//    
//
//    
//    
//}





// Minimal fix - replace your CollectionViewTableViewCell.swift with this
// This version removes the problematic navigation code but keeps calendar functionality
//
//import UIKit
//
//protocol CollectionViewTableViewCellDelegate: AnyObject {
//    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
//}
//
//class CollectionViewTableViewCell: UITableViewCell {
//    
//    static let identifier = "CollectionViewTableViewCell"
//    
//    weak var delegate: CollectionViewTableViewCellDelegate?
//    
//    private var titles: [Title] = []
//    
//    private let collectionView: UICollectionView = {
//        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 140, height: 200)
//        layout.scrollDirection = .horizontal
//        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
//        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
//        return collectionView
//    }()
//    
//    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
//        super.init(style: style, reuseIdentifier: reuseIdentifier)
//        contentView.backgroundColor = .systemBackground
//        contentView.addSubview(collectionView)
//        
//        collectionView.delegate = self
//        collectionView.dataSource = self
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//    
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        collectionView.frame = contentView.bounds
//    }
//    
//    public func configure(with titles: [Title]) {
//        self.titles = titles
//        DispatchQueue.main.async { [weak self] in
//            self?.collectionView.reloadData()
//        }
//    }
//}
//
//extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
//    
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//        
//        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
//            return UICollectionViewCell()
//        }
//        
//        let title = titles[indexPath.row]
//        cell.configure(with: title.poster_path ?? "", titleName: title.original_title ?? title.original_name ?? "Unknown")
//        
//        return cell
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//        return titles.count
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
//        collectionView.deselectItem(at: indexPath, animated: true)
//        
//        let title = titles[indexPath.row]
//        let titleName = title.original_title ?? title.original_name ?? ""
//        
//        // For now, just show an alert when movie is tapped
//        // You can implement proper navigation later
//        if let viewController = findViewController() {
//            let alert = UIAlertController(title: titleName, message: "Movie details would be shown here", preferredStyle: .alert)
//            alert.addAction(UIAlertAction(title: "OK", style: .default))
//            viewController.present(alert, animated: true)
//        }
//    }
//    
//    private func findViewController() -> UIViewController? {
//        var responder: UIResponder? = self
//        while responder != nil {
//            if let viewController = responder as? UIViewController {
//                return viewController
//            }
//            responder = responder?.next
//        }
//        return nil
//    }
//}
//
//// Enhanced TitleCollectionViewCell with calendar reminder support
//class TitleCollectionViewCell: UICollectionViewCell {
//    
//    static let identifier = "TitleCollectionViewCell"
//    
//    private var currentTitleName: String = ""
//    
//    private let posterImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.layer.cornerRadius = 8
//        return imageView
//    }()
//    
//    private let reminderIndicator: UIView = {
//        let view = UIView()
//        view.backgroundColor = UIColor.systemRed.withAlphaComponent(0.9)
//        view.layer.cornerRadius = 10
//        view.translatesAutoresizingMaskIntoConstraints = false
//        view.isHidden = true
//        
//        let label = UILabel()
//        label.text = "📅"
//        label.font = .systemFont(ofSize: 12)
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(label)
//        
//        NSLayoutConstraint.activate([
//            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
//            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
//        ])
//        
//        return view
//    }()
//    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        setupViews()
//        setupLongPressGesture()
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private func setupViews() {
//        contentView.addSubview(posterImageView)
//        contentView.addSubview(reminderIndicator)
//        
//        posterImageView.translatesAutoresizingMaskIntoConstraints = false
//        
//        NSLayoutConstraint.activate([
//            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
//            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
//            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
//            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
//            
//            reminderIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
//            reminderIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
//            reminderIndicator.widthAnchor.constraint(equalToConstant: 20),
//            reminderIndicator.heightAnchor.constraint(equalToConstant: 20)
//        ])
//    }
//    
//    private func setupLongPressGesture() {
//        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
//        longPress.minimumPressDuration = 0.6
//        contentView.addGestureRecognizer(longPress)
//    }
//    
//    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
//        if gesture.state == .began {
//            // Haptic feedback
//            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
//            impactFeedback.impactOccurred()
//            
//            // Show reminder indicator temporarily
//            showReminderIndicator()
//            
//            // Find the view controller to present calendar options
//            if let viewController = findViewController() as? HomeViewController {
//                viewController.showMovieReminderOptions(for: currentTitleName)
//            }
//        }
//    }
//    
//    private func showReminderIndicator() {
//        reminderIndicator.isHidden = false
//        reminderIndicator.alpha = 0
//        
//        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
//            self.reminderIndicator.alpha = 1
//            self.reminderIndicator.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
//        } completion: { _ in
//            UIView.animate(withDuration: 0.2) {
//                self.reminderIndicator.transform = .identity
//            }
//            
//            // Hide after 2 seconds
//            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
//                UIView.animate(withDuration: 0.3) {
//                    self.reminderIndicator.alpha = 0
//                } completion: { _ in
//                    self.reminderIndicator.isHidden = true
//                }
//            }
//        }
//    }
//    
//    private func findViewController() -> UIViewController? {
//        var responder: UIResponder? = self
//        while responder != nil {
//            if let viewController = responder as? UIViewController {
//                return viewController
//            }
//            responder = responder?.next
//        }
//        return nil
//    }
//    
//    override func prepareForReuse() {
//        super.prepareForReuse()
//        posterImageView.image = nil
//        reminderIndicator.isHidden = true
//        currentTitleName = ""
//    }
//    
//    public func configure(with model: String, titleName: String = "") {
//        currentTitleName = titleName
//        
//        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
//            return
//        }
//        
//        // Load image without SDWebImage - using native iOS
//        loadImage(from: url) { [weak self] image in
//            DispatchQueue.main.async {
//                self?.posterImageView.image = image
//            }
//        }
//    }
//    
//    // Native iOS image loading function (replaces SDWebImage)
//    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
//        URLSession.shared.dataTask(with: url) { data, response, error in
//            guard let data = data, error == nil else {
//                completion(nil)
//                return
//            }
//            let image = UIImage(data: data)
//            completion(image)
//        }.resume()
//    }
//}


import UIKit

protocol CollectionViewTableViewCellDelegate: AnyObject {
    func collectionViewTableViewCellDidTapCell(_ cell: CollectionViewTableViewCell, viewModel: TitlePreviewViewModel)
}

class CollectionViewTableViewCell: UITableViewCell {
    
    static let identifier = "CollectionViewTableViewCell"
    
    weak var delegate: CollectionViewTableViewCellDelegate?
    
    private var titles: [Title] = []
    
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 140, height: 200)
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.identifier)
        return collectionView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.backgroundColor = .systemBackground
        contentView.addSubview(collectionView)
        
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        collectionView.frame = contentView.bounds
    }
    
    // KEEP THE ORIGINAL WORKING CONFIGURE METHOD
    public func configure(with titles: [Title]) {
        self.titles = titles
        DispatchQueue.main.async { [weak self] in
            self?.collectionView.reloadData()
        }
    }
}

extension CollectionViewTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TitleCollectionViewCell.identifier, for: indexPath) as? TitleCollectionViewCell else {
            return UICollectionViewCell()
        }
        
        let title = titles[indexPath.row]
        cell.configure(with: title.poster_path ?? "", titleName: title.original_title ?? title.original_name ?? "Unknown")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return titles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        
        let title = titles[indexPath.row]
        let titleName = title.original_title ?? title.original_name ?? ""
        
        guard let titleOverview = title.overview else {
            return
        }
        
        // USE YOUR ORIGINAL WORKING APPROACH
        APICaller.shared.getMovie(with: titleName) { [weak self] result in
            switch result {
            case .success(let videoElement):
                DispatchQueue.main.async {
                    let viewModel = TitlePreviewViewModel(title: titleName, youtubeView: videoElement, titleOverview: titleOverview)
                    
                    guard let strongSelf = self else {
                        return
                    }
                    
                    strongSelf.delegate?.collectionViewTableViewCellDidTapCell(strongSelf, viewModel: viewModel)
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}

// Enhanced TitleCollectionViewCell with calendar functionality
class TitleCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "TitleCollectionViewCell"
    
    private var currentTitleName: String = ""
    
    private let posterImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 8
        return imageView
    }()
    
    private let reminderIndicator: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemRed.withAlphaComponent(0.9)
        view.layer.cornerRadius = 10
        view.translatesAutoresizingMaskIntoConstraints = false
        view.isHidden = true
        
        let label = UILabel()
        label.text = "📅"
        label.font = .systemFont(ofSize: 12)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        
        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
        setupLongPressGesture()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(reminderIndicator)
        
        posterImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            posterImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            reminderIndicator.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            reminderIndicator.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            reminderIndicator.widthAnchor.constraint(equalToConstant: 20),
            reminderIndicator.heightAnchor.constraint(equalToConstant: 20)
        ])
    }
    
    private func setupLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.6
        contentView.addGestureRecognizer(longPress)
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // Haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            // Show reminder indicator temporarily
            showReminderIndicator()
            
            // Find the view controller to present calendar options
            if let viewController = findViewController() as? HomeViewController {
                viewController.showMovieReminderOptions(for: currentTitleName)
            }
        }
    }
    
    private func showReminderIndicator() {
        reminderIndicator.isHidden = false
        reminderIndicator.alpha = 0
        
        UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseInOut) {
            self.reminderIndicator.alpha = 1
            self.reminderIndicator.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
        } completion: { _ in
            UIView.animate(withDuration: 0.2) {
                self.reminderIndicator.transform = .identity
            }
            
            // Hide after 2 seconds
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                UIView.animate(withDuration: 0.3) {
                    self.reminderIndicator.alpha = 0
                } completion: { _ in
                    self.reminderIndicator.isHidden = true
                }
            }
        }
    }
    
    private func findViewController() -> UIViewController? {
        var responder: UIResponder? = self
        while responder != nil {
            if let viewController = responder as? UIViewController {
                return viewController
            }
            responder = responder?.next
        }
        return nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        posterImageView.image = nil
        reminderIndicator.isHidden = true
        currentTitleName = ""
    }
    
    public func configure(with model: String, titleName: String = "") {
        currentTitleName = titleName
        
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model)") else {
            return
        }
        
        // Native iOS image loading (no SDWebImage needed)
        loadImage(from: url) { [weak self] image in
            DispatchQueue.main.async {
                self?.posterImageView.image = image
            }
        }
    }
    
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data, error == nil else {
                completion(nil)
                return
            }
            let image = UIImage(data: data)
            completion(image)
        }.resume()
    }
}
