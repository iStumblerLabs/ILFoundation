#import <Foundation/Foundation.h>
#import <CommonCrypto/CommonDigest.h>

#include "NSStream+ILFoundation.h"
#include "NSString+ILFoundation.h"

#define ILSTREAM_BUFFER_SIZE 4096

@implementation NSInputStream (ILFoundation)

// MARK: - Message Digests

- (NSData*) md2 {
    ILHashingInputStream* hashingStream = [ILHashingInputStream.alloc initWithInputStream:self hashFunction:ILHashingFunctionMD2];
    return hashingStream.readToEndAndHash;
}

- (NSData*) md4 {
    ILHashingInputStream* hashingStream = [ILHashingInputStream.alloc initWithInputStream:self hashFunction:ILHashingFunctionMD4];
    return hashingStream.readToEndAndHash;
}

- (NSData*) md5 {
    ILHashingInputStream* hashingStream = [ILHashingInputStream.alloc initWithInputStream:self hashFunction:ILHashingFunctionMD5];
    return hashingStream.readToEndAndHash;
}

// MARK: - Secure Hash Algorithms

- (NSData*) sha1 {
    ILHashingInputStream* hashingStream = [ILHashingInputStream.alloc initWithInputStream:self hashFunction:ILHashingFunctionSHA1];
    return hashingStream.readToEndAndHash;
}

- (NSData*) sha2_224 {
    ILHashingInputStream* hashingStream = [ILHashingInputStream.alloc initWithInputStream:self hashFunction:ILHashingFunctionSHA2_224];
    return hashingStream.readToEndAndHash;
}

- (NSData*) sha2_256 {
    ILHashingInputStream* hashingStream = [ILHashingInputStream.alloc initWithInputStream:self hashFunction:ILHashingFunctionSHA2_256];
    return hashingStream.readToEndAndHash;
}

- (NSData*) sha2_384 {
    ILHashingInputStream* hashingStream = [ILHashingInputStream.alloc initWithInputStream:self hashFunction:ILHashingFunctionSHA2_384];
    return hashingStream.readToEndAndHash;
}

- (NSData*) sha2_512 {
    ILHashingInputStream* hashingStream = [ILHashingInputStream.alloc initWithInputStream:self hashFunction:ILHashingFunctionSHA2_512];
    return hashingStream.readToEndAndHash;
}

@end

// MARK: -

typedef struct {
    int (*hashInitFunction)(void*);
    int (*hashUpdateFunction)(void*,const void*,CC_LONG);
    int (*hashFinalFunction)(unsigned char*, void*);
    BOOL initialized;
} ILHashingFunctionImpl;

@interface ILHashingInputStream ()
@property(assign) ILHashingFunction hashFunctionStorage;
@property(assign) ILHashingFunctionImpl hashFunctionImpl;
@property(retain) NSMutableData* hashContextStorage;
@property(retain) NSInputStream* inputStreamStorage;
@property(retain) NSMutableData* lastReadStorage;
@property(retain) NSData* streamHashStorage;
@property(assign) id<NSStreamDelegate> delegateStorage;
@end

// MARK: -

@implementation ILHashingInputStream

/// Create a new ILHashingInputStream with the hashing function and upstream dataStream
/// @param dataStream - an NSInputStream you want to read and get the hash of
+ (ILHashingInputStream*) hashingStream:(NSInputStream*) dataStream withFunction:(ILHashingFunction)function {
    return [self.alloc initWithInputStream:dataStream hashFunction:function];
}

+ (NSMutableData*) hashContextFor:(ILHashingFunction) function {
    NSMutableData* data = nil;
    size_t contextSize = 0;

    switch (function) {
        case ILHashingFunctionMD2:         contextSize = sizeof(CC_MD2_CTX); break;
        case ILHashingFunctionMD4:         contextSize = sizeof(CC_MD4_CTX); break;
        case ILHashingFunctionMD5:         contextSize = sizeof(CC_MD5_CTX); break;
        case ILHashingFunctionSHA1:        contextSize = sizeof(CC_SHA1_CTX); break;
        case ILHashingFunctionSHA2_224:    contextSize = sizeof(CC_SHA256_CTX); break;
        case ILHashingFunctionSHA2_256:    contextSize = sizeof(CC_SHA256_CTX); break;
        case ILHashingFunctionSHA2_384:    contextSize = sizeof(CC_SHA512_CTX); break;
        case ILHashingFunctionSHA2_512:    contextSize = sizeof(CC_SHA512_CTX); break;
    }

    data = [NSMutableData dataWithLength:contextSize];

    return data;
}

