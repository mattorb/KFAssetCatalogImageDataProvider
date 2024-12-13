// mattorb.com

import Kingfisher
import SwiftUI

/// KingFisher ImageDataProvider that loads an asset from the asset catalog, i.e. - for a SwiftUI Preview, from the 'Preview Content' asset catalog
struct AssetImageDataProvider: ImageDataProvider {
  let assetName: String
  let delay: TimeInterval
  
  var cacheKey: String {
    return "asset-catalog://\(assetName)?delay=\(delay)"
  }
  
  struct AssetLoadingError: Error {}
  
  init(assetName: String, delay: TimeInterval = 0) {
    self.assetName = assetName
    self.delay = delay
  }
  
  func data(handler: @escaping @Sendable (Result<Data, Error>) -> Void) {
    Task {
      if delay > 0 {
        try? await Task.sleep(nanoseconds: UInt64(delay * 1_000_000_000))
      }
      
      if let image = UIImage(named: assetName), let data = image.pngData() {
        handler(.success(data))
      } else {
        handler(.failure(AssetLoadingError()))
      }
    }
  }
}

extension KFImage {
  @MainActor
  /// initializer that supports a URL which refers to asset to load from an asset catalog
  ///   URL format:  asset-catalog://filename.ext or asset-catalog://filename.ext?delay=3    (3 seconds)
  /// Thus, you can refer to a 'Preview Content' asset catalog image, for a SwiftUI preview where the
  ///   the image is fetched by Kingfisher
  ///
  ///  if file or http or https scheme are used, they behave unaffected
  init(smartURL: URL?) {
    if let url = smartURL,
       url.isAssetCatalogURL,
       let assetName = url.host(percentEncoded: false) {
      let provider = AssetImageDataProvider(assetName: assetName, delay: url.queryParameter(named: "delay", defaultValue: 0))
      self.init(source: .provider(provider))
    } else {
      self.init(smartURL)
    }
  }
}

private extension URL {
  var isAssetCatalogURL: Bool {
    return scheme == "asset-catalog"
  }
  
  func queryParameter(named: String, defaultValue: TimeInterval) -> TimeInterval {
    if let queryItems = URLComponents(url: self, resolvingAgainstBaseURL: false)?.queryItems {
      if let delayString = queryItems.first(where: { $0.name == "delay" })?.value,
         let delay = TimeInterval(delayString)
      {
        return delay
      }
    }
    
    return defaultValue
  }
}
