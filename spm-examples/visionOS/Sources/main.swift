import onnxruntime_visionos

let base = OrtGetApiBase()!
let version = String(cString: base.pointee.GetVersionString!())
let apiVersion = ORT_API_VERSION

print("ONNX Runtime version: \(version)")
print("ORT API version: \(apiVersion)")
