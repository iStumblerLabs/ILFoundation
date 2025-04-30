#import "NSURL+ILFoundation.h"
#import "NSString+ILFoundation.h"

NSString* const ILDataURLScheme = @"data";
NSString* const ILDataURLUTF8Encoding = @"utf8";
NSString* const ILDataURLHexEncoding = @"hex";
NSString* const ILDataURLBase64Encoding = @"base64";

@implementation NSURL (ILFoundation)

+ (NSURL*) dataURLWithData:(NSData*) data {
    NSString* encodedData = [data base64EncodedStringWithOptions:0];
    NSString* dataURL = [[ILDataURLScheme stringByAppendingString:@":;base64,"] stringByAppendingString:encodedData];
    return [NSURL URLWithString:dataURL];
}

+ (NSURL*) dataURLWithData:(NSData*) data
                 mediaType:(NSString*) mediaType
                parameters:(NSDictionary<NSString*,NSString*>*) parameters
           contentEncoding:(NSString*) contentEncoding {
    NSString* dataURL = [ILDataURLScheme stringByAppendingString:@":"];

    if (mediaType) {
        dataURL = [dataURL stringByAppendingFormat:@"%@;", mediaType];
        if (parameters) {
            for (NSString* key in parameters.allKeys) {
                dataURL = [dataURL stringByAppendingFormat:@"%@=%@;", key, parameters[key]];
            }
        }
    }
    // TODO: else if paramaters are present, but no mediaType, report a media type error

    // Encode the data as directed by the contentEncoding
    if ([ILDataURLHexEncoding isEqualToString:contentEncoding]) {
        dataURL = [dataURL stringByAppendingFormat:@"%@,%@", contentEncoding, [NSString hexStringWithData:data]];
    }
    else if ([ILDataURLBase64Encoding isEqualToString:contentEncoding]) {
        dataURL = [dataURL stringByAppendingFormat:@"%@,%@", contentEncoding, [data base64EncodedStringWithOptions:0]];
    }
    else if ([ILDataURLUTF8Encoding isEqualToString:contentEncoding]) {
        dataURL = [dataURL stringByAppendingFormat:@"%@,%@", contentEncoding, [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding]];
    }
    else { // Assume UTF8
        dataURL = [dataURL stringByAppendingFormat:@",%@", [NSString.alloc initWithData:data encoding:NSUTF8StringEncoding]];
    }

    return [NSURL URLWithString:dataURL];
}

// MARK: - Data X-Type URLs

+ (NSURL*) dataURLWithDate:(NSDate*) date {
    return [NSURL URLWithString:[NSString stringWithFormat:@"data:x-type/epoch-seconds,%f", date.timeIntervalSince1970]];
}

+ (nullable NSDate*) dateWithDataURL:(NSURL*) url {
    NSDate* date = nil;
    if ([url.scheme isEqualToString:ILDataURLScheme]) {
        NSScanner* URIscanner = [NSScanner scannerWithString:url.absoluteString];
        NSString* contentEncoding = nil;
        // scan up to scheme separator
        [URIscanner scanUpToString:@":" intoString:nil];
        [URIscanner scanString:@":" intoString:nil];
        // scan up to data separator
        [URIscanner scanUpToString:@"," intoString:&contentEncoding];
        [URIscanner scanString:@"," intoString:nil];

        if ([contentEncoding isEqualToString:@"x-type/epoch-seconds"]) {
            // read date as floating point value
            double dateValue = 0;
            [URIscanner scanDouble:&dateValue];

            date = [NSDate dateWithTimeIntervalSince1970:dateValue];
        }
    }

    return date;
}

+ (NSURL*) dataURLWithDate:(NSDate*) date interval:(NSTimeInterval) interval {
    return [NSURL URLWithString:[NSString stringWithFormat:@"data:x-type/epoch-interval,%f,%f", date.timeIntervalSince1970, interval]];
}

