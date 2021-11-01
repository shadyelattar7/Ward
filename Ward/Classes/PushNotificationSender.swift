//
//  PushNotificationSender.swift
//  Halak
//
//  Created by Elattar on 3/23/21.
//  Copyright © 2021 Elattar. All rights reserved.
//

import Foundation
import UIKit


class PushNotificationSender {
    func sendPushNotification(to token: String, title: String, body: String) {
        let ServerKey = "    AAAAhEpfpX0:APA91bEayJQ7NY0ngnQCmbuVSzXSb3gUAiuvw4Jb9ouQXFuLdITXUWDdPeFslGAigA4uHr9vLhYl13GluiaAygyxGeQvoXfr0OvsBQeUM_8Uf1XK4H4GSOeEaNZk_D46oAd41lbqPNgf"
        
        let urlString = "https://fcm.googleapis.com/fcm/send"
        let url = NSURL(string: urlString)!
        let paramString: [String : Any] = ["to" : token,
                                           "notification" : ["title" : title, "body" : body],
                                           "data" : ["user" : "test_id"]
        ]
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.httpBody = try? JSONSerialization.data(withJSONObject:paramString, options: [.prettyPrinted])
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("key=\(ServerKey)", forHTTPHeaderField: "Authorization")
        let task =  URLSession.shared.dataTask(with: request as URLRequest)  { (data, response, error) in
            do {
                if let jsonData = data {
                    if let jsonDataDict  = try JSONSerialization.jsonObject(with: jsonData, options: JSONSerialization.ReadingOptions.allowFragments) as? [String: AnyObject] {
                        NSLog("Received data:\n\(jsonDataDict))")
                    }
                }
            } catch let err as NSError {
                print(err.debugDescription)
            }
        }
        task.resume()
    }
}
