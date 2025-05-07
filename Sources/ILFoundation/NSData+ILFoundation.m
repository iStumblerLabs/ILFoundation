#import <CommonCrypto/CommonDigest.h>

#include "NSData+ILFoundation.h"
#include "NSString+ILFoundation.h"
#include "NSURL+ILFoundation.h"

// TODO: if the data size is greater than a given threshold, use the stream-based hash functions

@implementation NSData (ILFoundation)

- (NSString*) hexString {
    return [NSString hexStringWithData:self];
}

- (BOOL) isBinaryPlistData {
    return ([self rangeOfData:[NSURL URLWithString:@"data:;hex,62706C6973743030"].URLData
                      options:NSDataSearchAnchored
                        range:NSMakeRange(0, [self length])].location == 0); // it's bplist

}

// MARK: - Message Digests

- (NSData*) md2 {
    unsigned char digest[CC_MD2_DIGEST_LENGTH];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CC_MD2( self.bytes, (unsigned)self.length, digest);
#pragma clang diagnostic pop
    return [NSData dataWithBytes:digest length:CC_MD2_DIGEST_LENGTH];
}

- (NSData*) md4 {
    unsigned char digest[CC_MD4_DIGEST_LENGTH];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CC_MD4( self.bytes, (unsigned)self.length, digest);
#pragma clang diagnostic pop
    return [NSData dataWithBytes:digest length:CC_MD4_DIGEST_LENGTH];
}

- (NSData*) md5 {
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
    CC_MD5( self.bytes, (unsigned)self.length, digest);
#pragma clang diagnostic pop
    return [NSData dataWithBytes:digest length:CC_MD5_DIGEST_LENGTH];
}

// MARK: - Secure Hash Algorithms

- (NSData*) sha1 {
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];

    CC_SHA1(self.bytes, (unsigned)self.length, digest);

    return [NSData dataWithBytes:digest length:CC_SHA1_DIGEST_LENGTH];
}

- (NSData*) sha2:(long) digestLength {
    uint8_t digest[digestLength];

    switch (digestLength) {
        case CC_SHA224_DIGEST_LENGTH: {
            CC_SHA224(self.bytes, (unsigned)self.length, digest);
            break;
        }
        case CC_SHA256_DIGEST_LENGTH: {
            CC_SHA256(self.bytes, (unsigned)self.length, digest);
            break;
        }
        case CC_SHA384_DIGEST_LENGTH: {
            CC_SHA384(self.bytes, (unsigned)self.length, digest);
            break;
        }
        case CC_SHA512_DIGEST_LENGTH: {
            CC_SHA512(self.bytes, (unsigned)self.length, digest);
            break;
        }
    }

    return [NSData dataWithBytes:digest length:digestLength];
}

- (NSData*) sha2_224 {
    return [self sha2:CC_SHA224_DIGEST_LENGTH];
}

- (NSData*) sha2_256 {
    return [self sha2:CC_SHA256_DIGEST_LENGTH];
}

- (NSData*) sha2_384 {
    return [self sha2:CC_SHA384_DIGEST_LENGTH];
}

- (NSData*) sha2_512 {
    return [self sha2:CC_SHA512_DIGEST_LENGTH];
}

@end
