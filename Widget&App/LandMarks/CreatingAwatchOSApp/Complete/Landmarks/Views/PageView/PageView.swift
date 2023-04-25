/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view for bridging a UIPageViewController.
*/

import SwiftUI

//在 SwiftUI 中表示 UIKit view 和 view controllers，我们需要创建遵循 UIViewRepresentable 和 UIViewControllerRepresentable 协议的类型
struct PageView<Page: View>: View {
    var pages: [Page]
    @State private var currentPage = 0

    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            //UIPageViewController是一个controller，在上面有view，他是一个根视图控制器，实现效果类似与翻书的效果,可启用滑动交互来从一个页面移动到另一个页面
            //使用 $ 语法创建用状态来存储值的 binding
            PageViewController(pages: pages, currentPage: $currentPage)
            //UIPageControl是一个UIview，跟UIButton是一类型的带有控制功能的控件
            PageControl(numberOfPages: pages.count, currentPage: $currentPage)
                .frame(width: CGFloat(pages.count * 18))
                .padding(.trailing)
        }
    }
}

struct PageView_Previews: PreviewProvider {
    static var previews: some View {
        PageView(pages: ModelData().features.map { FeatureCard(landmark: $0) })
            .aspectRatio(3 / 2, contentMode: .fit)
    }
}
