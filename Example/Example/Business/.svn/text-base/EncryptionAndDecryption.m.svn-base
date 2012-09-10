//
//  Decrypt.m
//  HaoLianLuo
//
//  Created by iPhone_wmobile on 10-10-28.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "EncryptionAndDecryption.h"


@implementation EncryptionAndDecryption


Byte GetNumOfChar(char cc)
{
	Byte num = 255;
	
	if (cc>='0' && cc<='9') 
	{
		num= cc-'0';
	}
	else
	{
		switch (cc) 
		{
			case 'a':
			case 'A':
				num= 10;
				break;
			case 'b':
			case 'B':
				num= 11;
				break;
			case 'c':
			case 'C':
				num= 12;
				break;
			case 'd':
			case 'D':
				num= 13;
				break;
			case 'e':
			case 'E':
				num= 14;
				break;
			case 'f':
			case 'F':
				num= 15;
				break;
			default:
				break;
		}
	}
	
	return	num;
}

char GetCharOfHex(Byte num)
{
	char cc= '\0';
	
	num= (num & 0x0f);
	if (num<10) 
	{
		cc= num+'0';
	}
	else 
	{
		switch (num)
		{
			case 10:
				cc= 'a';
				break;
			case 11:
				cc= 'b';
				break;
			case 12:
				cc= 'c';
				break;
			case 13:
				cc= 'd';
				break;
			case 14:
				cc= 'e';
				break;
			case 15:
				cc= 'f';
				break;
			default:
				break;
		}
	}
	return	cc;
}

+(NSString*)  encryption:(NSString*) input
{	
	if (input==nil)
		return @"";
    
    NSData *data = [input dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //转换到base64
    data = [GTMBase64 encodeData:data];
    NSString * base64String = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return [base64String autorelease]; 
    
	/*
     NSString	*strEncry= nil;
     
     
     const UInt8*	strbuf=		(const UInt8*)[info cStringUsingEncoding: NSUTF8StringEncoding];
     const size_t	lenInfo=	[info	lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
     size_t			lenOutInfo=	EstimateBas64EncodedDataSize(lenInfo);
     char			*outBuf=	(char*)malloc(lenOutInfo+1);
     
     Base64EncodeData(strbuf, lenInfo, outBuf, &lenOutInfo, NO);
     outBuf[lenOutInfo]=			'\0';
     printLog(@"%s", outBuf);
     strEncry=					[NSString stringWithFormat:@"%s", outBuf];
     free(outBuf);
     if ([strEncry length]>0)
     return	strEncry;
     
     return @"";
     */
    /*
     if (info==nil)
     return @"";
     
     NSInteger		size= [info length];
     NSMutableString	*strEncry= [NSMutableString stringWithCapacity:size*4];
     NSInteger		index;
     
     
     char			cBuf[5];
     const UInt16*	strbuf= (const UInt16*)[info cStringUsingEncoding: NSUTF16StringEncoding];
     
     cBuf[4]= '\0';
     for (index=0; index<size; ++index) 
     {
     UInt16 cc=  strbuf[index];
     
     //printLog(@"encryption %d", cc);
     
     Byte high=	((cc>>8)+1) & 0xff;
     Byte low=	( cc+1 ) & 0xff;
     
     cBuf[0]= GetCharOfHex(high/16);
     cBuf[1]= GetCharOfHex(high%16);
     cBuf[2]= GetCharOfHex(low/16);
     cBuf[3]= GetCharOfHex(low%16);
     
     [strEncry appendFormat:@"%s", cBuf];
     }
     
     if ([strEncry length]>0)
     return	strEncry;
     
     return @"";
     */
}

+(NSString*)  decrypt:(NSString*) info
{
	if (info==nil)
		return @"";
    if (0==[info length]) 
        return @"";
    
    NSData *data = [info dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];    
    data = [GTMBase64 decodeData:data];    
    NSString *accountStr = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];  
    //printLog(@"\ninfo = %@\n",info);
    
    //printLog(@"\naccountStr = %@\n",accountStr);
    return [accountStr autorelease];
    
	/*
     NSString		*strDecry=	nil;
     const UInt8*	strbuf=		(const UInt8*)[info cStringUsingEncoding: NSUTF8StringEncoding];
     const size_t	lenInfo=	[info	lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
     size_t			lenOutInfo=	EstimateBas64DecodedDataSize(lenInfo);
     char			*outBuf=	(char*)malloc(lenOutInfo+1);
     
     Base64DecodeData(strbuf, lenInfo, outBuf, &lenOutInfo);
     outBuf[lenOutInfo]=			'\0';
     strDecry=					[NSString stringWithCString:outBuf encoding:NSUTF8StringEncoding];
     free(outBuf);
     
     return strDecry;
     */
    /*
     if (info==nil)
     return @"";
     
     NSInteger size=	[info length];
     if (size<4 || size%4!=0)
     return @"";
     
     NSMutableString *strDecry= [NSMutableString stringWithCapacity:size/4];
     NSInteger		index;
     
     const char*		strbuf= [info UTF8String];
     wchar_t			uBuf[2];
     char			cBuf[4];
     Byte			highOne, highTwo, lowOne, lowtwo;
     Byte			high, low;
     
     uBuf[1]= L'\0';
     for (index=0; (index+3) < size; index+= 4) 
     {	
     cBuf[0]= strbuf[index];
     cBuf[1]= strbuf[index+1];
     cBuf[2]= strbuf[index+2];
     cBuf[3]= strbuf[index+3];
     
     highOne= GetNumOfChar(cBuf[0]);
     highTwo= GetNumOfChar(cBuf[1]);
     lowOne=	 GetNumOfChar(cBuf[2]);
     lowtwo=	 GetNumOfChar(cBuf[3]);
     if (highOne>15 || highTwo>15 || lowOne>15 || lowtwo>15)
     return @"";
     
     high=	((highOne<<4)&0xf0)+(highTwo&0x0f);
     low=	((lowOne<<4)&0xf0)+(lowtwo&0x0f);
     
     uBuf[0]= high;
     uBuf[0]= (((uBuf[0]+255)<<8)&0xff00)+((low+255)&0x00ff);
     
     //printLog(@"decrypt %d", uBuf[0]);
     
     [strDecry appendFormat:@"%S", uBuf];
     }
     
     return strDecry;
     */
}