+ (nullable NSDate*) dateWithDataURL:(NSURL*) url interval:(NSTimeInterval*) interval {
    NSDate* date = nil;

    if ([url.scheme isEqualToString:ILDataURLScheme]) {
        NSScanner* URIscanner = [NSScanner scannerWithString:url.absoluteString];
        NSString* contentEncoding = nil;
        // scan up to scheme separator
        [URIscanner scanUpToString:@":" intoString:nil];
        [URIscanner scanString:@":" intoString:nil];
        // scan up to data separator
        [URIscanner scanUpToString:@"," intoString:&contentEncoding];
        [URIscanner scanString:@"," intoString:nil];

        if ([contentEncoding isEqualToString:@"x-type/epoch-interval"]) {
            // read date as floating point value
            double dateValue = 0;
            [URIscanner scanDouble:&dateValue];
            [URIscanner scanString:@"," intoString:nil];
            date = [NSDate dateWithTimeIntervalSince1970:dateValue];

            // read interval as floating point value
            [URIscanner scanDouble:interval];
        }
    }

    return date;
}

// MARK: -

+ (NSURL*) dataURLWithPoint:(CGPoint) point {
    return [NSURL URLWithString:[NSString stringWithFormat:@"data:x-type/point,%f,%f", point.x, point.y]];
}

/// @returns the `CGPoint` from an RFC 2397 `data:`
/// @param url with an `x-type/point` content type;
/// or `NSZeroPoint`
+ (CGPoint) pointWithDataURL:(NSURL*) url {
    CGPoint point = CGPointZero;
    if ([url.scheme isEqualToString:ILDataURLScheme]) {
        NSScanner* URIscanner = [NSScanner scannerWithString:url.absoluteString];
        NSString* contentEncoding = nil;
        // scan up to scheme separator
        [URIscanner scanUpToString:@":" intoString:nil];
        [URIscanner scanString:@":" intoString:nil];
        // scan up to data separator
        [URIscanner scanUpToString:@"," intoString:&contentEncoding];
        [URIscanner scanString:@"," intoString:nil];
        // read point as floating point value
        double x = 0;
        double y = 0;
        [URIscanner scanDouble:&x];
        [URIscanner scanString:@"," intoString:nil];
        [URIscanner scanDouble:&y];
        point = CGPointMake(x, y);
    }

    return point;
}

+ (NSURL*) dataURLWithSize:(CGSize) size {
    return [NSURL URLWithString:[NSString stringWithFormat:@"data:x-type/size,%f,%f", size.width, size.height]];
}

+ (CGSize) sizeWithDataURL:(NSURL*) url {
    CGSize size = CGSizeZero;
    if ([url.scheme isEqualToString:ILDataURLScheme]) {
        NSScanner* URIscanner = [NSScanner scannerWithString:url.absoluteString];
        NSString* contentEncoding = nil;
        // scan up to scheme separator
        [URIscanner scanUpToString:@":" intoString:nil];
        [URIscanner scanString:@":" intoString:nil];
        // scan up to data separator
        [URIscanner scanUpToString:@"," intoString:&contentEncoding];
        [URIscanner scanString:@"," intoString:nil];
        // read size as floating point value
        double width = 0;
        double height = 0;
        [URIscanner scanDouble:&width];
        [URIscanner scanString:@"," intoString:nil];
        [URIscanner scanDouble:&height];
        size = CGSizeMake(width, height);
    }

    return size;
}

+ (NSURL*) dataURLWithRect:(CGRect) rect {
    return [NSURL URLWithString:[NSString stringWithFormat:@"data:x-type/rect,%f,%f,%f,%f", rect.origin.x, rect.origin.y, rect.size.width, rect.size.height]];
}

