//
//  MapViewController.swift
//  Example
//
//  Created by Oleksandr Kurtsev on 21/10/2022.
//

import UIKit
import MapKit

final class MapViewController: UIViewController {
    
    override func loadView() {
        view = MKMapView()
    }
}
