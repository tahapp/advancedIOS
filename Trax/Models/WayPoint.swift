//
//  WayPoint.swift
//  Trax
//
//  Created by ben hussain on 11/1/23.
//

import Foundation
import MapKit

class WayPoint : NSObject
{

    
    var lat:  CLLocationDegrees
    var lon:  CLLocationDegrees
    var name: String
    var desc: String
    var links: [Link?] = []
    init(lat:  CLLocationDegrees, lon:  CLLocationDegrees, name: String, desc: String) {
        self.lat = lat
        self.lon = lon
        self.name = name
        self.desc = desc
        
    }
}
class Link
{
    let href: URL
    let type: String
    init(href: URL, type: String) {
        self.href = href
        self.type = type
    }
}
class ImageLink
{
    static var links = [Link?]()
}

class XMLURLS
{
    static let url = URL(string: "https://web.stanford.edu/class/cs193p/Vacation.gpx")!
}

