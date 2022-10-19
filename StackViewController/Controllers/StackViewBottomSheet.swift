//
//  StackViewBottomSheet.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 19/10/2022.
//

import UIKit

final public class StackViewBottomSheet: UIViewController {
    
    // MARK: - Views
    
    private lazy var backView = Subviews.backView
    private lazy var headerView = Subviews.headerView
    
    // MARK: - Properties
    
    private let childVC: UIViewController
    
    private var scrollViewOffset: CGFloat = 0
    
    private lazy var bottomSheetHeightConstraint = self.makeBottomSheetHeightConstraint()
    
    enum BottomSheetPosition {
        case minimum, maximum, progressing
    }
    
    private var bottomSheetPosition: BottomSheetPosition = .minimum
    
    private var initialBottomSheetHeight: CGFloat {
        switch bottomSheetPosition {
        case .maximum: return StackViewHelper.maximumHeight
        case .minimum: return StackViewHelper.minimumHeight
        case .progressing: return 0.0
        }
    }
    
    private var currentPosition: BottomSheetPosition {
        let height = bottomSheetHeightConstraint.constant
        if height == StackViewHelper.maximumHeight {
            return .maximum
        } else if height == StackViewHelper.minimumHeight {
            return .minimum
        } else {
            return .progressing
        }
    }
    
    // MARK: - Lifecycle
    
    public override func loadView() {
        view = StackViewPassThroughView()
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        setupGestures()
        setupLayout()
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
    
    private func setupGestures() {
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTapGesture))
        headerView.addGestureRecognizer(pan)
        headerView.addGestureRecognizer(tap)
    }
    
    private func setupLayout() {
        view.addSubview(backView)
        backView.pinToSuperview(edges: [.left, .right, .bottom])
        bottomSheetHeightConstraint.isActive = true
        
        backView.addSubview(headerView)
        headerView.activate(constraints: [
            headerView.topAnchor.constraint(equalTo: backView.topAnchor, constant: 0),
            headerView.leadingAnchor.constraint(equalTo: backView.leadingAnchor, constant: 0),
            headerView.trailingAnchor.constraint(equalTo: backView.trailingAnchor, constant: 0),
            headerView.heightAnchor.constraint(equalToConstant: StackViewHelper.headerHeight),
        ])
        
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
        backView.heightAnchor.constraint(equalToConstant: StackViewHelper.minimumHeight)
    }
    
    // MARK: - Moving
    
    private func canMoveBottomSheet(_ scrollView: UIScrollView) -> Bool {
        guard scrollView.isTracking else { return false }
        let offset = scrollView.contentOffset.y
        switch currentPosition {
        case .maximum: return offset < 0
        case .minimum: return offset > 0
        case .progressing: return true
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
        bottomSheetHeightConstraint.constant = max(
            StackViewHelper.minimumHeight,
            min(value, StackViewHelper.maximumHeight)
        )
    }
    
    private func finishMoving(velocity: CGPoint) {
        let distance = StackViewHelper.maximumHeight - StackViewHelper.minimumHeight
        let progressDistance = bottomSheetHeightConstraint.constant - StackViewHelper.minimumHeight
        let progress = progressDistance / distance
        let delta = velocity.y * -100
        
        if abs(delta) > StackViewHelper.minimumVelocityConsideration && progress != 0 && progress != 1 {
            let rest = abs(distance - progressDistance)
            let duration = TimeInterval(rest / abs(delta))
            let position: BottomSheetPosition = delta > 0 ? .minimum : .maximum
            animateMoving(to: position, duration: duration, velocity: velocity)
        } else {
            animateMoving(to: progress < 0.5 ? .minimum : .maximum)
        }
    }
    
    private func animateMoving(to position: BottomSheetPosition, duration: TimeInterval = 0.2, velocity: CGPoint = .zero) {
        bottomSheetPosition = position
        bottomSheetHeightConstraint.constant = initialBottomSheetHeight
        
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
        case .progressing: break
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
}

// MARK: - UIScrollViewDelegate

extension StackViewBottomSheet: UIScrollViewDelegate {
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        scrollViewOffset = scrollView.contentOffset.y
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard canMoveBottomSheet(scrollView) else { return }
        moveBottomSheet(scrollView)
    }
    
    public func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        scrollViewOffset = 0
        switch currentPosition {
        case .minimum, .progressing:
            targetContentOffset.pointee = .zero
        case .maximum:
            break
        }
        finishMoving(velocity: velocity)
    }
}

// MARK: - Subviews

private enum Subviews {
    
    static var backView: UIView {
        let view = UIView()
        view.backgroundColor = .white
        return view
    }
    
    static var headerView: UIView {
        let view = UIView()
        return view
    }
}
