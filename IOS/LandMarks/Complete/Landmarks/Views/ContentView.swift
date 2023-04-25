/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the list of landmarks.
*/

import SwiftUI

struct ContentView: View {
    
    @State private var selection: Tab = .featured
    
    //添加要显示的选项卡的枚举
    enum Tab{
        case featured
        case list
    }
    var body: some View {
        
        //每个视图上的修饰符与属性可以采用tag(_:)的可能值之一匹配，因此当用户在用户界面中进行选择时，可以协调显示哪个视图
        TabView(selection: $selection, content: {
            CategoryHome()
                .tabItem({//添加TabView视图tag标签
                    Label("Featured", systemImage: "star")
                })
                .tag(Tab.featured)
            LandmarkList()
                .tabItem({//添加TabView视图tag标签
                    Label("List", systemImage: "list.bullet")
                })
                .tag(Tab.list)
        })

    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ModelData())//将模型对象添加到环境中，从而使对象可用于任何子视图,即在视图层次结构中向下传递数据
    }
}
