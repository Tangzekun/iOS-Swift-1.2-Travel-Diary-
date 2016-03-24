//
//  Location.swift
//  FinalProject
//
//  Created by TangZekun on 8/4/15.
//  Copyright (c) 2015 TangZekun. All rights reserved.
//

import UIKit
import MapKit
import CoreData

protocol LocationDelegate: class {
    func location(location: Location, didUpdateWithValue value: String?)
}

class Location: UIViewController,CLLocationManagerDelegate
{
    var coreLocationManager = CLLocationManager()
    var locationManager : LocationManager!
    var delegate: LocationDelegate?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var locationInfo: UILabel!
    
    var existingItem : Geograph!
    
    //var addressInfo: String = ""
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        coreLocationManager.delegate = self
        locationManager = LocationManager.sharedInstance
        let authorizationCode = CLLocationManager.authorizationStatus()
        if authorizationCode == CLAuthorizationStatus.NotDetermined && coreLocationManager.respondsToSelector("requestAlwaysAuthorization") || coreLocationManager.respondsToSelector("requestWhenInusageAuthorization")
        {
            if NSBundle.mainBundle().objectForInfoDictionaryKey("NSLocationAlwaysUsageDescription") != nil
            {
                coreLocationManager.requestAlwaysAuthorization()
            }
            else
            {
                println("No description provided.")
            }
        }
        else
        {
            getlocation()
        }

    }
    
    
    @IBAction func updateTapped(sender: AnyObject)
    {
        delegate?.location(self, didUpdateWithValue: locationInfo.text)
        /*
        let appDel : AppDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        
        // reference Model
        let context : NSManagedObjectContext = appDel.managedObjectContext!
        let en = NSEntityDescription.entityForName("Geograph", inManagedObjectContext: context)
        
        
        if (existingItem != nil)
        {
            //existingItem.setValue(locationInfo.text as String?, forKey: "location")
            
            existingItem.location = locationInfo.text!
            println("Value changed to : \(existingItem)")
        }
        else
        {
            
            // create instance of our data and initializ
            var newItem = Geograph (entity : en!, insertIntoManagedObjectContext : context)
            
            // map our property
            newItem.location = locationInfo.text!
            println(newItem.location)
        }
        
        // save our content
        context.save(nil)
        
        // navigate back to view controller
        //self.navigationController?.popToRootViewControllerAnimated(true)
        self.navigationController?.popViewControllerAnimated(true)
        //self.dismissViewControllerAnimated(true, completion: nil)
*/
        self.navigationController?.popViewControllerAnimated(true)
    }
 
   
    
    @IBAction func reloadTapped(sender: AnyObject)
    {
        getlocation()
    }
    
    
    func getlocation()
    {
        
        locationManager.startUpdatingLocationWithCompletionHandler
            {
                (latitude, longitude, status, verboseMessage, error) -> () in self.displayLocation(CLLocation(latitude: latitude, longitude: longitude))
        }
    }
    
    
    func displayLocation(location: CLLocation)
    {
        mapView.setRegion(MKCoordinateRegion(center: CLLocationCoordinate2DMake(location.coordinate.latitude, location.coordinate.longitude), span: MKCoordinateSpanMake(0.05, 0.05)), animated: true)
        
        let locationPinCoord = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let annotation = MKPointAnnotation()
        
        annotation.coordinate = locationPinCoord
        mapView.addAnnotation(annotation)
        mapView.showAnnotations([annotation], animated: true)
        
        locationManager.reverseGeocodeLocationWithCoordinates(location, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
            ///////
            //println(reverseGecodeInfo)
            
            ////////
            let address = reverseGecodeInfo?.objectForKey("formattedAddress") as? String
            self.locationInfo.text = address
            
        })
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    func locationManager(manager: CLLocationManager!, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        if status != CLAuthorizationStatus.NotDetermined || status != CLAuthorizationStatus.Denied || status != CLAuthorizationStatus.Restricted
        {
            getlocation()
        }
    }
    
    //NSLocationAlwaysUsageDescription
}
