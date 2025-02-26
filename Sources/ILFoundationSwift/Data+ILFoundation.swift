import Foundation
internal import ILFoundation

extension Data { // TODO: ILHashable

    // MARK: - ILHashable

    public var md2: Data {
        return (self as NSData).md2
    }

    public var md4: Data {
        return (self as NSData).md4
    }

    public var md5: Data {
        return (self as NSData).md5
    }

    public var sha1: Data {
        return (self as NSData).sha1
    }

    public var sha2_224: Data {
        return (self as NSData).sha2_224
    }

    public var sha2_256: Data {
        return (self as NSData).sha2_256
    }

    public var sha2_384: Data {
        return (self as NSData).sha2_384
    }

    public var sha2_512: Data {
        return (self as NSData).sha2_512
    }

    // MARK: - ILFoundation

    public var hexString: String {
        return (self as NSData).hexString
    }
}
