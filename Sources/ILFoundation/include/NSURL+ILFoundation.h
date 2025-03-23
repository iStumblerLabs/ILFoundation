#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// MARK: Data URI Constants

/// @const `data:` URL scheme
extern NSString* const ILDataURLScheme;

/// @const utf8 encoding
extern NSString* const ILDataURLUTF8Encoding;

/// @const hex encoding
extern NSString* const ILDataURLHexEncoding;

/// @const base64 encoding
extern NSString* const ILDataURLBase64Encoding;

// MARK: -

///
/// @ref https://datatracker.ietf.org/doc/html/rfc2397
///
@interface NSURL (ILFoundation)

/// @returns an RFC 2397 `data:` URL with the data provided
/// @param data the data to encode as a base64 `data:` URL
///
+ (NSURL*) dataURLWithData:(NSData*) data;

/// @returns an RFC 2397 `data:` URL with the provided
/// @param data to encode and the
/// @param mediaType of the data and the
/// @param parameters of the media type, and specifying the
/// @param contentEncoding for the URL
///
+ (NSURL*) dataURLWithData:(NSData*) data
                 mediaType:(nullable NSString*) mediaType
                parameters:(nullable NSDictionary<NSString*,NSString*>*) parameters
           contentEncoding:(nullable NSString*) contentEncoding;

// MARK: - Data X-Type URLs

/// @returns an RFC 2397 `data:` URL with the
/// @param date provided as `x-type/epoch-seconds` as a floating point value
/// e.g. `data:x-type/epoch-seconds,0`
+ (NSURL*) dataURLWithDate:(NSDate*) date;

/// @returns an `NSDate*` from an RFC 2397 `data:`
/// @param url with an `x-type/epoch-seconds` or `x-type/epoch-interval` content type;
/// or nil
+ (nullable NSDate*) dateWithDataURL:(NSURL*) url;

/// @returns an RFC 2397 `data:` URL with the provided
/// @param date as `x-type/epoch-interval` first value and the
/// @param interval as the second value
/// e.g. `data:x-type/epoch-interval,0,60`
+ (NSURL*) dataURLWithDate:(NSDate*) date interval:(NSTimeInterval) interval;

/// @returns the `NSTimeInterval` from an RFC 2397 `data:`
/// @param url provided it has an `x-type/epoch-interval` content type
+ (nullable NSDate*) dateWithDataURL:(NSURL*) url interval:(NSTimeInterval*) interval;

/// @returns an RFC 2397 `data:` URL with the provided
/// @param point as an `x-type/point` two tupe with the x and y values
/// e.g. `data:x-type/point,0,0`
+ (NSURL*) dataURLWithPoint:(CGPoint) point;

/// @returns the `CGPoint` from an RFC 2397 `data:`
/// @param url with an `x-type/point` content type;
/// or {0,0}
+ (NSPoint) pointWithDataURL:(NSURL*) url;

/// @returns an RFC 2397 `data:` URL with the provided
/// @param size as an `x-type/size` two tupe with the height and width values
/// e.g. `data:x-type/size,100,100`
+ (NSURL*) dataURLWithSize:(CGSize) size;

/// @returns an `CGSize` from an RFC 2397 `data:`
/// @param url with an `x-type/size` content type;
/// or {0,0}
+ (CGSize) sizeWithDataURL:(NSURL*) url;

/// @returns an RFC 2397 `data:` URL with the provided
/// @param rect as an `x-type/rect` four tupe with the x, y, height, and width value
/// e.g. `data:x-type/rect,0,0,100,100`
+ (NSURL*) dataURLWithRect:(CGRect) rect;

/// @returns an `CGRect` from an RFC 2397 `data:`
/// @param url with an `x-type/rect` content type;
/// or {0,0,0,0}
+ (CGRect) rectWithDataURL:(NSURL*) url;

/// @returns an RFC 2397 `data:` URL with the provided
/// @param range as an `x-type/range` two tupe with the location and length values
/// e.g. `data:x-type/range,0,100`
+ (NSURL*) dataURLWithRange:(NSRange) range;

