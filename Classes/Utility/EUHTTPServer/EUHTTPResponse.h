//
//  EUHTTPResponse.h
//  EVEUniverse
//
//  Created by Shimanski on 8/30/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class EUHTTPResponse;
@protocol EUHTTPResponseDelegate<NSObject>

- (void) httpResponse:(EUHTTPResponse*) response didCompleteWithError:(NSError*) error;

@end

@interface EUHTTPResponse : NSObject<NSStreamDelegate> {
	NSOutputStream *outputStream;
	NSMutableData *outputData;
	CFHTTPMessageRef message;
	id <EUHTTPResponseDelegate> delegate;
}
@property (nonatomic, retain) NSOutputStream *outputStream;
@property (nonatomic, retain) NSMutableData *outputData;
@property (nonatomic, assign) CFHTTPMessageRef message;
@property (nonatomic, assign) id <EUHTTPResponseDelegate> delegate;

- (id)initWithOutputStream:(NSOutputStream *)writeStream 
				  delegate:(id<EUHTTPResponseDelegate>) anObject;

- (void) run;

@end
