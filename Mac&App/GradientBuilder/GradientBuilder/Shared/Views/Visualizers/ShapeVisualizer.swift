/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The scale visualizer.
*/

import SwiftUI

struct ShapeVisualizer: View {
    var gradients: [Gradient]
    @State private var state = SymbolState()

    var body: some View {
        GeometryReader { proxy in
            ZStack {
                ForEach(state.entries.indices, id: \.self) { index in
                    let entry = state.entries[index]
                    entry.symbol
                        .foregroundStyle(.ellipticalGradient(
                            gradients[entry.gradientSeed % gradients.count]))//图案的颜色
                        .scaleEffect(entry.selected ? 4 : 1)//图案的大小.被选中图案变大
                        .position(
                            x: proxy.size.width * entry.x,
                            y: proxy.size.height * entry.y)
                        .onTapGesture {//symbol添加点击手势
                            withAnimation{//添加点击手势的动画
                                state.entries[index].selected.toggle()
                            }
                        }
                        .accessibilityAction {//向视图添加可访问性操作
                            state.entries[index].selected.toggle()
                        }
                }
            }
        }
        .font(.system(size: 24))
        .contentShape(Rectangle())
        .onTapGesture {//整体View添加点击手势
            withAnimation(.easeInOut(duration: 2)) {
                state.reposition()//添加点击手势的动画,点击整体View的空白位置,2秒间所有Symbol更换位置
            }
        }
        .accessibilityAction(named: "Reposition") {//向视图添加可访问性操作
            state.reposition()
        }
        .drawingGroup()//在最终显示之前将此视图的内容合成为屏幕外图像
    }
}

struct SymbolState {
    var entries: [Entry] = []

    init(count: Int = 100) {
        for index in 0..<count {
            entries.append(Entry(gradientSeed: index))//添加随机图案
        }
    }
    //所有随机图案更换位置,位置随机
    mutating func reposition() {
        for index in entries.indices {
            entries[index].reposition()
        }
    }

    struct Entry {
        var gradientSeed: Int
        var symbolSeed: Int
        var x: Double
        var y: Double
        var selected: Bool = false

        init(gradientSeed: Int) {
            self.gradientSeed = gradientSeed
            symbolSeed = Int.random(in: 1..<symbols.count)
            x = Double.random(in: 0..<1)
            y = Double.random(in: 0..<1)
        }

        //单个随机图案更换位置,位置随机
        mutating func reposition() {
            x = Double.random(in: 0..<1)
            y = Double.random(in: 0..<1)
        }

        //单个随机Image
        var symbol: Image {
            Image(systemName: symbols[symbolSeed])
        }
    }
}

private let symbols = [
    "triangle.fill",
    "heart.fill",
    "star.fill",
    "diamond.fill",
    "octagon.fill",
    "capsule.fill",
    "square.fill",
    "seal.fill"
]
