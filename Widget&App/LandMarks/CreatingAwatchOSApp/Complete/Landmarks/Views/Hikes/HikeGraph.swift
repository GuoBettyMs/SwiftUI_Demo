/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The elevation, heart rate, and pace of a hike plotted on a graph.
*/

import SwiftUI

extension Animation {
    
    // MARK: 弹簧动画
    static func ripple(index: Int) -> Animation {
        Animation.spring(dampingFraction: 0.5)      //dampingFraction阻尼0.5,让胶囊条跳动并逐渐减弱
            .speed(2)               //将动画速度加快一点，减少每个胶囊条移动到新位置的时间
            .delay(0.03 * Double(index))        //基于每个胶囊条在图表中的位置为动画添加一个延时
    }
}

struct HikeGraph: View {
    var hike: Hike
    var path: KeyPath<Hike.Observation, Range<Double>>

    var color: Color {
        switch path {
        case \.elevation:
            return .gray
        case \.heartRate:
            return Color(hue: 0, saturation: 0.5, brightness: 0.7)
        case \.pace:
            return Color(hue: 0.7, saturation: 0.4, brightness: 0.7)
        default:
            return .black
        }
    }

    var body: some View {
        let data = hike.observations
        
        //将变量的所有数据从小到大排序
        let overallRange = rangeOfRanges(data.lazy.map { $0[keyPath: path] })
        
        //变量为数组，所以在图表上表现为一段（magnitude:单个数组变量范围中最大值与最小值的差）不是一点
        let maxMagnitude = data.map { magnitude(of: $0[keyPath: path]) }.max()!
        
        //图表高度比例，分别对比单个数组变量的范围（magnitude:最大值与最小值的差）与整体数组变量的范围（magnitude:最大值与最小值的差），得到合适的图表比例
        let heightRatio = 1 - CGFloat(maxMagnitude / magnitude(of: overallRange))

        return GeometryReader { proxy in
            HStack(alignment: .bottom, spacing: proxy.size.width / 120) {
                ForEach(Array(data.enumerated()), id: \.offset) { index, observation in
                    GraphCapsule(
                        index: index,
                        color: color,
                        height: proxy.size.height,
                        range: observation[keyPath: path],         //单个数组变量path的范围
                        overallRange: overallRange                 //整体数组变量path的范围
                    )
                    .animation(.ripple(index: index))
                }
                .offset(x: 0, y: proxy.size.height * heightRatio)
            }
        }
    }
}

// MARK: 数组变量整体排序
//Hike.Observation是一个数组，数组Observation含有数组变量（elevation、pace、heartRate），先将elevation数组从小到大排序，然后再对多个elevation数组从小到大排序
func rangeOfRanges<C: Collection>(_ ranges: C) -> Range<Double>
    where C.Element == Range<Double> {
    guard !ranges.isEmpty else { return 0..<0 }
    let low = ranges.lazy.map { $0.lowerBound }.min()!          //变量的所有数据的下限
    let high = ranges.lazy.map { $0.upperBound }.max()!         //变量的所有数据的上限
    return low..<high
}

// MARK: 数组变量范围中最大值与最小值的差
func magnitude(of range: Range<Double>) -> Double {
    range.upperBound - range.lowerBound
}

struct HikeGraph_Previews: PreviewProvider {
    static var hike = ModelData().hikes[0]

    static var previews: some View {
        Group {
            HikeGraph(hike: hike, path: \.elevation)
                .frame(height: 200)
            HikeGraph(hike: hike, path: \.heartRate)
                .frame(height: 200)
            HikeGraph(hike: hike, path: \.pace)
                .frame(height: 200)
        }
    }
}
