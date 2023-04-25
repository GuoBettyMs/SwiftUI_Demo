//
//  Badge.swift
//  Landmarks
//
//  Created by gbt on 2022/11/3.
//  Copyright © 2022 Apple. All rights reserved.
//
/*
    See LICENSE folder for this sample’s licensing information.

    Abstract:
    A view that displays a badge.
*/

import SwiftUI

struct Badge: View {
    
    //徽章符号
    var badgeSymbols: some View {
        ForEach(0..<8) { index in
            RotatedBadgeSymbol(
                angle: .degrees(Double(index) / Double(8)) * 360.0
            )
        }
        .opacity(0.5)
    }
    
    var body: some View {
        ZStack{
            BadgeBackground()
            
            //通过读取周围的几何图形和缩放符号来更正徽章符号的大小
            GeometryReader { geometry in
                badgeSymbols
                    .scaleEffect(1.0/4.0, anchor: .top)
                    .position(x: geometry.size.width / 2.0, y: (3.0 / 4.0) * geometry.size.height)
                
            }
        }
        .scaledToFit()
    }
}

struct Badge_Previews: PreviewProvider {
    static var previews: some View {
        Badge()
    }
}