+ (CGRect) rectWithDataURL:(NSURL*) url {
    CGRect rect = CGRectZero;
    if ([url.scheme isEqualToString:ILDataURLScheme]) {
        NSScanner* URIscanner = [NSScanner scannerWithString:url.absoluteString];
        NSString* contentEncoding = nil;
        // scan up to scheme separator
        [URIscanner scanUpToString:@":" intoString:nil];
        [URIscanner scanString:@":" intoString:nil];
        // scan up to data separator
        [URIscanner scanUpToString:@"," intoString:&contentEncoding];
        [URIscanner scanString:@"," intoString:nil];
        // read rect as floating point value
        double x = 0;
        double y = 0;
        double width = 0;
        double height = 0;
        [URIscanner scanDouble:&x];
        [URIscanner scanString:@"," intoString:nil];
        [URIscanner scanDouble:&y];
        [URIscanner scanString:@"," intoString:nil];
        [URIscanner scanDouble:&width];
        [URIscanner scanString:@"," intoString:nil];
        [URIscanner scanDouble:&height];
        rect = CGRectMake(x, y, width, height);
    }

    return rect;
}

+ (NSURL*) dataURLWithRange:(NSRange) range {
    return [NSURL URLWithString:[NSString stringWithFormat:@"data:x-type/range,%lu,%lu", (unsigned long)range.location, (unsigned long)range.length]];
}

+ (NSRange) rangeWithDataURL:(NSURL*) url {
    NSRange range = NSMakeRange(0, 0);
    if ([url.scheme isEqualToString:ILDataURLScheme]) {
        NSScanner* URIscanner = [NSScanner scannerWithString:url.absoluteString];
        NSString* contentEncoding = nil;
        // scan up to scheme separator
        [URIscanner scanUpToString:@":" intoString:nil];
        [URIscanner scanString:@":" intoString:nil];
        // scan up to data separator
        [URIscanner scanUpToString:@"," intoString:&contentEncoding];
        [URIscanner scanString:@"," intoString:nil];

        if ([contentEncoding isEqualToString:@"x-type/range"]) {
            // read range as integer value
            NSUInteger location = 0;
            NSUInteger length = 0;
            [URIscanner scanInteger:(NSInteger*)&location];
            [URIscanner scanString:@"," intoString:nil];
            [URIscanner scanInteger:(NSInteger*)&length];
            range = NSMakeRange(location, length);
        }
    }

    return range;
}

+ (NSURL*) dataURLWithVector:(CGVector)vector {
    return [NSURL URLWithString:[NSString stringWithFormat:@"data:x-type/vector,%f,%f", vector.dx, vector.dy]];
}

+ (CGVector) vectorWithDataURL:(NSURL *)url {
    CGVector vector = CGVectorMake(0, 0);
    if ([url.scheme isEqualToString:ILDataURLScheme]) {
        NSScanner* URIscanner = [NSScanner scannerWithString:url.absoluteString];
        NSString* contentEncoding = nil;
        // scan up to scheme separator
        [URIscanner scanUpToString:@":" intoString:nil];
        [URIscanner scanString:@":" intoString:nil];
        // scan up to data separator
        [URIscanner scanUpToString:@"," intoString:&contentEncoding];
        [URIscanner scanString:@"," intoString:nil];

        if ([contentEncoding isEqualToString:@"x-type/vector"]) {
            // read vector as floating point value
            double dx = 0;
            double dy = 0;
            [URIscanner scanDouble:&dx];
            [URIscanner scanString:@"," intoString:nil];
            [URIscanner scanDouble:&dy];
            vector = CGVectorMake(dx, dy);
        }
    }

    return vector;
}

// MARK: -

/// @returns an RFC 2397 `data:` URL with the provided
/// @param measure as an `x-type/measure` two tupe with the value and unit values
/// e.g. `data:x-type/measure,100,cm`
+ (NSURL*) dataURLWithMeasurement:(NSMeasurement*) measure {
    return [NSURL URLWithString:[NSString stringWithFormat:@"data:x-type/measure,%f,%@", measure.doubleValue, measure.unit.symbol]];
}

