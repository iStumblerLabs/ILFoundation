#import "NSString+ILFoundation.h"
#import "NSURL+ILFoundation.h"
#import "NSData+ILFoundation.h"

// MARK: UTF Magic Numbers

NSString* const ILUTF8BOMMagic = @"data:;hex,EFBBBF";
NSString* const ILUTF16BEMagic = @"data:;hex,FEFF";
NSString* const ILUTF16LEMagic = @"data:;hex,FFFE";
NSString* const ILUTF32BEMagic = @"data:;hex,0000FEFF";
NSString* const ILUTF32LEMagic = @"data:;hex,FFFE0000";

// MARK: -

@implementation NSString (ILFoundation)

+ (NSData*) magicForUTFEncoding:(NSStringEncoding) utfEncoding {
    static NSData* UTF8BOMMagicData;
    static NSData* UTF16BEMagicData;
    static NSData* UTF16LEMagicData;
    static NSData* UTF32BEMagicData;
    static NSData* UTF32LEMagicData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UTF8BOMMagicData = [NSURL URLWithString:ILUTF8BOMMagic].URLData;
        UTF16BEMagicData = [NSURL URLWithString:ILUTF16BEMagic].URLData;
        UTF16LEMagicData = [NSURL URLWithString:ILUTF16LEMagic].URLData;
        UTF32BEMagicData = [NSURL URLWithString:ILUTF32BEMagic].URLData;
        UTF32LEMagicData = [NSURL URLWithString:ILUTF32LEMagic].URLData;
    });

    NSData* magic = nil;
    switch (utfEncoding) {
        case NSUTF8StringEncoding:
            magic = UTF8BOMMagicData;
            break;
        case NSUTF16StringEncoding:
            magic = UTF16BEMagicData;
            break;
        case NSUTF16BigEndianStringEncoding:
            magic = UTF16BEMagicData;
            break;
        case NSUTF16LittleEndianStringEncoding:
            magic = UTF16LEMagicData;
            break;
        case NSUTF32StringEncoding:
            magic = UTF32BEMagicData;
            break;
        case NSUTF32BigEndianStringEncoding:
            magic = UTF32BEMagicData;
            break;
        case NSUTF32LittleEndianStringEncoding:
            magic = UTF32LEMagicData;
            break;
        default:
            break;
    }

    return magic;
}

