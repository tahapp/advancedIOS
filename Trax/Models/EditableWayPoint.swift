//
//  EditableWayPoint.swift
//  Trax
//
//  Created by ben hussain on 11/6/23.
//

import UIKit
import MapKit

/* this is step one to make pin draggable
 we could have make coordinate settable in waypoint extension, but
 to distinguisg between editable waypoint and non-editble way point
 we had to subclass 
 */
class EditableWayPoint: WayPoint
{
    override var coordinate: CLLocationCoordinate2D
    {
        get
        {
            return super.coordinate
        }
        set
        {
            lat = newValue.latitude
            lon = newValue.longitude
        }
    }
}