/// @returns an `NSMeasurement` from an RFC 2397 `data:`
/// @param url with an `x-type/measure` content type;
/// or nil
+ (nullable NSMeasurement*) measurementWithDataURL:(NSURL*) url {
    NSMeasurement* measure = nil;
    if ([url.scheme isEqualToString:ILDataURLScheme]) {
        NSScanner* URIscanner = [NSScanner scannerWithString:url.absoluteString];
        NSString* contentEncoding = nil;
        // scan up to scheme separator
        [URIscanner scanUpToString:@":" intoString:nil];
        [URIscanner scanString:@":" intoString:nil];
        // scan up to data separator
        [URIscanner scanUpToString:@"," intoString:&contentEncoding];
        [URIscanner scanString:@"," intoString:nil];

        if ([contentEncoding isEqualToString:@"x-type/measure"]) {
            // read measure as floating point value
            double value = 0;
            NSString* unit = nil;
            [URIscanner scanDouble:&value];
            [URIscanner scanString:@"," intoString:nil];
            [URIscanner scanUpToString:@"" intoString:&unit];
            measure = [NSMeasurement.alloc initWithDoubleValue:value unit:[NSUnit.alloc initWithSymbol:unit]];
        }
    }

    return measure;
}

+ (NSURL*) dataURLWithRegex:(NSRegularExpression*) regex {
    return [NSURL URLWithString:[NSString stringWithFormat:@"data:x-type/regex,%@", regex.pattern]];
}

+ (nullable NSRegularExpression*) regexWithDataURL:(NSURL*) url {
    NSRegularExpression* regex = nil;

    if ([url.scheme isEqualToString:ILDataURLScheme]) {
        NSScanner* URIscanner = [NSScanner scannerWithString:url.absoluteString];
        NSString* contentEncoding = nil;
        // scan up to scheme separator
        [URIscanner scanUpToString:@":" intoString:nil];
        [URIscanner scanString:@":" intoString:nil];
        // scan up to data separator
        [URIscanner scanUpToString:@"," intoString:&contentEncoding];
        [URIscanner scanString:@"," intoString:nil];

        if ([contentEncoding isEqualToString:@"x-type/regex"]) {
            // read regex as string value
            NSString* pattern = nil;
            [URIscanner scanUpToString:@"" intoString:&pattern];
            regex = [NSRegularExpression regularExpressionWithPattern:pattern options:0 error:nil];
        }
    }

    return regex;
}

// MARK: - URNs

+ (NSURL*) URNWithUUID:(NSUUID*) uuid {
    return [NSURL URLWithString:[NSString stringWithFormat:@"urn:uuid:%@", uuid.UUIDString]];
}

+ (nullable NSUUID*) UUIDWithURL:(NSURL*) uuidURN {
    NSUUID* uuid = nil;

    NSArray* urnComponents = [uuidURN.absoluteString componentsSeparatedByString:@":"];
    if (urnComponents.count == 3
    && [urnComponents[0] isEqualToString:@"urn"]
    && [urnComponents[1] isEqualToString:@"uuid"]) {
        uuid = [NSUUID.alloc initWithUUIDString:urnComponents[2]];
    }

    return uuid;
}

// MARK: - UTType Data URLs

+ (NSURL*) URLWithUTTypeData:(NSData*)UTTypeData {
    NSURL* dataURL = nil;
#if OSX
    dataURL = [NSURL URLWithDataRepresentation:UTTypeData relativeToURL:nil];
#elif TARGET_OS_IOS
    NSPropertyListFormat plistFormat;
    NSError* plistError = nil;
    id plist = [NSPropertyListSerialization propertyListWithData:UTTypeData
                                                         options:NSPropertyListImmutable
                                                          format:&plistFormat
                                                           error:&plistError];
    if ([plist isKindOfClass:NSArray.class]) {
        dataURL = [NSURL URLWithString:[plist firstObject]];
    }
    else if ([plist isKindOfClass:NSString.class]) {
        dataURL = [NSURL URLWithString:plist];
    }
#endif
    return dataURL;
}

