//
//  ProfileEditor.swift
//  Landmarks
//
//  Created by gbt on 2022/11/3.
//  Copyright © 2022 Apple. All rights reserved.
//
/*
See LICENSE folder for this sample’s licensing information.

Abstract:
An editable profile view.
*/
import SwiftUI

struct ProfileEditor: View {
    @Binding var profile: Profile//绑定用户配置文件草稿副本
    
    var dateRange: ClosedRange<Date> {
        let min = Calendar.current.date(byAdding: .year, value: -1, to: profile.goalDate)!
        let max = Calendar.current.date(byAdding: .year, value: 1, to: profile.goalDate)!
        return min...max
    }
    
    var body: some View {
        List {
            HStack {
                Text("Username").bold()
                Divider()
                TextField("Username", text: $profile.username)//绑定配置文件的用户名
            }
            //添加用户接收地标相关事件的通知按钮
            Toggle(isOn: $profile.prefersNotifications) {
                Text("Enable Notifications").bold()
            }
            
            VStack(alignment: .leading, spacing: 20) {
                 Text("Seasonal Photo").bold()
                 //选择地标照片属于的季节
                 Picker("Seasonal Photo", selection: $profile.seasonalPhoto) {
                     ForEach(Profile.Season.allCases) { season in
                         Text(season.rawValue).tag(season)
                     }
                 }
                 .pickerStyle(.segmented)
             }
            
            //添加地标访问目标日期
            DatePicker(selection: $profile.goalDate, in: dateRange, displayedComponents: .date) {
                Text("Goal Date").bold()
            }
        }
    }
}

struct ProfileEditor_Previews: PreviewProvider {
    static var previews: some View {
        ProfileEditor(profile: .constant(.default))
    }
}
