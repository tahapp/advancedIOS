//
//  MapKitGPXExtension.swift
//  Trax
//
//  Created by ben hussain on 11/1/23.
//


import MapKit

extension WayPoint: MKAnnotation
{
    var coordinate: CLLocationCoordinate2D
    {
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
        
    }
    
    var title: String?
    {
        return name
    }
    
    var subtitle: String?
    {
        return desc
    }
    
    var thumbnailURL:URL?
    {
        for case let link? in links
        {
            if link.type == Constants.thumbnail
            {
                return link.href
                
            }
        }
        return nil
    }
    var largeURL :URL?
    {
        for case let link? in links
        {
            if link.type == Constants.large
            {
                return link.href
                
            }
        }
        return nil
    }
    // we need this because when we select pins, we will select each one individulally, so we need to know wacch pin url and to download one image per click
}
