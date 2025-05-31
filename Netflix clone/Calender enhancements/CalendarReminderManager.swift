//
//  CalendarReminderManager.swift
//  Netflix clone
//
//  Created by AMAN K.A on 31/05/25.
//

import Foundation
import EventKit
import UIKit

class CalendarReminderManager {
    
    static let shared = CalendarReminderManager()
    private let eventStore = EKEventStore()
    
    private init() {}
    
    // MARK: - Calendar Permission
    
    func requestCalendarPermission(completion: @escaping (Bool) -> Void) {
        eventStore.requestAccess(to: .event) { granted, error in
            DispatchQueue.main.async {
                completion(granted)
            }
        }
    }
    
    var hasCalendarPermission: Bool {
        return EKEventStore.authorizationStatus(for: .event) == .authorized
    }
    
    // MARK: - Create Reminder
    
    func createWatchReminder(
        for title: String,
        on date: Date,
        duration: TimeInterval = 7200, // Default 2 hours
        reminderMinutesBefore: Double = 10,
        completion: @escaping (Bool, Error?) -> Void
    ) {
        guard hasCalendarPermission else {
            completion(false, CalendarError.noPermission)
            return
        }
        
        let event = EKEvent(eventStore: eventStore)
        event.title = "Watch: \(title)"
        event.notes = "Reminder to watch \(title) on Netflix 🎬"
        event.startDate = date
        event.endDate = date.addingTimeInterval(duration)
        event.calendar = eventStore.defaultCalendarForNewEvents
        
        // Add alarm
        let alarm = EKAlarm(relativeOffset: -reminderMinutesBefore * 60)
        event.addAlarm(alarm)
        
        do {
            try eventStore.save(event, span: .thisEvent)
            completion(true, nil)
        } catch {
            completion(false, error)
        }
    }
    
    // MARK: - Quick Reminder Options
    
