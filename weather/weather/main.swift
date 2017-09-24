//
//  main.swift
//  weather
//
//  Created by Brian D Keane on 9/24/17.
//  Copyright © 2017 Brian D Keane. All rights reserved.
//

import Foundation

// check to make sure a city was included
if (CommandLine.arguments.count <= 1)
{
    print("You need to provide a location")
    exit(9)
}

var location = ""

for index in 0..<CommandLine.arguments.count
{
    if index == 0 {
        print(CommandLine.arguments[0])
    }
    
    if (index != 0)
    {
        location += CommandLine.arguments[index] + " "
    }
}
let weather = Weather()
weather.getTemp(location: location)

// do not end program until finished
while (weather.finished != true)
{
    sleep(1)
}
