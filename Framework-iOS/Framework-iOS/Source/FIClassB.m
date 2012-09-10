/*!
 *	FIClassB.m
 *	Framework-iOS
 *	
 *	Created by Diney Bomfim on 4/30/11.
 *	Copyright 2011 DB-Interactive. All rights reserved.
 */

#import "FIClassB.h"
#import "FIClassC.h"

#pragma mark -
#pragma mark Constants
#pragma mark -
//**************************************************
//  Constants
//**************************************************


#pragma mark -
#pragma mark Private Interface
#pragma mark -
//**************************************************
//	Private Interface
//**************************************************


#pragma mark -
#pragma mark Public Interface
#pragma mark -
//**************************************************
//	Public Interface
//**************************************************

@implementation FIClassB

#pragma mark -
#pragma mark Properties
//**************************************************
//  Properties
//**************************************************


#pragma mark -
#pragma mark Constructors
//**************************************************
//  Constructors
//**************************************************

- (id)init
{
	if ((self = [super init]))
	{
		FIClassC *classC = [[FIClassC alloc] init];
		[classC methodC];
		[classC release];
	}
	
	return self;
}

#pragma mark -
#pragma mark Private Methods
//**********************************************************************************************************
//
//  Private Methods
//
//**********************************************************************************************************


#pragma mark -
#pragma mark Self Public Methods
//**********************************************************************************************************
//
//  Self Public Methods
//
//**********************************************************************************************************

- (void) methodB
{
	NSLog(@"Calling methodB at FIClassB");
}

#pragma mark -
#pragma mark Override Public Methods
//**********************************************************************************************************
//
//  Override Public Methods
//
//**********************************************************************************************************

- (void) methodAWith:(int)anInt
{
	NSLog(@"Calling methodAWith:%i overrided by FIClassB",anInt);
}

- (void)dealloc
{
	[super dealloc];
}

@end
