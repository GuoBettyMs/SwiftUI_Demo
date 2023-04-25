//
//  BadgeBackground.swift
//  Landmarks
//
//  Created by gbt on 2022/11/2.
//  Copyright © 2022 Apple. All rights reserved.
//

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that displays the background of a badge.
*/

import SwiftUI

struct BadgeBackground: View {
    var body: some View {
        
        //容器视图,获取当前容器视图大小
        GeometryReader { geometry in
            /*//应用修改器将形状变成视图
            Path{ path in
            }.fill(.black)
             */
            
            Path { path in
                //1.假设一个容器
                //min() 当包含的视图不是正方形时，使用几何图形的两个维度中最小的一个
                var width = min(geometry.size.width, geometry.size.height)
                let height = width
                
                //使用缩放x轴上的形状，然后将形状添加到其几何图形中的中心位置
                let xScale: CGFloat = 0.832
                let xOffset = (width * (1.0 - xScale)) / 2.0
                width *= xScale

                //2.为路径添加一个起点
                path.move(
                    to: CGPoint(
                        x: width * 0.95 + xOffset,
                        y: height * (0.20 + HexagonParameters.adjustment)
                    )
                )

                HexagonParameters.segments.forEach { segment in
                    //3.为形状数据的每个点绘制线条以创建粗略的六边形
                    path.addLine(
                        to: CGPoint(
                            x: width * segment.line.x + xOffset,
                            y: height * segment.line.y
                        )
                    )

                    //4.为形状数据的角绘制贝塞尔曲线
                    path.addQuadCurve(
                        to: CGPoint(
                            x: width * segment.curve.x + xOffset,
                            y: height * segment.curve.y
                        ),
                        control: CGPoint(
                            x: width * segment.control.x + xOffset,
                            y: height * segment.control.y
                        )
                    )
                }
            }
            .fill(.linearGradient(
                Gradient(colors: [Self.gradientStart, Self.gradientEnd]),
                startPoint: UnitPoint(x: 0.5, y: 0),
                endPoint: UnitPoint(x: 0.5, y: 0.6)
            ))
        }
        .aspectRatio(1, contentMode: .fit)//保持 1:1 的纵横比,将修改器应用于渐变填充
    }
    static let gradientStart = Color(red: 239.0 / 255, green: 120.0 / 255, blue: 221.0 / 255)
    static let gradientEnd = Color(red: 239.0 / 255, green: 172.0 / 255, blue: 120.0 / 255)
}

struct BadgeBackground_Previews: PreviewProvider {
    static var previews: some View {
        BadgeBackground()
    }
}

