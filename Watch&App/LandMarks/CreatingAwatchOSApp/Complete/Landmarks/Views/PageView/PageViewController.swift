/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that wraps a UIPageViewController.
*/

import SwiftUI
import UIKit

//类似UIKit的 ViewController
struct PageViewController<Page: View>: UIViewControllerRepresentable {
    var pages: [Page]
    
    //从 PageView 中跟踪当前页面：在 PageView 中声明一个 @State 属性（currentPage），并传递一个 binding 给此属性，直到 PageViewController 更新 binding 来匹配可见页面
    @Binding var currentPage: Int

    // MARK: 定义 SwiftUI 管理的 Coordinator 类型，并将其作为表示 view 上下文的一部分提供
    //可以用这个 coordinator 实现常见的 Cocoa 模式，例如代理、数据源以及通过 target-action 响应用户事件
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: 创建视图控制器对象并配置其初始状态。
    func makeUIViewController(context: Context) -> UIPageViewController {
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        
        //将 coordinator 作为数据源添加给 UIPageViewController
        pageViewController.dataSource = context.coordinator
        //将 coordinator 指定为 UIPageViewController 的代理。
        pageViewController.delegate = context.coordinator

        return pageViewController           //view 会在每次滑动后更新以显示正确的页码
    }

    // MARK: 使用来自 SwiftUI 的新信息更新指定视图控制器的状态。
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        
        //setViewControllers传递currentPage 的 binding 的值： [context.coordinator.controllers[currentPage]]
        pageViewController.setViewControllers(
            [context.coordinator.controllers[currentPage]], direction: .forward, animated: true)
    }

    // MARK: 实现功能：启用滑动交互来从一个页面移动到另一个页面
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var controllers = [UIViewController]()

        //将PageViewController的每一页添加 UIViewController
        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            
            //UIHostingController 是一个 UIViewController 的子类，表示 UIKit 上下文中的 SwiftUI view
            controllers = parent.pages.map { UIHostingController(rootView: $0) }
        }

        
        // MARK: 指定前一页的视图控制器
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerBefore viewController: UIViewController) -> UIViewController? {
//            guard let index = controllers.firstIndex(of: viewController) else {
//                return nil
//            }
//            if index == 0 {
//                return controllers.last
//            }
//            return controllers[index - 1]
                
            if let index = controllers.firstIndex(of: viewController){
                if index > 0 {
                    return controllers[index - 1]
                }
            }
            
            return nil
                
        }

        // MARK: 指定后一页的视图控制器
        func pageViewController(
            _ pageViewController: UIPageViewController,
            viewControllerAfter viewController: UIViewController) -> UIViewController? {
//            guard let index = controllers.firstIndex(of: viewController) else {
//                return nil
//            }
//            if index + 1 == controllers.count {
//                return controllers.first
//            }
//            return controllers[index + 1]
                
            if let index = controllers.firstIndex(of: viewController){
                if index < controllers.count - 1 {
                    return controllers[index + 1]
                }
            }
            
            return nil
        }

        //用户完成了翻页手势（completed=true），SwiftUI 就会调用此方法，可以找到当前 view controller 的索引并更新 binding ，从而PageViewController的当前页数与跳转的视图控制器所在索引一致
        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index
            }
        }
    }
}
