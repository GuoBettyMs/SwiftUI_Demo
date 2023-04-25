//
//  PageControl.swift
//  Landmarks
//
//  Created by gbt on 2022/11/3.
//  Copyright © 2022 Apple. All rights reserved.
//
/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view wrapping a UIPageControl.
*/
import SwiftUI
import UIKit

//UIViewRepresentable协议 使用其方法来支持UIView(创建、更新和拆除)
struct PageControl: UIViewRepresentable {
    var numberOfPages: Int
    @Binding var currentPage: Int
    
    // MARK: 创建视图对象并配置其初始状态
    func makeUIView(context: Context) -> UIPageControl{
        let control = UIPageControl()
        control.numberOfPages = numberOfPages
        control.addTarget(context.coordinator, action: #selector(Coordinator.updateCurrentPage), for: .valueChanged)//添加点击事件
        return control
    }
 
    // MARK: 使用来自 SwiftUI 的新信息更新指定视图的状态
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        uiView.currentPage = currentPage
    }
    
    // MARK: 创建协调器
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    // MARK: 创建一个嵌套Coordinator类型,创建委托或数据源
    class Coordinator: NSObject{
        var control: PageControl
        
        init(_ control: PageControl) {
            self.control = control
        }
        
        // MARK: 一般函数 - 更新当前页面绑定
        @objc func updateCurrentPage(sender: UIPageControl){
            control.currentPage = sender.currentPage
        }
    }
    
}


