//
//  CallsAttribution.m
//  HaoLianLuo
//
//  Created by iPhone_wmobile on 10-10-25.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "CallsAttribution.h"

const int KTY_PHNUM_FILE_VERSION_LEN = 2;
const int KTY_PHNUM_FILE_MAXID_LEN = 2;

@implementation CallsAttribution


//===========指定偏移地址从"mobliecity.db"中读入地区号
+(NSInteger) ReadUint16:(NSInteger) nReadFilePos
{
	//NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    //NSString *documentsDirectory = [paths objectAtIndex:0];
    //NSString *path = [documentsDirectory stringByAppendingPathComponent:@"mobliecity.db"];
	NSString  *path= [[NSBundle mainBundle] pathForResource:@"mobliecity" ofType:@"db"];
	
	NSInteger	nQuHao= -1;
	FILE*	fp= fopen([path UTF8String], "rb");
	if (fp)
	{
		Byte tmpByte[2];
		
		fseek(fp, nReadFilePos, SEEK_SET);
		if(fread(tmpByte, sizeof(Byte), 2, fp)==2)
		{
			//NSLog(@"%d %d", tmpByte[0], tmpByte[1] );
			unsigned short	val= 0x1122;
			if (0x11==*(Byte*)&val)//( 'x'==(((*(unsigned short*)"xp")>>8)&0xff) ) 
			{//=======大头模式
				nQuHao= tmpByte[0];
				nQuHao= (nQuHao<<8) + tmpByte[1];
			}
			else//====小头模式
			{
				nQuHao= tmpByte[1];
				nQuHao= (nQuHao<<8)+tmpByte[0];
			}
		}
		fclose(fp);
	}
	return nQuHao;
}


+(NSString*) processCityName_3:(NSInteger) aQuHao
{
	NSMutableString		*aCityName= nil;
	
	if ((310 <= aQuHao && 319 >= aQuHao) || 335 == aQuHao)
	{
		aCityName= [NSMutableString stringWithString:@"河北"];
	}
	else if (349 <= aQuHao && 359 >= aQuHao)
	{
		aCityName= [NSMutableString stringWithString:@"山西"];
	}
	else if ((370 <= aQuHao && 379 >= aQuHao) || (391 <= aQuHao && 398 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"河南"];
	}
	else
	{
		return nil;
	}
	
	switch (aQuHao)
	{
		case 310:
			[aCityName appendString:@"邯郸"];
			break;
		case 311:
			[aCityName appendString:@"石家庄"];
			break;
		case 312:
			[aCityName appendString:@"保定"];
			break;
		case 313:
			[aCityName appendString:@"张家口"];
			break;
		case 314:
			[aCityName appendString:@"承德"];
			break;
		case 315:
			[aCityName appendString:@"唐山"];
			break;
		case 316:
			[aCityName appendString:@"廊坊"];
			break;
		case 317:
			[aCityName appendString:@"沧州"];
			break;
		case 318:
			[aCityName appendString:@"衡水"];
			break;
		case 319:
			[aCityName appendString:@"邢台"];
			break;
		case 335:
			[aCityName appendString:@"秦皇岛"];
			break;
		case 349:
			[aCityName appendString:@"朔州"];
			break;
		case 350:
			[aCityName appendString:@"忻州"];
			break;
		case 351:
			[aCityName appendString:@"太原"];
			break;
		case 352:
			[aCityName appendString:@"大同"];
			break;
		case 353:
			[aCityName appendString:@"阳泉"];
			break;
		case 354:
			[aCityName appendString:@"晋中"];
			break;
		case 355:
			[aCityName appendString:@"长治"];
			break;
		case 356:
			[aCityName appendString:@"晋城"];
			break;
		case 357:
			[aCityName appendString:@"临汾"];
			break;
		case 358:
			[aCityName appendString:@"吕梁"];
			break;
		case 359:
			[aCityName appendString:@"运城"];
			break;
		case 370:
			[aCityName appendString:@"商丘"];
			break;
		case 371:
			[aCityName appendString:@"郑州"];
			break;
		case 372:
			[aCityName appendString:@"安阳"];
			break;
		case 373:
			[aCityName appendString:@"新乡"];
			break;
		case 374:
			[aCityName appendString:@"许昌"];
			break;
		case 375:
			[aCityName appendString:@"平顶山"];
			break;
		case 376:
			[aCityName appendString:@"信阳"];
			break;
		case 377:
			[aCityName appendString:@"南阳"];
			break;
		case 378:
			[aCityName appendString:@"开封"];
			break;
		case 379:
			[aCityName appendString:@"洛阳"];
			break;
		case 391:
			[aCityName appendString:@"焦作"];
			break;
		case 392:
			[aCityName appendString:@"鹤壁"];
			break;
		case 393:
			[aCityName appendString:@"濮阳"];
			break;
		case 394:
			[aCityName appendString:@"周口"];
			break;
		case 395:
			[aCityName appendString:@"漯河"];
			break;
		case 396:
			[aCityName appendString:@"驻马店"];
			break;
		case 397:
			[aCityName appendString:@"潢川"];
			break;
		case 398:
			[aCityName appendString:@"三门峡"];
			break;
	}
	return aCityName;
}


