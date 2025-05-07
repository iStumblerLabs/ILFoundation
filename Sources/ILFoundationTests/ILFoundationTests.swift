import XCTest
import ILFoundation
import ILFoundationSwift

final class ILFoundationTests: XCTestCase {

    override func setUpWithError() throws { }

    override func tearDownWithError() throws { }

    // MARK: - Reference Data and Hashcodes

    // get the null and standard test text "The quick brown fox jumps over the lazy dog" as utf8 data
    let nullStringData      = "".data(using: String.Encoding.utf8)!
    let quickBrownData      = "The quick brown fox jumps over the lazy dog".data(using: String.Encoding.utf8)!

    let md2NullHash         = "8350e5a3e24c153df2275c9f80692773"
    let md2QuickHash        = "03d85a0d629d2c442e987525319fc471"

    let md4NullHash         = "31d6cfe0d16ae931b73c59d7e0c089c0"
    let md4QuickHash        = "1bee69a46ba811185c194762abaeae90"

    let md5NullHash         = "d41d8cd98f00b204e9800998ecf8427e"
    let md5QuickHash        = "9e107d9d372bb6826bd81d3542a419d6"

    let sha1NullHash        = "da39a3ee5e6b4b0d3255bfef95601890afd80709"
    let sha1QuickHash       = "2fd4e1c67a2d28fced849ee1bb76e7391b93eb12"

    let sha2_224NullHash    = "d14a028c2a3a2bc9476102bb288234c415a2b01f828ea62ac5b3e42f"
    let sha2_224QuickHash   = "730e109bd7a8a32b1cb9d9a09aa2325d2430587ddbc0c38bad911525"

    let sha2_256NullHash    = "e3b0c44298fc1c149afbf4c8996fb92427ae41e4649b934ca495991b7852b855"
    let sha2_256QuickHash   = "d7a8fbb307d7809469ca9abcb0082e4f8d5651e46d3cdb762d02d0bf37c9e592"

    let sha2_384NullHash    = "38b060a751ac96384cd9327eb1b1e36a21fdb71114be07434c0cc7bf63f6e1da274edebfe76f65fbd51ad2f14898b95b"
    let sha2_384QuickHash   = "ca737f1014a48f4c0b6dd43cb177b0afd9e5169367544c494011e3317dbf9a509cb1e5dc1e85a941bbee3d7f2afbc9b1"

    let sha2_512NullHash    = "cf83e1357eefb8bdf1542850d66d8007d620e4050b5715dc83f4a921d36ce9ce47d0d13c5d85f2b0ff8318d2877eec2f63b931bd47417a81a538327af927da3e"
    let sha2_512QuickHash   = "07e547d9586f6a73f73fbac0435ed76951218fb7d0c8d788a309d785436bbb642e93a252a954f23912547d1e8a3b5ed6e1bfd7097821233fa0538f3db854fee6"

    // MARK: - Message Digests

    func testMD2Null() throws {
        XCTAssertEqual(nullStringData.md2.hexString, md2NullHash, "")
    }

    func testMD2QuickBrownFox() throws {
        XCTAssertEqual(quickBrownData.md2.hexString, md2QuickHash, "")
    }

    func testMD4Null() throws {
        XCTAssertEqual(nullStringData.md4.hexString, md4NullHash, "")
    }

    func testMD4QuickBrownFox() throws {
        XCTAssertEqual(quickBrownData.md4.hexString, md4QuickHash, "")
    }

    func testMD5Null() throws {
        XCTAssertEqual(nullStringData.md5.hexString, md5NullHash, "")
    }

    func testMD5QuickBrownFox() throws {
        XCTAssertEqual(quickBrownData.md5.hexString, md5QuickHash, "")
    }

    // MARK: - SHA-1

    func testSHA_1Null() throws {
        XCTAssertEqual(nullStringData.sha1.hexString, sha1NullHash, "")
    }

    func testSHA_1QuickBrownFox() throws {
        XCTAssertEqual(quickBrownData.sha1.hexString, sha1QuickHash, "")
    }

    // MARK: - SHA-2 Instances

    func testSHA2_224Null() throws {
        XCTAssertEqual(nullStringData.sha2_224.hexString, sha2_224NullHash, "")
    }

