//
//  MapVC.swift
//  City Butcher
//
//  Created by Elattar on 12/7/20.
//  Copyright © 2020 Elattar. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

//1
protocol  coordinateLocation: class {
    func locationCoordinate(Coordinate: CLLocationCoordinate2D)
}

class MapVC: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var current_btn: UIButton!
    @IBOutlet weak var confAddress_btn: UIButton!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var addressName_lbl: UITextField!
    
    let regionInMeter: Double = 10000
    let locationManager = CLLocationManager()
    private var mapChangedFromUserInteraction = false
    
    var latitude = 0.0
    var longitude = 0.0
    var location: CLLocationCoordinate2D?
    
    var isCheckout: Bool = false
  
    //2
    weak var delegate: coordinateLocation!
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
        self.tabBarController?.tabBar.isHidden = true

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        self.tabBarController?.tabBar.isHidden = true

    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
    }
    
    private func setupView(){
        locationManager.requestWhenInUseAuthorization()
        navigationItem.hidesBackButton = true
        self.title = "اختيار العنوان"
        
        checkLocationService()
        self.mapView.delegate = self
        current_btn.layer.cornerRadius = 8
        confAddress_btn.layer.cornerRadius = 8
        addressName_lbl.setView(corner: 12)
//        if isCheckout{
//            backBtn.setImage(UIImage(named: "Arrow - Left 2"), for: .normal)
//        }else{
//            backBtn.setImage(UIImage(named: "down-arrow-1"), for: .normal)
//        }
  
    }
    
    private func centerViewOnUserLocation(){
        if let location = locationManager.location?.coordinate{
            let region = MKCoordinateRegion(center: location, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
            mapView.setRegion(region, animated: true)
            
        }
    }
    
    
    private func setupLoactionManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    
    private func checkLocationService(){
        if CLLocationManager.locationServicesEnabled(){
            setupLoactionManager()
            checkLocationAuthorization()
           
        }else{
            opensettingToUser()
        }
    }
    
    func checkLocationAuthorization(){
        switch CLLocationManager.authorizationStatus() {
        case .authorizedWhenInUse:
            mapView.showsUserLocation = true
            centerViewOnUserLocation()
            locationManager.startUpdatingLocation()
        case .denied:
           // opensettingToUser()
            break
        case .notDetermined:
            //  locationManager.requestWhenInUseAuthorization()
            break
        case .restricted:
            break
        case .authorizedAlways:
            break
        @unknown default:
            print("error")
        }
    }
    
    
    
    fileprivate func opensettingToUser()
    {
        
        var message = ""
        if isCheckout{
            message = "يرجي تحديد موقعك لتوصيل الطلب  ، هل تريد التوجه للاعدادت ؟"
        }else{
            message = "يرجي تحديد موقعك لاظهار اقرب الاسر و منتجاتها علي هذا العنوان ، هل تريد التوجه للاعدادت ؟"
        }
        let enableLocation = UIAlertController(title: "توجه",
                                               message: message
                                               , preferredStyle: UIAlertController.Style.alert)
        
        enableLocation.addAction(UIAlertAction(title: "تم", style: .default, handler: { (action: UIAlertAction!) in
            print("Handle Ok logic here")
            
            guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                return
            }
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                    print("Settings opened: \(success)") // Prints true
                })
            }
            
        }))
        
        enableLocation.addAction(UIAlertAction(title: "إلغاء", style: .cancel, handler: { (action: UIAlertAction!) in
            print("Handle Cancel Logic here")
        }))
        present(enableLocation, animated: true, completion: nil)
        
        return
    }
    
    @IBAction func back_btn(_ sender: Any) {
        
        self.dismiss(animated: true, completion: nil)
        
    }
    
    @IBAction func confAddress(_ sender: Any) {
        print("Back")
        
            guard let locationCoordinate = location else {return}
            //3
            self.delegate.locationCoordinate(Coordinate: locationCoordinate)
            self.dismiss(animated: true, completion: nil)
        
       
    }
    
    
    @IBAction func currentLocation_btn(_ sender: Any) {
        checkLocationService()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {return}
        let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
        let region = MKCoordinateRegion(center: center, latitudinalMeters: regionInMeter, longitudinalMeters: regionInMeter)
        mapView.setRegion(region, animated: true)
        
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {return}
        //  cameraMoveToLocation(toLocation: locValue)
        print("Current Location: \(locValue.latitude) , \(locValue.longitude)")
        
        self.getAddressFromLatLon(latitude: locValue.latitude, with: locValue.longitude)
        
        
        self.latitude = locValue.latitude
        self.longitude = locValue.longitude
        self.location = locValue
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
    func getAddressFromLatLon(latitude: Double, with longitude: Double)   {
        var center : CLLocationCoordinate2D = CLLocationCoordinate2D()
        
        let ceo: CLGeocoder = CLGeocoder()
        center.latitude = latitude
        center.longitude = longitude
        
        let loc: CLLocation = CLLocation(latitude:center.latitude, longitude: center.longitude)
        
        ceo.reverseGeocodeLocation(loc, completionHandler:
            {(placemarks, error) in
                if (error != nil) {
                    print("reverse geodcode fail: \(error!.localizedDescription)")
                }
                let pm = placemarks! as [CLPlacemark]
                
                if pm.count > 0 {
                    let pm = placemarks![0]
                    
                    var addressString : String = ""
                    if pm.subLocality != nil {
                        addressString = addressString + pm.subLocality! + ", "
                    }
                    if pm.thoroughfare != nil {
                        addressString = addressString + pm.thoroughfare! + ", "
                    }
                    if pm.locality != nil {
                        addressString = addressString + pm.locality! + ", "
                    }
                    if pm.country != nil {
                        addressString = addressString + pm.country! + ", "
                    }
                    if pm.postalCode != nil {
                        addressString = addressString + pm.postalCode! + " "
                    }
                    
                    print(addressString)
                    self.addressName_lbl.text = addressString
                   
                }
        })
    }
    
}


extension MapVC: MKMapViewDelegate{
    private func mapViewRegionDidChangeFromUserInteraction() -> Bool {
        let view = self.mapView.subviews[0]
        //  Look through gesture recognizers to determine whether this region change is from user interaction
        if let gestureRecognizers = view.gestureRecognizers {
            for recognizer in gestureRecognizers {
                if( recognizer.state == UIGestureRecognizer.State.began || recognizer.state == UIGestureRecognizer.State.ended ) {
                    return true
                }
            }
        }
        return false
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        mapChangedFromUserInteraction = mapViewRegionDidChangeFromUserInteraction()
        if (mapChangedFromUserInteraction) {
            // user will change map region
            print("user WILL change map.")
            
        }
    }
    
    func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
        if (mapChangedFromUserInteraction) {
            // user changed map region
            print("user CHANGED map.")
            //            print(mapView.region.span.latitudeDelta)
            //            print(mapView.region.span.longitudeDelta)
            
            print(mapView.region.center.latitude)
            print(mapView.region.center.longitude)
            
            self.latitude = mapView.region.center.latitude
            self.longitude = mapView.region.center.longitude
            self.location = mapView.region.center
            
            self.getAddressFromLatLon(latitude: mapView.region.center.latitude, with: mapView.region.center.longitude)
        }
    }
}