+(NSString*) processCityName_4:(NSInteger) aQuHao
{
	NSMutableString		*aCityName= nil;
	
	if ((410 <= aQuHao && 419 >= aQuHao) || 421 == aQuHao || 427 == aQuHao || 429 == aQuHao)
	{
		aCityName= [NSMutableString stringWithString:@"辽宁"];
	}
	else if (431 <= aQuHao && 439 >= aQuHao)
	{
		aCityName= [NSMutableString stringWithString:@"吉林"];
	}
	else if ((451 <= aQuHao && 459 >= aQuHao) || (467 <= aQuHao && 469 >= aQuHao) || 464 == aQuHao)
	{
		aCityName= [NSMutableString stringWithString:@"黑龙江"];
	}
	else if ((470 <= aQuHao && 479 >= aQuHao) || (482 < aQuHao && 483 > aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"内蒙古"];
	}
	else 
	{
		return nil;
	}
	
	switch (aQuHao)
	{
		case 410:
			[aCityName appendString:@"铁岭"];
			break;
		case 411:
			[aCityName appendString:@"大连"];
			break;
		case 412:
			[aCityName appendString:@"鞍山"];
			break;
		case 413:
			[aCityName appendString:@"抚顺"];
			break;
		case 414:
			[aCityName appendString:@"本溪"];
			break;
		case 415:
			[aCityName appendString:@"丹东"];
			break;
		case 416:
			[aCityName appendString:@"锦州"];
			break;
		case 418:
			[aCityName appendString:@"阜新"];
			break;
		case 417:
			[aCityName appendString:@"营口"];
			break;
		case 419:
			[aCityName appendString:@"辽阳"];
			break;
		case 421:
			[aCityName appendString:@"朝阳"];
			break;
		case 427:
			[aCityName appendString:@"盘锦"];
			break;
		case 429:
			[aCityName appendString:@"葫芦岛"];
			break;
		case 431:
			[aCityName appendString:@"长春"];
			break;
		case 432:
			[aCityName appendString:@"吉林"];
			break;
		case 433:
			[aCityName appendString:@"延吉"];
			break;
		case 434:
			[aCityName appendString:@"四平"];
			break;
		case 435:
			[aCityName appendString:@"通化"];
			break;
		case 436:
			[aCityName appendString:@"白城"];
			break;
		case 437:
			[aCityName appendString:@"辽源"];
			break;
		case 438:
			[aCityName appendString:@"松原"];
			break;
		case 439:
			[aCityName appendString:@"白山"];
			break;
		case 451:
			[aCityName appendString:@"哈尔滨"];
			break;
		case 452:
			[aCityName appendString:@"齐齐哈尔"];
			break;
		case 453:
			[aCityName appendString:@"牡丹江"];
			break;
		case 454:
			[aCityName appendString:@"佳木斯"];
			break;
		case 455:
			[aCityName appendString:@"绥化"];
			break;
		case 456:
			[aCityName appendString:@"黑河"];
			break;
		case 457:
			[aCityName appendString:@"大兴安岭"];
			break;
		case 458:
			[aCityName appendString:@"伊春"];
			break;
		case 459:
			[aCityName appendString:@"大庆"];
			break;
		case 464:
			[aCityName appendString:@"七台河"];
			break;
		case 467:
			[aCityName appendString:@"鸡西"];
			break;
		case 468:
			[aCityName appendString:@"鹤岗"];
			break;
		case 469:
			[aCityName appendString:@"双鸭山"];
			break;
		case 470:
			[aCityName appendString:@"呼伦贝尔"];
			break;
		case 471:
			[aCityName appendString:@"呼和浩特"];
			break;
		case 472:
			[aCityName appendString:@"包头"];
			break;
		case 473:
			[aCityName appendString:@"乌海"];
			break;
		case 474:
			[aCityName appendString:@"乌兰查布"];
			break;
		case 475:
			[aCityName appendString:@"通辽"];
			break;
		case 476:
			[aCityName appendString:@"赤峰"];
			break;
		case 477:
			[aCityName appendString:@"鄂尔多斯"];
			break;
		case 478:
			[aCityName appendString:@"巴彦淖尔"];
			break;
		case 479:
			[aCityName appendString:@"锡林浩特"];
			break;
		case 482:
			[aCityName appendString:@"乌兰浩特"];
			break;
		case 483:
			[aCityName appendString:@"巴彦浩特"];
			break;
	}
	
	return aCityName;
}