    func testSHA2_224QuickBrownFox() throws {
        XCTAssertEqual(quickBrownData.sha2_224.hexString, sha2_224QuickHash, "")
    }

    func testSHA2_256Null() throws {
        XCTAssertEqual(nullStringData.sha2_256.hexString, sha2_256NullHash, "")
    }

    func testSHA2_256QuickBrownFox() throws {
        XCTAssertEqual(quickBrownData.sha2_256.hexString, sha2_256QuickHash, "")
    }

    func testSHA2_384Null() throws {
        XCTAssertEqual(nullStringData.sha2_384.hexString, sha2_384NullHash, "")
    }

    func testSHA2_384QuickBrownFox() throws {
        XCTAssertEqual(quickBrownData.sha2_384.hexString, sha2_384QuickHash, "")
    }

    func testSHA2_512Null() throws {
        XCTAssertEqual(nullStringData.sha2_512.hexString, sha2_512NullHash, "")
    }

    func testSHA2_512QuickBrownFox() throws {
        XCTAssertEqual(quickBrownData.sha2_512.hexString, sha2_512QuickHash, "")
    }

    // MARK: - ILHashableInputStream - category methods on NSInputStream

    func testMD2HashalbeNSInputStream() throws {
        let inStream = InputStream(data: quickBrownData)

        XCTAssertEqual(inStream.md2.hexString, md2QuickHash, "")
    }

    func testMD4HashableNSInputStream() throws {
        let inputStream: InputStream = InputStream(data: quickBrownData)

        XCTAssertEqual(inputStream.md4.hexString, md4QuickHash, "")
    }

    func testMD5HashableNSInputStream() throws {
        let inputStream = InputStream(data: quickBrownData)

        XCTAssertEqual(inputStream.md5.hexString, md5QuickHash, "")
    }

    func testSHA1HashableNSInputStream() throws {
        let inputStream = InputStream(data: quickBrownData)

        XCTAssertEqual(inputStream.sha1.hexString, sha1QuickHash, "")
    }

    func testSHA2_224HashableNSInputStream() throws {
        let inputStream = InputStream(data: quickBrownData)

        XCTAssertEqual(inputStream.sha2_224.hexString, sha2_224QuickHash, "")
    }

    func testSHA2_256HashableNSInputStream() throws {
        let inputStream = InputStream(data: quickBrownData)

        XCTAssertEqual(inputStream.sha2_256.hexString, sha2_256QuickHash, "")
    }

    func testSHA2_384HashableNSInputStream() throws {
        let inputStream = InputStream(data: quickBrownData)

        XCTAssertEqual(inputStream.sha2_384.hexString, sha2_384QuickHash, "")
    }

    func testSHA2_512HashableNSInputStream() throws {
        let inputStream = InputStream(data: quickBrownData)

        XCTAssertEqual(inputStream.sha2_512.hexString, sha2_512QuickHash, "")
    }

    // MARK: - ILHashingInputStream - Input Stream Hash Wrapper

    func testMD2ILHashingInputStream() throws {
        // create the hashing stream
        let testStream = ILHashingInputStream(inputStream:InputStream(data: quickBrownData), hashFunction:.MD2)
        let streamHash = testStream.readToEndAndHash()

        XCTAssertEqual(streamHash!.hexString, md2QuickHash, "")
    }

    func testMD4ILHashingInputStream() throws {
        // create a stream with some test data in it and then create the hashing stream
        let testStream = ILHashingInputStream(inputStream:InputStream(data: quickBrownData), hashFunction:.MD4)
        let streamHash = testStream.readToEndAndHash()

        XCTAssertEqual(streamHash!.hexString, md4QuickHash, "")
    }

    func testMD5ILHashingInputStream() throws {
        // create a stream with some test data in it and then create the hashing stream
        let testStream = ILHashingInputStream(inputStream:InputStream(data: quickBrownData), hashFunction:.MD5)
        let streamHash = testStream.readToEndAndHash()

        XCTAssertEqual(streamHash!.hexString, md5QuickHash, "")
    }

