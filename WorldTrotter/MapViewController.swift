//
//  MapViewController.swift
//  WorldTrotter
//
//  Created by Samantha Selleck on 2/4/17.
//  Copyright © 2017 CSC. All rights reserved.
//

import UIKit
import MapKit


class MapViewController: UIViewController
{
    var mapView: MKMapView!
    //var locationManager: CLLocationManager!
    override func loadView()
    {
        //create a map view
        mapView = MKMapView()
        
        //set it as "the" view of this view controller
        view = mapView
        
        let segmentedControl = UISegmentedControl(items: ["Standard","Hybrid","Staellite"])
        segmentedControl.backgroundColor = UIColor.white.withAlphaComponent(0.5)
        segmentedControl.selectedSegmentIndex = 0
        //next line - Before auto layout autoresizing masks was used to allow views
        //to scale for different-sized screens at runtime.  It's turned off to keep from
        //conflicting with explicit contraints
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        // Don't need the self here but does not hurt.  self.view.addSubview(segmentedControl)
        view.addSubview(segmentedControl)
        
        //these are NSLayoutConstraints
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
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        print("Map view")
    }
    
     /*override func viewWillAppear(_ animated: Bool) {
        super.viewDidLoad()
        print("Map window view")
    }*/
    
    //Silver Challenge Chp. 5, will change the map background color to the time of day.
    override func viewWillAppear(_ animated: Bool) {
        //colors for each the evening and morning time
        let darkColor = UIColor.init(red:0.784,  green:0.784,  blue:0.788, alpha:1)
        let lightColor = UIColor.init(red:0.961,  green:0.957,  blue:0.945, alpha:1)
        
        //a check to determine what time it is and then show the correct color
        if isEvening(hourToCheck: getTheHour()) {
            view.backgroundColor = darkColor
        } else {
            view.backgroundColor = lightColor
        }
        
    }
    
    //function that find the time of the day that it currently is
    func getTheHour() -> Int {
        let date = Date()
        let calendar = NSCalendar.currentCalendar()
        let time = calendar.component(.Hour, from: date)
        let currentTime = time!.hour
        return currentTime
    }
    
    //function that checks if the time is between what hours and whether or not to send true or false
    func isEvening(hourToCheck: Int) -> Bool {
        switch hourToCheck {
        case 0...6:
            return true
        case 7...18:
            return false
        case 19...23:
            return true
        default: return false
        }
    }
}