+(NSString*) processCityName_5:(NSInteger) aQuHao
{
	NSMutableString	*aCityName= nil;
	
	if ((510 <= aQuHao && 519 >= aQuHao) || 523 == aQuHao || 527 == aQuHao)
	{
		aCityName= [NSMutableString stringWithString:@"江苏"];
	}
	else if ( (530 <= aQuHao && 539 >= aQuHao) || 543 == aQuHao || 546 == aQuHao)
	{
		aCityName= [NSMutableString stringWithString:@"山东"];
	}
	else if ((550 <= aQuHao && 559 >= aQuHao) || (561 <= aQuHao && 566 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"安徽"];
	}
	else if ((570 <= aQuHao && 580 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"浙江"];
	}
	else if ((591 <= aQuHao && 599 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"福建"];
	}
	else 
	{
		return nil;
	}
	
	
	switch (aQuHao)
	{
		case 510:
			[aCityName appendString:@"无锡"];
			break;
		case 511:
			[aCityName appendString:@"镇江"];
			break;
		case 512:
			[aCityName appendString:@"苏州"];
			break;
		case 513:
			[aCityName appendString:@"南通"];
			break;
		case 514:
			[aCityName appendString:@"扬州"];
			break;
		case 515:
			[aCityName appendString:@"盐城"];
			break;
		case 516:
			[aCityName appendString:@"徐州"];
			break;
		case 517:
			[aCityName appendString:@"淮安"];
			break;
		case 518:
			[aCityName appendString:@"连云港"];
			break;
		case 519:
			[aCityName appendString:@"常州"];
			break;
		case 523:
			[aCityName appendString:@"泰州"];
			break;
		case 527:
			[aCityName appendString:@"宿迁"];
			break;
		case 530:
			[aCityName appendString:@"菏泽"];
			break;
		case 531:
			[aCityName appendString:@"济南"];
			break;
		case 532:
			[aCityName appendString:@"青岛"];
			break;
		case 533:
			[aCityName appendString:@"淄博"];
			break;
		case 534:
			[aCityName appendString:@"德州"];
			break;
		case 535:
			[aCityName appendString:@"烟台"];
			break;
		case 536:
			[aCityName appendString:@"潍坊"];
			break;
		case 537:
			[aCityName appendString:@"济宁"];
			break;
		case 538:
			[aCityName appendString:@"泰安"];
			break;
		case 539:
			[aCityName appendString:@"临沂"];
			break;
		case 543:
			[aCityName appendString:@"滨州"];
			break;
		case 546:
			[aCityName appendString:@"东营"];
			break;
		case 550:
			[aCityName appendString:@"滁州"];
			break;
		case 551:
			[aCityName appendString:@"合肥"];
			break;
		case 552:
			[aCityName appendString:@"蚌埠"];
			break;
		case 553:
			[aCityName appendString:@"芜湖"];
			break;
		case 554:
			[aCityName appendString:@"淮南"];
			break;
		case 555:
			[aCityName appendString:@"马鞍山"];
			break;
		case 556:
			[aCityName appendString:@"安庆"];
			break;
		case 557:
			[aCityName appendString:@"宿州"];
			break;
		case 558:
			[aCityName appendString:@"阜阳"];
			break;
		case 559:
			[aCityName appendString:@"黄山"];
			break;
		case 561:
			[aCityName appendString:@"淮北"];
			break;
		case 562:
			[aCityName appendString:@"铜陵"];
			break;
		case 563:
			[aCityName appendString:@"宣城"];
			break;
		case 564:
			[aCityName appendString:@"六安"];
			break;
		case 565:
			[aCityName appendString:@"巢湖"];
			break;
		case 566:
			[aCityName appendString:@"池州"];
			break;
		case 570:
			[aCityName appendString:@"衢州"];
			break;
		case 571:
			[aCityName appendString:@"杭州"];
			break;
		case 572:
			[aCityName appendString:@"湖州"];
			break;
		case 573:
			[aCityName appendString:@"嘉兴"];
			break;
		case 574:
			[aCityName appendString:@"宁波"];
			break;
		case 575:
			[aCityName appendString:@"绍兴"];
			break;
		case 576:
			[aCityName appendString:@"台州"];
			break;
		case 577:
			[aCityName appendString:@"温州"];
			break;
		case 578:
			[aCityName appendString:@"丽水"];
			break;
		case 579:
			[aCityName appendString:@"金华"];
			break;
		case 580:
			[aCityName appendString:@"舟山"];
			break;
		case 591:
			[aCityName appendString:@"福州"];
			break;
		case 592:
			[aCityName appendString:@"厦门"];
			break;
		case 593:
			[aCityName appendString:@"宁德"];
			break;
		case 594:
			[aCityName appendString:@"莆田"];
			break;
		case 595:
			[aCityName appendString:@"泉州"];
			break;
		case 596:
			[aCityName appendString:@"漳州"];
			break;
		case 597:
			[aCityName appendString:@"龙岩"];
			break;
		case 598:
			[aCityName appendString:@"三明"];
			break;
		case 599:
			[aCityName appendString:@"南平"];
			break;
	}
	
	return nil;
}


