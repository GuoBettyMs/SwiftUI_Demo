/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The main interface of the app.
*/

import SwiftUI

struct ContentView: View {
    @Binding var store: GradientModelStore
    @State private var isPlaying = false

    var body: some View {
#if os(iOS)
        content//iOS导航栏View
            .fullScreenCover(isPresented: $isPlaying) {
                visualizer
            }
#else
        let item = ToolbarItem(placement: .navigation) {
            Toggle(isOn: $isPlaying) {
                Image(systemName: "play.fill")
            }
        }

        if isPlaying {
            visualizer
                .toolbar { item }
        } else {
            content//macOS导航栏View
                .toolbar { item }
        }
#endif
    }

    var content: some View {
        NavigationView {
            List {
                ForEach(store.gradients.indices, id: \.self) { index in
                    let gradient = store.gradients[index]
                    NavigationLink(destination: GradientDetailView(gradient: $store.gradients[index])) {
                        HStack {
                            RoundedRectangle(cornerRadius: 6)
                                .fill(.linearGradient(gradient.gradient, startPoint: .leading, endPoint: .trailing))
                                .frame(width: 32, height: 32)

                            VStack(alignment: .leading) {
                                gradient.name.isEmpty ? Text("New Gradient") : Text(gradient.name)
                                Text("\(gradient.stops.count) colors")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }
            }
            .navigationTitle("Gradients")
            .toolbar {//macOS
                ToolbarItem(placement: .primaryAction) {//primaryAction该项目表示主要操作,即列表右上角增加“+”按钮
                    Button {
                        store.append(colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple])
                    } label: {
                        Image(systemName: "plus")
                    }
                }

#if os(iOS)//iOS
                ToolbarItem(placement: .cancellationAction) {//cancellationAction该项目表示模态界面的取消操作,即列表左上角再增加播放按钮
                    Button {
                        isPlaying = true
                    } label: {
                        Image(systemName: "play.fill")
                    }
                }
#endif
            }

            Text("No Gradient")
        }
    }

   
    var visualizer: some View {

        NavigationView {
            Visualizer(gradients: store.gradients.map(\.gradient))
                .toolbar {//IOS添加导航栏Button
#if os(iOS)
                    Button {
                        isPlaying = false
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                    }
#endif
                }
            Text("Choose a visualizer")//macOS显示
        }
        .preferredColorScheme(.dark)//设置此演示文稿的首选配色方案为暗黑模式
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: .constant(GradientModelStore()))
    }
}
