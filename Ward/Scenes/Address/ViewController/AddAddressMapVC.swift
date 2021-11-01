//
//  AddAddressMapVC.swift
//  Ward
//
//  Created by Shadi Elattar on 10/19/21.
//

import UIKit
import MapKit
import CoreLocation

class AddAddressMapVC: UIViewController, CLLocationManagerDelegate {
    
    
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
    var addressName: String = ""
    
    
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
        
        let message = "You have no Address till now, Let's chage that!"
        
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
        
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func confAddress(_ sender: Any) {
        guard let locationCoordinate = location else {return}
        
        let sb = UIStoryboard(name: "Cart", bundle: nil).instantiateViewController(withIdentifier: "NewAddressVC") as! NewAddressVC
        sb.location = locationCoordinate
        sb.addressName = addressName
        sb.isAddAddress = true
        self.navigationController?.pushViewController(sb, animated: true)
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
                                            self.addressName = addressString
                                            self.addressName_lbl.text = addressString
                                            
                                        }
                                    })
    }
    
}


extension AddAddressMapVC: MKMapViewDelegate{
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
