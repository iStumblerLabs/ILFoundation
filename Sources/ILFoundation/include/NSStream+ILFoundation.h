#import <Foundation/Foundation.h>

#ifdef SWIFT_PACKAGE
#import "ILHashable.h"
#else
#import <ILFoundation/ILHashable.h>
#endif

NS_ASSUME_NONNULL_BEGIN

// MARK: -

typedef enum {
    ILHashMD2,
    ILHashMD4,
    ILHashMD5,
    ILHashSHA1,
    ILHashSHA2_224,
    ILHashSHA2_256,
    ILHashSHA2_384,
    ILHashSHA2_512
    // TODO: ILHashSHA3_224;
    // TODO: ILHashSHA3_256;
    // TODO: ILHashSHA3_384;
    // TODO: ILHashSHA3_512;
    // TODO: ILHashSkein_256_256;
    // TODO: ILHashSkein_512_256;
    // TODO: ILHashSkein_512_512;
}
ILHashingFunction;

// MARK: -

/// Implements the `ILHashable` methods on an `NSInputStream` by performing a blocking read of the
/// entire stream. Not reccomended for long streams, as it will block the calling thread until the entire stream is
/// read and hashed.
///
@interface NSInputStream (ILFoundation) <ILHashable>

@end

// MARK: -

/// Wraps an input stream, forwarning events to the delegate, can be queried for the hash once self.bytesAreAvailable is NO
///
/// Usage: NSImputStream -> ILHashingHashingInputStream
///
/// Create an NSInputStream from any source, pass it to the contstructor if the ILHashingInputStream with the hashing function you want to use
/// To get multiple hashes chain ILHashingHashingInputStreams
///
@interface ILHashingInputStream : NSInputStream <NSStreamDelegate>

/// Create a new ILHashingInputStream with the InputStream and hashing function provided
+ (ILHashingInputStream*) hashingStream:(NSInputStream*) dataStream withFunction:(ILHashingFunction)function;

- (instancetype) initWithInputStream:(NSInputStream*) dataStream hashFunction:(ILHashingFunction)function;

/// Upstream NSInputStream to read data from
@property(readonly) NSInputStream* inputStream;

/// Hashing function to use for this input stream
@property(readonly) ILHashingFunction hashFunction;

/// The stream hash is avaiable when the stream is completely read
@property(readonly, nullable) NSData* streamHash;

/// Synchronously read the stream to the end and return the hash
- (nullable NSData*) readToEndAndHash;

@end

// MARK: -

/// Wraps and output stream, forwarding events to the delegate, can be queried for the hash once
///
@interface ILHashingOutputStream : NSOutputStream <NSStreamDelegate>

/// Create a new ILHashingOutputStream with the OutputStream and hashing function provided
+ (ILHashingOutputStream*) hashingStream:(NSOutputStream*) dataStream withFunction:(ILHashingFunction)function;

- (instancetype) initWithOutputStream:(NSOutputStream*) dataStream hashFunction:(ILHashingFunction)function;

/// Downstream NSOutputStream to send data to
@property(readonly) NSOutputStream* outputStream;

/// Hashing function to use for this output stream
@property(readonly) ILHashingFunction hashFunction;

/// The stream hash is avaiable when the stream is completely read
@property(readonly) NSData* streamHash;

@end

NS_ASSUME_NONNULL_END
