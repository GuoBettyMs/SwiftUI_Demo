/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that presents a map of a landmark.
*/

import SwiftUI
import MapKit

struct MapView: View {
    var coordinate: CLLocationCoordinate2D//设置坐标属性
    
    //创建一个保存地图区域信息的私有状态变量,返回属性值region
    //<#注#> 1.将state属性传递给子视图属于值传递类型，父级修改该值,子级View随之发生改变,但是子级无法修改该值来改变父级View,即子视图只能只读访问region
    //2.State属性始终将状态声明为私有private,防止可能与 SwiftUI 提供的存储管理冲突,将其放置在需要访问该值的视图层次结构中的最高视图中
    @State private var region = MKCoordinateRegion()

    var body: some View {
        //$region添加前缀$，相当于传递一个绑定，即对基础值的引用。当用户与地图交互时，地图会更新区域值以匹配当前在用户界面中可见的地图部分
        Map(coordinateRegion: $region)//将默认Text视图替换Map为与区域绑定的视图。
            .onAppear {
                setRegion(coordinate)//向地图添加视图修改器，以触发基于当前坐标的区域计算
            }
    }
    
    //添加一个基于坐标值更新区域的方法
    private func setRegion(_ coordinate: CLLocationCoordinate2D) {
        region = MKCoordinateRegion(
            center: coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.2, longitudeDelta: 0.2)
        )
    }
}

struct PlayButton: View {
    //创建变量,返回属性值isPlay
    //<#注#> 将Binding属性传递给子视图属于引用类型，父级与子级View能相互关联
    @Binding var isPlay: Bool
    
    var body: some View {
        Button(isPlay ? "Pause" : "Play") {
            isPlay.toggle()
        }
    }
}

struct PlayerView: View {

    @State private var isPlaying: Bool = false

    var body: some View {
        VStack {
            Text("播放器视图")
                .foregroundStyle(isPlaying ? .primary : .secondary)
            
            //使用$来传递父视图isPlay属性的引用,PlayButton父视图可以读写PlayerView里的状态值,isPlay值发生了修改,isPlaying也发生修改, SwiftUI 会更新 PlayerView 和 PlayButton 视图
            //点击按钮,使父视图isPlay值发生改变,子视图PlayerView的isPlaying值也发生改变
            PlayButton(isPlay: $isPlaying)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView(coordinate: CLLocationCoordinate2D(latitude: 34.011_286, longitude: -116.166_868))
        //        PlayerView()
    }
}
