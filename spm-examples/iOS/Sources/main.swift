import onnxruntime

let base = OrtGetApiBase()!
let cStr = base.pointee.GetVersionString!()
let version = String(cString: cStr!)
let apiVersion = ORT_API_VERSION

print("ONNX Runtime version: \(version)")
print("ORT API version: \(apiVersion)")
