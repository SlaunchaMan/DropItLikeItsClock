//: Playground - noun: a place where people can play

import ClockUI

let view = ClockView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))

view.calendar = Calendar(identifier: .gregorian)
view.calendar.timeZone = TimeZone(identifier: "America/Detroit")!
view.backgroundColor = .white

view