+(NSString*) processCityName_6:(NSInteger) aQuHao
{
	NSMutableString*	aCityName= nil;
	
	if ((631 <= aQuHao && 635 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"山东"];
	}
	else if (662 == aQuHao || 668 == aQuHao || 663 == aQuHao || 660 == aQuHao)
	{
		aCityName= [NSMutableString stringWithString:@"广东"];
	}
	else if ((691 == aQuHao || 692 == aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"云南"];
	}
	else 
	{
		return nil;
	}
	
	
	switch (aQuHao)
	{
		case 631:
			[aCityName appendString:@"威海"];
			break;
		case 632:
			[aCityName appendString:@"枣庄"];
			break;
		case 633:
			[aCityName appendString:@"日照"];
			break;
		case 634:
			[aCityName appendString:@"莱芜"];
			break;
		case 635:
			[aCityName appendString:@"聊城"];
			break;
		case 660:
			[aCityName appendString:@"汕尾"];
			break;
		case 662:
			[aCityName appendString:@"阳江"];
			break;
		case 663:
			[aCityName appendString:@"揭阳"];
			break;
		case 668:
			[aCityName appendString:@"茂名"];
			break;
		case 691:
			[aCityName appendString:@"西双版纳"];
			break;
		case 692:
			[aCityName appendString:@"德宏"];
			break;
	}
	
	return aCityName;
}