    func testSHA1ILHashingInputStream() throws {
        // create a stream with some test data in it and then create the hashing stream
        let testStream = ILHashingInputStream(inputStream:InputStream(data: quickBrownData), hashFunction:.SHA1)
        let streamHash = testStream.readToEndAndHash()

        XCTAssertEqual(streamHash!.hexString, sha1QuickHash, "")
    }

    func testSHA2_224ILHashingInputStream() throws {
        // create a stream with some test data in it and then create the hashing stream
        let testStream = ILHashingInputStream(inputStream:InputStream(data: quickBrownData), hashFunction:.SHA2_224)
        let streamHash = testStream.readToEndAndHash()

        XCTAssertEqual(streamHash!.hexString, sha2_224QuickHash, "")
    }

    func testSHA2_256ILHashingInputStream() throws {
        // create a stream with some test data in it and then create the hashing stream
        let testStream = ILHashingInputStream(inputStream:InputStream(data: quickBrownData), hashFunction:.SHA2_256)
        let streamHash = testStream.readToEndAndHash()

        XCTAssertEqual(streamHash!.hexString, sha2_256QuickHash, "")
    }

    func testSHA2_384ILHashingInputStream() throws {
        // create a stream with some test data in it and then create the hashing stream
        let testStream = ILHashingInputStream(inputStream:InputStream(data: quickBrownData), hashFunction:.SHA2_384)
        let streamHash = testStream.readToEndAndHash()

        XCTAssertEqual(streamHash!.hexString, sha2_384QuickHash, "")
    }

    func testSHA2_512ILHashingInputStream() throws {
        // create a stream with some test data in it and then create the hashing stream
        let testStream = ILHashingInputStream(inputStream:InputStream(data: quickBrownData), hashFunction:.SHA2_512)
        let streamHash = testStream.readToEndAndHash()

        XCTAssertEqual(streamHash!.hexString, sha2_512QuickHash, "")
    }

    // MARK: - Stacking Hashing Input Streams

    func testHashingInputStreamStack() throws {
        let inputStream = InputStream(data: quickBrownData)
        let md2Stream = ILHashingInputStream(inputStream:inputStream, hashFunction:.MD2)
        let md4Stream = ILHashingInputStream(inputStream:md2Stream, hashFunction:.MD4)
        let md5Stream = ILHashingInputStream(inputStream:md4Stream, hashFunction:.MD5)
        let sha1Stream = ILHashingInputStream(inputStream:md5Stream, hashFunction:.SHA1)
        let sha2_224Stream = ILHashingInputStream(inputStream:sha1Stream, hashFunction:.SHA2_224)
        let sha2_256Stream = ILHashingInputStream(inputStream:sha2_224Stream, hashFunction:.SHA2_256)
        let sha2_384Stream = ILHashingInputStream(inputStream:sha2_256Stream, hashFunction:.SHA2_384)
        let sha2_512Stream = ILHashingInputStream(inputStream:sha2_384Stream, hashFunction:.SHA2_512)

        // read all the streams up the stack to the end
        sha2_512Stream.readToEndAndHash()

        // now validate the hashes
        XCTAssertEqual(md2Stream.streamHash!.hexString, md2QuickHash, "")
        XCTAssertEqual(md4Stream.streamHash!.hexString, md4QuickHash, "")
        XCTAssertEqual(md5Stream.streamHash!.hexString, md5QuickHash, "")
        XCTAssertEqual(sha1Stream.streamHash!.hexString, sha1QuickHash, "")
        XCTAssertEqual(sha2_224Stream.streamHash!.hexString, sha2_224QuickHash, "")
        XCTAssertEqual(sha2_256Stream.streamHash!.hexString, sha2_256QuickHash, "")
        XCTAssertEqual(sha2_384Stream.streamHash!.hexString, sha2_384QuickHash, "")
        XCTAssertEqual(sha2_512Stream.streamHash!.hexString, sha2_512QuickHash, "")
    }

    // MARK: - TODO: Runloop Based ILHashingInputStream Tests

    // MARK: TODO: ILHashingOutputStream Tests

    // MARK: - RFC 2397 data: URL Tests

