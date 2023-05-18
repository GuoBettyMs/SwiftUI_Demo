/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A representation of a hike.
*/

import Foundation

struct Hike: Codable, Hashable, Identifiable {
    var id: Int
    var name: String
    var distance: Double            //miles
    var difficulty: Int
    var observations: [Observation]     //观察值

    static var formatter = LengthFormatter()

    var distanceText: String {
        Hike.formatter
            .string(fromValue: distance, unit: .kilometer)
    }

    struct Observation: Codable, Hashable {
        var distanceFromStart: Double

        var elevation: Range<Double>            //里程
        var pace: Range<Double>                 //步速
        var heartRate: Range<Double>
    }
}
