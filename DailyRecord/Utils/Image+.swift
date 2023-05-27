//
//  Image+.swift
//  DailyRecord
//
//  Created by 안정흠 on 2023/05/27.
//

import SwiftUI

extension Image {
    // MARK: 저장된 캐시 이미지가 없다면 서버에 이미지를 요청해서 받아오고, 해당 이미지를 캐시에 저장한 뒤 반환합니다.
    private static func requestImage(key: URL, defaultImage: Image) async -> Image {
        // URL이 유효하지 않은 경우 기본 이미지를 반환하고 메서드를 종료합니다.
        guard var urlComponents = URLComponents(url: key,
                                                resolvingAgainstBaseURL: false)
        else {
            return defaultImage
        }
        
        // MEMO: url scheme이 http인 경우 iOS에서 보안성 이슈로 이미지를 요청하지 않기 때문에, scheme을 강제로 https로 세팅
        urlComponents.scheme = "https"
        
        // URL로 이미지 데이터를 요청 -> UIImage로 변환합니다.
        guard
            let imageURL = urlComponents.url,
            let imageData = try? Data(contentsOf: imageURL),
            let reponseUIImage = UIImage(data: imageData)
        else {
            return defaultImage
        }
        
        // 서버에 요청한 이미지를 NSCache에 저장합니다.
        ImageCacheManager.setObject(forKey: key, setImage: reponseUIImage)
        
        // 서버에서 불러온 이미지를 Image 타입으로 변환하고 return Image에 할당합니다.
        let reponseImage = Image(uiImage: reponseUIImage)
        return reponseImage
    }
    
    
    static func loadCachedImage(key: URL) async -> Image {
        // 캐시 이미지 없음, 유효하지 않은 URL 등이 있을 때 반환할 기본 플레이스홀더 이미지입니다.
        let returnImage = Image(systemName: "photo")
        
        // MARK: key로 접근했을 때, 캐시 이미지가 존재하면 해당 이미지를 반환하고 메서드를 종료합니다.
        let cacheImage = ImageCacheManager.getObject(forKey: key)
        if let cacheImage {
            let image = Image(uiImage: cacheImage)
            return image
        }
        // 결과 이미지를 반환합니다.
        /// 1. 캐시 이미지가 있는 경우 -> 해당 캐시 이미지를 반환
        /// 2. 캐시 이미지가 없는 경우 -> 서버에 URL을 통해서 이미지를 요청하고 응답 이미지를 반환
        /// 3. 캐시 이미지가 없음 + URL이 유효하지 않음 -> Asset의 기본 플레이스홀더 이미지를 반환
        return await requestImage(key: key, defaultImage: returnImage)
    }
}
