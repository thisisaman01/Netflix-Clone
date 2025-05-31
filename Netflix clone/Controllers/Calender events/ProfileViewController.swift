//
//  ProfileViewController.swift
//  Netflix clone
//
//  Created by AMAN K.A on 31/05/25.
//


import UIKit
import EventKit
import EventKitUI

class ProfileViewController: UIViewController {
    
    private let eventStore = EKEventStore()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "person.crop.circle.fill")
        imageView.tintColor = .systemRed
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Netflix User"
        label.font = .systemFont(ofSize: 24, weight: .bold)
        label.textColor = .label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let emailLabel: UILabel = {
        let label = UILabel()
        label.text = "user@netflix.com"
        label.font = .systemFont(ofSize: 16, weight: .regular)
        label.textColor = .secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // Calendar Integration Buttons
    private let openCalendarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("📅 Open Apple Calendar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let createEventButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("➕ Create Netflix Reminder", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = .systemRed
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let viewEventsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("👀 View Calendar Events", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let openGoogleCalendarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("🗓️ Open Google Calendar", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemOrange
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 10
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // Profile Options
    private let accountSettingsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⚙️ Account Settings", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let downloadsButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("⬇️ My Downloads", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let signOutButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign Out", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = .systemGray6
        button.setTitleColor(.systemRed, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemRed.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
        requestCalendarPermission()
    }
    
    private func setupUI() {
        title = "Profile & Calendar"
        view.backgroundColor = .systemBackground
        
        // Add navigation bar button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(dismissViewController))
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(profileImageView)
        contentView.addSubview(nameLabel)
        contentView.addSubview(emailLabel)
        
        // Calendar section
        contentView.addSubview(openCalendarButton)
        contentView.addSubview(createEventButton)
        contentView.addSubview(viewEventsButton)
        contentView.addSubview(openGoogleCalendarButton)
        
        // Profile section
        contentView.addSubview(accountSettingsButton)
        contentView.addSubview(downloadsButton)
        contentView.addSubview(signOutButton)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            // ScrollView
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            // Content View
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            // Profile Image
            profileImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 80),
            profileImageView.heightAnchor.constraint(equalToConstant: 80),
            
            // Name Label
            nameLabel.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            nameLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            nameLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Email Label
            emailLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8),
            emailLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            emailLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            // Calendar Section
            openCalendarButton.topAnchor.constraint(equalTo: emailLabel.bottomAnchor, constant: 30),
            openCalendarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            openCalendarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            openCalendarButton.heightAnchor.constraint(equalToConstant: 50),
            
            createEventButton.topAnchor.constraint(equalTo: openCalendarButton.bottomAnchor, constant: 12),
            createEventButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            createEventButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            createEventButton.heightAnchor.constraint(equalToConstant: 50),
            
            viewEventsButton.topAnchor.constraint(equalTo: createEventButton.bottomAnchor, constant: 12),
            viewEventsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            viewEventsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            viewEventsButton.heightAnchor.constraint(equalToConstant: 44),
            
            openGoogleCalendarButton.topAnchor.constraint(equalTo: viewEventsButton.bottomAnchor, constant: 12),
            openGoogleCalendarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            openGoogleCalendarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            openGoogleCalendarButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Profile Section
            accountSettingsButton.topAnchor.constraint(equalTo: openGoogleCalendarButton.bottomAnchor, constant: 30),
            accountSettingsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            accountSettingsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            accountSettingsButton.heightAnchor.constraint(equalToConstant: 44),
            
            downloadsButton.topAnchor.constraint(equalTo: accountSettingsButton.bottomAnchor, constant: 16),
            downloadsButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            downloadsButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            downloadsButton.heightAnchor.constraint(equalToConstant: 44),
            
            signOutButton.topAnchor.constraint(equalTo: downloadsButton.bottomAnchor, constant: 30),
            signOutButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            signOutButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            signOutButton.heightAnchor.constraint(equalToConstant: 44),
            signOutButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupActions() {
        openCalendarButton.addTarget(self, action: #selector(openAppleCalendar), for: .touchUpInside)
        createEventButton.addTarget(self, action: #selector(createNetflixEvent), for: .touchUpInside)
        viewEventsButton.addTarget(self, action: #selector(viewCalendarEvents), for: .touchUpInside)
        openGoogleCalendarButton.addTarget(self, action: #selector(openGoogleCalendar), for: .touchUpInside)
        accountSettingsButton.addTarget(self, action: #selector(openAccountSettings), for: .touchUpInside)
        downloadsButton.addTarget(self, action: #selector(openDownloads), for: .touchUpInside)
        signOutButton.addTarget(self, action: #selector(signOut), for: .touchUpInside)
    }
    
    // MARK: - Calendar Integration Functions
    
    private func requestCalendarPermission() {
        eventStore.requestAccess(to: .event) { [weak self] granted, error in
            DispatchQueue.main.async {
                if !granted {
                    self?.showCalendarPermissionAlert()
                }
            }
        }
    }
    
    @objc private func openAppleCalendar() {
        // Method 1: Open Apple Calendar app directly
        if let calendarURL = URL(string: "calshow://") {
            if UIApplication.shared.canOpenURL(calendarURL) {
                UIApplication.shared.open(calendarURL, options: [:], completionHandler: nil)
            } else {
                // Fallback to calendar:// scheme
                if let fallbackURL = URL(string: "calendar://") {
                    UIApplication.shared.open(fallbackURL, options: [:], completionHandler: nil)
                } else {
                    showErrorAlert(message: "Cannot open Calendar app. Please make sure it's installed.")
                }
            }
        }
    }
    
    @objc private func createNetflixEvent() {
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
            showCalendarPermissionAlert()
            return
        }
        
        // Create event using native EventKitUI
        let eventController = EKEventEditViewController()
        eventController.eventStore = eventStore
        eventController.editViewDelegate = self
        
        // Pre-populate event details
        let event = EKEvent(eventStore: eventStore)
        event.title = "Watch Netflix 🎬"
        event.notes = "Time to watch your favorite Netflix shows and movies!"
        event.startDate = Date().addingTimeInterval(3600) // 1 hour from now
        event.endDate = Date().addingTimeInterval(7200) // 2 hours from now
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        // Add reminder
        let alarm = EKAlarm(relativeOffset: -600) // 10 minutes before
        event.addAlarm(alarm)
        
        eventController.event = event
        
        present(eventController, animated: true)
    }
    
    @objc private func viewCalendarEvents() {
        guard EKEventStore.authorizationStatus(for: .event) == .authorized else {
            showCalendarPermissionAlert()
            return
        }
        
        // Show calendar chooser to view events
        let calendarChooser = EKCalendarChooser(selectionStyle: .single, displayStyle: .allCalendars, entityType: .event, eventStore: eventStore)
        calendarChooser.title = "Choose Calendar to View"
        calendarChooser.delegate = self
        
        let navController = UINavigationController(rootViewController: calendarChooser)
        present(navController, animated: true)
    }
    
    @objc private func openGoogleCalendar() {
        // Try to open Google Calendar app
        if let googleCalendarURL = URL(string: "googlecalendar://") {
            if UIApplication.shared.canOpenURL(googleCalendarURL) {
                UIApplication.shared.open(googleCalendarURL, options: [:], completionHandler: nil)
            } else {
                // Fallback to web version
                if let webURL = URL(string: "https://calendar.google.com") {
                    UIApplication.shared.open(webURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    private func showCalendarPermissionAlert() {
        let alert = UIAlertController(
            title: "Calendar Access Needed",
            message: "To create and view calendar events, please allow calendar access in Settings.",
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
    
    private func showErrorAlert(message: String) {
        let alert = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    // MARK: - Other Button Actions
    
    @objc private func dismissViewController() {
        dismiss(animated: true)
    }
    
    @objc private func openAccountSettings() {
        let alert = UIAlertController(title: "Account Settings", message: "Account settings would be implemented here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func openDownloads() {
        let alert = UIAlertController(title: "Downloads", message: "Downloads management would be implemented here", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @objc private func signOut() {
        let alert = UIAlertController(title: "Sign Out", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        let signOut = UIAlertAction(title: "Sign Out", style: .destructive) { _ in
            // Handle sign out logic here
            print("User signed out")
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel)
        
        alert.addAction(signOut)
        alert.addAction(cancel)
        
        present(alert, animated: true)
    }
}

// MARK: - EKEventEditViewDelegate

extension ProfileViewController: EKEventEditViewDelegate {
    func eventEditViewController(_ controller: EKEventEditViewController, didCompleteWith action: EKEventEditViewAction) {
        controller.dismiss(animated: true) {
            switch action {
            case .saved:
                let alert = UIAlertController(title: "Event Saved! 🎉", message: "Your Netflix reminder has been added to your calendar", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Great!", style: .default))
                self.present(alert, animated: true)
            case .canceled:
                print("Event creation canceled")
            case .deleted:
                print("Event deleted")
            @unknown default:
                break
            }
        }
    }
}

// MARK: - EKCalendarChooserDelegate

extension ProfileViewController: EKCalendarChooserDelegate {
    func calendarChooserDidFinish(_ calendarChooser: EKCalendarChooser) {
        calendarChooser.dismiss(animated: true) {
            if let selectedCalendar = calendarChooser.selectedCalendars.first {
                self.showEventsForCalendar(selectedCalendar)
            }
        }
    }
    
    func calendarChooserDidCancel(_ calendarChooser: EKCalendarChooser) {
        calendarChooser.dismiss(animated: true)
    }
    
    private func showEventsForCalendar(_ calendar: EKCalendar) {
        let startDate = Date()
        let endDate = Calendar.current.date(byAdding: .month, value: 1, to: startDate) ?? Date()
        
        let predicate = eventStore.predicateForEvents(withStart: startDate, end: endDate, calendars: [calendar])
        let events = eventStore.events(matching: predicate)
        
        let message = events.isEmpty ? "No events found in the next month" : "\(events.count) events found in the next month"
        
        let alert = UIAlertController(title: "Calendar Events", message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}

