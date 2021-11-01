//
//  GetAddressName.swift
//  Takeaway
//
//  Created by Elattar on 1/29/21.
//  Copyright © 2021 Elattar. All rights reserved.
//

import Foundation
import CoreLocation

class GetAddress{
    
    public static func getcurrentaddress(location: CLLocationCoordinate2D, completionHandler: @escaping (_: String?) -> () )
    {
        let location = CLLocation(latitude: location.latitude, longitude: location.longitude)
        CLGeocoder().reverseGeocodeLocation(location, preferredLocale: nil) { (placemark, error) in
            if let pm = placemark?.first {
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
                print("Address: \(addressString)")
                completionHandler(addressString)
            }else {
                completionHandler(nil)
            }
        }
    }
    
}
