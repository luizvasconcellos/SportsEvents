//
//  SportEventCollectionViewCell.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 12/10/24.
//

import UIKit

final class SportEventCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    private var timer: Timer?
    private var event: Event? {
        didSet {
            bindUI()
            startTimer()
        }
    }
    var favoriteAction: (() -> Void)?
    
    // MARK: - UI Elements
    private lazy var stackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 4.0
        view.alignment = .center
        view.distribution = .fillProportionally
        
        return view
    }()
    
    private lazy var timerLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.textColor = .lightGray
        
        return view
    }()
    
    private lazy var favoriteButton: UIButton = {
        let view = UIButton()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.heightAnchor.constraint(equalToConstant: 40).isActive = true
        view.setTitleColor(.yellow, for: .normal)
        
        return view
    }()
    
    private lazy var firstTeamLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.textColor = .lightGray
        view.lineBreakMode = .byTruncatingTail
        
        return view
    }()
    
    private lazy var secondTeamLabel: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.numberOfLines = 1
        view.textColor = .lightGray
        view.lineBreakMode = .byTruncatingTail
        
        return view
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private Functions
extension SportEventCollectionViewCell {
    private func setupUI() {
        
        backgroundColor = .clear
        stackView.addArrangedSubview(timerLabel)
        stackView.addArrangedSubview(favoriteButton)
        
        contentView.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor)
        ])
        
        favoriteButton.addTarget(self, action: #selector(favoriteButtonTapped), for: .touchUpInside)
    }
    
    private func bindUI() {
        
        var image = UIImage(systemName: "star")
        favoriteButton.tintColor = .darkGray
        if event?.isFavorite ?? false {
            image = UIImage(systemName: "star.fill")
            favoriteButton.tintColor = .yellow
        }
        favoriteButton.setImage(image, for: .normal)
        
        let teams = event?.eventName.components(separatedBy: "-")
        addTeamsToStack(teams)
    }
    
    private func addTeamsToStack(_ teams: [String]?) {
        
        if let teams = teams {
            firstTeamLabel.text = teams.first
            stackView.addArrangedSubview(firstTeamLabel)
            secondTeamLabel.text = teams.last
            stackView.addArrangedSubview(secondTeamLabel)
        }
    }
    
    private func startTimer() {
        
        timer?.invalidate()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(updateTimer), userInfo: nil, repeats: true)
        updateTimer()
    }
    
    @objc private func updateTimer() {
        
        guard let startTime = event?.eventStartTime else {
            timerLabel.text = "HH:MM:SS"
            return
        }
        
        let currentDate = Date()
        let timeInterval = startTime.timeIntervalSince(currentDate)
        let hours = Int(timeInterval) / 3600
        let minutes = (Int(timeInterval) % 3600) / 60
        let seconds = Int(timeInterval) % 60
        
        if timeInterval == 0 {
            if let eventName = event?.eventName {
                ToastMessage.show(message: "The event \(eventName) is starting now",
                                  position: .bottom)
            }
        }
        if timeInterval <= 0 {
            timer?.invalidate()
            timer = nil
            if timeInterval > -90 {
                timerLabel.text = "on going"
            } else {
                timerLabel.text = "early today"
            }
        } else {
            timerLabel.text = String(format: "%02d:%02d:%02d", hours, minutes, seconds)
            if hours < 2 {
                timerLabel.textColor = .red
            }
        }
    }
    
    @objc private func favoriteButtonTapped() {
        favoriteAction?()
    }
    
    override func prepareForReuse() {
        timerLabel.textColor = .lightGray
    }
}
    // MARK: - Configure Cell
extension SportEventCollectionViewCell {
    /// Function to configure the cell with data
    /// - Parameters
    ///  - event: Event object to be used by the cell
    func configure(with event: Event) {
        self.event = event
    }
}
