//
//  Onboarding.swift
//  Onboarding
//
//  Created by Sachin Agrawal on 3/8/24.
//

import UIKit

class OnboardingViewController: UIViewController, UIScrollViewDelegate {

    // MARK: Onboarding Data
    let onboardingData = [
        OnboardingData(
            icon: "gamecontroller",
            header: "Gaming",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        ),
        OnboardingData(
            icon: "airplane",
            header: "Flights",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        ),
        OnboardingData(
            icon: "map.circle",
            header: "Information",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        ),
        OnboardingData(
            icon: "exclamationmark.shield",
            header: "Warning",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        ),
        OnboardingData(
            icon: "bell",
            header: "Notifications",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        ),
        OnboardingData(
            icon: "bookmark",
            header: "Bookmarks",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit."
        )
    ]
    
    // Page control for indicating current page
    let pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.currentPageIndicatorTintColor = UIColor.systemGray
        pageControl.pageIndicatorTintColor = UIColor.systemGray4
        return pageControl
    }()

    // Scroll view for displaying onboarding screens
    lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isPagingEnabled = true
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.delegate = self
        return scrollView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    // MARK: Setup Methods
    func setupViews() {
        view.addSubview(scrollView)
        scrollView.frame = view.bounds
        
        // Add swipe gestures for scrolling through pages
        let leftSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleLeftSwipe(_:)))
        leftSwipeGesture.direction = .left
        scrollView.addGestureRecognizer(leftSwipeGesture)

        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleRightSwipe(_:)))
        rightSwipeGesture.direction = .right
        scrollView.addGestureRecognizer(rightSwipeGesture)
        
        // Add page control
        pageControl.addTarget(self, action: #selector(pageControlValueChanged), for: .valueChanged)
        
        // Add onboarding views
        var previousView: UIView?
        for (_, data) in onboardingData.enumerated() {
            let onboardingView = OnboardingView(data: data)
            scrollView.addSubview(onboardingView)
            onboardingView.translatesAutoresizingMaskIntoConstraints = false

            // Set constraints for onboarding view
            NSLayoutConstraint.activate([
                onboardingView.topAnchor.constraint(equalTo: scrollView.topAnchor),
                onboardingView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
                onboardingView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
                onboardingView.heightAnchor.constraint(equalTo: scrollView.heightAnchor),
                onboardingView.leadingAnchor.constraint(equalTo: previousView?.trailingAnchor ?? scrollView.leadingAnchor)
            ])

            previousView = onboardingView
        }
        
        // Set scroll view content size and page control properties
        scrollView.contentSize = CGSize(width: scrollView.frame.width * CGFloat(onboardingData.count), height: scrollView.frame.height)
        scrollView.isPagingEnabled = true

        pageControl.numberOfPages = onboardingData.count
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(pageControl)

        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50)
        ])
        
        // Add continue button
        let continueButton = UIButton()
        continueButton.setTitle("Continue", for: .normal)
        continueButton.setTitleColor(.systemBlue, for: .normal)
        continueButton.addTarget(self, action: #selector(continueButtonTapped), for: .touchUpInside)
        continueButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(continueButton)
        
        // Set constraints for continue button
        NSLayoutConstraint.activate([
            continueButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            continueButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            continueButton.widthAnchor.constraint(equalToConstant: 150),
            continueButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        // Skip button
        let skipButton = UIButton()
        skipButton.setTitle("Skip", for: .normal)
        skipButton.setTitleColor(.systemBlue, for: .normal)
        skipButton.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        skipButton.addTarget(self, action: #selector(skipButtonTapped), for: .touchUpInside)
        skipButton.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(skipButton)
        
        NSLayoutConstraint.activate([
            skipButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            skipButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10)
        ])
    }

    // MARK: Action Methods
    // Handle left swipe gesture
    @objc func handleLeftSwipe(_ gesture: UISwipeGestureRecognizer) {
        handleSwipe(gesture, direction: .left)
        print("left")
    }

    // Handle right swipe gesture
    @objc func handleRightSwipe(_ gesture: UISwipeGestureRecognizer) {
        handleSwipe(gesture, direction: .right)
        print("right")
    }

    // Handle swipe gesture
    @objc func handleSwipe(_ gesture: UISwipeGestureRecognizer, direction: UISwipeGestureRecognizer.Direction) {
        // Determine next page based on swipe direction
        let currentPage = pageControl.currentPage
        var nextPage: Int
        
        print(direction)
        switch direction {
        case .left:
            nextPage = min(currentPage + 1, onboardingData.count - 1)
        case .right:
            nextPage = max(currentPage - 1, 0)
        default:
            return
        }

        // Set content offset of scroll view to scroll to next page
        let xOffset = scrollView.frame.width * CGFloat(nextPage)
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
        pageControl.currentPage = nextPage
    }

    // Handle continue button tap
    @objc func continueButtonTapped() {
        let currentPage = pageControl.currentPage

        // If not on last page, scroll to next page, and otherwise, perform segue to main view
        if currentPage != onboardingData.count - 1 {
            let nextPage = min(currentPage + 1, onboardingData.count - 1)
            let xOffset = scrollView.frame.width * CGFloat(nextPage)
            scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
            pageControl.currentPage = nextPage
        } else {
            performSegue(withIdentifier: "toMainView", sender: self)
        }
    }
    
    // Handle page control value change
    @objc func pageControlValueChanged() {
        // Scroll to the selected page
        let newPage = pageControl.currentPage
        let xOffset = scrollView.frame.width * CGFloat(newPage)
        scrollView.setContentOffset(CGPoint(x: xOffset, y: 0), animated: true)
    }
    
    // Handle skip button tap
    @objc func skipButtonTapped() {
        // Perform segue to main view directly
        performSegue(withIdentifier: "toMainView", sender: self)
    }
}

// Struct to hold data for each onboarding screen
struct OnboardingData {
    let icon: String
    let header: String
    let description: String
}

// MARK: Onboarding View
// Custom view for displaying onboarding content
class OnboardingView: UIView {

    // Initialize view with onboarding data
    init(data: OnboardingData) {
        super.init(frame: .zero)

        // Add icon image view
        let iconImageView = UIImageView(image: UIImage(systemName: data.icon))
        iconImageView.tintColor = .systemBlue
        iconImageView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(iconImageView)

        // Add header label
        let headerLabel = UILabel()
        headerLabel.text = data.header
        headerLabel.font = UIFont.systemFont(ofSize: 32)
        headerLabel.translatesAutoresizingMaskIntoConstraints = false
        addSubview(headerLabel)

        // Add description label
        let descriptionLabel = UILabel()
        descriptionLabel.text = data.description
        descriptionLabel.font = UIFont.systemFont(ofSize: 24)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.textAlignment = .center
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = UIColor.secondaryLabel
        addSubview(descriptionLabel)
        
        // Set constraints for views
        if let image = iconImageView.image {
            let aspectRatio = image.size.width / image.size.height
            let widthConstraint = iconImageView.widthAnchor.constraint(equalToConstant: 110)
            let heightConstraint = iconImageView.heightAnchor.constraint(equalTo: iconImageView.widthAnchor, multiplier: 1.0 / aspectRatio)

            NSLayoutConstraint.activate([
                widthConstraint,
                heightConstraint,
                iconImageView.centerXAnchor.constraint(equalTo: centerXAnchor),
                iconImageView.centerYAnchor.constraint(equalTo: centerYAnchor, constant: -100),

                headerLabel.topAnchor.constraint(equalTo: iconImageView.bottomAnchor, constant: 20),
                headerLabel.centerXAnchor.constraint(equalTo: centerXAnchor),

                descriptionLabel.topAnchor.constraint(equalTo: headerLabel.bottomAnchor, constant: 20),
                descriptionLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
                descriptionLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
            ])
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
