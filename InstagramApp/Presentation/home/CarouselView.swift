//
//  CarouselView.swift
//  InstagramApp
//
//  Created by Razvan Cozma on 26.06.2022.
//

import UIKit

class CarouselView: UIView {
    lazy var scrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.delegate = self
        scrollView.bounces = false
        return scrollView
    }()
    
    lazy var stackView: UIStackView = {
       let stackView = UIStackView()
        stackView.distribution = .fillEqually
        stackView.axis = .horizontal
        stackView.backgroundColor = .black
        return stackView
    }()
    
    lazy var pageControl: ScrollingPageControl = {
        return ScrollingPageControl()
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addCustomView()
    }

    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func addCustomView() {
        self.addSubview(scrollView)
        self.addSubview(pageControl)
        scrollView.leadingAnchor(equalTo: leadingAnchor)
            .trailingAnchor(equalTo: trailingAnchor)
            .topAnchor(equalTo: topAnchor)
        
        scrollView.addSubview(stackView)
        stackView.leadingAnchor(equalTo: scrollView.leadingAnchor)
            .trailingAnchor(equalTo: scrollView.trailingAnchor)
            .topAnchor(equalTo: scrollView.topAnchor)
            .bottomAnchor(equalTo: scrollView.bottomAnchor)
        pageControl.topAnchor(equalTo: scrollView.bottomAnchor, constant: 5)
            .bottomAnchor(equalTo: bottomAnchor)
            .centerXAnchor(equalTo: centerXAnchor)
    }
    
    func setView(medias: [Media], imageRatio: CGFloat) {
        pageControl.pages = medias.count
        stackView.subviews.forEach {$0.removeFromSuperview()}
        let height = UIScreen.main.bounds.width * imageRatio
        for media in medias {
            guard let url =  URL(string: media.mediaUrl ?? "") else {
                continue
            }
            let item = ISImageView(image: UIImage(named: "Rep"))
            item.translatesAutoresizingMaskIntoConstraints = false
            item.isUserInteractionEnabled = true
            item.kf.setImage(with: url)
            item.isInteractable = true
            stackView.addArrangedSubview(item)
            item.heightAnchor(equalTo: height)
            item.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        }
        scrollView.heightAnchor(equalTo: height)
    }
}

extension CarouselView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = round(scrollView.contentOffset.x / scrollView.frame.width)
        pageControl.selectedPage = Int(page)
    }
}
