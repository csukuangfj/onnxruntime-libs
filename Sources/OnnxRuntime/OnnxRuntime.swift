import onnxruntime

/// Swift wrapper for ONNX Runtime C API
public enum OnnxRuntime {
    /// Returns the version string of the linked ONNX Runtime library (e.g., "1.27.1")
    public static var version: String {
        guard let base = OrtGetApiBase() else {
            return "unknown"
        }
        guard let getVersionString = base.pointee.GetVersionString else {
            return "unknown"
        }
        guard let cStr = getVersionString() else {
            return "unknown"
        }
        return String(cString: cStr)
    }

    /// Returns the ORT_API_VERSION defined in the headers
    public static var apiVersion: Int32 {
        return Int32(ORT_API_VERSION)
    }
}