+(NSString*) processCityName_7:(NSInteger) aQuHao
{
	NSMutableString	*aCityName= nil;
	
	if (701 == aQuHao)
	{
		aCityName= [NSMutableString stringWithString:@"江西"];
	}
	else if ((710 <= aQuHao && 719 >= aQuHao) || 722 == aQuHao || 724 == aQuHao || 728 == aQuHao)
	{
		aCityName= [NSMutableString stringWithString:@"湖北"];
	}
	else if ((730 <= aQuHao && 739 >= aQuHao) || (743 <= aQuHao && 746 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"湖南"];
	}
	else if ((750 <= aQuHao && 760 >= aQuHao) || 762 == aQuHao || 763 == aQuHao || 766 == aQuHao || 768 == aQuHao || 769 == aQuHao)
	{
		aCityName= [NSMutableString stringWithString:@"广东"];
	}
	else if ((770 <= aQuHao && 779 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"广西"];
	}
	else if ((790 <= aQuHao && 799 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"江西"];
	}
	else
	{
		return nil;
	}
	
	
	switch (aQuHao)
	{
		case 701:
			[aCityName appendString:@"鹰潭"];
			break;
		case 710:
			[aCityName appendString:@"襄樊"];
			break;
		case 711:
			[aCityName appendString:@"鄂州"];
			break;
		case 712:
			[aCityName appendString:@"孝感"];
			break;
		case 713:
			[aCityName appendString:@"黄冈"];
			break;
		case 714:
			[aCityName appendString:@"黄石"];
			break;
		case 715:
			[aCityName appendString:@"咸宁"];
			break;
		case 716:
			[aCityName appendString:@"荆州"];
			break;
		case 717:
			[aCityName appendString:@"宜昌"];
			break;
		case 718:
			[aCityName appendString:@"恩施"];
			break;
		case 719:
			[aCityName appendString:@"十堰"];
			break;
		case 722:
			[aCityName appendString:@"随州"];
			break;
		case 724:
			[aCityName appendString:@"荆门"];
			break;
		case 728:
			[aCityName appendString:@"江汉"];
			break;
		case 730:
			[aCityName appendString:@"岳阳"];
			break;
		case 731:
			[aCityName appendString:@"长沙"];
			break;
		case 732:
			[aCityName appendString:@"湘潭"];
			break;
		case 733:
			[aCityName appendString:@"株洲"];
			break;
		case 734:
			[aCityName appendString:@"衡阳"];
			break;
		case 735:
			[aCityName appendString:@"郴州"];
			break;
		case 736:
			[aCityName appendString:@"常德"];
			break;
		case 737:
			[aCityName appendString:@"益阳"];
			break;
		case 738:
			[aCityName appendString:@"娄底"];
			break;
		case 739:
			[aCityName appendString:@"邵阳"];
			break;
		case 743:
			[aCityName appendString:@"吉首"];
			break;
		case 744:
			[aCityName appendString:@"张家界"];
			break;
		case 745:
			[aCityName appendString:@"怀化"];
			break;
		case 746:
			[aCityName appendString:@"永州"];
			break;
		case 750:
			[aCityName appendString:@"江门"];
			break;
		case 751:
			[aCityName appendString:@"韶关"];
			break;
		case 752:
			[aCityName appendString:@"惠州"];
			break;
		case 753:
			[aCityName appendString:@"梅州"];
			break;
		case 754:
			[aCityName appendString:@"汕头"];
			break;
		case 755:
			[aCityName appendString:@"深圳"];
			break;
		case 756:
			[aCityName appendString:@"珠海"];
			break;
		case 757:
			[aCityName appendString:@"佛山"];
			break;
		case 758:
			[aCityName appendString:@"肇庆"];
			break;
		case 759:
			[aCityName appendString:@"湛江"];
			break;
		case 760:
			[aCityName appendString:@"中山"];
			break;
		case 762:
			[aCityName appendString:@"河源"];
			break;
		case 763:
			[aCityName appendString:@"清远"];
			break;
		case 766:
			[aCityName appendString:@"云浮"];
			break;
		case 768:
			[aCityName appendString:@"潮州"];
			break;
		case 769:
			[aCityName appendString:@"东莞"];
			break;
		case 770:
			[aCityName appendString:@"防城港"];
			break;
		case 771:
			[aCityName appendString:@"南宁"];
			break;
		case 772:
			[aCityName appendString:@"柳州"];
			break;
		case 773:
			[aCityName appendString:@"桂林"];
			break;
		case 774:
			[aCityName appendString:@"梧州"];
			break;
		case 775:
			[aCityName appendString:@"贵港"];
			break;
		case 776:
			[aCityName appendString:@"百色"];
			break;
		case 777:
			[aCityName appendString:@"钦州"];
			break;
		case 778:
			[aCityName appendString:@"河池"];
			break;
		case 779:
			[aCityName appendString:@"北海"];
			break;
		case 790:
			[aCityName appendString:@"新余"];
			break;
		case 791:
			[aCityName appendString:@"南昌"];
			break;
		case 792:
			[aCityName appendString:@"九江"];
			break;
		case 793:
			[aCityName appendString:@"上饶"];
			break;
		case 794:
			[aCityName appendString:@"抚州"];
			break;
		case 795:
			[aCityName appendString:@"宜春"];
			break;
		case 796:
			[aCityName appendString:@"吉安"];
			break;
		case 797:
			[aCityName appendString:@"赣州"];
			break;
		case 798:
			[aCityName appendString:@"景德镇"];
			break;
		case 799:
			[aCityName appendString:@"萍乡"];
			break;
	}
	
	return aCityName;
}


