//
//  GPXParser.swift
//  Trax
//
//  Created by ben hussain on 11/1/23.
//

import Foundation

class GPXParser: NSObject, XMLParserDelegate
{
    private var currentTag: String?
    
    private var lat: Double?
    private var lon: Double?
    private var name: String?
    private var desc: String?
    private var href: URL?
    private var type: String?
    

    private var wayPoint: WayPoint?
    private var link : Link?

    var wayPoints : [WayPoint] = []
    private var links : [Link] = []
    
    private var xmlParser: XMLParser!

    override init()
    {
        super.init()
    }
    func startParsin(url: URL?)
    {
        guard let nonOptionalURL = url else
        {
            return
        }
        if let data = try? Data(contentsOf: nonOptionalURL)
        {
            
            xmlParser = XMLParser(data: data)
            xmlParser.delegate = self
            xmlParser.parse()
        }else
        {
            fatalError("fail to download data")
        }
    }
  
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
     
        switch elementName
        {
        case "wpt":
            if let latitude = attributeDict["lat"], let longitude = attributeDict["lon"]
            {
                if let numLat = Double(latitude), let numLon = Double(longitude)
                {
                    self.lat = numLat
                    self.lon = numLon
                }else
                {
                    print("lat and lon conversion failure")
                }
                
            }else
            {
                print("lon and lat dict failure")
            }
        case "link":
            if let hypertextReference = attributeDict["href"], let url = URL(string: hypertextReference)
            {
                self.href = url
            }else
            {
                print("herf failure")
            }
            
        default:
            self.currentTag = elementName
        }
        
        
    }
   
    func parser(_ parser: XMLParser, foundCharacters string: String) {
       
        
        switch currentTag
        {
        case "name":
            if string.count > 1
            {
                
                self.name = string
            }
            
        case "desc":
            if string.count > 1
            {
                self.desc = string
            }
            
        case "type":
            if string.count > 1
            {
                self.type = string
            }
        default:
            break
            
        }
        /* the check because of the weird behavior of xml parser it goes to 3 then it come back to 2 with the string value.count = 1, making my values empty*/
    }
   
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
        
        switch elementName
        {
        
        case "link":
            if let hyperText = href, let someType = type
            {
                link = Link(href: hyperText, type: someType)
                if let l = link
                {
                    links.append(l)
                }
            }else
            {
                print("href and type failure")
            }
            
            
        case "wpt":
            if let lat = self.lat, let lon = self.lon, let name = self.name, let desc = self.desc
            {
                wayPoint = WayPoint(lat: lat, lon: lon, name: name, desc: desc)
                if let wayPoint = wayPoint
                {
                    wayPoint.links = links
                    links.removeAll(keepingCapacity: true)
                    wayPoints.append(wayPoint)
                }
            }
            else
            {
                print("waypoint init failure")
            }

            
        default:
            break
            
        }
    }
}