    // test basic data URL creation
    func testDataURLWithData() throws {
        if let exampleData: Data = "testDataURLWithData()".data(using: .utf8) {
            let testURL: URL = NSURL.dataURL(with: exampleData)
            NSLog("testDataURLWithData: \(testURL)")
            XCTAssertNotNil(testURL, "testURL is not null")
            XCTAssert(!testURL.isFileURL, "testURL is not a file URL")
            XCTAssert(testURL.absoluteString.hasPrefix("data:"), "testURL is a data URL")
            XCTAssert(testURL.absoluteString.contains("base64"), "testURL is a base64 data URL")
        }
        else {
            XCTFail("Failed to create Data from string")
        }
    }

    // test `data:,` URL creation
    func testNullDataURL() throws {
        let testURL: NSURL = NSURL(string: "data:,")!
        let testData: Data? = testURL.urlData
        XCTAssertNil(testData, "testData is null")
    }

    // test `data:,0` single byte URL creation
    func testSingleByteDataURL() throws {
        let testURL: NSURL = NSURL(string: "data:,0")!
        let testData: Data? = testURL.urlData
        XCTAssertNotNil(testData, "testData is not null")
        XCTAssert(testData!.count == 1, "testData is one byte")
        XCTAssert(testData == "0".data(using: String.Encoding.utf8), "testData is \"0\"")
    }

    // data:,Hello%20World
    func testStringDataURL() throws {
        let testURL: NSURL = NSURL(string: "data:,Hello%20World".removingPercentEncoding!)!
        let testData: Data? = testURL.urlData
        XCTAssertNotNil(testData, "testData is not null")
        NSLog("testData: \(testData!)")
        XCTAssert(testData!.count == 11, "testData is 11 bytes")
        XCTAssert(testData!.elementsEqual("Hello World".data(using: String.Encoding.utf8)!), "testData is 'Hello World'")
    }

    // data:;hex,EFBBBF
    func testHexDataURL() throws {
        let testURL: NSURL = NSURL(string: "data:;hex,EFBBBF")!
        let testData: Data? = testURL.urlData
        XCTAssertNotNil(testData, "testData is not null")
        XCTAssert(testData!.count == 3, "testData is 3 bytes")
        XCTAssertEqual(NSString.hexString(with: testData!).uppercased(), "EFBBBF")
    }

    // base64 encoded "1234567890"
    // data:application/octet-stream;base64,MTIzNDU2Nzg5MA==
    func testBase64DataURL() throws {
        let testURL: NSURL = NSURL(string: "data:application/octet-stream;base64,MTIzNDU2Nzg5MA==")!
        let testData: Data? = testURL.urlData
        XCTAssertNotNil(testData, "testData is not null")
        XCTAssert(testData!.count == 10, "testData is 10 bytes")
        XCTAssert(String(data: testData!, encoding: String.Encoding.utf8) == "1234567890", "testData is '1234567890'")
    }

    // data:text/example;foo=bar,
    func testDataURLParameters() throws {
        let testURL: NSURL = NSURL(string: "data:text/example;foo=bar,")!
        var mediaType: NSString?
        var parameters: NSDictionary?
        var encoding: NSString?
        let testData: Data? = testURL.urlData(withMediaType: &mediaType, parameters: &parameters, contentEncoding: &encoding)
        XCTAssertNotNil(mediaType, "mediaType is not nil")
        XCTAssertNotNil(parameters, "parameters is not nil")
        XCTAssertNil(encoding, "encoding is nil")
        XCTAssertNil(testData, "testData is nil")
    }

    // data:text/example;foo=bar;hex,FF
    func testDataURLParametersHex() throws {
        let testURL: NSURL = NSURL(string: "data:text/example;foo=bar;hex,FF")!
        var mediaType: NSString?
        var parameters: NSDictionary?
        var encoding: NSString?
        let testData: Data? = testURL.urlData(withMediaType: &mediaType, parameters: &parameters, contentEncoding: &encoding)
        XCTAssertNotNil(mediaType, "mediaType is not nil")
        XCTAssertNotNil(parameters, "parameters is not nil")
        XCTAssertNotNil(encoding, "encoding is not nil")
        XCTAssertNotNil(testData, "testData is not nil")
        XCTAssert(testData!.count == 1, "testData is 1 byte")
        XCTAssertEqual(NSString.hexString(with: testData!).uppercased(), "FF")
    }