+(NSString*)  encryptionHLL:(NSString*) info
{	
    
    if (info==nil)
        return @"";
    
    NSInteger		size= [info length];
    NSMutableString	*strEncry= [NSMutableString stringWithCapacity:size*4];
    NSInteger		index;
    
    
    char			cBuf[5];
    const UInt16*	strbuf= (const UInt16*)[info cStringUsingEncoding: NSUTF16StringEncoding];
    
    cBuf[4]= '\0';
    for (index=0; index<size; ++index) 
    {
        UInt16 cc=  strbuf[index];
        
        //printLog(@"encryption %d", cc);
        
        Byte high=	((cc>>8)+1) & 0xff;
        Byte low=	( cc+1 ) & 0xff;
        
        cBuf[0]= GetCharOfHex(high/16);
        cBuf[1]= GetCharOfHex(high%16);
        cBuf[2]= GetCharOfHex(low/16);
        cBuf[3]= GetCharOfHex(low%16);
        
        [strEncry appendFormat:@"%s", cBuf];
    }
    
    if ([strEncry length]>0)
        return	strEncry;
    
    return @"";
}

+(NSString*)  decryptHLL:(NSString*) info
{
    if (info==nil)
        return @"";
    
    NSInteger size=	[info length];
    if (size<4 || size%4!=0)
        return @"";
    
    NSMutableString *strDecry= [NSMutableString stringWithCapacity:size/4];
    NSInteger		index;
    
    const char*		strbuf= [info UTF8String];
    wchar_t			uBuf[2];
    char			cBuf[4];
    Byte			highOne, highTwo, lowOne, lowtwo;
    Byte			high, low;
    
    uBuf[1]= L'\0';
    for (index=0; (index+3) < size; index+= 4) 
    {	
        cBuf[0]= strbuf[index];
        cBuf[1]= strbuf[index+1];
        cBuf[2]= strbuf[index+2];
        cBuf[3]= strbuf[index+3];
        
        highOne= GetNumOfChar(cBuf[0]);
        highTwo= GetNumOfChar(cBuf[1]);
        lowOne=	 GetNumOfChar(cBuf[2]);
        lowtwo=	 GetNumOfChar(cBuf[3]);
        if (highOne>15 || highTwo>15 || lowOne>15 || lowtwo>15)
            return @"";
        
        high=	((highOne<<4)&0xf0)+(highTwo&0x0f);
        low=	((lowOne<<4)&0xf0)+(lowtwo&0x0f);
        
        uBuf[0]= high;
        uBuf[0]= (((uBuf[0]+255)<<8)&0xff00)+((low+255)&0x00ff);
        
        //printLog(@"decrypt %d", uBuf[0]);
        
        [strDecry appendFormat:@"%S", uBuf];
    }
    
    return strDecry;
}

@end
