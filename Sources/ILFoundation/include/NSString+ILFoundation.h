#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: UTF Magic Numbers

/// these are exposed so that the tests can use them

/// @const UTF-8 Byte Order Mark Magic: EF BB BF
extern NSString* const ILUTF8BOMMagic;

/// @const UTF-16 Big Endian Magic: FE FF
extern NSString* const ILUTF16BEMagic;

/// @const UTF-16 Little Endian Magic: FF FE
extern NSString* const ILUTF16LEMagic;

/// @const UTF-32 Big Endian Magic: 00 00 FE FF
extern NSString* const ILUTF32BEMagic;

/// @const UTF-32 Little Endian Magic: FF FE 00 00
extern NSString* const ILUTF32LEMagic;

// MARK: -

@interface NSString (ILFoundation)

/// @returns the NSStringEncoding based on the magic number of the
/// @param data provided or NSStringEncodingUn
+ (NSStringEncoding) UTFEncodingOfData:(NSData*) data;

/// @returns a string from any type of UTF data by auto-detecting the encoding of the
/// @param data provided
+ (NSString*) stringWithUTFData:(NSData*) data;

/// @returns a hexadecimal string representation of the
/// @param data provided
+ (NSString*) hexStringWithData:(NSData*) data;

// MARK: -

/// @returns a new string by auto-detecting the UTF encoding in the
/// @param data provided,
- (instancetype) initWithUTFData:(NSData*) data;

/// @returns a hexstring with the
/// @param data provided
- (instancetype) initHexStringWithData:(NSData*) data;

// MARK: - UTF8 Error Detection & Correction

/// @returns YES if any errors are detected in the String
- (BOOL) containsUTF8Errors;

/// @returns a new string with any UTF8 errors removed
- (NSString*) stringByCleaningUTF8Errors;

// MARK: -

/// @returns a new data object with the
/// @param UTFEncoding specified including the BOM
- (NSData*) dataWithByteOrderUTFEncoding:(NSStringEncoding)UTFEncoding;

/// @returns an array of substrings with a
/// @param maximum length
- (NSArray<NSString*>*) linesWithMaxLen:(NSUInteger) maximum;

@end

NS_ASSUME_NONNULL_END