    // data:text/plain;charset=UTF-8;page=21,the%20data:1234,5678 <- UTF-8 encoding
    func testDataURLParametersImplicitEncoding() throws {
        let testURL: NSURL = NSURL(string: "data:text/plain;charset=UTF-8;page=21,the%20data:1234,5678")!
        var mediaType: NSString?
        var parameters: NSDictionary?
        var encoding: NSString?
        let testData: Data? = testURL.urlData(withMediaType: &mediaType, parameters: &parameters, contentEncoding: &encoding)
        XCTAssertNotNil(mediaType, "mediaType is not nil")
        XCTAssertNotNil(parameters, "parameters is not nil")
        XCTAssertEqual(parameters?.count, 2, "parameters has 2 entries")
        XCTAssertEqual(parameters?.object(forKey: "charset") as? String, "UTF-8", "parameters has charset=UTF-8")
        XCTAssertEqual(parameters?.object(forKey: "page") as? String, "21", "parameters has page=21")
        XCTAssertNil(encoding, "encoding is nil")
        XCTAssertEqual(mediaType, "text/plain", "mediaType is 'text/plain'")
        XCTAssertNotNil(testData, "testData is not nil")
        XCTAssert(testData!.elementsEqual("the data:1234,5678".data(using: String.Encoding.utf8)!))
    }

    // MARK: - Data X-Type URL Tests

    func testDataURLWithDate() throws {
        let testDate = Date()
        let dateURL = NSURL.dataURL(with: testDate)
        XCTAssertNotNil(dateURL, "dateURL is not nil")
        XCTAssert(dateURL.absoluteString.hasPrefix("data:"), "dateURL is a data URL")

        let dataDate = NSURL.date(withDataURL: dateURL)!
        XCTAssertNotNil(dataDate, "dataDate is not nil")
        XCTAssert(testDate.timeIntervalSince(dataDate) < 0.001, "dataDate is within 1ms of testDate")
    }

    func testDataURLWithInterval() throws {
        let testDate = Date()
        let testInterval = TimeInterval(12345)
        let intervalURL = NSURL.dataURL(with:testDate, interval:testInterval)
        XCTAssertNotNil(intervalURL, "intervalURL is not nil")
        XCTAssert(intervalURL.absoluteString.hasPrefix("data:"), "intervalURL is a data URL")

        var dataInterval = 0.0
        let dataDate = NSURL.date(withDataURL: intervalURL, interval: &dataInterval)!
        XCTAssertNotNil(dataDate, "dataDate is not nil")
        XCTAssert(testDate.timeIntervalSince(dataDate) < 0.001, "dataDate is within 1ms of testDate")
        XCTAssert((dataInterval - testInterval) < 0.001, "dataInterval is within 1ms of testInterval")
    }

    func testDataURLWithPoint() {
        let testPoint = CGPoint(x: 123.456, y: 789.012)
        let pointURL = NSURL.dataURL(with: testPoint)
        XCTAssertNotNil(pointURL, "pointURL is not nil")
        XCTAssert(pointURL.absoluteString.hasPrefix("data:"), "pointURL is a data URL")

        let dataPoint = NSURL.point(withDataURL: pointURL)
        XCTAssertNotNil(dataPoint, "dataPoint is not nil")
        XCTAssertEqual(dataPoint, testPoint, "dataPoint is equal to testPoint")
    }

    func testDataURLWithSize() {
        let testSize = CGSize(width: 123.456, height: 789.012)
        let sizeURL = NSURL.dataURL(with: testSize)
        XCTAssertNotNil(sizeURL, "sizeURL is not nil")
        XCTAssert(sizeURL.absoluteString.hasPrefix("data:"), "sizeURL is a data URL")

        let dataSize = NSURL.size(withDataURL: sizeURL)
        XCTAssertNotNil(dataSize, "dataSize is not nil")
        XCTAssertEqual(dataSize, testSize, "dataSize is equal to testSize")
    }

    func testDataURLWithRect() {
        let testRect = CGRect(x: 123.456, y: 789.012, width: 345.678, height: 901.234)
        let rectURL = NSURL.dataURL(with: testRect)
        XCTAssertNotNil(rectURL, "rectURL is not nil")
        XCTAssert(rectURL.absoluteString.hasPrefix("data:"), "rectURL is a data URL")

        let dataRect = NSURL.rect(withDataURL: rectURL)
        XCTAssertNotNil(dataRect, "dataRect is not nil")
        XCTAssertEqual(dataRect, testRect, "dataRect is equal to testRect")
    }

