
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
    
    let pinCoordOne = CLLocationCoordinate2DMake(40.550143, -80.181923) //hometown
    let pinCoordTwo = CLLocationCoordinate2DMake(35.969742, -79.999589) //where I am currently
    let pinCoordThree = CLLocationCoordinate2DMake(45.965048, 9.202486) //Where I would like to be
    var visitingPin: Int = -1 //index of pins to cycle through the list of locations

    override func loadView()
    {
        mapView = MKMapView()
        mapView.delegate = self
        
        locationManager = CLLocationManager()
        //locationManager.delegate = self
       
        //set it as "the" view of this view controller
        view = mapView
        
        locationManager.requestAlwaysAuthorization()    // ask for authorization from user
        locationManager.requestWhenInUseAuthorization()//use the location only when the app is in use and not when it is in the background
        
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
        
        initalizePinButton(segmentedControl)
        
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
    //Creates the button to find the users current location
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
        
        //sending the butoon being pressed to showLocButton
        locationButton.addTarget(self, action: #selector(MapViewController.showLocButton(sender:)), for: .touchUpInside)
    }
    //Asks for permission to use location and shows the users location
    func showLocButton(sender: UIButton!) {
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        if mapView.showsUserLocation == true //show the blue dot
        {
            mapView.showsUserLocation = false
            
            var region = mapView.region
            var span = MKCoordinateSpan()//the span of the map region
            span.latitudeDelta = region.span.latitudeDelta*20000 //will reset the latitude to a zoomed out view
            span.longitudeDelta = region.span.longitudeDelta*20000 //will reset the longitude to a zoomed out view
            region.span = span;
            mapView.setRegion(region, animated: true);
        }
        else{
            mapView.showsUserLocation = true
        }

    }
        //Shows the map view either zoomed into the users location or the zoomed out.
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        mapView.centerCoordinate = (userLocation.location?.coordinate)!
        locationManager.startUpdatingLocation() //turn on the location manager to look for location
        let zoomedInCurrentLocation = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500, 500)//creating a region that will zoom into the map
        mapView.setRegion(zoomedInCurrentLocation, animated: true) //Set the map to the region and will use the zooming animation to true to get that.
    }
    //This function will create the button for the pins being dropped
    func initalizePinButton(_ pin: UIView!){
        let pinButton = UIButton.init(type: .system)
        pinButton.setTitle("View Pin(s)", for: .normal)
        pinButton.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        pinButton.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(pinButton)
        
        let topButtonConstraint = pinButton.topAnchor.constraint(equalTo: pin.bottomAnchor, constant: 40)
        let leadingButtonConstraint = pinButton.leadingAnchor.constraint(equalTo: view.leadingAnchor)
        let trailingButtonConstraint = pinButton.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        
        topButtonConstraint.isActive = true
        leadingButtonConstraint.isActive = true
        trailingButtonConstraint.isActive = true
        
        //When button is being pressed it it will send over to the pinButtonWasPressed function
        pinButton.addTarget(self, action: #selector(MapViewController.pinButtonWasPressed(sender:)), for: .touchUpInside)
        
    }
    //This function will do the action everytime the button has been hit. It will cycle through the pins
    func pinButtonWasPressed(sender: UIButton){
        
        //The animation as will as the coords. for each of the pins
        var pins = [MKPointAnnotation]()
        for _ in 0..<3 {
            pins.append(MKPointAnnotation())
        }
        pins[0].coordinate = self.pinCoordOne
        pins[0].title = "Sewickley, PA"
        pins[1].coordinate = self.pinCoordTwo
        pins[1].title = "High Point, NC"
        pins[2].coordinate = self.pinCoordThree
        pins[2].title = "Lake Como, Italy"
        for i in 0..<3 {
            mapView.addAnnotation(pins[i])
        }
        
        //The locations of each of the pins and how close it needs to be zoomed
        let regionOne = MKCoordinateRegion(center: self.pinCoordOne, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let regionTwo = MKCoordinateRegion(center: self.pinCoordTwo, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        let regionThree = MKCoordinateRegion(center: self.pinCoordThree, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        //the cycle of pins so that they will be able to keep being able to be viewed if the button keeps getting hit
        switch self.visitingPin {
        case -1:
            mapView.setRegion(regionOne, animated: true)
            self.visitingPin = 0
        case 0:
            mapView.setRegion(regionTwo, animated: true)
            self.visitingPin = 1
        case 1:
            mapView.setRegion(regionThree, animated: true)
            self.visitingPin = 2
        case 2:
            mapView.setRegion(regionOne, animated: true)
            self.visitingPin = 0
        default:
            break
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
