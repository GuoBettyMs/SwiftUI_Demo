//
//  PageViewController.swift
//  Landmarks
//
//  Created by gbt on 2022/11/3.
//  Copyright © 2022 Apple. All rights reserved.
//
//要在 SwiftUI 中表示 UIKit 视图和视图控制器，您需要创建符合和协议的类型。您的自定义类型创建和配置它们所代表的 UIKit 类型，而 SwiftUI 管理它们的生命周期并在需要时更新它们
/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that wraps a UIPageViewController.
*/
import SwiftUI
import UIKit

//UIViewControllerRepresentable协议 使用其方法来支持UIViewController(创建、更新和拆除)
struct PageViewController<Page: View>: UIViewControllerRepresentable {

    var pages: [Page]//地标页面
    @Binding var currentPage: Int

    // MARK: 创建视图控制器对象并配置其初始状态
    //SwiftUI 在准备好显示视图时调用该方法一次，然后管理视图控制器的生命周期
    func makeUIViewController(context: Context) -> UIPageViewController{
        let pageViewController = UIPageViewController(
            transitionStyle: .scroll,
            navigationOrientation: .horizontal)
        pageViewController.dataSource = context.coordinator//遵守UIPageViewControllerDataSource协议
        pageViewController.delegate = context.coordinator//遵守UIPageViewControllerDelegate协议
        return pageViewController
    }
    
    // MARK: 使用来自 SwiftUI 的新信息更新指定视图控制器的状态
    //在页面视图控制器的生命周期内仅初始化一次控制器
    func updateUIViewController(_ pageViewController: UIPageViewController, context: Context) {
        //UIHostingController(rootView: 将 SwiftUI 视图集成到 UIKit 视图层次结构中,在创建时，指定要用作此视图控制器的根视图的 SwiftUI 视图
//        pageViewController.setViewControllers([UIHostingController(rootView: pages[0])], direction: .forward, animated: true)
        
        //在协调器中初始化控制器数组,传递当前页面值
        pageViewController.setViewControllers(
                    [context.coordinator.controllers[currentPage]], direction: .forward, animated: true)
    }
    
    // MARK: 创建和返回一个新的协调器
    //SwiftUI之前会调用此方法，用此协调器可以实现常见的 Cocoa 模式，例如委托、数据源以及通过 target-action 响应用户事件
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: 声明一个嵌套Coordinator类,创建委托或数据源
    class Coordinator: NSObject, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        var parent: PageViewController
        var controllers = [UIViewController]()
        
        //在协调器中初始化控制器数组
        init(_ pageViewController: PageViewController) {
            parent = pageViewController
            controllers = parent.pages.map { UIHostingController(rootView: $0)}
        }
        
        // MARK: 遵守UIPageViewControllerDataSource协议 - 在给定视图控制器之前返回视图控制器
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else{
                return nil
            }
            if index == 0{
                return controllers.last
            }
            return controllers[index - 1]
        }
        
        // MARK: 遵守UIPageViewControllerDataSource协议 - 在给定视图控制器之后返回视图控制器
        func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
            guard let index = controllers.firstIndex(of: viewController) else{
                return nil
            }
            if index + 1 == controllers.count{
                return controllers.first
            }
            return controllers[index + 1]
        }
        
        // MARK: 遵守UIPageViewControllerDelegate协议 - 获取当前视图控制器的索引
        //在页面切换动画完成时调用此方法
        func pageViewController(
            _ pageViewController: UIPageViewController,
            didFinishAnimating finished: Bool,
            previousViewControllers: [UIViewController],
            transitionCompleted completed: Bool) {
            if completed,
               let visibleViewController = pageViewController.viewControllers?.first,
               let index = controllers.firstIndex(of: visibleViewController) {
                parent.currentPage = index//找到当前视图控制器的索引并更新绑定
            }
        }
        
    }
    
    
    

}