    func testDataURLWithRange() {
        let testRange = NSRange(location: 123, length: 456)
        let rangeURL = NSURL.dataURL(with: testRange)
        XCTAssertNotNil(rangeURL, "rangeURL is not nil")
        XCTAssert(rangeURL.absoluteString.hasPrefix("data:"), "rangeURL is a data URL")

        let dataRange = NSURL.range(withDataURL: rangeURL)
        XCTAssertNotNil(dataRange, "dataRange is not nil")
        XCTAssertEqual(dataRange, testRange, "dataRange is equal to testRange")
    }

    func testDataURNWithUUID() {
        let testUUID = UUID()
        let uuidURL = NSURL.urn(with: testUUID)
        XCTAssertNotNil(uuidURL, "uuidURL is not nil")
        XCTAssert(uuidURL.absoluteString.hasPrefix("urn:"), "uuidURL is a URN URL")

        let dataUUID = NSURL.uuid(with: uuidURL)
        XCTAssertNotNil(dataUUID, "dataUUID is not nil")
        XCTAssertEqual(dataUUID, testUUID, "dataUUID is equal to testUUID")
    }

    /* func testDataURLWithMeasure() {
        let testMeasure = Measurement(value: 123.456, unit: UnitLength.meters)
        let measureURL = NSURL.dataURL(with: testMeasure)
        XCTAssertNotNil(measureURL, "measureURL is not nil")
        XCTAssert(measureURL.absoluteString.hasPrefix("data:"), "measureURL is a data URL")

        let dataMeasure = NSURL.measurement(withDataURL: measureURL)
        XCTAssertNotNil(dataMeasure, "dataMeasure is not nil")
        XCTAssertEqual(dataMeasure, testMeasure, "dataMeasure is equal to testMeasure")
    } */

    // MARK: - UTF Auto-detection Tests

    func testUTF8EncodingDetection() throws {
        let utf8Data: Data = "UTF-8".data(using: String.Encoding.utf8)!
        let encoding: UInt = NSString.utfEncoding(of: utf8Data)
        XCTAssertEqual(encoding, String.Encoding.utf8.rawValue, "utf8Data is UTF-8")
    }

    func testUTF8Decode() throws {
        let utf8Data: Data = "UTF-8".data(using: String.Encoding.utf8)!
        let decoded = NSString(data: utf8Data, encoding: String.Encoding.utf8.rawValue)
        XCTAssertNotNil(decoded, "utf8Data decoded is not nil")
        XCTAssert(decoded == "UTF-8", "decoded is 'UTF-8'")
    }

    func testUTF8ByteOrder() throws {
        let utf8BOMData: Data = NSString(string: "UTF-8").data(withByteOrderUTFEncoding: String.Encoding.utf8.rawValue)
        XCTAssertNotNil(utf8BOMData, "utf8BOMData is not nil")
        let _: NSData = NSURL(string: ILUTF8BOMMagic)!.urlData! as NSData
        // XCTAssert(utf8BOMData, "utf8BOMData has BOM")
    }

    func testUTF16EncodingDetection() throws {
        let utf16Data: Data = "UTF-16".data(using: String.Encoding.utf16)!
        let encoding: UInt = NSString.utfEncoding(of: utf16Data)
        XCTAssertEqual(encoding, String.Encoding.utf16LittleEndian.rawValue, "utf16Data is UTF-16LE")

        let decoded = NSString(data: utf16Data, encoding: String.Encoding.utf16LittleEndian.rawValue)
        XCTAssertNotNil(decoded, "utf16Data decoded is not nil")
    }

    func testUTF16BEDetection() throws {
        let utf16BEData: Data = NSString(string: "UTF-16BE").data(withByteOrderUTFEncoding: String.Encoding.utf16BigEndian.rawValue)
        let encoding: UInt = NSString.utfEncoding(of: utf16BEData)
        XCTAssertEqual(encoding, String.Encoding.utf16BigEndian.rawValue, "utf16BEData is UTF-16BE")

        let decoded = NSString(data: utf16BEData, encoding: String.Encoding.utf16BigEndian.rawValue)
        XCTAssertNotNil(decoded, "utf16BEData decoded is not nil")
        // XCTAssert(decoded == "UTF-16BE", "decoded is 'UTF-16BE'")
    }

