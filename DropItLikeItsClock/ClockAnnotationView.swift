//
//  ClockAnnotationView.swift
//  DropItLikeItsClock
//
//  Created by Jeff Kelley on 5/22/17.
//  Copyright © 2017 Jeff Kelley. All rights reserved.
//

import UIKit
import MapKit

import ClockUI

class ClockAnnotationView: MKAnnotationView {
    
    let clockView: ClockView
    
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        guard let annotation = annotation as? ClockAnnotation
            else { fatalError() }
        
        clockView = ClockView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        clockView.backgroundColor = .white
        clockView.calendar = Calendar(identifier: .gregorian)
        clockView.calendar.timeZone = annotation.timeZone
        
        clockView.layer.cornerRadius = 25
        clockView.clipsToBounds = true
        
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        frame = clockView.frame
        addSubview(clockView)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var calendar: Calendar {
        get { return clockView.calendar }
        set { clockView.calendar = newValue }
    }
    
    override var annotation: MKAnnotation? {
        didSet {
            if let annotation = annotation as? ClockAnnotation {
                clockView.calendar = Calendar(identifier: .gregorian)
                clockView.calendar.timeZone = annotation.timeZone
            }
        }
    }
    
    override var canShowCallout: Bool {
        get { return false }
        set { }
    }
    
    override var isDraggable: Bool {
        get { return false }
        set { }
    }
    
    override func prepareForReuse() {
        clockView.calendar = .autoupdatingCurrent
    }
    
    override var intrinsicContentSize: CGSize {
        return CGSize(width: 50, height: 50)
    }
    
}
