//
//  ContainerPageViewController.swift
//  InstaQR
//
//  Created by Oleg Abalonski on 12/18/19.
//  Copyright © 2019 Oleg Abalonski. All rights reserved.
//

import UIKit

// medium.com/unsplash/ios-on-demand-resources-and-on-boarding-f9dc8014cbd8

class ContainerPageViewController: UIViewController {
    
    // MARK: - Internal Properties
    
    var pageSections: [PageSection]!
    
    // MARK: - Private Properties
    
    fileprivate lazy var pageViewController: UIPageViewController = {
        let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        pageViewController.delegate = self
        pageViewController.dataSource = self
        pageViewController.view.translatesAutoresizingMaskIntoConstraints = false
        return pageViewController
    }()
    
    fileprivate lazy var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.numberOfPages = pageSections.count
        pageControl.currentPage = 0
        pageControl.pageIndicatorTintColor = .systemGray5
        pageControl.currentPageIndicatorTintColor = .label
        pageControl.isUserInteractionEnabled = false
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        return pageControl
    }()
    
    // MARK: - View Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        view.addSubview(pageControl)
        setupPageViewController()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        layoutViews()
    }
    
    // MARK: - Setup
    
    fileprivate func setupPageViewController() {
        view.addSubview(pageViewController.view)
        addChild(pageViewController)
        pageViewController.didMove(toParent: self)
        
        let pageSectionViewController = getViewController(at: 0)
        pageViewController.setViewControllers([pageSectionViewController], direction: .forward, animated: false)
    }
    
    // MARK: - Layout
    
    fileprivate func layoutViews() {
        
        NSLayoutConstraint.activate([
            pageControl.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            pageControl.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            pageControl.heightAnchor.constraint(equalToConstant: 20.0),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -System.shared.globalInset),
            
            pageViewController.view.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pageViewController.view.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pageViewController.view.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20.0),
            pageViewController.view.bottomAnchor.constraint(equalTo: pageControl.topAnchor, constant: -view.layoutMargins.left),
        ])
    }
    
    // MARK: - Private Methods
    
    fileprivate func getViewController(at index: Int) -> PageSectionViewController {
        let pageSectionViewController = PageSectionViewController()
        pageSectionViewController.pageIndex = index
        pageSectionViewController.inset = 16.0
        pageSectionViewController.gifName = pageSections[index].gifFileName
        pageSectionViewController.placeholderImage = UIImage(named: pageSections[index].placeholderImageFileName)
        pageSectionViewController.sectionTitle = pageSections[index].title
        pageSectionViewController.sectionSubtitle = pageSections[index].subtitle
        return pageSectionViewController
    }
    
    // MARK: - Actions
    
    @objc fileprivate func cancelButtonWasTapped() {
        dismiss(animated: true, completion: nil)
    }
}

// MARK: - UIPageViewControllerDataSource
extension ContainerPageViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let onBoardingSectionViewController = viewController as? PageSectionViewController else { return nil }
        let currentIndex = onBoardingSectionViewController.pageIndex
        
        if (currentIndex <= 0) { return nil }
        
        return getViewController(at: currentIndex - 1)
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let onBoardingSectionViewController = viewController as? PageSectionViewController else { return nil }
        let currentIndex = onBoardingSectionViewController.pageIndex
        
        if (currentIndex >= pageSections.count - 1) { return nil }
        
        return getViewController(at: currentIndex + 1)
    }
}

// MARK: - UIPageViewControllerDelegate
extension ContainerPageViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        
        guard let onBoardingSectionViewController = pageViewController.viewControllers?[0] as? PageSectionViewController else { return }
        let currentIndex = onBoardingSectionViewController.pageIndex
        pageControl.currentPage = currentIndex
    }
}
