/*!
 *	FIClassC.m
 *	Framework-iOS
 *	
 *	Created by Diney Bomfim on 4/30/11.
 *	Copyright 2011 DB-Interactive. All rights reserved.
 */

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

@implementation FIClassC

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
		// Initialization code here.
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

- (void) methodC
{
	NSLog(@"Calling methodC at FIClassC\n\
		  FIClassC is a private class an its interface is not visible to the developers.");
}

#pragma mark -
#pragma mark Override Public Methods
//**********************************************************************************************************
//
//  Override Public Methods
//
//**********************************************************************************************************

- (void)dealloc
{
	[super dealloc];
}

@end
