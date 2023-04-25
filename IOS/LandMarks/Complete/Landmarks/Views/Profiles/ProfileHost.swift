//
//  ProfileHost.swift
//  Landmarks
//
//  Created by gbt on 2022/11/3.
//  Copyright © 2022 Apple. All rights reserved.
//
/*
See LICENSE folder for this sample’s licensing information.

Abstract:
A view that hosts the profile viewer and editor.
*/

import SwiftUI

struct ProfileHost: View {
    //@Environment 监听系统级别信息的变换,一旦修饰的属性 editMode 发生了变换，自定义的ProfileHost 就会刷新
    @Environment(\.editMode) var editMode
    @EnvironmentObject var modelData: ModelData//从环境中读取用户的配置文件数据,将数据控制权传递给配置文件主机
    @State private var draftProfile = Profile.default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {

            //创建一个打开和关闭环境值的编辑按钮
            HStack{
                //添加一个取消按钮
                if editMode?.wrappedValue == .active {
                    Button("Cancel", role: .cancel) {
                        draftProfile = modelData.profile
                        editMode?.animation().wrappedValue = .inactive
                    }
                }
                Spacer()
                EditButton()
            }
            
            if editMode?.wrappedValue == .inactive{//未编辑模式
                //为了避免在确认任何编辑之前更新全局应用程序状态 - 例如在用户输入他们的姓名时 - 编辑视图在其自身的副本上运行。
                ProfileSummary(profile: modelData.profile)//显示从环境中读取的静态配置文件视图
            }else{//编辑模式
                ProfileEditor(profile: $draftProfile)//显示编辑模式视图
                //用户点击完成按钮时更新持久配置文件,否则，旧值会在下次激活编辑模式时重新出现
                .onAppear {
                    draftProfile = modelData.profile
                }
                .onDisappear {
                    modelData.profile = draftProfile
                }
            }
            
        }
        .padding()
    }
}

struct ProfileHost_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHost()
            .environmentObject(ModelData())//尽管此视图不使用具有属性的属性，但该视图的子视图却使用了。若没有环境对象修饰符，预览会失败
    }
}
