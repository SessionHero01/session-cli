import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
      
//      global_service_shared_get_port(nil, 0, nil,0, nil, 0);
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}


func getPort(
    pskData: [UInt8],
    dataDir: [UInt8],
    errorBufferLength: Int
) -> UInt16 {
    let errorBuffer = UnsafeMutablePointer<CChar>.allocate(capacity: errorBufferLength)
    defer {
        errorBuffer.deallocate()
    }

    let port = global_service_shared_get_port(
        pskData,
        pskData.count,
        dataDir,
        dataDir.count,
        errorBuffer,
        errorBufferLength
    )

    if errorBuffer.pointee != 0 {
        let errorMessage = String(cString: errorBuffer)
        print("Error: \(errorMessage)")
    }

    return port
}
