/*
See LICENSE folder for this sample’s licensing information.

Abstract:
The views of the app, which display details of the fetched earthquake data.
*/

import SwiftUI
import CoreData

struct ContentView: View {
    var quakesProvider: QuakesProvider = .shared

    @AppStorage("lastUpdated")
    private var lastUpdated = Date.distantFuture.timeIntervalSince1970

    @FetchRequest(sortDescriptors: [SortDescriptor(\.time, order: .reverse)])
    private var quakes: FetchedResults<Quake>

    #if os(iOS)
    @State private var editMode: EditMode = .inactive
    @State private var selectMode: SelectMode = .inactive
    #endif
    @State private var selection: Set<String> = []
    @State private var isLoading = false
    @State private var error: QuakeError?
    @State private var hasError = false

    var body: some View {
        NavigationView {
            List(selection: $selection) {
                ForEach(quakes, id: \.code) { quake in
                    NavigationLink(destination: QuakeDetail(quake: quake)) {
                        QuakeRow(quake: quake)
                    }
                }
                .onDelete(perform: deleteQuakes)
            }
            .listStyle(SidebarListStyle())//描述侧边栏列表的行为和外观的列表样式
            .navigationTitle(title)
            .toolbar(content: toolbarContent)
            #if os(iOS)
            .environment(\.editMode, $editMode)
            .refreshable {
                await fetchQuakes()
            }
            #else
            .frame(minWidth: 320)
            #endif

            EmptyView()
        }
        .alert(isPresented: $hasError, error: error) { }
    }
}

// MARK: Core Data

extension ContentView {
    var title: String {
        #if os(iOS)
        if selectMode.isActive || selection.isEmpty {
            return "Earthquakes"
        } else {
            return "\(selection.count) Selected"
        }
        #else
        return "Earthquakes"
        #endif
    }

    //未编辑模式,删除选中值
    private func deleteQuakes(at offsets: IndexSet) {
        let objectIDs = offsets.map { quakes[$0].objectID }
        quakesProvider.deleteQuakes(identifiedBy: objectIDs)
        selection.removeAll()
    }

    //编辑模式,删除选中值
    private func deleteQuakes(for codes: Set<String>) async {
        do {
            let quakesToDelete = quakes.filter { codes.contains($0.code) }
            //在 Swift 中使用异步函数分两步完成：将函数本身声明为 is async，然后使用await
            //每个await关键字都标记了我们代码中的一个暂停点。当执行到达它时，它会停止并将主线程的控制权交还给应用程序的运行循环
            //然后，被调用的异步函数在另一个线程上运行，占用完成网络传输所需的所有时间。当数据传输完成时，异步函数返回它的结果，并且我们的代码中的执行从它暂停的地方恢复
            try await quakesProvider.deleteQuakes(quakesToDelete)
        } catch {
            self.error = error as? QuakeError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        selection.removeAll()
        #if os(iOS)
        editMode = .inactive
        #endif
    }

    private func fetchQuakes() async {
        isLoading = true
        do {
            try await quakesProvider.fetchQuakes()
            lastUpdated = Date().timeIntervalSince1970
        } catch {
            self.error = error as? QuakeError ?? .unexpectedError(error: error)
            self.hasError = true
        }
        isLoading = false
    }
}

// MARK: Toolbar Content

extension ContentView {
    @ToolbarContentBuilder
    private func toolbarContent() -> some ToolbarContent {
        #if os(iOS)
        toolbarContent_iOS()
        #else
        toolbarContent_macOS()
        #endif
    }

    #if os(iOS)
    @ToolbarContentBuilder
    private func toolbarContent_iOS() -> some ToolbarContent {
        ToolbarItem(placement: .navigationBarLeading) {
            if editMode == .active {
                SelectButton(mode: $selectMode) {
                    if selectMode.isActive {
                        selection = Set(quakes.map { $0.code })
                    } else {
                        selection = []
                    }
                }
            }
        }

        ToolbarItem(placement: .navigationBarTrailing) {
            EditButton(editMode: $editMode) {
                selection.removeAll()
                editMode = .inactive
                selectMode = .inactive
            }
        }

        ToolbarItemGroup(placement: .bottomBar) {
            RefreshButton {
                //Task类型可以运行、暂停和取消异步代码
                Task {
                    await fetchQuakes()
                }
            }
            .disabled(isLoading || editMode == .active)

            Spacer()
            ToolbarStatus(
                isLoading: isLoading,
                lastUpdated: lastUpdated,
                quakesCount: quakes.count
            )
            Spacer()

            if editMode == .active {
                DeleteButton {
                    Task {
                        await deleteQuakes(for: selection)
                    }
                }
                .disabled(isLoading || selection.isEmpty)//正在浏览中或者未选中时无法删除
            }
        }
    }
    #else
    @ToolbarContentBuilder
    private func toolbarContent_macOS() -> some ToolbarContent {
        ToolbarItemGroup(placement: .status) {
            ToolbarStatus(
                isLoading: isLoading,
                lastUpdated: lastUpdated,
                quakesCount: quakes.count
            )
        }

        ToolbarItemGroup(placement: .navigation) {
            RefreshButton {
                Task {
                    await fetchQuakes()
                }
            }
            .disabled(isLoading)
            Spacer()
            DeleteButton {
                Task {
                    await deleteQuakes(for: selection)
                }
            }
            .disabled(isLoading || selection.isEmpty)
        }
    }
    #endif
}

struct ContentView_Previews: PreviewProvider {
    static let quakesProvider = QuakesProvider.preview
    static var previews: some View {
        ContentView(quakesProvider: quakesProvider)
            .environment(\.managedObjectContext,
                          quakesProvider.container.viewContext)
    }
}
