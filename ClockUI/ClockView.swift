//
//  ClockView.swift
//  DropItLikeItsClock
//
//  Created by Jeff Kelley on 5/19/17.
//  Copyright © 2017 Jeff Kelley. All rights reserved.
//

import UIKit

extension DateComponents {
    
    func percentFilled(of component: Calendar.Component) -> Double {
        guard let calendar = calendar else { fatalError() }
        
        let currentValue = value(for: component)!
        let maxValue = calendar.maximumRange(of: component)!.upperBound
        return Double(currentValue) / Double(maxValue)
    }
    
    func percent(_ percent: Double,
                 in otherComponent: Calendar.Component) -> Double {
        guard let calendar = calendar else { fatalError() }
        
        let max = calendar.maximumRange(of: otherComponent)!.upperBound
        
        return percent * (1.0 / Double(max))
    }
    
}

public class ClockView: UIView {
    
    class HandView: UIView {
        
        let hand: UIView
        
        override var tintColor: UIColor! {
            set {
                hand.backgroundColor = newValue
            }
            get {
                return hand.backgroundColor!
            }
        }
        
        init(frame: CGRect, width: CGFloat = 1.0, heightPercent: CGFloat = 1.0) {
            let height = (frame.height / 2.0) * heightPercent
            hand = UIView(frame: CGRect(x: frame.midX - (width / 2.0),
                                        y: frame.midY - height,
                                        width: width,
                                        height: height))
            
            super.init(frame: frame)
            
            addSubview(hand)
        }
        
        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
    }
    
    private var displayLink: CADisplayLink? {
        didSet {
            if let oldValue = oldValue {
                oldValue.remove(from: .main, forMode: .commonModes)
            }
        }
    }
    
    private let hourHand: HandView
    private let minuteHand: HandView
    private let secondHand: HandView
    
    public var calendar: Calendar = .autoupdatingCurrent {
        didSet {
            drawCurrentWatchFace()
        }
    }
    
    override public init(frame: CGRect) {
        hourHand = HandView(frame: frame, width: 2.0, heightPercent: (2.0 / 3.0))
        hourHand.tintColor = .black
        
        minuteHand = HandView(frame: frame, width: 2.0)
        minuteHand.tintColor = .black
        
        secondHand = HandView(frame: frame)
        secondHand.tintColor = .red
        
        super.init(frame: frame)
        
        addSubview(hourHand)
        addSubview(minuteHand)
        addSubview(secondHand)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        if let displayLink = displayLink {
            displayLink.remove(from: .main, forMode: .commonModes)
        }
    }
    
    override public func didMoveToWindow() {
        super.didMoveToWindow()
        
        displayLink = CADisplayLink(target: self,
                                    selector: #selector(drawCurrentWatchFace))
        
        displayLink?.add(to: .main, forMode: .commonModes)
    }
    
    @objc private func drawCurrentWatchFace() {
        drawWatchFace(for: Date())
    }
    
    private func drawWatchFace(for date: Date) {
        // We need to break down the date more granularly than just hours, minutes,
        // and seconds, as we need fractional components of them.
        var dateComponents =
            calendar.dateComponents([.hour, .minute, .second, .nanosecond],
                                    from: date)
        
        dateComponents.calendar = calendar
        
        let nanosecondsPercentage = dateComponents.percentFilled(of: .nanosecond)
        
        let secondsPercentage =
            dateComponents.percent(nanosecondsPercentage, in: .second) +
                dateComponents.percentFilled(of: .second)
        
        let minutesPercentage =
            dateComponents.percent(secondsPercentage, in: .minute) +
                dateComponents.percentFilled(of: .minute)
        
        var hoursPercentage =
            dateComponents.percent(minutesPercentage, in: .hour) +
                dateComponents.percentFilled(of: .hour)
        
        // Since we’re rotating a view for the hand, doubling the rotation amount
        // gives us 12-hour time.
        hoursPercentage *= 2.0;
        
        hourHand.transform = CGAffineTransform(rotationAngle: CGFloat(2 * Double.pi * hoursPercentage))
        minuteHand.transform = CGAffineTransform(rotationAngle: CGFloat(2 * Double.pi * minutesPercentage))
        secondHand.transform = CGAffineTransform(rotationAngle: CGFloat(2 * Double.pi * secondsPercentage))
    }
    
}
