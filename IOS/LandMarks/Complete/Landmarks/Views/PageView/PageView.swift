//
//  PageView.swift
//  Landmarks
//
//  Created by gbt on 2022/11/3.
//  Copyright © 2022 Apple. All rights reserved.
//
/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view for bridging a UIPageViewController.
*/
import SwiftUI

struct PageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 0
    
    var body: some View {

        ZStack(alignment: .bottomTrailing){
            //父视图PageViewController将Binding属性$currentPage传递给子视图PageView，父级与子级View能相互关联
            PageViewController(pages: pages, currentPage: $currentPage)
            PageControl(numberOfPages: pages.count, currentPage: $currentPage)//绑定父级PageControl的currentPage
                .frame(width: CGFloat(pages.count * 18))
                .padding(.trailing)
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(pages: ModelData().features.map{FeatureCard(landmark: $0)})
            .aspectRatio(3 / 2, contentMode: .fit)
 
    }
}
