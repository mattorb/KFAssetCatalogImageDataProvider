Proof of concept initializer for KingFisher KFImage that will load either over network (https://), local file (file://), or from an asset catalog (asset-catalog://)

This is especially for putting local images in a 'Preview Content' asset catalog, and having fake data for SwiftUI previews which refers to those images and renders them in the previews.
