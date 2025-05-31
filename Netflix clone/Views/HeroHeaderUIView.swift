//
//  HeroHeaderUIView.swift
//  Netflix clone
//
//  Created by AMAN K.A on 07/09/23.
//



// calender



import UIKit
import SDWebImage  // Add this import for sd_setImage

class HeroHeaderUIView: UIView {
    
    private let downloadButton: UIButton = {
        let button = UIButton()
        button.setTitle("Download", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.layer.borderColor = UIColor.white.cgColor
        button.layer.borderWidth = 2
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        
        // Add shadow for better visibility
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        
        return button
    }()
    
    private let playButton: UIButton = {
        let button = UIButton()
        button.setTitle("▶ Play", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.layer.cornerRadius = 8
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
        button.backgroundColor = UIColor.white
        
        // Add shadow for better visibility
        button.layer.shadowColor = UIColor.black.cgColor
        button.layer.shadowOffset = CGSize(width: 0, height: 2)
        button.layer.shadowOpacity = 0.7
        button.layer.shadowRadius = 4
        
        return button
    }()
    
    private let heroImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.image = UIImage(named: "heroimage")
        return imageView
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Trending Movies"
        label.font = .systemFont(ofSize: 28, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        label.numberOfLines = 2
        
        // Enhanced shadow for better readability
        label.layer.shadowColor = UIColor.black.cgColor
        label.layer.shadowOffset = CGSize(width: 1, height: 1)
        label.layer.shadowOpacity = 0.9
        label.layer.shadowRadius = 3
        
        return label
    }()
    
    private var gradientLayer: CAGradientLayer?

    private func addGradient() {
        // Remove existing gradient if any
        gradientLayer?.removeFromSuperlayer()
        
        let gradientLayer = CAGradientLayer()
        
        // Create a stronger, more visible gradient that works in both modes
        gradientLayer.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.1).cgColor,
            UIColor.black.withAlphaComponent(0.4).cgColor,
            UIColor.black.withAlphaComponent(0.7).cgColor,
            UIColor.black.withAlphaComponent(0.9).cgColor
        ]
        
        gradientLayer.locations = [0.0, 0.3, 0.5, 0.7, 1.0]
        gradientLayer.frame = bounds
        self.gradientLayer = gradientLayer
        layer.addSublayer(gradientLayer)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(heroImageView)
        addGradient()
        addSubview(titleLabel)
        addSubview(playButton)
        addSubview(downloadButton)
        applyConstraints()
        setupLongPressGesture()
    }
    