/// @returns an `NSRange` from an RFC 2397 `data:`
/// @param url with an `x-type/range` content type;
/// or {0,0}
+ (NSRange) rangeWithDataURL:(NSURL*) url;

/// @returns an RFC 2397 `data:` URL with the provided
/// @param vector as an `x-type/vector` two tupe with the dx and dy values
/// e.g. `data:x-type/vector,1,1`
+ (NSURL*) dataURLWithVector:(CGVector) vector;

/// @returns an `CGVector` from an RFC 2397 `data:`
/// @param url with an `x-type/vector` content type;
/// or {0,0}
+ (CGVector) vectorWithDataURL:(NSURL*) url;

// MARK: -

/// @returns an RFC 2397 `data:` URL with the provided
/// @param measure as an `x-type/measure` two tupe with the value and unit values
/// e.g. `data:x-type/measure,100,cm`
+ (NSURL*) dataURLWithMeasurement:(NSMeasurement*) measure;

/// @returns an `NSMeasurement` from an RFC 2397 `data:`
/// @param url with an `x-type/measure` content type;
/// or nil
+ (nullable NSMeasurement*) measurementWithDataURL:(NSURL*) url;

/// @returns an RFC 2397 `data:` URL with the provided
/// @param regex as an `x-type/regex` string
/// e.g. `data:x-type/regex,^a.*z$`
+ (NSURL*) dataURLWithRegex:(NSRegularExpression*) regex;

/// @returns an `NSRegularExpression` from an RFC 2397 `data:`
/// @param url with an `x-type/regex` content type;
/// or nil
+ (nullable NSRegularExpression*) regexWithDataURL:(NSURL*) url;

// Saved Searches
// TODO: +(NSURL*) dataURLWithPredicate:(NSPredicate*) pressure;
// TODO: +(NSPredicate*) predicateWithDataURL:(NSURL*) url;

// Saved Sort State
// TODO: +(NSURL*) dataURLWithSort:(NSSortDescriptor*) sorted;
// TODO: +(NSSortDescriptor*) sortWithDataURL:(NSURL*) url;

// MARK: - URNs

/// @returns a `urn:uuid:` with the provided
/// @param uuid URN
/// e.g. `urn:uuid:550e8400-e29b-41d4-a716-446655440000`
/// @ref https://www.rfc-editor.org/rfc/rfc9562
+ (NSURL*) URNWithUUID:(NSUUID*) uuid;

/// @returns the `NSUUID` from a `urn:uuid:`
/// @param uuidURN provided
+ (NSUUID*) UUIDWithURL:(NSURL*) uuidURN;

// MARK: - UTType Data URLs

/// @returns an RFC 2397 `data:` URL with the data provided as NS/UIPasteboard data with the UTType `public.url`
/// @param UTTypeData data from a pasteboard with the UTType `public.url`
/// this works around different behaviors in NSPastebaord and UIPasteboard
+ (nullable NSURL*) URLWithUTTypeData:(NSData*)UTTypeData;

// MARK: -

/// attempt to parse the URL as an RFC 2397 `data:` URL and return the data
/// e.g.
/// `data:;hex,EFBBBF`
/// `data:application/octet-stream;base64,RUZCQkJG`
///
@property(readonly, nullable) NSData* URLData;

- (instancetype) initWithUTTypeData:(NSData*)UTTypeData;

/// @returns the data parsed from this URL as an RFC 2397 `data:` URL
/// @param returnMediaType the media type of the data
/// @param returnParameters the parameters of the media type
/// @param returnContentEncoding the content encoding of the data
///
/// In addition to the `base64` encoding specified in RFC 2397, the following encodings are supported:
/// - `hex`: hexadecimal encoding- usefull for embedding short byte sequences as strings
/// - `utf8`: UTF-8 encoding
///
- (nullable NSData*) URLDataWithMediaType:(NSString*_Nullable *_Nullable) returnMediaType
                               parameters:(NSDictionary<NSString*,NSString*>*_Nullable *_Nullable) returnParameters
                          contentEncoding:(NSString*_Nullable *_Nullable) returnContentEncoding;

@end

NS_ASSUME_NONNULL_END
