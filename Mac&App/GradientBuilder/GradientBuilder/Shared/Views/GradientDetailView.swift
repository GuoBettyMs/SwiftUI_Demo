/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The gradient detail view.
*/

import SwiftUI

struct GradientDetailView: View {
    @Binding var gradient: GradientModel
    @State private var isEditing = false
    @State private var selectedStopID: Int?

    var body: some View {
        VStack {
            #if os(macOS)
            gradientBackground
            #else
            if !isEditing {
                gradientBackground
            } else {
                //色条
                GradientControl(gradient: $gradient, selectedStopID: $selectedStopID)
                    .padding()

                //选中色条调节点,弹出色条调节点的颜色设置列表
                if let selectedStopID = selectedStopID {
                    SystemColorList(color: $gradient[stopID: selectedStopID].color) {
                        gradient.remove(selectedStopID)
                        self.selectedStopID = nil
                    }
                } else {//未选中色条调节点,显示默认值
                    SystemColorList.Empty()
                }
            }
            #endif
        }
        .safeAreaInset(edge: .bottom) {
            VStack(spacing: 0) {
                #if os(macOS)
                GradientControl(gradient: $gradient, selectedStopID: $selectedStopID, drawGradient: false)
                    .padding(.horizontal)
                #endif

                HStack {
                    #if os(macOS)
                    // macOS always allows editing of the title
                    TextField("Name", text: $gradient.name)
                        .textFieldStyle(.roundedBorder)
                        .frame(maxWidth: 200)
                    #else
                    if isEditing {
                        TextField("Name", text: $gradient.name)
                    } else {
                        gradient.name.isEmpty ? Text("New Gradient") : Text(gradient.name)
                    }
                    #endif

                    Spacer()

                    Text("\(gradient.stops.count) colors")
                        .foregroundStyle(.secondary)
                }
                .padding()
            }
            .background(.thinMaterial)
            .controlSize(.large)
        }
        .navigationTitle(gradient.name)
#if os(iOS)
        .toolbar {
            Button(isEditing ? "Done" : "Edit") {
                isEditing.toggle()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
#endif
    }

    private var gradientBackground: some View {
        LinearGradient(gradient: gradient.gradient, startPoint: .leading, endPoint: .trailing)
            .ignoresSafeArea(edges: .bottom)
    }
}

struct Detail_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            GradientDetailView(
                gradient: .constant(GradientModel(colors: [.red, .orange, .yellow, .green, .blue, .indigo, .purple])))
        }
    }
}