    private func setupLongPressGesture() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
        longPress.minimumPressDuration = 0.7
        heroImageView.addGestureRecognizer(longPress)
        heroImageView.isUserInteractionEnabled = true
    }
    
    @objc private func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
        if gesture.state == .began {
            // Add haptic feedback
            let impactFeedback = UIImpactFeedbackGenerator(style: .medium)
            impactFeedback.impactOccurred()
            
            // Find the view controller to present the reminder options
            if let viewController = findViewController() as? HomeViewController {
                let movieTitle = titleLabel.text ?? "Featured Content"
                viewController.showMovieReminderOptions(for: movieTitle)
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
    
    private func applyConstraints() {
        
        let titleLabelConstraints = [
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            titleLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -20)
        ]
        
        let playButtonConstraints = [
            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            playButton.widthAnchor.constraint(equalToConstant: 120),
            playButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        let downloadButtonConstraints = [
            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
            downloadButton.widthAnchor.constraint(equalToConstant: 120),
            downloadButton.heightAnchor.constraint(equalToConstant: 40)
        ]
        
        NSLayoutConstraint.activate(titleLabelConstraints)
        NSLayoutConstraint.activate(playButtonConstraints)
        NSLayoutConstraint.activate(downloadButtonConstraints)
    }
    
    public func configure(with model: TitleViewModel) {
        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
            return
        }
        
        titleLabel.text = model.titleName
        heroImageView.sd_setImage(with: url, completed: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        heroImageView.frame = bounds
        
        // Update gradient frame when layout changes
        gradientLayer?.frame = bounds
    }
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        
        // Update gradient frame when appearance changes
        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            gradientLayer?.frame = bounds
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
}
































// default


//import UIKit
//
//class HeroHeaderUIView: UIView {
//
//    private let downloadButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("Download", for: .normal)
//        button.setTitleColor(.white, for: .normal)
//        button.layer.borderColor = UIColor.white.cgColor
//        button.layer.borderWidth = 2
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 8
//        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
//        button.backgroundColor = UIColor.black.withAlphaComponent(0.6)
//
//        // Add shadow for better visibility
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOffset = CGSize(width: 0, height: 2)
//        button.layer.shadowOpacity = 0.7
//        button.layer.shadowRadius = 4
//
//        return button
//    }()
//
//    private let playButton: UIButton = {
//        let button = UIButton()
//        button.setTitle("▶ Play", for: .normal)
//        button.setTitleColor(.black, for: .normal)
//        button.translatesAutoresizingMaskIntoConstraints = false
//        button.layer.cornerRadius = 8
//        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .bold)
//        button.backgroundColor = UIColor.white
//
//        // Add shadow for better visibility
//        button.layer.shadowColor = UIColor.black.cgColor
//        button.layer.shadowOffset = CGSize(width: 0, height: 2)
//        button.layer.shadowOpacity = 0.7
//        button.layer.shadowRadius = 4
//
//        return button
//    }()
//
//    private let heroImageView: UIImageView = {
//        let imageView = UIImageView()
//        imageView.contentMode = .scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.image = UIImage(named: "heroimage")
//        return imageView
//    }()
//
//    private let titleLabel: UILabel = {
//        let label = UILabel()
//        label.text = "Trending Movies"
//        label.font = .systemFont(ofSize: 28, weight: .bold)
//        label.textColor = .white
//        label.textAlignment = .center
//        label.translatesAutoresizingMaskIntoConstraints = false
//        label.numberOfLines = 2
//
//        // Enhanced shadow for better readability
//        label.layer.shadowColor = UIColor.black.cgColor
//        label.layer.shadowOffset = CGSize(width: 1, height: 1)
//        label.layer.shadowOpacity = 0.9
//        label.layer.shadowRadius = 3
//
//        return label
//    }()
//
//    private var gradientLayer: CAGradientLayer?
//
//    private func addGradient() {
//        // Remove existing gradient if any
//        gradientLayer?.removeFromSuperlayer()
//
//        let gradientLayer = CAGradientLayer()
//
//        // Create a stronger, more visible gradient that works in both modes
//        gradientLayer.colors = [
//            UIColor.clear.cgColor,
//            UIColor.black.withAlphaComponent(0.1).cgColor,
//            UIColor.black.withAlphaComponent(0.4).cgColor,
//            UIColor.black.withAlphaComponent(0.7).cgColor,
//            UIColor.black.withAlphaComponent(0.9).cgColor
//        ]
//
//        gradientLayer.locations = [0.0, 0.3, 0.5, 0.7, 1.0]
//        gradientLayer.frame = bounds
//        self.gradientLayer = gradientLayer
//        layer.addSublayer(gradientLayer)
//    }
//
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        addSubview(heroImageView)
//        addGradient()
//        addSubview(titleLabel)
//        addSubview(playButton)
//        addSubview(downloadButton)
//        applyConstraints()
//    }
//
//    private func applyConstraints() {
//
//        let titleLabelConstraints = [
//            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
//            titleLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
//            titleLabel.bottomAnchor.constraint(equalTo: playButton.topAnchor, constant: -20)
//        ]
//
//        let playButtonConstraints = [
//            playButton.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 70),
//            playButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
//            playButton.widthAnchor.constraint(equalToConstant: 120),
//            playButton.heightAnchor.constraint(equalToConstant: 40)
//        ]
//
//        let downloadButtonConstraints = [
//            downloadButton.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -70),
//            downloadButton.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -50),
//            downloadButton.widthAnchor.constraint(equalToConstant: 120),
//            downloadButton.heightAnchor.constraint(equalToConstant: 40)
//        ]
//
//        NSLayoutConstraint.activate(titleLabelConstraints)
//        NSLayoutConstraint.activate(playButtonConstraints)
//        NSLayoutConstraint.activate(downloadButtonConstraints)
//    }
//
//    public func configure(with model: TitleViewModel) {
//        guard let url = URL(string: "https://image.tmdb.org/t/p/w500/\(model.posterURL)") else {
//            return
//        }
//
//        titleLabel.text = model.titleName
//        heroImageView.sd_setImage(with: url, completed: nil)
//    }
//
//    override func layoutSubviews() {
//        super.layoutSubviews()
//        heroImageView.frame = bounds
//
//        // Update gradient frame when layout changes
//        gradientLayer?.frame = bounds
//    }
//
//    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
//        super.traitCollectionDidChange(previousTraitCollection)
//
//        // Update gradient frame when appearance changes
//        if traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
//            gradientLayer?.frame = bounds
//        }
//    }
//
//    required init?(coder: NSCoder) {
//        fatalError()
//    }
//}