+(NSString*) processCityName_8:(NSInteger) aQuHao
{
	NSMutableString	*aCityName= nil;
	
	if ((830 <= aQuHao && 839 >= aQuHao) || (825 <= aQuHao && 827 >= aQuHao) || (812 <= aQuHao && 818 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"四川"];
	}
	else if ((851 <= aQuHao && 859 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"贵州"];
	}
	else if ((870 <= aQuHao && 888 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"云南"];
	}
	else if ((891 <= aQuHao && 897 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"西藏"];
	}
	else if ((898 <= aQuHao && 899 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"海南"];
	}
	else 
	{
		return nil;
	}
	
	
	switch (aQuHao)
	{
		case 812:
			[aCityName appendString:@"攀枝花"];
			break;
		case 813:
			[aCityName appendString:@"自贡"];
			break;
		case 816:
			[aCityName appendString:@"绵阳"];
			break;
		case 817:
			[aCityName appendString:@"南充"];
			break;
		case 818:
			[aCityName appendString:@"达州"];
			break;
		case 825:
			[aCityName appendString:@"遂宁"];
			break;
		case 826:
			[aCityName appendString:@"广安"];
			break;
		case 827:
			[aCityName appendString:@"巴中"];
			break;
		case 830:
			[aCityName appendString:@"泸州"];
			break;
		case 831:
			[aCityName appendString:@"宜宾"];
			break;
		case 832:
			[aCityName appendString:@"资阳"];
			break;
		case 833:
			[aCityName appendString:@"乐山"];
			break;
		case 834:
			[aCityName appendString:@"凉山"];
			break;
		case 835:
			[aCityName appendString:@"雅安"];
			break;
		case 836:
			[aCityName appendString:@"甘孜州"];
			break;
		case 837:
			[aCityName appendString:@"阿坝州"];
			break;
		case 838:
			[aCityName appendString:@"德阳"];
			break;
		case 839:
			[aCityName appendString:@"广元"];
			break;
		case 851:
			[aCityName appendString:@"贵阳"];
			break;
		case 852:
			[aCityName appendString:@"遵义"];
			break;
		case 853:
			[aCityName appendString:@"安顺"];
			break;
		case 854:
			[aCityName appendString:@"都匀"];
			break;
		case 855:
			[aCityName appendString:@"凯里"];
			break;
		case 856:
			[aCityName appendString:@"铜仁"];
			break;
		case 857:
			[aCityName appendString:@"毕节"];
			break;
		case 858:
			[aCityName appendString:@"六盘水"];
			break;
		case 859:
			[aCityName appendString:@"兴义"];
			break;
		case 870:
			[aCityName appendString:@"昭通"];
			break;
		case 871:
			[aCityName appendString:@"昆明"];
			break;
		case 872:
			[aCityName appendString:@"大理"];
			break;
		case 873:
			[aCityName appendString:@"红河"];
			break;
		case 874:
			[aCityName appendString:@"曲靖"];
			break;
		case 875:
			[aCityName appendString:@"保山"];
			break;
		case 876:
			[aCityName appendString:@"文山"];
			break;
		case 877:
			[aCityName appendString:@"玉溪"];
			break;
		case 878:
			[aCityName appendString:@"楚雄"];
			break;
		case 879:
			[aCityName appendString:@"思茅"];
			break;
		case 883:
			[aCityName appendString:@"临沧"];
			break;
		case 886:
			[aCityName appendString:@"怒江"];
			break;
		case 887:
			[aCityName appendString:@"迪庆"];
			break;
		case 888:
			[aCityName appendString:@"丽江"];
			break;
		case 891:
			[aCityName appendString:@"拉萨"];
			break;
		case 892:
			[aCityName appendString:@"日喀则"];
			break;
		case 893:
			[aCityName appendString:@"山南"];
			break;
		case 894:
			[aCityName appendString:@"林芝"];
			break;
		case 895:
			[aCityName appendString:@"昌都"];
			break;
		case 896:
			[aCityName appendString:@"那曲"];
			break;
		case 897:
			[aCityName appendString:@"阿里"];
			break;
		case 898:
			[aCityName appendString:@"海口"];
			break;
		case 899:
			[aCityName appendString:@"三亚"];
			break;
	}
	
	return aCityName;
}


