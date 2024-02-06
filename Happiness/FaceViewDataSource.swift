//
//  FaceViewDataSource.swift
//  Happiness
//
//  Created by ben hussain on 4/17/23.
//

import Foundation
protocol FaceViewDataSource: AnyObject
{
    func adjustSmilness(_ faceView: FaceView) ->Double?
}
