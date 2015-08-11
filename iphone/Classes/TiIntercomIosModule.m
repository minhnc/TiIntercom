/**
 * tiIntercom
 *
 * Created by Your Name
 * Copyright (c) 2015 Your Company. All rights reserved.
 */

#import "TiIntercomIosModule.h"
#import "TiBase.h"
#import "TiHost.h"
#import "TiUtils.h"
#import <Intercom/Intercom.h>

@implementation TiIntercomIosModule

#pragma mark Internal

// this is generated for your module, please do not change it
-(id)moduleGUID
{
	return @"b749dbf8-38ad-45e4-9f1c-bf843ae690a2";
}

// this is generated for your module, please do not change it
-(NSString*)moduleId
{
	return @"ti.intercom.ios";
}

#pragma mark Lifecycle

-(void)startup
{
	// this method is called when the module is first loaded
	// you *must* call the superclass
	[super startup];

	NSLog(@"[INFO] %@ loaded",self);
}

-(void)shutdown:(id)sender
{
	// this method is called when the module is being unloaded
	// typically this is during shutdown. make sure you don't do too
	// much processing here or the app will be quit forceably

	// you *must* call the superclass
	[super shutdown:sender];
}

#pragma mark Cleanup

-(void)dealloc
{
	// release any resources that have been retained by the module
	[super dealloc];
}

#pragma mark Internal Memory Management

-(void)didReceiveMemoryWarning:(NSNotification*)notification
{
	// optionally release any resources that can be dynamically
	// reloaded once memory is available - such as caches
	[super didReceiveMemoryWarning:notification];
}

#pragma mark Listener Notifications

-(void)_listenerAdded:(NSString *)type count:(int)count
{
	if (count == 1 && [type isEqualToString:@"my_event"])
	{
		// the first (of potentially many) listener is being added
		// for event named 'my_event'
	}
}

-(void)_listenerRemoved:(NSString *)type count:(int)count
{
	if (count == 0 && [type isEqualToString:@"my_event"])
	{
		// the last listener called for event named 'my_event' has
		// been removed, we can optionally clean up any resources
		// since no body is listening at this point for that event
	}
}

#pragma Public APIs
-(void)initialize:(id)args
{
    ENSURE_UI_THREAD(initialize, args);
    ENSURE_SINGLE_ARG(args, NSDictionary);
    [Intercom setApiKey:[args objectForKey:@"api_key"] forAppId:[args objectForKey:@"app_id"]];
    NSLog(@"[DEBUG] Intercom initailized");
}

-(void)registerUserWithEmail:(id)email
{
    ENSURE_SINGLE_ARG(email, NSString);
    [Intercom registerUserWithEmail:email];
    NSLog(@"[DEBUG] Intercom registers user with email: %@", email);
}

-(void)registerUnidentifiedUser:(id)args
{
    [Intercom registerUnidentifiedUser];
    NSLog(@"[DEBUG] Intercom registers undefined user");
}

-(void)registerUserWithUserId:(id)userId
{
    ENSURE_SINGLE_ARG(userId, NSString);
    [Intercom registerUserWithUserId:userId];
    NSLog(@"[DEBUG] Intercom registers user with user id: %@", userId);
}

-(void)presentMessageComposer:(id)args
{
    ENSURE_UI_THREAD(presentMessageComposer, args);
    [Intercom presentMessageComposer];
    NSLog(@"[DEBUG] Intercom presents message composer");
}

-(void)presentConversationList:(id)args
{
    ENSURE_UI_THREAD(presentConversationList, args);
    [Intercom presentConversationList];
    NSLog(@"[DEBUG] Intercom presents ConverstaionList");
}

-(void)reset:(id)args
{
    [Intercom reset];
    NSLog(@"[DEBUG] Intercom resets");
}

-(void)logEventWithName:(id)name
{
    ENSURE_SINGLE_ARG(name, NSString);
    [Intercom logEventWithName:name];
    NSLog(@"[DEBUG] Intercom logs event with name");
}

/*
-(void)logEventWithNameAndData:(id)args
{
    ENSURE_SINGLE_ARG(args, NSDictionary);
    [Intercom logEventWithName:[args objectForKey:@"name"] metaData: @{@"date": [args objectForKey:@"date"],@"data": [args objectForKey:@"data"]}];
    NSLog(@"[DEBUG] Intercom logs event with name and data");
}
*/

- (void)logEventWithNameAndData:(id)args 
{
	//thanks to @animecyc for helping out with this https://github.com/animecyc
	
  	NSString *eventName = nil;
  	NSDictionary *data = nil;

  	ENSURE_ARG_AT_INDEX(eventName, args, 0, NSString);
  	ENSURE_ARG_AT_INDEX(data, args, 1, NSDictionary);

  	//NSLog(@"[INFO] %@ ~> %@", eventName, data);
	[Intercom logEventWithName:eventName metaData:data];

}

-(void)setDeviceToken:(NSString *)devToken
{	
	//we have to convert device token from string to NSData
	
	const char * chars = [devToken UTF8String];
	int i = 0;
	int len = (int)devToken.length;

	NSMutableData *data = [NSMutableData dataWithCapacity:len / 2];
	char byteChars[3] = {'\0','\0','\0'};
	unsigned long wholeByte;

	while (i < len) 
	{
	    byteChars[0] = chars[i++];
	    byteChars[1] = chars[i++];
	    wholeByte = strtoul(byteChars, NULL, 16);
	    [data appendBytes:&wholeByte length:1];
	}
	
	NSLog(@"[DEBUG] Intercom registers device for push notifications:  %@", data );
	
    [Intercom setDeviceToken:data];
   
}


- (void)updateUserWithAttributes:(id)args 
{

  	NSDictionary *data = nil;

  	
  	ENSURE_ARG_AT_INDEX(data, args, 0, NSDictionary);

  
	[Intercom updateUserWithAttributes:data];
	NSLog(@"[INFO][DEBUG] Intercom update user with:  %@", data );
}



@end