// MARK: -

- (instancetype) initWithUTTypeData:(NSData*)UTTypeData {
    return [self initWithString:[NSURL URLWithUTTypeData:UTTypeData].absoluteString];
}

- (NSData*) URLData {
    return [self URLDataWithMediaType:nil parameters:nil contentEncoding:nil];
}

- (NSData*) URLDataWithMediaType:(NSString**) returnMediaType
                      parameters:(NSDictionary<NSString*, NSString*>**) returnParameters
                 contentEncoding:(NSString**) returnEncoding { // TODO: add error parameter
    NSData* decoded = nil;
    if ([self.scheme isEqualToString:ILDataURLScheme]) { // it's a data URL!
        NSScanner* URIscanner = [NSScanner scannerWithString:self.absoluteString];
        NSString* mediaType = @"";
        NSMutableDictionary<NSString*, NSString*>* parameters = NSMutableDictionary.new;
        NSString* contentEncoding = nil;
        NSString* encoding = nil;
        NSString* dataString = nil;
        // scan up to scheme separator
        [URIscanner scanUpToString:@":" intoString:nil];
        [URIscanner scanString:@":" intoString:nil];
        // scan up to data separator
        [URIscanner scanUpToString:@"," intoString:&contentEncoding];
        [URIscanner scanString:@"," intoString:nil];
        // split encoding
        NSArray<NSString*>* encodingParts = [contentEncoding componentsSeparatedByString:@";"];
        for (NSString* part in encodingParts) {
            if ([@[ILDataURLUTF8Encoding, ILDataURLHexEncoding, ILDataURLBase64Encoding] containsObject:part]) {
                encoding = part;
            }
            else if ([part rangeOfString:@"/"].location != NSNotFound) { // it's a mediatype
                mediaType = part;
            }
            else if ([part rangeOfString:@"="].location != NSNotFound) { // it's a parameter
                NSArray<NSString*>* parameterParts = [part componentsSeparatedByString:@"="];
                parameters[parameterParts.firstObject] = parameterParts.lastObject;
            }
            // TODO: else report a media type decode error
        }

        [URIscanner scanUpToString:@"" intoString:&dataString];

        if (dataString) {
            dataString = dataString.stringByRemovingPercentEncoding; // remove any URL encoding in the data string

            if ([encoding isEqualToString:ILDataURLUTF8Encoding]) {
                // decode utf8
                decoded = [dataString dataUsingEncoding:NSUTF8StringEncoding];
            }
            else if ([encoding isEqualToString:ILDataURLHexEncoding]) {
                // decode hex
                NSMutableData* buffer = NSMutableData.new;
                NSUInteger scanIndex = 0;
                unsigned int byte = 0;
                while (scanIndex < dataString.length) {
                    [[NSScanner scannerWithString:[dataString substringWithRange:NSMakeRange(scanIndex, 2)]] scanHexInt:&byte];
                    [buffer appendBytes:&byte length:1];
                    scanIndex += 2;
                }
                decoded = buffer;
            }
            else if ([encoding isEqualToString:ILDataURLBase64Encoding]) {
                // decode base64
                decoded = [NSData.alloc initWithBase64EncodedString:dataString options:0];
                // TODO: if decoded is nil, report a decoding error
            }
            else if (dataString) {
                // assume utf8
                decoded = [dataString dataUsingEncoding:NSUTF8StringEncoding];
            }
        }

        if (returnMediaType) { *returnMediaType = mediaType; }
        if (returnParameters) { *returnParameters = parameters; }
        if (returnEncoding) { *returnEncoding = encoding; }
    }

    return decoded;
}

@end
