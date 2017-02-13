
//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Samantha Selleck on 2/4/17.
//  Copyright © 2017 CSC. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, CLLocationManagerDelegate
{
    var mapView: MKMapView!
    var locationManager = CLLocationManager()
    
    override func loadView()
    {
        mapView = MKMapView()
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        //locationManager.delegate = self
       
        //set it as "the" view of this view controller
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard","Hybrid","Staellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        //next line - Before auto layout autoresizing masks was used to allow views
        //to scale for different-sized screens at runtime.  It's turned off to keep from
        //conflicting with explicit contraints
        
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(segmentedControl)
        
        //The topConstraint - the topAnchor of the segmentedControl is constrained to the 
        //bottomAnchor of the topLayoutGuide +8
        let topConstraint = segmentedControl.topAnchor.constraint(equalTo: topLayoutGuide.bottomAnchor, constant: 8)
        let margins = view.layoutMarginsGuide
        let leadingContraint = segmentedControl.leadingAnchor.constraint(equalTo: margins.leadingAnchor)
        let trailingConstraint = segmentedControl.trailingAnchor.constraint(equalTo: margins.trailingAnchor)
        
        segmentedControl.addTarget(self, action: #selector(MapViewController.mapTypeChanged(_:)), for: .valueChanged)
        
        //Properties that will activate the constraints 
        topConstraint.isActive=true
        leadingContraint.isActive=true
        trailingConstraint.isActive=true
        
        //locationManager.requestAlwaysAuthorization()
        initalizeLocButton(segmentedControl)
    }
    
    //Function will list options to see the map in different views
    func mapTypeChanged(_ segControl: UISegmentedControl)
    {
        switch segControl.selectedSegmentIndex {
        case 0:
            mapView.mapType = .standard
        case 1:
            mapView.mapType = .hybrid
        case 2:
            mapView.mapType = .satellite
        default:
            break
        }
    }
    
    func initalizeLocButton(_ anyView: UIView!){
        let locationButton = UIButton.init(type: .system)
        locationButton.setTitle("My Location", for: .normal)
        locationButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        locationButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(locationButton)
        
        let topButtonConstraint = locationButton.topAnchor.constraint(equalTo: anyView.bottomAnchor, constant: 8)
        let leadingButtonConstraint = locationButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingButtonConstraint = locationButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        topButtonConstraint.isActive = true
        leadingButtonConstraint.isActive = true
        trailingButtonConstraint.isActive = true
        
        locationButton.addTarget(self, action: #selector(MapViewController.showLocButton(sender:)), for: .touchUpInside)
    }
    
    func showLocButton(sender: UIButton!) {
        locationManager.requestAlwaysAuthorization()    // ask for authorization from user
        locationManager.requestWhenInUseAuthorization()//use the location only when the app is in use and not when it is in the background
        mapView.showsUserLocation = true //show the blue dot
    }

    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        
        if userLocation  { //if the users location isnt found or if the button has been pushed once
            locationManager.startUpdatingLocation() //turn on the location manager to look for location
            let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)//creating a region that will zoom into the map
            mapView.setRegion(zoomedInCurrentLocation, animated: true) //Set the map to the region and will use the zooming animation to true to get that.
        }
        else{
            var region = mapView.region
            var span = MKCoordinateSpan()
            span.latitudeDelta = region.span.latitudeDelta*2
            span.longitudeDelta = region.span.longitudeDelta*2
            region.span = span; mapView.setRegion(region, animated: true);
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Errors:", error.localizedDescription) //print out an error to the debug if a problem arises.
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        print("Map view")
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        print("Map window view")
    }
}
