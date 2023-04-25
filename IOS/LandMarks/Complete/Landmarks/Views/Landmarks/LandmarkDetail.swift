/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view showing the details for a landmark.
*/

import SwiftUI

struct LandmarkDetail: View {
    @EnvironmentObject var modelData: ModelData
    var landmark: Landmark

    //比较输入地标id(landmark.id)和模型数据地标id($0.id),计算输入地标的索引
    //firstIndex(where: 返回满足条件的第一个元素的索引
    var landmarkIndex: Int {
        modelData.landmarks.firstIndex(where: { $0.id == landmark.id })!
    }

    var body: some View {
        ScrollView {
            //子视图ContentView 无法修改父视图MapView的属性值region
            MapView(coordinate: landmark.locationCoordinate)
                .ignoresSafeArea(edges: .top)//允许地图内容延伸到屏幕的顶部边缘
                .frame(height: 300)

            //将图像视图分层到地图视图的顶部
            CircleImage(image: landmark.image)
                .offset(y: -130)
                .padding(.bottom, -130)

            VStack(alignment: .leading) {
                HStack {
                    Text("\(landmark.id)")
                    Text("\(modelData.landmarks[0].id)")
                    Text(landmark.name)
                        .font(.title)
                    FavoriteButton(isSet: $modelData.landmarks[landmarkIndex].isFavorite)//绑定属性isSet
           
                }

                HStack {
                    Text(landmark.park)
                    Spacer()
                    Text(landmark.state)
                }
                .font(.subheadline)//修饰符应用于组中包含的所有元素
                .foregroundColor(.secondary)//修饰符应用于组中包含的所有元素

                Divider()

                Text("About \(landmark.name)")
                    .font(.title2)
                Text(landmark.description)
            }
            .padding()
        }
        .navigationTitle(landmark.name)//设置ScrollView的导航栏标题
        .navigationBarTitleDisplayMode(.inline)//导航栏标题在内侧
    }
}

struct LandmarkDetail_Previews: PreviewProvider {
    static let modelData = ModelData()

    static var previews: some View {
        LandmarkDetail(landmark: modelData.landmarks[0])
            .environmentObject(modelData)//修饰符environmentObject 在视图层次结构中向下传递数据
    }
}
