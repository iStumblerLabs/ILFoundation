#import <Foundation/Foundation.h>

#ifdef SWIFT_PACKAGE
#import "ILHashable.h"
#else
#import <ILFoundation/ILHashable.h>
#endif

NS_ASSUME_NONNULL_BEGIN

@interface NSData (ILFoundation) <ILHashable>

/// lowercase hex string representing this data
@property(nonatomic,readonly) NSString* hexString;
@property(nonatomic,readonly) BOOL isBinaryPlistData;

@end

NS_ASSUME_NONNULL_END
