/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing a list of landmarks.
*/

import SwiftUI

struct LandmarkList: View {
    @EnvironmentObject var modelData: ModelData//全局环境,从环境中查找遵守 ObservableObject的对象,在入口需要传入 .environmentObject(ModelData())
   
    @State private var showFavoritesOnly = false//使用 @State属性包装器将值标记为状态，将属性声明为私有，并为其赋予默认值

    //创建星星地标数组
    var filteredLandmarks: [Landmark] {
        //从地标数组中过滤出符合过滤条件的地标,过滤条件:1.有星星标志的地标 2.Toggle视图被选中,即showFavoritesOnly为true
        modelData.landmarks.filter { landmark in
            (landmark.isFavorite || !showFavoritesOnly)
        }
    }

    var body: some View {
        NavigationView {
            //列表显示静态和动态组合视图,使用ForEach来现实动态视图
            List {
                Toggle(isOn: $showFavoritesOnly) {//使用$前缀来访问showFavoritesOnly的绑定状态
                    Text("Favorites only")
                }

                ForEach(filteredLandmarks) { landmark in
                    //将从landmarkData.json文件获取数据的landmarks数组,传递给List初始化程序
                    NavigationLink {
                        LandmarkDetail(landmark: landmark)//可点击的行List,点击列表单行可导航到LandmarkDetail视图
                    } label: {
                        LandmarkRow(landmark: landmark)//列表单行的视图
                    }
                }
            }
            .navigationTitle("Landmarks")//设置显示列表时的导航栏标题
            
            /*//列表只显示动态视图
             //List(landmarks, id: \.id)用来调整不符合Identifiable协议的元素集合
             //但是结构体Landmark遵守Identifiable协议,因已经具备Identifiable协议要求的id属性,只需添加一个属性就可以对其解码
             // List(landmarks, id: \.id) -> List(landmarks)
            List(filteredLandmarks){ landmark in
                NavigationLink {
                    LandmarkDetail(landmark: landmark)
                } label: {
                    LandmarkRow(landmark: landmark)
                }
            }.navigationTitle("Landmarks")
            */
        }
    }
}

struct LandmarkList_Previews: PreviewProvider {
    static var previews: some View {

        ForEach(["iPhone SE (2nd generation)", "iPhone XS Max"], id: \.self) { deviceName in
            LandmarkList()
                .environmentObject(ModelData())//修饰符environmentObject 在视图层次结构中向下传递数据
                .previewDevice(PreviewDevice(rawValue: deviceName))//将当前列表预览更改为以 iPhone SE、iPhone XS 的大小呈现
                .previewDisplayName(deviceName)//预览的标签为设备名称
        }
    }
}
