//
//  HeaderCollectionReusableView.swift
//  SportsEvents
//
//  Created by Luiz Vasconcellos on 13/10/24.
//

import UIKit

final class HeaderCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Properties
    var collapsableAction: (() -> Void)?
    var isCollapsed: Bool = false {
        didSet {
            setChevronImage()
        }
    }
    
    // MARK: - UI elements
    private lazy var contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor(red: 37.0/255.0, green: 42.0/255.0, blue: 53.0/255.0, alpha: 1.0)
        
        return view
    }()
    
    private lazy var headerTitle: UILabel = {
        let view = UILabel()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.font = .preferredFont(forTextStyle: .title2)
        view.textColor = .white
        view.isUserInteractionEnabled = true
        
        return view
    }()
    
    private lazy var collapsableImage: UIImageView = {
        let view = UIImageView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.tintColor = .white
        
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
extension HeaderCollectionReusableView {
    private func setupUI() {
        
        setChevronImage()
        self.addSubview(contentView)
        contentView.addSubview(headerTitle)
        contentView.addSubview(collapsableImage)
        
        NSLayoutConstraint.activate([
            contentView.topAnchor.constraint(equalTo: self.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            headerTitle.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            headerTitle.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            collapsableImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            collapsableImage.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(collabsableHeaderTapped))
        addGestureRecognizer(tap)
    }
    
    private func setChevronImage() {
        collapsableImage.image = isCollapsed ? UIImage(systemName: "chevron.down") : UIImage(systemName: "chevron.up")
    }
    
    @objc private func collabsableHeaderTapped() {
        collapsableAction?()
    }
}
    
// MARK: - Configure cell
extension HeaderCollectionReusableView {
    /// Function to configure the header cell with data
    /// - Parameters
    ///  - title: String that will be shown on title
    ///  - isCollapsed: Bool to check if it's collapsa if it's collapsed or not to change the chevron image.
    func configure(with title: String, isCollapsed: Bool) {
        headerTitle.text = title
        self.isCollapsed = isCollapsed
    }
}
