//
//  MessageViewController.h
//  EVEUniverse
//
//  Created by Mr. Depth on 2/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EUMailMessage;
@interface MessageViewController : UIViewController<UIWebViewDelegate> {
	UIWebView *webView;
	EUMailMessage* message;
}
@property (retain, nonatomic) IBOutlet UIWebView *webView;
@property (retain, nonatomic) EUMailMessage* message;

@end
