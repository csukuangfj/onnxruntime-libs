import onnxruntime

let base = OrtGetApiBase()!
let getVersionString = base.pointee.GetVersionString!
let version = String(cString: getVersionString())
let apiVersion = ORT_API_VERSION

print("ONNX Runtime version: \(version)")
print("ORT API version: \(apiVersion)")