+ (NSMutableData*) digestDataFor:(ILHashingFunction) function {
    NSMutableData* digest = nil;
    size_t digestSize = 0;

    switch (function) {
        case ILHashingFunctionMD2:         digestSize = CC_MD2_DIGEST_LENGTH; break;
        case ILHashingFunctionMD4:         digestSize = CC_MD4_DIGEST_LENGTH; break;
        case ILHashingFunctionMD5:         digestSize = CC_MD5_DIGEST_LENGTH; break;
        case ILHashingFunctionSHA1:        digestSize = CC_SHA1_DIGEST_LENGTH; break;
        case ILHashingFunctionSHA2_224:    digestSize = CC_SHA224_DIGEST_LENGTH; break;
        case ILHashingFunctionSHA2_256:    digestSize = CC_SHA256_DIGEST_LENGTH; break;
        case ILHashingFunctionSHA2_384:    digestSize = CC_SHA384_DIGEST_LENGTH; break;
        case ILHashingFunctionSHA2_512:    digestSize = CC_SHA512_DIGEST_LENGTH; break;
    }

    digest = [NSMutableData dataWithLength:digestSize];

    return digest;
}

+ (ILHashingFunctionImpl) hashFunctionImplFor:(ILHashingFunction) function {
    ILHashingFunctionImpl impl = {};
    impl.initialized = YES;

    switch (function) {
        case ILHashingFunctionMD2: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            impl.hashInitFunction = (int(*)(void*))CC_MD2_Init;
            impl.hashUpdateFunction = (int(*)(void*,const void*,CC_LONG))CC_MD2_Update;
            impl.hashFinalFunction = (int(*)(unsigned char*, void*))CC_MD2_Final;
#pragma clang diagnostic pop
            break;
        }
        case ILHashingFunctionMD4: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            impl.hashInitFunction = (int(*)(void*))CC_MD4_Init;
            impl.hashUpdateFunction = (int(*)(void*,const void*,CC_LONG))CC_MD4_Update;
            impl.hashFinalFunction = (int(*)(unsigned char*, void*))CC_MD4_Final;
#pragma clang diagnostic pop
            break;
        }
        case ILHashingFunctionMD5: {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
            impl.hashInitFunction = (int(*)(void*))CC_MD5_Init;
            impl.hashUpdateFunction = (int(*)(void*,const void*,CC_LONG))CC_MD5_Update;
            impl.hashFinalFunction = (int(*)(unsigned char*, void*))CC_MD5_Final;
#pragma clang diagnostic pop
            break;
        }
        case ILHashingFunctionSHA1: {
            impl.hashInitFunction = (int(*)(void*))CC_SHA1_Init;
            impl.hashUpdateFunction = (int(*)(void*,const void*,CC_LONG))CC_SHA1_Update;
            impl.hashFinalFunction = (int(*)(unsigned char*, void*))CC_SHA1_Final;
            break;
        }
        case ILHashingFunctionSHA2_224 : {
            impl.hashInitFunction = (int(*)(void*))CC_SHA224_Init;
            impl.hashUpdateFunction = (int(*)(void*,const void*,CC_LONG))CC_SHA224_Update;
            impl.hashFinalFunction = (int(*)(unsigned char*, void*))CC_SHA224_Final;
            break;
        }
        case ILHashingFunctionSHA2_256: {
            impl.hashInitFunction = (int(*)(void*))CC_SHA256_Init;
            impl.hashUpdateFunction = (int(*)(void*,const void*,CC_LONG))CC_SHA256_Update;
            impl.hashFinalFunction = (int(*)(unsigned char*, void*))CC_SHA256_Final;
            break;
        }
        case ILHashingFunctionSHA2_384: {
            impl.hashInitFunction = (int(*)(void*))CC_SHA384_Init;
            impl.hashUpdateFunction = (int(*)(void*,const void*,CC_LONG))CC_SHA384_Update;
            impl.hashFinalFunction = (int(*)(unsigned char*, void*))CC_SHA384_Final;
            break;
        }
        case ILHashingFunctionSHA2_512: {
            impl.hashInitFunction = (int(*)(void*))CC_SHA512_Init;
            impl.hashUpdateFunction = (int(*)(void*,const void*,CC_LONG))CC_SHA512_Update;
            impl.hashFinalFunction = (int(*)(unsigned char*, void*))CC_SHA512_Final;
            break;
        }
        default: {
            impl.initialized = NO;
        }
    }

    return impl;
}

// MARK: -

- (instancetype) initWithInputStream:(NSInputStream*) dataStream hashFunction:(ILHashingFunction)function {
    if ((self = super.init)) {
        self.inputStreamStorage = dataStream;
        self.inputStreamStorage.delegate = self;
        self.hashFunctionStorage = function;
        self.hashFunctionImpl = [ILHashingInputStream hashFunctionImplFor:function];
    }

    return self;
}

- (NSInputStream*) inputStream {
    return self.inputStreamStorage;
}

- (ILHashingFunction) hashFunction {
    return self.hashFunctionStorage;
}

