//
//  HomeItemTableViewCell.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 26.06.2022.
//

import UIKit
import Kingfisher

class HomeItemTableViewCell: UITableViewCell {
    private let padding: CGFloat = Constants.UI.defaultPadding

    lazy var userNameLabel: UILabel = {
        let label = UILabel()
        label.text = "Razvan"
        label.numberOfLines = 2
        label.textColor =  Constants.UI.defaultTextColor
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        return label
    }()
    
    lazy var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor =  Constants.UI.defaultTextColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        label.numberOfLines = 0
        return label
    }()
    
    lazy var dateLabel: UILabel = {
        let label = UILabel()
        label.textColor =  Constants.UI.defaultTextColor
        label.font = UIFont.systemFont(ofSize: 15, weight: .semibold)
        return label
    }()
    
    lazy var mediaImageView: ISImageView = {
        let imageView = ISImageView(image: UIImage(named: "Rep"))
        imageView.backgroundColor = .lightGray
        imageView.isUserInteractionEnabled = true
        imageView.isInteractable = true
        return imageView
    }()
    
    lazy var carouselView: CarouselView = {
        let view = CarouselView()
        return view
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.backgroundColor = UIColor.clear
        self.selectionStyle = .none
        addSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func prepareForReuse() {
          super.prepareForReuse()
        mediaImageView.kf.cancelDownloadTask()
        mediaImageView.image = nil
        mediaImageView.clearConstraints()
    }
    
    
    func update(uiElement: HomeUIElement, dateFormatter: DateFormatter) {
        let media = uiElement.media
        userNameLabel.text = uiElement.userName
        descriptionLabel.text = media?.caption
        dateLabel.text = dateFormatter.string(from: media?.timestamp ?? Date())
        mediaImageView.isHidden = true
        carouselView.isHidden = true
        guard let mediaType = media?.mediaType else {
            return
        }
        let imageRatio = media?.imageRatio ?? 0.5
        switch mediaType {
        case .carouselAlbum:
            carouselView.isHidden = false
            carouselView.setView(medias:(media?.children?.data ?? []), imageRatio: imageRatio)
        case .image:
            if let mediaUrl = media?.imageUrl {
                mediaImageView.clearConstraints()
                mediaImageView.heightAnchor(equalTo: UIScreen.main.bounds.width * imageRatio)
                mediaImageView.kf.setImage(with: mediaUrl)
                mediaImageView.isHidden = false
            }
        }
                    
    }
    
    private func addSubviews() {
        let leadingConstant: CGFloat = Constants.UI.defaultPadding
        let stackview = UIStackView()
        stackview.axis = .vertical
        stackview.spacing = 5
        contentView.addSubview(stackview)
        stackview.leadingAnchor(equalTo: contentView.leadingAnchor)
            .topAnchor(equalTo: contentView.topAnchor)
            .trailingAnchor(equalTo: contentView.trailingAnchor)
            .bottomAnchor(equalTo: contentView.bottomAnchor, constant: -15, priority: .medium)
        
        let userNameParentView = UIView()
        stackview.addArrangedSubview(userNameParentView)
        userNameParentView.addSubview(userNameLabel)
        userNameLabel.leadingAnchor(equalTo: userNameParentView.leadingAnchor, constant: leadingConstant)
            .trailingAnchor(equalTo: userNameParentView.trailingAnchor)
            .topAnchor(equalTo: userNameParentView.topAnchor)
            .bottomAnchor(equalTo: userNameParentView.bottomAnchor)
        
        stackview.addArrangedSubview(mediaImageView)
        stackview.addArrangedSubview(carouselView)
        
        let dateParentView = UIView()
        stackview.addArrangedSubview(dateParentView)
        dateParentView.addSubview(dateLabel)
        dateLabel.leadingAnchor(equalTo: dateParentView.leadingAnchor, constant: leadingConstant)
            .trailingAnchor(equalTo: dateParentView.trailingAnchor)
            .topAnchor(equalTo: dateParentView.topAnchor)
            .bottomAnchor(equalTo: dateParentView.bottomAnchor)
        
        
        let descriptionParentView = UIView()
        stackview.addArrangedSubview(descriptionParentView)
        descriptionParentView.addSubview(descriptionLabel)
        descriptionLabel.leadingAnchor(equalTo: descriptionParentView.leadingAnchor, constant: leadingConstant)
            .trailingAnchor(equalTo: descriptionParentView.trailingAnchor)
            .topAnchor(equalTo: descriptionParentView.topAnchor)
            .bottomAnchor(equalTo: descriptionParentView.bottomAnchor)
        
    }
}