+(NSString*) processCityName_9:(NSInteger) aQuHao
{
	NSMutableString* aCityName= nil;
	
	if ((901 <= aQuHao && 909 >= aQuHao) || (990 <= aQuHao && 999 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"新疆"];
	}
	else if ((910 <= aQuHao && 919 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"陕西"];
	}
	else if ((930 <= aQuHao && 943 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"甘肃"];
	}
	else if ((951 <= aQuHao && 955 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"宁夏"];
	}
	else if ((970 <= aQuHao && 979 >= aQuHao))
	{
		aCityName= [NSMutableString stringWithString:@"青海"];
	}
	else
	{
		return nil;
	}
	
	switch (aQuHao)
	{
		case 901:
			[aCityName appendString:@"塔城"];
			break;
		case 902:
			[aCityName appendString:@"哈密"];
			break;
		case 903:
			[aCityName appendString:@"和田"];
			break;
		case 906:
			[aCityName appendString:@"阿勒泰"];
			break;
		case 908:
			[aCityName appendString:@"克州"];
			break;
		case 909:
			[aCityName appendString:@"博乐"];
			break;
		case 910:
			[aCityName appendString:@"咸阳"];
			break;
		case 911:
			[aCityName appendString:@"延安"];
			break;
		case 912:
			[aCityName appendString:@"榆林"];
			break;
		case 913:
			[aCityName appendString:@"渭南"];
			break;
		case 914:
			[aCityName appendString:@"商洛"];
			break;
		case 915:
			[aCityName appendString:@"安康"];
			break;
		case 916:
			[aCityName appendString:@"汉中"];
			break;
		case 917:
			[aCityName appendString:@"宝鸡"];
			break;
		case 919:
			[aCityName appendString:@"铜川"];
			break;
		case 930:
			[aCityName appendString:@"临夏"];
			break;
		case 931:
			[aCityName appendString:@"兰州"];
			break;
		case 932:
			[aCityName appendString:@"定西"];
			break;
		case 933:
			[aCityName appendString:@"平凉"];
			break;
		case 934:
			[aCityName appendString:@"庆阳"];
			break;
		case 935:
			[aCityName appendString:@"武威"];
			break;
		case 936:
			[aCityName appendString:@"张掖"];
			break;
		case 937:
			[aCityName appendString:@"酒泉"];
			break;
		case 938:
			[aCityName appendString:@"天水"];
			break;
		case 939:
			[aCityName appendString:@"陇南"];
			break;
		case 941:
			[aCityName appendString:@"甘南"];
			break;
		case 943:
			[aCityName appendString:@"白银"];
			break;
		case 951:
			[aCityName appendString:@"银川"];
			break;
		case 952:
			[aCityName appendString:@"石嘴山"];
			break;
		case 953:
			[aCityName appendString:@"吴忠"];
			break;
		case 954:
			[aCityName appendString:@"固原"];
			break;
		case 955:
			[aCityName appendString:@"中卫"];
			break;
		case 970:
			[aCityName appendString:@"海晏"];
			break;
		case 971:
			[aCityName appendString:@"西宁"];
			break;
		case 972:
			[aCityName appendString:@"海东"];
			break;
		case 973:
			[aCityName appendString:@"黄南"];
			break;
		case 974:
			[aCityName appendString:@"共和"];
			break;
		case 975:
			[aCityName appendString:@"果洛"];
			break;
		case 976:
			[aCityName appendString:@"玉树"];
			break;
		case 977:
			[aCityName appendString:@"德令哈"];
			break;
		case 979:
			[aCityName appendString:@"格尔木"];
			break;
		case 990:
			[aCityName appendString:@"克拉玛依"];
			break;
		case 991:
			[aCityName appendString:@"乌鲁木齐"];
			break;
		case 992:
			[aCityName appendString:@"奎屯"];
			break;
		case 993:
			[aCityName appendString:@"石河子"];
			break;
		case 994:
			[aCityName appendString:@"昌吉"];
			break;
		case 995:
			[aCityName appendString:@"吐鲁番"];
			break;
		case 996:
			[aCityName appendString:@"库尔勒"];
			break;
		case 997:
			[aCityName appendString:@"阿克苏"];
			break;
		case 998:
			[aCityName appendString:@"喀什"];
			break;
		case 999:
			[aCityName appendString:@"伊犁"];
			break;
	}
	return aCityName;
}

//根据区号获取城名称
+(NSString*) GetCityName:(NSInteger) nQuHao
{
	if (10 == nQuHao)
	{
		return @"北京";
	}
	else if (20 == nQuHao)
	{
		return @"广东广州";
	}
	else if (21 == nQuHao)
	{
		return @"上海";
	}
	else if (22 == nQuHao)
	{
		return @"天津";
	}
	else if (23 == nQuHao)
	{
		return @"重庆";
	}
	else if (24 == nQuHao)
	{
		return @"辽宁沈阳";
	}
	else if (25 == nQuHao)
	{
		return @"江苏南京";
	}
	else if (27 == nQuHao)
	{
		return @"湖北武汉";
	}
	else if (28 == nQuHao)
	{
		return @"四川成都";
	}
	else if (29 == nQuHao)
	{
		return @"陕西西安";
	}
	
	else if (nQuHao > 300 && nQuHao < 400)
	{
		return [CallsAttribution processCityName_3:nQuHao];
	}
	else if (nQuHao > 400 && nQuHao < 500)
	{
		return [CallsAttribution processCityName_4:nQuHao];
	}
	else if (nQuHao > 500 && nQuHao < 600)
	{
		return [CallsAttribution processCityName_5:nQuHao];
	}
	else if (nQuHao > 600 && nQuHao < 700)
	{
		return [CallsAttribution processCityName_6:nQuHao];
	}
	else if (nQuHao > 700 && nQuHao < 800)
	{
		return [CallsAttribution processCityName_7:nQuHao];
	}
	else if (nQuHao > 800 && nQuHao < 900)
	{
		return [CallsAttribution processCityName_8:nQuHao];
	}
	else if (nQuHao > 900 && nQuHao < 1000)
	{
		return [CallsAttribution processCityName_9:nQuHao];
	}
	else
	{
		return nil;
	}
}


//============特殊号码的归属地查询
+ (NSString*) processSpecialPhNum: (NSString*) phone
{
	
	return nil;
}