- (NSData*) streamHash {
    return self.streamHashStorage;
}

// MARK: - NSStream

- (void) open {
    if (!self.hashContextStorage) { // allow for multiple calls to open, but warn about it
        self.hashContextStorage = [ILHashingInputStream hashContextFor:self.hashFunction];
        if (self.hashFunctionImpl.initialized) {
            self.hashFunctionImpl.hashInitFunction((void*)self.hashContextStorage.bytes);
        }
        else {
            NSLog(@"Error: open called before setting hashFunctionImpl"); // if you use .new to create a stream, you must set the hashFunction
            [[NSException.alloc initWithName:NSInternalInconsistencyException reason:@"open called before setting hashFunctionImpl" userInfo:nil] raise];
        }
    }
    else
        NSLog(@"Warning: open called multiple times on ILHashingInputStream");

    [self.inputStream open];
}

- (void) close {
    NSMutableData* digest = [ILHashingInputStream digestDataFor:self.hashFunction];
    self.hashFunctionImpl.hashFinalFunction((unsigned char*)digest.mutableBytes, (void*)self.hashContextStorage.bytes);
    self.streamHashStorage = digest;

    [self.inputStream close];
}

- (NSStreamStatus) streamStatus {
    return self.inputStreamStorage.streamStatus;
}

- (NSError*) streamError {
    return self.inputStreamStorage.streamError;
}

- (id<NSStreamDelegate>) delegate {
    return self.delegateStorage;
}

- (void) setDelegate:(id<NSStreamDelegate>) delegate {
    self.delegateStorage = delegate;
}

// MARK: - NSInputStream

-(NSInteger) read:(uint8_t*) buffer maxLength:(NSUInteger) maxLength {
    NSInteger bytesRead = -1;

    if (self.lastReadStorage) { // if we have a buffer from a previous read event on the stream, return it
        if (self.lastReadStorage.length < maxLength) {
            [self.lastReadStorage getBytes:buffer length:self.lastReadStorage.length];
            bytesRead = self.lastReadStorage.length;
            self.lastReadStorage = nil;
        }
        else { // return as much as we can and trim the storage buffer
            [self.lastReadStorage getBytes:buffer length:maxLength];
            [self.lastReadStorage setData:[self.lastReadStorage subdataWithRange:NSMakeRange(maxLength, self.lastReadStorage.length - maxLength)]];
            bytesRead = maxLength;
        }
    }
    else {
        bytesRead = [self.inputStream read:buffer maxLength:maxLength];

        if (bytesRead > 0) {
            self.hashFunctionImpl.hashUpdateFunction((void*)self.hashContextStorage.bytes, (const void*)buffer, (CC_LONG)bytesRead);
        }
    }

    return bytesRead;
}

-(BOOL) getBuffer:(uint8_t* _Nullable*)buffer length:(NSUInteger*) len {
    return [self.inputStream getBuffer:buffer length:len];
}

- (BOOL) hasBytesAvailable {
    return self.inputStream.hasBytesAvailable;
}

// MARK: - NSStreamDelegate

- (void) stream:(NSStream*) dataStream handleEvent:(NSStreamEvent) eventCode {
    // pass all events through to the dlegate
    switch (eventCode) {
        case NSStreamEventNone: break; // No event has occurred.
        case NSStreamEventOpenCompleted: break; // TODO: error if the context has not been created at this point?
        case NSStreamEventHasBytesAvailable: { // The stream has bytes to be read.
            // read the bytes w/o advancing the 'read' head and pass them along to the delegate
            NSMutableData* data = [NSMutableData dataWithLength:ILSTREAM_BUFFER_SIZE];
            NSInteger bytesRead = [self read:(unsigned char*)data.bytes maxLength:data.length];
            data.length = bytesRead;
            if (self.lastReadStorage) { // append our data to the remaining
                [self.lastReadStorage appendData:data];
            }
            else {
                self.lastReadStorage = data;
            }
            break;
        }
        case NSStreamEventHasSpaceAvailable: {
            break; // The NSOutputStream can accept bytes for writing
        }
        case NSStreamEventEndEncountered: { // The end of the stream has been reached.
            break;
        }
        case NSStreamEventErrorOccurred: { // An error has occurred on the stream.
            break;
        }
    }

    // forward the notification to the delegate
    [self.delegate stream:dataStream handleEvent:eventCode];
}

- (NSData*) readToEndAndHash {
    u_int8_t buffer[ILSTREAM_BUFFER_SIZE];

    [self open];

    while(self.hasBytesAvailable) {
        [self read:(uint8_t* _Nonnull)&buffer maxLength:sizeof(buffer)];
    }

    [self close];

    return self.streamHash;
}

@end

// MARK: -

@implementation NSOutputStream (ILFoundation)



@end
