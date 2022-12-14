//
//  StackViewBottomSheet.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 19/10/2022.
//

import UIKit

final class StackViewBottomSheet: UIViewController {
    
    // MARK: - Views
    
    private let childVC: UIViewController
    private lazy var backView: UIView = .init()
    
    // MARK: - Public Properties
    
    var onChangePosition: ((CGFloat) -> Void)?
    var onMoveToMinimum: (() -> Void)?
    
    var headerView: UIView!
    var configuration: StackViewConfigurationType!
    var bottomSheetPosition: BottomSheetPosition = .minimum
    
    // MARK: - Private Properties
    
    private var scrollViewOffset: CGFloat = 0.0
    private var minimumVelocity: CGFloat = 50.0
    private var isBlockedMoving: Bool = false
    
    private lazy var bottomSheetHeightConstraint = {
        makeBottomSheetHeightConstraint()
    }()
    
    private var constraintConstant: CGFloat = .zero {
        didSet {
            bottomSheetHeightConstraint.constant = constraintConstant
            onChangePosition?(constraintConstant)
        }
    }
    
    // MARK: - Position Properties
    
    private var currentPosition: BottomSheetPosition {
        let height = constraintConstant
        switch height {
        case configuration.maxHeight: return .maximum
        case configuration.minHeight: return .minimum
        default: return .progressing
        }
    }
    
    private var initialBottomSheetHeight: CGFloat {
        switch bottomSheetPosition {
        case .maximum: return configuration.maxHeight
        case .minimum: return configuration.minHeight
        case .progressing, .hidden: return 0.0
        }
    }
    
    // MARK: - Public Methods
    
    public func move(to state: BottomSheetPosition) {
        animateMoving(to: state)
    }
    
    // MARK: - Lifecycle
    
    public override func loadView() {
        view = StackViewPassThroughView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupBackView()
        setupHeaderView()
        setupChildVC()
        trackScrollView()
    }
    
    // MARK: - Initialization
    
    public init(childVC: UIViewController) {
        self.childVC = childVC
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    private func setupBackView() {
        view.addSubview(backView)
        backView.pinToSuperview(edges: [.left, .right, .bottom])
        bottomSheetHeightConstraint.isActive = true
        backView.backgroundColor = configuration.backColor
        backView.layer.shadowOffset = configuration.shadowOffset
        backView.layer.shadowRadius = configuration.shadowRadius
        backView.layer.shadowColor = configuration.shadowColor.cgColor
        backView.layer.shadowOpacity = Float(configuration.shadowOpacity)
        
        backView.layer.cornerRadius = configuration.cornerRadius
        headerView.layer.cornerRadius = configuration.cornerRadius
        backView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        headerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
    }
    
    private func setupHeaderView() {
        backView.addSubview(headerView)
        headerView.activate(constraints: [
            headerView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: configuration.headerHeight),
        ])
        
        addGestureToHeaderView()
    }
    
    private func addGestureToHeaderView() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        headerView.addGestureRecognizer(pan)
        headerView.addGestureRecognizer(tap)
    }
    
    private func setupChildVC() {
        addChild(childVC)
        backView.addSubview(childVC.view)
        childVC.view.activate(constraints: [
            childVC.view.topAnchor.constraint(equalTo: headerView.bottomAnchor, constant: 0),
            childVC.view.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 0),
            childVC.view.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: 0),
            childVC.view.bottomAnchor.constraint(equalTo: backView.bottomAnchor, constant: 0),
        ])
        
        childVC.didMove(toParent: self)
    }
    
    private func makeBottomSheetHeightConstraint() -> NSLayoutConstraint {
        backView.heightAnchor.constraint(equalToConstant: configuration.minHeight)
    }
    
    // MARK: - Moving
    
    private func canMoveBottomSheet(_ scrollView: UIScrollView) -> Bool {
        guard scrollView.isTracking else { return false }
        let offset = scrollView.contentOffset.y
        
        if isBlockedMoving && offset >= 0 {
            scrollViewOffset = offset
            isBlockedMoving = false
        }
        
        switch currentPosition {
        case .maximum: return offset < 0 && !isBlockedMoving
        case .minimum: return offset > 0 && !isBlockedMoving
        case .progressing: return true
        case .hidden: return false
        }
    }
    
    private func moveBottomSheet(_ scrollView: UIScrollView) {
        scrollView.contentOffset = .zero
        let gesture = scrollView.panGestureRecognizer
        let translation = gesture.translation(in: view).y - scrollViewOffset
        updateBottomSheetContraint(translation: translation)
    }
    
    private func updateBottomSheetContraint(translation: CGFloat) {
        let value = initialBottomSheetHeight - translation
        constraintConstant = max(
            configuration.minHeight,
            min(value, configuration.maxHeight)
        )
    }
    
    private func finishMoving(velocity: CGPoint) {
        let distance = configuration.maxHeight - configuration.minHeight
        let progressDistance = constraintConstant - configuration.minHeight
        let progress = progressDistance / distance
        let delta = velocity.y * -100
        
        if abs(delta) > minimumVelocity && progress != 0 && progress != 1 {
            let rest = abs(distance - progressDistance)
            let duration = TimeInterval(rest / abs(delta))
            let position: BottomSheetPosition = delta > 0 ? .minimum : .maximum
            animateMoving(to: position, duration: duration, velocity: velocity)
        } else {
            animateMoving(to: progress < 0.5 ? .minimum : .maximum)
        }
    }
    
    private func animateMoving(to position: BottomSheetPosition, duration: TimeInterval = 0.2, velocity: CGPoint = .zero) {
        guard position != .progressing else { return }
        if position == .minimum { onMoveToMinimum?() }
        
        bottomSheetPosition = position
        constraintConstant = initialBottomSheetHeight
        
        UIView.animate(
            withDuration: min(duration, 0.4),
            delay: 0,
            usingSpringWithDamping: velocity.y == 0 ? 1 : 0.6,
            initialSpringVelocity: abs(velocity.y),
            options: [.allowUserInteraction]
        ) {
            self.view.layoutIfNeeded()
        }
    }
    
    // MARK: - Handling Gestures
    
    @objc func handleTapGesture(_ gestureRecognizer: UITapGestureRecognizer) {
        switch currentPosition {
        case .minimum: animateMoving(to: .maximum)
        case .maximum: animateMoving(to: .minimum)
        case .progressing, .hidden: break
        }
    }
    
    @objc func handlePanGesture(_ gestureRecognizer: UIPanGestureRecognizer) {
        switch gestureRecognizer.state {
        case .began, .changed:
            let translation = gestureRecognizer.translation(in: headerView)
            updateBottomSheetContraint(translation: translation.y)
        case .ended:
            let velocity = gestureRecognizer.velocity(in: headerView)
            let point = CGPoint(x: velocity.x / -1000, y: velocity.y / -1000)
            finishMoving(velocity: point)
        default: break
        }
    }
    
    func trackScrollView() {
        if let childVC = childVC as? UITableViewController,
           let tableView = childVC.tableView as? StackUITableView {
            tableView.scrollViewDelegate = self
            tableView.delegate = childVC
        }
    }
}

// MARK: - UIScrollViewDelegate

extension StackViewBottomSheet: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewOffset = scrollView.contentOffset.y
        if currentPosition == .maximum && scrollViewOffset < 0 {
            isBlockedMoving = true
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard canMoveBottomSheet(scrollView) else { return }
        moveBottomSheet(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewOffset = 0
        switch currentPosition {
        case .minimum, .progressing, .hidden:
            targetContentOffset.pointee = .zero
        case .maximum:
            break
        }
        finishMoving(velocity: velocity)
    }
}
