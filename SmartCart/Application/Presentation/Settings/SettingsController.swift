//
//  SettingsController.swift
//  SmartCart
//
//  Created by Lukáš Šanda on 17/12/2019.
//  Copyright © 2019 Lukáš Šanda. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

internal class SettingsController: UIViewController {
    
    // MARK: - Properties
    
    private let contentView = SettingsView()
    private let locationManager = CLLocationManager()
    private let presenter: SettingsPresenter
    
    private var userLocation: CLLocation? {
        willSet {
            guard userLocation == nil, let location = newValue else { return }
            setRegionOnUserLocation(location)
        }
    }
    
    // MARK: - Initialization
    
    internal init(presenter: SettingsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    internal required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.load()
        
        // If user allowed location manager
        if CLLocationManager.locationServicesEnabled() {
            setupLocationManager()
        }
    }
    
    override internal func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
}


// MARK: - SettingsPresenter
extension SettingsController: SettingsDelegate {
    func didLoadStoredSupermarkets(_ locations: [CLLocationCoordinate2D]?) {
        contentView.mapView.removeAnnotations(contentView.mapView.annotations)
        
        guard let locations = locations else { return }
        
        var annotations = [MKPointAnnotation]()
        for location in locations {
            let annotation = MKPointAnnotation()
            annotation.coordinate = location
            annotation.title = "Remove"
            
            annotations.append(annotation)
        }
        
        DispatchQueue.main.async {
            self.contentView.mapView.addAnnotations(annotations)
        }
    }
    
    func presentController(_ controller: UIViewController) {
        navigationController?.present(controller, animated: true, completion: nil)
    }
}

// MARK: - MKMapViewDelegate
extension SettingsController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        var view: MKMarkerAnnotationView?
        
        // User Pin
        if annotation.coordinate == mapView.userLocation.coordinate {
            return nil
            
        } else if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: "marker") as? MKMarkerAnnotationView {
            // Market Pin
            dequeuedView.annotation = annotation
            view = dequeuedView
            
        } else {
            // Callout of Market Pin
            let calloutView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: "marker")
            calloutView.canShowCallout = true
            calloutView.calloutOffset = CGPoint(x: 0, y: 5)
            calloutView.rightCalloutAccessoryView = UIButton(type: .close)
            view = calloutView
        }
        
        return view
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let location = view.annotation else { return }
        presenter.removeLocation(location.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        contentView.isPinSelected = true
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        contentView.isPinSelected = false
    }
}

// MARK: - CLLocationManagerDelegate
extension SettingsController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let userLocation = locations.last else { return }
        self.userLocation = userLocation
    }
    
    func setRegionOnUserLocation(_ location: CLLocation) {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: location.coordinate.latitude,
                longitude: location.coordinate.longitude),
            span: MKCoordinateSpan(
                latitudeDelta: 0.01,
                longitudeDelta: 0.01))
        
        contentView.mapView.setRegion(region, animated: false)
    }
}

// MARK: - SettingsViewDelegate
extension SettingsController: SettingsViewDelegate {
    func deleteDataDidTap() {
        presenter.deleteAllData {
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    func saveLocationDidTap() {
        presenter.saveLocation(contentView.mapView.centerCoordinate)
    }
}

// MARK: - Setup View Appereance
private extension SettingsController {
    func setup() {
        contentView.mapView.delegate = self
        contentView.delegate = self
        view.addSubview(contentView)
        contentView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        setupLocalization()
    }
    
    func setupLocalization() {
        title = "Settings"
        // Favorite Supermarket
        contentView.favoriteShopTitle = "Favorite Supermarket"
        contentView.favoriteShopDesc = "Select your preffered supermarker that we can notify you with created last cart to remind you selected items."
        contentView.moreInfoDesc = " We will notify you when you cross the radius of selected supermarket. Radius is set to 200 meters."
        contentView.moreInfoTitle = "More info"
        contentView.lessInfoTitle = "Less info"
        contentView.saveLocationTitle = "Save Location"
        // Delete Data
        contentView.deleteDataTitle = "Delete Data"
        contentView.deleteDataDesc = "Erase all stored data. Which means all carts and all stored items. This action can not be taken back."
        contentView.deleteDataButtonTitle = "Delete All"
    }
    
    func setupLocationManager() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
    }
}
