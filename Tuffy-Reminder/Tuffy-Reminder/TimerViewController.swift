//
//  TimerViewController.swift
//  Tuffy-Reminder
//
//  Created by csuftitan on 12/9/24.
//

import UIKit

class TimerViewController: UIViewController {

    // Timer components
    private var timer: Timer?
    private var remainingTime: Int = 25 * 60 // Default to 25 minutes in seconds
    
    // UI Components
    private let timerLabel: UILabel = {
        let label = UILabel()
        label.text = "25:00"
        label.font = UIFont.systemFont(ofSize: 48, weight: .bold)
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.addTarget(self, action: #selector(startTimer), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let resetButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Reset", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 20, weight: .medium)
        button.addTarget(self, action: #selector(resetTimer), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup UI
    private func setupUI() {
        view.backgroundColor = .systemBackground
        view.addSubview(timerLabel)
        view.addSubview(startButton)
        view.addSubview(resetButton)
        
        // Constraints
        NSLayoutConstraint.activate([
            // Timer label constraints
            timerLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timerLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: -50),
            
            // Start button constraints
            startButton.topAnchor.constraint(equalTo: timerLabel.bottomAnchor, constant: 20),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            // Reset button constraints
            resetButton.topAnchor.constraint(equalTo: startButton.bottomAnchor, constant: 10),
            resetButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    // MARK: - Timer Logic
    @objc private func startTimer() {
        if timer == nil { // Start timer only if it's not already running
            timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
            startButton.setTitle("Pause", for: .normal)
        } else {
            // Pause the timer
            timer?.invalidate()
            timer = nil
            startButton.setTitle("Start", for: .normal)
        }
    }
    
    @objc private func resetTimer() {
        timer?.invalidate()
        timer = nil
        remainingTime = 25 * 60 // Reset to 25 minutes
        timerLabel.text = formatTime(remainingTime)
        startButton.setTitle("Start", for: .normal)
    }
    
    @objc private func updateTimer() {
        if remainingTime > 0 {
            remainingTime -= 1
            timerLabel.text = formatTime(remainingTime)
        } else {
            timer?.invalidate()
            timer = nil
            startButton.setTitle("Start", for: .normal)
            showAlert()
        }
    }
    
    private func formatTime(_ seconds: Int) -> String {
        let minutes = seconds / 60
        let remainingSeconds = seconds % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
    
    private func showAlert() {
        let alert = UIAlertController(title: "Time's Up!", message: "Pomodoro session completed.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
}
