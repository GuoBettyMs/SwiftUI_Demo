//
//  HikeView.swift
//  Landmarks
//
//  Created by gbt on 2022/11/3.
//  Copyright © 2022 Apple. All rights reserved.
//
/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view displaying information about a hike, including an elevation graph.
*/
import SwiftUI

extension AnyTransition {
    static var moveAndFade: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .scale.combined(with: .opacity)
        )
    }
}

struct HikeView: View {
    var hike: Hike
    @State private var showDetail = false
    
    var body: some View {
        VStack {
            HStack {
                HikeGraph(hike: hike, path: \.elevation)
                    .frame(width: 50, height: 30)

                VStack(alignment: .leading) {
                    Text(hike.name)
                        .font(.headline)
                    Text(hike.distanceText)
                }

                Spacer()

                Button {
                    //显示按钮和视图添加动画过渡
                    withAnimation {
                        showDetail.toggle()
                    }
                } label: {
                    Label("Graph", systemImage: "chevron.right.circle")
                        .labelStyle(.iconOnly)
                        .imageScale(.large)
                        .rotationEffect(.degrees(showDetail ? 90 : 0))//点击按钮,按钮旋转90度
//                        .animation(nil, value: showDetail)//当存在显示视图动画,可传递nil给修饰符防止旋转效果被动画化
                        .scaleEffect(showDetail ? 1.5 : 1)//点击按钮,按钮变大
                        .padding()
//                        .animation(.spring(), value: showDetail)//显示视图动画
                }
            }

            if showDetail {
                HikeDetail(hike: hike)
                    .transition(.moveAndFade)//添加动画,通过滑入和滑出视线出现和消失
            }
        }
    }
}

struct HikeView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            HikeView(hike: ModelData().hikes[0])
                .padding()
            Spacer()
        }
    }
}