+ (NSString*) processFixedPhNum: (NSString*) phone
{
	
	if ((unichar)'0'==[phone characterAtIndex:0])
	{
		if ( (unichar)'1'==[phone characterAtIndex:1])
		{
			return @"北京";
		}
		else if ( (unichar)'2' == [phone characterAtIndex:1])
		{
			NSString* sPhNumUn= [phone substringWithRange:NSMakeRange(1, 2)];
			if (nil==sPhNumUn)
				return nil;
			else
				return [CallsAttribution GetCityName:[sPhNumUn intValue]];
		}
		else
		{
			NSString* sPhNumUn= [phone substringWithRange:NSMakeRange(1, 3)];
			if (nil==sPhNumUn)
				return nil;
			else
				return [CallsAttribution GetCityName:[sPhNumUn intValue]];
		}
	}
	
	return nil;
}

//============手机号码的归属地查询
+ (NSString*) processMobilePhNum: (NSString*) phone
{
	if ([phone length]<11)
		return nil;
	
	NSString* nPhNum= [phone substringFromIndex:[phone length]-11];
	
	if ([phone characterAtIndex:0]==(unichar)'0') 
	{
		return [CallsAttribution processFixedPhNum: phone];
	}
	
	NSInteger n3rdInt= [ [nPhNum substringWithRange:NSMakeRange(2, 1)] intValue ];
	
	NSInteger nRelativeOffset = 0;
	NSInteger nReadFilePos = 0;
	unichar	  numChar= [nPhNum characterAtIndex:1];
	if (numChar==(unichar)'3')
	{
		nRelativeOffset = KTY_PHNUM_FILE_VERSION_LEN + KTY_PHNUM_FILE_MAXID_LEN + (0 + n3rdInt) * 20000;
	}
	else if (numChar==(unichar)'5')
	{
		nRelativeOffset = KTY_PHNUM_FILE_VERSION_LEN + KTY_PHNUM_FILE_MAXID_LEN + (10 + n3rdInt) * 20000;
	}
	else if (numChar==(unichar)'8')
	{
		nRelativeOffset = KTY_PHNUM_FILE_VERSION_LEN + KTY_PHNUM_FILE_MAXID_LEN + (20 + n3rdInt) * 20000;
	}
	else
	{
		return nil;
	}
	
	NSString* nFourBuf= [nPhNum substringWithRange:NSMakeRange(3, 4)];
	nReadFilePos = nRelativeOffset + [nFourBuf intValue] * 2;
	
	NSInteger nQuHao = [CallsAttribution ReadUint16:nReadFilePos];
	if (nQuHao != -1)
	{
		return [CallsAttribution GetCityName:nQuHao];
	}
	return nil;	
}

//=======查询手机号码对应的归属地
+ (NSString*) attributionOfPhone: (NSString*) phone
{
	if (nil==phone)
		return nil;
	
	NSInteger nPhNumLen = [phone length];
	if (nPhNumLen < 8)
	{
		return [CallsAttribution processSpecialPhNum:phone];
	}
	else if (nPhNumLen < 11)
	{
		return [CallsAttribution processFixedPhNum:phone];
	}
	else
	{
		return [CallsAttribution processMobilePhNum:phone];
	}
}


//=======查询手机号码对应的电话供应商
+ (NSString*) providerOfPhone: (NSString*) phone
{
    if (nil == phone||phone.length<3) {
        return nil;
    }
	static NSDictionary *dictQuery= nil;
	
	if (dictQuery==nil)
	{
		NSString* provider1= @"移动";
		NSString* provider2= @"联通";
		NSString* provicer3= @"电信";
		
		dictQuery= [NSDictionary dictionaryWithObjectsAndKeys:
					provider1, @"134", provider1, @"135",
					provider1, @"136", provider1, @"137",
					provider1, @"138", provider1, @"139",provider1, @"147",
					provider1, @"150", provider1, @"151",provider1, @"152",
					provider1, @"157", provider1, @"158",
					provider1, @"159", provider1, @"182",provider1, @"187",
					provider1, @"188",
					
					provider2, @"130", provider2, @"131",
					provider2, @"132", 
					provider2, @"155", provider2, @"156",
					provider2, @"185", provider2, @"186",
					
					provicer3, @"133", provicer3, @"153",
					provicer3, @"180", provicer3, @"189",
					nil];
		[dictQuery retain];//==========静态字典 [会有内存泄漏吗]
		
		//NSLog(@"providerOfPhone's query dictionary init");
	}
	
	NSMutableString *phoneDo= [NSMutableString stringWithString:phone];
	[phoneDo stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];
	
	NSRange	  range=	{0, 3};
	NSString* prefix=	[phoneDo substringWithRange:range];
	
	if (prefix)
	{
		NSString* provider= [dictQuery objectForKey:prefix];
		return provider;
	}
	return nil;
}


@end
