#import <Foundation/Foundation.h>


/// Defines properties for getting various hash codes for an object
///
@protocol ILHashable <NSObject>

// MARK: - Message Digests

/// https://en.wikipedia.org/wiki/MD2_(hash_function)
@property(nonatomic,readonly) NSData* md2;

/// https://en.wikipedia.org/wiki/MD4
@property(nonatomic,readonly) NSData* md4;

/// https://en.wikipedia.org/wiki/MD5
@property(nonatomic,readonly) NSData* md5;

// MARK: - Secure Hash Algorithms

/// https://en.wikipedia.org/wiki/SHA-1
@property(nonatomic,readonly) NSData* sha1;

// MARK: -

/// https://en.wikipedia.org/wiki/SHA-2
@property(nonatomic,readonly) NSData* sha2_224;
@property(nonatomic,readonly) NSData* sha2_256;
@property(nonatomic,readonly) NSData* sha2_384;
@property(nonatomic,readonly) NSData* sha2_512;

// MARK: -

/// https://en.wikipedia.org/wiki/SHA-3
// TODO: @property(nonatomic,readonly) NSData* sha3_224;
// TODO: @property(nonatomic,readonly) NSData* sha3_256;
// TODO: @property(nonatomic,readonly) NSData* sha3_384;
// TODO: @property(nonatomic,readonly) NSData* sha3_512;

// TODO: - Skein

/// https://en.wikipedia.org/wiki/Skein_(hash_function)
// TODO: @property(nonatomic,readonly) NSData* skein_256_256;
// TODO: @property(nonatomic,readonly) NSData* skein_512_256;
// TODO: @property(nonatomic,readonly) NSData* skein_512_512;

@end