    func showQuickReminderOptions(
        for movieTitle: String,
        from viewController: UIViewController,
        completion: @escaping (Bool) -> Void
    ) {
        let alert = UIAlertController(
            title: "Set Watch Reminder",
            message: "When would you like to be reminded to watch \"\(movieTitle)\"?",
            preferredStyle: .actionSheet
        )
        
        // Tonight option
        let tonight = UIAlertAction(title: "🌙 Tonight at 8 PM", style: .default) { [weak self] _ in
            let tonight8PM = self?.getTonightAt8PM() ?? Date()
            self?.createWatchReminder(for: movieTitle, on: tonight8PM) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self?.showSuccessAlert(for: movieTitle, date: tonight8PM, from: viewController)
                    } else {
                        self?.showErrorAlert(error: error, from: viewController)
                    }
                    completion(success)
                }
            }
        }
        
        // Tomorrow option
        let tomorrow = UIAlertAction(title: "☀️ Tomorrow at 7 PM", style: .default) { [weak self] _ in
            let tomorrow7PM = self?.getTomorrowAt7PM() ?? Date()
            self?.createWatchReminder(for: movieTitle, on: tomorrow7PM) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self?.showSuccessAlert(for: movieTitle, date: tomorrow7PM, from: viewController)
                    } else {
                        self?.showErrorAlert(error: error, from: viewController)
                    }
                    completion(success)
                }
            }
        }
        
        // Weekend option
        let weekend = UIAlertAction(title: "🎉 This Weekend", style: .default) { [weak self] _ in
            let weekendDate = self?.getThisWeekend() ?? Date()
            self?.createWatchReminder(for: movieTitle, on: weekendDate) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self?.showSuccessAlert(for: movieTitle, date: weekendDate, from: viewController)
                    } else {
                        self?.showErrorAlert(error: error, from: viewController)
                    }
                    completion(success)
                }
            }
        }
        
        // Custom date option
        let custom = UIAlertAction(title: "📅 Choose Custom Date", style: .default) { [weak self] _ in
            self?.showCustomDatePicker(for: movieTitle, from: viewController, completion: completion)
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        
        alert.addAction(tonight)
        alert.addAction(tomorrow)
        alert.addAction(weekend)
        alert.addAction(custom)
        alert.addAction(cancel)
        
        // For iPad
        if let popover = alert.popoverPresentationController {
            popover.sourceView = viewController.view
            popover.sourceRect = CGRect(x: viewController.view.bounds.midX, y: viewController.view.bounds.midY, width: 0, height: 0)
        }
        
        viewController.present(alert, animated: true)
    }
    
    // MARK: - Custom Date Picker
    
    private func showCustomDatePicker(
        for movieTitle: String,
        from viewController: UIViewController,
        completion: @escaping (Bool) -> Void
    ) {
        let alert = UIAlertController(title: "When to watch \(movieTitle)?", message: "Select date and time", preferredStyle: .alert)
        
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .dateAndTime
        datePicker.preferredDatePickerStyle = .compact
        datePicker.minimumDate = Date()
        
        alert.setValue(datePicker, forKey: "contentViewController")
        
        let setReminder = UIAlertAction(title: "Set Reminder", style: .default) { [weak self] _ in
            self?.createWatchReminder(for: movieTitle, on: datePicker.date) { success, error in
                DispatchQueue.main.async {
                    if success {
                        self?.showSuccessAlert(for: movieTitle, date: datePicker.date, from: viewController)
                    } else {
                        self?.showErrorAlert(error: error, from: viewController)
                    }
                    completion(success)
                }
            }
        }
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            completion(false)
        }
        
        alert.addAction(setReminder)
        alert.addAction(cancel)
        
        viewController.present(alert, animated: true)
    }
    
    // MARK: - Helper Functions
    
    private func getTonightAt8PM() -> Date {
        let calendar = Calendar.current
        let today = Date()
        var components = calendar.dateComponents([.year, .month, .day], from: today)
        components.hour = 20 // 8 PM
        components.minute = 0
        return calendar.date(from: components) ?? today
    }
    
    private func getTomorrowAt7PM() -> Date {
        let calendar = Calendar.current
        let tomorrow = calendar.date(byAdding: .day, value: 1, to: Date()) ?? Date()
        var components = calendar.dateComponents([.year, .month, .day], from: tomorrow)
        components.hour = 19 // 7 PM
        components.minute = 0
        return calendar.date(from: components) ?? tomorrow
    }
    
    private func getThisWeekend() -> Date {
        let calendar = Calendar.current
        let today = Date()
        let weekday = calendar.component(.weekday, from: today)
        
        // Calculate days until Saturday (weekday 7)
        let daysUntilSaturday = (7 - weekday + 1) % 7
        let saturday = calendar.date(byAdding: .day, value: daysUntilSaturday == 0 ? 7 : daysUntilSaturday, to: today) ?? today
        
        var components = calendar.dateComponents([.year, .month, .day], from: saturday)
        components.hour = 14 // 2 PM
        components.minute = 0
        return calendar.date(from: components) ?? saturday
    }
    
    // MARK: - Alert Helpers
    
    private func showSuccessAlert(for movieTitle: String, date: Date, from viewController: UIViewController) {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        let alert = UIAlertController(
            title: "Reminder Set! 🎉",
            message: "You'll be reminded to watch '\(movieTitle)' on \(formatter.string(from: date))",
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "Great!", style: .default))
        viewController.present(alert, animated: true)
    }
    
    private func showErrorAlert(error: Error?, from viewController: UIViewController) {
        let message = error?.localizedDescription ?? "Unknown error occurred"
        let alert = UIAlertController(
            title: "Could not set reminder",
            message: message,
            preferredStyle: .alert
        )
        
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        viewController.present(alert, animated: true)
    }
    
    func showPermissionAlert(from viewController: UIViewController) {
        let alert = UIAlertController(
            title: "Calendar Access Needed",
            message: "To set watch reminders, please allow calendar access in Settings.",
            preferredStyle: .alert
        )
        
        let settings = UIAlertAction(title: "Open Settings", style: .default) { _ in
            if let settingsURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(settingsURL)
            }
        }
        
        let cancel = UIAlertAction(title: "Maybe Later", style: .cancel)
        
        alert.addAction(settings)
        alert.addAction(cancel)
        
        viewController.present(alert, animated: true)
    }
}

// MARK: - Error Types

enum CalendarError: LocalizedError {
    case noPermission
    
    var errorDescription: String? {
        switch self {
        case .noPermission:
            return "Calendar access permission is required to set reminders."
        }
    }
}