+ (NSStringEncoding) UTFEncodingOfData:(NSData*) data {
    NSStringEncoding encoding = 0;
    if ([data rangeOfData:[self magicForUTFEncoding:NSUTF8StringEncoding]
                  options:NSDataSearchAnchored
                    range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF8StringEncoding;
    }
    else if ([data rangeOfData:[self magicForUTFEncoding:NSUTF16BigEndianStringEncoding]
                         options:NSDataSearchAnchored
                           range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF16BigEndianStringEncoding;
    }
    else if ([data rangeOfData:[self magicForUTFEncoding:NSUTF16LittleEndianStringEncoding]
                       options:NSDataSearchAnchored
                         range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF16LittleEndianStringEncoding;
    }
    else if ([data rangeOfData:[self magicForUTFEncoding:NSUTF32BigEndianStringEncoding]
                       options:NSDataSearchAnchored
                         range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF32BigEndianStringEncoding;
    }
    else if ([data rangeOfData:[self magicForUTFEncoding:NSUTF32LittleEndianStringEncoding]
                       options:NSDataSearchAnchored
                         range:NSMakeRange(0, data.length)].location == 0) {
        encoding = NSUTF32LittleEndianStringEncoding;
    }
    else { // assume UTF8
        encoding = NSUTF8StringEncoding;
    }

    return encoding;
}

+ (NSStringEncoding) stringEncodingOfData:(NSData*) data convertedString:(NSString*_Nullable*) string {
    static NSDictionary* options;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        options = @{
            NSStringEncodingDetectionAllowLossyKey: @(YES)
        };
    });

    NSStringEncoding detectedEncoding = [NSString stringEncodingForData:data encodingOptions:options convertedString:string usedLossyConversion:nil];
    if (detectedEncoding == NSUTF16StringEncoding) { // check endianess
        if ([data rangeOfData:[self magicForUTFEncoding:NSUTF16BigEndianStringEncoding] options:0 range:NSMakeRange(0, data.length)].location == 0) {
            detectedEncoding = NSUTF16BigEndianStringEncoding;
        }
        else if ([data rangeOfData:[self magicForUTFEncoding:NSUTF16LittleEndianStringEncoding] options:0 range:NSMakeRange(0, data.length)].location == 0) {
            detectedEncoding = NSUTF16LittleEndianStringEncoding;
        }
    }
    else if (detectedEncoding == NSUTF32StringEncoding) { // check endianess
        if ([data rangeOfData:[self magicForUTFEncoding:NSUTF32BigEndianStringEncoding] options:0 range:NSMakeRange(0, data.length)].location == 0) {
            detectedEncoding = NSUTF32BigEndianStringEncoding;
        }
        else if ([data rangeOfData:[self magicForUTFEncoding:NSUTF32LittleEndianStringEncoding] options:0 range:NSMakeRange(0, data.length)].location == 0) {
            detectedEncoding = NSUTF32LittleEndianStringEncoding;
        }
    }

    return detectedEncoding;
}

+ (NSString*) stringWithUTFData:(NSData*) data {
    NSStringEncoding encoding = [self UTFEncodingOfData:data];
    return [NSString.alloc initWithData:data encoding:encoding];
}

+ (nullable NSString*) stringWithUTTypeData:(NSData*)UTTypeData {
    NSString* dataString = nil;
    NSPropertyListFormat plistFormat;
    NSError* plistError = nil;
    id plist = [NSPropertyListSerialization propertyListWithData:UTTypeData
                                                         options:NSPropertyListImmutable
                                                          format:&plistFormat
                                                           error:&plistError];
    dataString = [plist[@"$objects"] lastObject]; // little ugly, this is an NSKeyedArciver plist
    
    return dataString;

}

+ (NSString*) hexStringWithData:(NSData*) data {
    NSString* string = nil;
    const unsigned char *dataBuffer = (const unsigned char *)data.bytes;
    if (dataBuffer) {
        NSMutableString* hexString  = [NSMutableString stringWithCapacity:(data.length * 2)];
        for (int i = 0; i < data.length; ++i) {
            [hexString appendFormat:@"%02x", (unsigned int)dataBuffer[i]];
        }

        string = [NSString stringWithString:hexString];
    }

    return string;
}

// MARK: - Initilizers

- (nullable instancetype) initWithData:(NSData*) data {
    NSString* decoded = nil;
    NSStringEncoding encoding = [NSString stringEncodingOfData:data convertedString:&decoded];
    if (decoded) {
        self = [self initWithString:decoded];
    }
    else {
        self = [self initWithString:data.hexString];
    }

    return self;
}

- (nullable instancetype) initWithUTFData:(NSData*) data {
    return [self initWithString:[NSString stringWithUTFData:data]];
}

- (instancetype) initHexStringWithData:(NSData*) data {
    return [self initWithString:[NSString hexStringWithData:data]];
}

// MARK: - UTF8 Error Detection & Correction

// https://athenstean.com/blog/detecing-fixing-encoding-problems-nsstring/

- (BOOL) containsUTF8Errors {
    BOOL containsErrors = NO;

    // check for weird character patterns like: Ã„ Ã¤ Ã– Ã¶ Ãœ Ã¼ ÃŸ
    // We basically check the Basic Latin Unicode page: U+0000 to U+00FF
    for (int index = 0; index < self.length; ++index) {
        unichar const charInput = [self characterAtIndex:index];
        if ((charInput == 0xc2) && (index + 1 < self.length)) {
            // Check for degree character and similar that are UTF8 but have
            // incorrectly been translated as Latin1 (ISO 8859-1) or ASCII.
            unichar const char2Input = [self characterAtIndex:index+1];
            if ((char2Input >= 0xa0) && (char2Input <= 0xbf)) {
                containsErrors = true;
                break;
            }
        }
        if ((charInput == 0xc3) && (index + 1 < self.length)) {
            // Check for german umlauts and french accents that are UTF8 but have incorrectly
            // been translated as Latin1 (ISO 8859-1) or ASCII.
            unichar const char2Input = [self characterAtIndex:index+1];
            if ((char2Input >= 0x80) && (char2Input <= 0xbf)) {
                containsErrors = true;
                break;
            }
        }
    }

    return containsErrors;
}

- (NSString*) stringByCleaningUTF8Errors {
    NSMutableString* result = [NSMutableString stringWithCapacity:self.length];
    NSRange scanRange = NSMakeRange(0, 0);
    NSString * replacementString = nil;
    NSUInteger replacementLength = 0;

    // For efficency reasons, don't use replaceOccurrencesOfString but scan
    // the string ourselves. Each time a problematic character pattern is found,
    // copy over all characters we have scanned over and then add the replacement.
    for (int index = 0; index < self.length; ++index) {
        unichar const charInput = [self characterAtIndex:index];

        if ((charInput == 0xc2) && (index + 1 < self.length)) {
            unichar const char2Input = [self characterAtIndex:index + 1];
            if ((char2Input >= 0xa0) && (char2Input <= 0xbf)) {
                unichar charFixed = char2Input;
                replacementString = [NSString stringWithFormat:@"%C", charFixed];
                replacementLength = 2;
            }
        }

        if (( charInput == 0xc3) && (index + 1 < self.length)) {
            // Check for german umlauts and french accents that are UTF8 but have
            // incorrectly been translated as Latin1 (ISO 8859-1) or ASCII.
            unichar const char2Input = [self characterAtIndex:index+1];

            if ((char2Input >= 0x80) && (char2Input <= 0xbf)) {
                unichar charFixed = 0x40 + char2Input;
                replacementString = [NSString stringWithFormat:@"%C", charFixed];
                replacementLength = 2;
            }
        }
        else if ((charInput == 0xef) && (index + 2 < self.length)) {
            // Check for Unicode byte order mark, see:
            // http://en.wikipedia.org/wiki/Byte_order_mark
            unichar const char2Input = [self characterAtIndex:index+1];
            unichar const char3Input = [self characterAtIndex:index+2];
            if ((char2Input == 0xbb) && (char3Input == 0xbf)) {
                replacementString = @"";
                replacementLength = 3;
            }
        }

        if (replacementString == nil) {
            // No pattern detected, just keep scanning the next character.
            continue;
        }

        // First, copy over all chars we scanned over but have not copied yet. Then
        // append the replacement string and update the scan range.
        scanRange.length = index - scanRange.location;
        [result appendString:[self substringWithRange:scanRange]];
        [result appendString:replacementString];
        scanRange.location = index + replacementLength;

        replacementString = nil;
    }

    // Copy the rest
    scanRange.length = self.length - scanRange.location;
    [result appendString:[self substringWithRange:scanRange]];

    return result;
}

// MARK: -

- (NSData*) dataWithByteOrderUTFEncoding:(NSStringEncoding)utfEncoding {
    static NSData* UTF8BOMMagicData;
    static NSData* UTF16BEMagicData;
    static NSData* UTF16LEMagicData;
    static NSData* UTF32BEMagicData;
    static NSData* UTF32LEMagicData;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UTF8BOMMagicData = [NSURL URLWithString:ILUTF8BOMMagic].URLData;
        UTF16BEMagicData = [NSURL URLWithString:ILUTF16BEMagic].URLData;
        UTF16LEMagicData = [NSURL URLWithString:ILUTF16LEMagic].URLData;
        UTF32BEMagicData = [NSURL URLWithString:ILUTF32BEMagic].URLData;
        UTF32LEMagicData = [NSURL URLWithString:ILUTF32LEMagic].URLData;
    });

    NSMutableData* BOMData = NSMutableData.new;
    switch (utfEncoding) {
        case NSUTF8StringEncoding:
            [BOMData appendData:UTF8BOMMagicData];
            break;
        case NSUTF16BigEndianStringEncoding:
            [BOMData appendData:UTF16BEMagicData];
            break;
        case NSUTF16LittleEndianStringEncoding:
            [BOMData appendData:UTF16LEMagicData];
            break;
        case NSUTF32BigEndianStringEncoding:
            [BOMData appendData:UTF32BEMagicData];
            break;
        case NSUTF32LittleEndianStringEncoding:
            [BOMData appendData:UTF32LEMagicData];
            break;
        default:
            break;
    }

    [BOMData appendData:[self dataUsingEncoding:utfEncoding]];

    return BOMData;
}

- (NSArray<NSString*>*) linesWithMaxLen:(NSUInteger) maxLen {
    NSMutableArray* lines = NSMutableArray.new;
    NSUInteger index = 0;
    while (index < self.length) {
        NSUInteger lineLength = MIN(maxLen, self.length - index);
        NSRange lineRange = NSMakeRange(index, lineLength);
        NSString* line = [self substringWithRange:lineRange];
        [lines addObject:line];
        index += lineLength;
    }

    return lines;
}

@end
