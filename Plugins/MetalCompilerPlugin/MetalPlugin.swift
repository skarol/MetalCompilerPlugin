import Foundation
import os
import PackagePlugin

@main
struct MetalPlugin: BuildToolPlugin {
    func createBuildCommands(context: PackagePlugin.PluginContext, target: PackagePlugin.Target) async throws -> [PackagePlugin.Command] {
        var paths: [Path] = []
        target.directory.walk { path in
            if path.pathExtension == "metal" {
                paths.append(path)
            }
        }
        Diagnostics.remark("Running...")
        // guard let metalCompilerTool = try? context.tool(named: "MetalCompilerTool") else {
        //     Diagnostics.remark("MetalCompilerTool not found. Skipping plugin build.")
        //     return []
        // }
        let arguments = [
            "metal",
        ]
            // + inputs
            + [
                "-o",
                context.pluginWorkDirectory.appending(["debug.metallib"]).string,
                "-gline-tables-only",
                "-frecord-sources",
            ]
            + paths.map(\.string)
        return [
            .buildCommand(
                displayName: "Test",
                executable: Path("/usr/bin/xcrun"),
                arguments: arguments,
                environment: [:],
                inputFiles: paths,
                outputFiles: [
                    context.pluginWorkDirectory.appending(["debug.metallib"])
                ]
            )
            // .buildCommand(
            //     displayName: "Test",
            //     executable: metalCompilerTool.path,
            //     arguments: [
            //         "--output", context.pluginWorkDirectory.appending(["debug.metallib"]).string,
            //     ]
            //         + paths.map(\.string),
            //
            //     environment: [:],
            //     inputFiles: paths,
            //     outputFiles: [
            //         context.pluginWorkDirectory.appending(["debug.metallib"]),
            //     ]
            // ),
        ]
    }
}

extension Path {
    func walk(_ visitor: (Path) -> Void) {
        let errorHandler = { (_: URL, _: Swift.Error) -> Bool in
            true
        }
        guard let enumerator = FileManager().enumerator(at: url, includingPropertiesForKeys: nil, options: [], errorHandler: errorHandler)
        else {
            fatalError()
        }
        for url in enumerator {
            guard let url = url as? URL else {
                fatalError()
            }
            let path = Path(url.path)
            visitor(path)
        }
    }

    var url: URL {
        URL(fileURLWithPath: string)
    }

    var pathExtension: String {
        url.pathExtension
    }
}
