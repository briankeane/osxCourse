//
//  Weather.swift
//  weather
//
//  Created by Brian D Keane on 9/24/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Foundation

class Weather
{
    var finished = false
    func getTemp(location:String)
    {
        // encode location for inclusion in a query string
        if let encodedString = location.addingPercentEncoding(withAllowedCharacters: CharacterSet(charactersIn: "!*();:@&,/?%#[] \"").inverted)
        {
            if let url = URL(string: "https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20weather.forecast%20where%20woeid%20in%20(select%20woeid%20from%20geo.places(1)%20where%20text%3D%22\(encodedString)%22)&format=json&env=store%3A%2F%2Fdatatables.org%2Falltableswithkeys")
            {
                URLSession.shared.dataTask(with: url)
                {
                    (data, response, error) -> Void in
                    if (error != nil)
                    {
                        print ("API ERROR")
                        print (error!.localizedDescription)
                    }
                    else
                    {
                        if let data = data
                        {
                            let json = JSON(data)
                            if let temp = json["query"]["results"]["channel"]["item"]["condition"]["temp"].string
                            {
                                print("temp: °\(temp)")
                            }
                        }
                    }
                    self.finished = true
                    }.resume()
            }
            else
            {
                print("There was a problem creating the URL")
                self.finished = true
            }
        } else {
            print("error encoding string")
            self.finished = true
        }
    }
}
