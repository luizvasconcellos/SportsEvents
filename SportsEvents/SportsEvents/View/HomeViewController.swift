//
//  HomeViewController.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 12/10/24.
//

import UIKit
import Combine

// MARK: - Cell identifiers
private struct HomeViewControllerIdentifiers {
    static let header = "HeaderCollectionReusableViewIdentifier"
    static let cell = "SportEventCellIdentifier"
}

final class HomeViewController: UIViewController {
    
    // MARK: - properties
    private var viewModel: SportsEventsViewModel?
    private var cancellables = Set<AnyCancellable>()
    private var collapsedSections = Set<Int>()
    
    // MARK: - UI Elements
    private lazy var collectionView = UICollectionView()

    // MARK: - init
    init(viewModel: SportsEventsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCollectionView()
        registerCell()
        setupNavigationBar()
        binding()
        setupUI()
        collectionView.reloadData()
    }
}

// MARK: - Private Functions
extension HomeViewController {
    
    private func binding() {
        viewModel?.$sportsEventsPublished
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.collectionView.reloadData()
            }
            .store(in: &cancellables)
        
        viewModel?.$favoriteActionMessagePublished
            .receive(on: DispatchQueue.main)
            .sink { message in
                if !message.isEmpty {
                    ToastMessage.show(message: message,
                                      position: .bottom)
                }
            }
            .store(in: &cancellables)
        
        viewModel?.$fetchErrorPublished
            .receive(on: DispatchQueue.main)
            .sink { message in
                if !message.isEmpty {
                    ToastMessage.show(message: message,
                                      position: .bottom,
                                      type: .error)
                }
            }
            .store(in: &cancellables)
    }
    
    private func setupUI() {
        
        view.addSubview(collectionView)
        collectionView.backgroundColor = .clear
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
    }
    
    private func configureCollectionView() {
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: createCompositionalLayout())
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        collectionView.delegate = self
        collectionView.dataSource = self
    }
    
    private func registerCell() {
        
        collectionView.register(SportEventCollectionViewCell.self, forCellWithReuseIdentifier: HomeViewControllerIdentifiers.cell)
        collectionView.register(HeaderCollectionReusableView.self,
                                forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                                withReuseIdentifier: HomeViewControllerIdentifiers.header)
    }
    
    private func createCompositionalLayout() -> UICollectionViewCompositionalLayout {
        
        return UICollectionViewCompositionalLayout { (sectionIndex, environment) -> NSCollectionLayoutSection? in
            let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(0.25), heightDimension: .absolute(130))
            let item = NSCollectionLayoutItem(layoutSize: itemSize)
            item.contentInsets = NSDirectionalEdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4)
            
            let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .absolute(150))
            let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, subitems: [item])
            
            let section = NSCollectionLayoutSection(group: group)
            section.orthogonalScrollingBehavior = .continuous
            
            let headerSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .estimated(44))
            let sectionHeader = NSCollectionLayoutBoundarySupplementaryItem(
                layoutSize: headerSize,
                elementKind: UICollectionView.elementKindSectionHeader,
                alignment: .top)
            
            section.boundarySupplementaryItems = [sectionHeader]
            return section
        }
    }
    
    private func setupNavigationBar() {
        
        navigationItem.title = "Sports Events"
        navigationController?.setNavigationBarHidden(false, animated: false)
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationController?.navigationBar.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        let rightButton = UIBarButtonItem(title: nil, image: UIImage(systemName: "gear"), target: self, action: nil)
        navigationItem.rightBarButtonItem = rightButton
    }
}

// MARK: - Collectionview Delegate and DataSource
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel?.sportsEvents.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collapsedSections.contains(section) ? 0 : viewModel?.sportsEvents[section].activeEvents.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeViewControllerIdentifiers.cell, for: indexPath) as? SportEventCollectionViewCell,
              let event = viewModel?.sportsEvents[indexPath.section].activeEvents[indexPath.item] else { return UICollectionViewCell() }
        
        cell.configure(with: event)
        cell.favoriteAction = { [weak self] in
            guard let self = self else { return }
            
            self.viewModel?.addOrRemoveFavorite(eventId: event.eventId, sportId: event.sportId)
            self.collectionView.reloadSections([indexPath.section])
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let header = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: HomeViewControllerIdentifiers.header, for: indexPath) as? HeaderCollectionReusableView else {
            return UICollectionReusableView()
        }
        
        let sport = viewModel?.sportsEvents[indexPath.section]
        let nameWithEmoji = "\(sport?.sportId.emoji ?? "") \(sport?.sportName ?? "")"
        header.configure(with: nameWithEmoji, isCollapsed: collapsedSections.contains(indexPath.section))
        
        header.collapsableAction = { [weak self, weak header] in
            guard let self = self, let header = header else { return }
            if self.collapsedSections.contains(indexPath.section) {
                self.collapsedSections.remove(indexPath.section)
            } else {
                self.collapsedSections.insert(indexPath.section)
            }
            header.isCollapsed = self.collapsedSections.contains(indexPath.section)
            self.collectionView.reloadSections([indexPath.section])
        }
        return header
    }
}
