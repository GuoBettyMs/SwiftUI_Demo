/*
See LICENSE folder for this sample’s licensing information.

Abstract:
Storage for model data.
*/

import Foundation
import Combine


//实现 ObservableObject 协议，然后用 @Published 修饰对象里属性,对象可以给多个独立的 View 使用
final class ModelData: ObservableObject {
    @Published var landmarks: [Landmark] = load("landmarkData.json")//从landmarkData.json文件获取数据,创建一个初始化地标数组
    @Published var profile = Profile.default//创建配置文件实例,即使在用户关闭配置文件视图后配置文件仍然存在
    var hikes: [Hike] = load("hikeData.json")//在最初加载远足数据后永远不会修改它，因此您不需要使用@Published属性对其进行标记
    
    //特征地点数组
    var features: [Landmark] {
        landmarks.filter { $0.isFeatured }
    }
    
    //添加一个计算字典，其中类别名称作为键，以及每个键的关联地标数组
    var categories: [String: [Landmark]] {
        Dictionary(
            grouping: landmarks,
            by: { $0.category.rawValue }
        )
    }
    
}

//从应用程序的主包中获取具有给定名称的 JSON 数据,返回解码后的JSON 数据
func load<T: Decodable>(_ filename: String) -> T {
    let data: Data

    guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
        else {
            fatalError("Couldn't find \(filename) in main bundle.")
    }

    do {
        data = try Data(contentsOf: file)
    } catch {
        fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
    }

    do {
        let decoder = JSONDecoder()
        return try decoder.decode(T.self, from: data)
    } catch {
        fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
    }
}

