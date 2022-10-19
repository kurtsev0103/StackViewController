//
//  StackViewHelper.swift
//  StackViewController
//
//  Created by Oleksandr Kurtsev on 19/10/2022.
//

import UIKit

enum StackViewHelper {
    
    static let headerHeight: CGFloat = 50.0
    static let minimumHeight: CGFloat = 100.0
    static let maximumHeight: CGFloat = screenHeight * 0.5
    static let minimumVelocityConsideration: CGFloat = 50.0
    
    // MARK: - Properties
    
    static var screenWidth: CGFloat {
        UIScreen.main.bounds.width
    }

    static var screenHeight: CGFloat {
        UIScreen.main.bounds.height
    }
}


//enum MainModuleConstants {
//
//    // PeopleList
//    static let peopleListCellHeight: CGFloat = screenHeight / 10
//
//    // MapView
//    static let mapViewBottomMargin: CGFloat = floatingPanelMinHeight
//    static let mapViewButtomTipOffset: CGFloat = floatingPanelMinHeight - mapViewBottomMargin
//    static let mapViewButtomFullOffset: CGFloat = floatingPanelMaxHeight - mapViewBottomMargin
//
//    // FloatingPanel
//    static let floatingPanelCornerRadius: CGFloat = 20.0
//    static let floatingPanelBackgroundColor: UIColor = .white
//    static let floatingPanelMinHeight: CGFloat = peopleListCellHeight * 1.0 + floatingPanelContentPadding.top
//    static let floatingPanelMaxHeight: CGFloat = peopleListCellHeight * 4.0 + floatingPanelContentPadding.top
//
//    // FloatingPanelShadow
//    static let floatingPanelShadowColor: UIColor = .black
//    static let floatingPanelShadowOffset: CGSize = .zero
//    static let floatingPanelShadowRadius: CGFloat = 8
//    static let floatingPanelShadowSpread: CGFloat = 4
//
//    // FloatingPanelGrabber
//    static let floatingPanelGrabberHandlePadding: CGFloat = 8.0
//    static let floatingPanelGrabberHandleSize: CGSize = .init(width: 36.0, height: 4.0)
//
//    // FloatingPanelSheetView
//    static let floatingPanelContainerMargins: UIEdgeInsets = .zero
//    static let floatingPanelContentPadding: UIEdgeInsets = .init(
//        top: floatingPanelGrabberHandlePadding * 2.0 + floatingPanelGrabberHandleSize.height,
//        left: 0.0, bottom: 0.0, right: 0.0
//    )
//}
