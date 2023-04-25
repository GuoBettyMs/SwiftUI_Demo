//
//  CategoryHome.swift
//  Landmarks
//
//  Created by gbt on 2022/11/3.
//  Copyright © 2022 Apple. All rights reserved.
//

/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing featured landmarks above a list of landmarks grouped by category.
*/

import SwiftUI

struct CategoryHome: View {
    @EnvironmentObject var modelData: ModelData//创建一个环境对象,用来访问类别，以及稍后访问其他地标数据

    @State private var showingProfile = false //创建用户配置文件按钮属性
    
    var body: some View {
        NavigationView {
            List {
//                //视图顶部添加特色地标image
//                modelData.features[0].image
//                    .resizable()
//                    .scaledToFill()
//                    .frame(height: 200)
//                    .clipped()
//                    .listRowInsets(EdgeInsets())
                
                // MARK:  显示顶部滑动视图
                //PageView(pages:)中 pages 是 View数组[Page]
                //1.确定单个View,FeatureCard(landmark: ModelData().features[0])
                //2.组合多个View,modelData.features.map{ FeatureCard(landmark: $0)}
                PageView(pages: modelData.features.map{ FeatureCard(landmark: $0)})
                    .aspectRatio(3/2, contentMode: .fit)
                    .listRowInsets(EdgeInsets())//去掉内边距
                

                //将类别信息传递给行类型
                ForEach(modelData.categories.keys.sorted(), id: \.self) { key in
                    CategoryRow(categoryName: key, items: modelData.categories[key]!)
                }
                .listRowInsets(EdgeInsets())//边缘插图设置为零，以便内容可以扩展到显示的边缘
            }
            .listStyle(.inset)//添加列表样式的修饰符
            .navigationTitle("Featured")//导航栏的标题设置为精选
            .toolbar {//使用修饰符将用户配置文件按钮添加到导航栏
                Button{
                    showingProfile.toggle()
                }label: {
                    Label("User Profile", systemImage: "person.fill")
                }
            }
            .sheet(isPresented: $showingProfile) {//点击用户配置文件按钮时呈现视图
                ProfileHost()
                    .environmentObject(modelData)//修饰符environmentObject 传递数据
            }
        }
    }
}

struct CategoryHome_Previews: PreviewProvider {
    static var previews: some View {
        CategoryHome()
            .environmentObject(ModelData())
    }
}

