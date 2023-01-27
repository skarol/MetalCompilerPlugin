import XCTest

import Metal

final class MetalCompilerPluginTests: XCTestCase {
    func testExample() throws {

        // TODO: This only works under Xcode Unit Tests. But fails when run from `swift test` command line.

        let shadersBundlePath = Bundle(for: MetalCompilerPluginTests.self)
            .resourcePath! + "/MetalCompilerPlugin_ExampleShaders.bundle"
        let shadersBundleURL = URL(string: shadersBundlePath)!
        let bundle = Bundle(url: shadersBundleURL)!
        let libraryURL = bundle.url(forResource: "debug", withExtension: "metallib")!
        let device = MTLCreateSystemDefaultDevice()!
        let library = try device.makeLibrary(URL: libraryURL)
        print(library)
    }
}