    func testUTF16LEDetection() throws {
        let utf16LEData: Data = NSString(string: "UTF-16LE").data(withByteOrderUTFEncoding:String.Encoding.utf16LittleEndian.rawValue)
        let encoding: UInt = NSString.utfEncoding(of: utf16LEData)
        XCTAssertEqual(encoding, String.Encoding.utf16LittleEndian.rawValue, "utf16LEData is UTF-16LE")

        let decoded = NSString(data: utf16LEData, encoding: String.Encoding.utf16LittleEndian.rawValue)
        XCTAssertNotNil(decoded, "utf16LEData decoded is not nil")
        // XCTAssert((decoded! as String).compare("UTF-16LE") == ComparisonResult.orderedSame, "utf16LEData is 'UTF-16LE'")
    }

    func testUTF32EncodingDetection() throws {
        let utf32Data: Data = "UTF-32".data(using: String.Encoding.utf32)!
        let encoding: UInt = NSString.utfEncoding(of: utf32Data)
        XCTAssertEqual(encoding, String.Encoding.utf16LittleEndian.rawValue, "utf32Data is UTF-16LE?!")

        let decoded = NSString(data: utf32Data, encoding: String.Encoding.utf32LittleEndian.rawValue)
        XCTAssertNotNil(decoded, "utf32Data decoded is not nil")
    }

    func testUTF32BEDetection() throws {
        let utf32BEData: Data = NSString(string:"UTF-32BE").data(withByteOrderUTFEncoding: String.Encoding.utf32BigEndian.rawValue)
        let encoding: UInt = NSString.utfEncoding(of: utf32BEData)
        XCTAssertEqual(encoding, String.Encoding.utf32BigEndian.rawValue, "utf32BEData is UTF-32BE")

        let decoded = NSString(data: utf32BEData, encoding: String.Encoding.utf32BigEndian.rawValue)
        XCTAssertNotNil(decoded, "utf16LEData is 'UTF-32BE'")
    }

    func testUTF32LEDetection() throws {
        let utf32LEData: Data = NSString(string:"UTF-32LE").data(withByteOrderUTFEncoding: String.Encoding.utf32LittleEndian.rawValue)
        let encoding: UInt = NSString.utfEncoding(of: utf32LEData)
        XCTAssertEqual(encoding, String.Encoding.utf16LittleEndian.rawValue, "utf32LEData is UTF-32LE")

        let decoded = NSString(data: utf32LEData, encoding: String.Encoding.utf32LittleEndian.rawValue)
        XCTAssertNotNil(decoded, "utf32LEData decoded is not nil")
    }

    func testUTFAutoDetectInit() throws {

    }

    // MARK: - UTF8 Error Detection and Correction

    func testUTF8ErrorDetection() throws {
        let encodingErrors: NSString = "Ã„ Ã¤ Ã– Ã¶ Ãœ Ã¼ ÃŸ"
        XCTAssert(encodingErrors.containsUTF8Errors(), "encodingErrors contains errors")
    }

    func testUTF8ErrorCorrection() throws {
        let encodingErrors: NSString = "Ã„ Ã¤ Ã– Ã¶ Ãœ Ã¼ ÃŸ"
        let cleanedString: NSString = (encodingErrors as NSString).cleaningUTF8Errors() as NSString
        XCTAssert(!cleanedString.containsUTF8Errors(), "cleanedString has no errors")
    }

    // MARK: -

    func testLinesWithMaxLength() throws {
        let maxLen: UInt = 5
        let lines = NSString(string:"1234567890123456789012345678901234567").lines(withMaxLen: maxLen)
        NSLog("lines: \(lines)")
        XCTAssertNotNil(lines, "lines is not nil")
        for line in lines {
            XCTAssert(line.count <= maxLen, "line length < 20")
            XCTAssert(line.count != 0, "line not empty")
        }
    }

    /*
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        measure {
            // Put the code you want to measure the time of here.
        }
    }
    */
}
