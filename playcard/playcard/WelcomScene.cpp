//
//  WelcomScene.cpp
//  playcard
//
//  Created by wangwb on 13-6-6.
//
//

#include "WelcomScene.h"
#include "GameScene.h"
#include "UtilTool.h"

CCScene* Welcome::scene()
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    Welcome *layer = Welcome::create();
    
    // add layer as a child to scene
    scene->addChild(layer);
    
    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool Welcome::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !CCLayer::init() )
    {
        return false;
    }
    
    /////////////////////////////
    // 2. add a menu item with "X" image, which is clicked to quit the program
    //    you may modify it.
    
    // add a "close" icon to exit the progress. it's an autorelease object
    CCMenuItemImage *pCloseItem = CCMenuItemImage::create(
                                                          "CloseNormal.png",
                                                          "CloseSelected.png",
                                                          this,
                                                          menu_selector(Welcome::StartGame) );
    pCloseItem->setPosition( ccp(CCDirector::sharedDirector()->getWinSize().width - 20, 20) );
    
    // create menu, it's an autorelease object
    CCMenu* pMenu = CCMenu::create(pCloseItem, NULL);
    pMenu->setPosition( CCPointZero );
    this->addChild(pMenu, 1);
    
    /////////////////////////////
    // 3. add your codes below...
    
    // add a label shows "Hello World"
    // create and initialize a label
    CCLabelTTF* pLabel = CCLabelTTF::create("欢迎", "Thonburi", 34);
    
    // ask director the window size
    CCSize size = CCDirector::sharedDirector()->getWinSize();
    
    // position the label on the center of the screen
    pLabel->setPosition( ccp(size.width / 2, size.height - 20) );
    
    // add the label as a child to this layer
    this->addChild(pLabel, 1);
    
    // add "HelloWorld" splash screen"
    CCSprite* pSprite = CCSprite::create("HelloWorld.png");
    
    // position the sprite on the center of the screen
    pSprite->setPosition( ccp(size.width / 2, size.height/2) );
    pSprite->setTag(110);
    // add the sprite as a child to this layer
    this->addChild(pSprite, 3);
    
  
 	CCActionInterval *actionTo = CCScaleTo::create(2.0f, 2.0f, 0.5f);
	CCActionInterval *actionBy = CCScaleBy::create(2.0f, 0.5f, 2.0f);
    CCActionInterval *moveBy  = CCMoveBy::create(1,ccp(-50,-50) );
//	CCActionInterval *actionByCopy = CCScaleBy::create(2.0f, 0.5f, 2.0f);
//	CCActionInterval *actionBack = actionByCopy->reverse();
    
//	pSprite->runAction(CCSpawn::create(actionTo, actionBy,moveBy, NULL));
    
    
    CCActionInterval*  move = CCMoveBy::create(1, CCPointMake(150,0));
    CCFiniteTimeAction*  action = CCSequence::create( move, CCDelayTime::create(2), move, NULL);
    
    pSprite->runAction(action);

    //////////////////////////////////////////////
    CCSize s = CCDirector::sharedDirector()->getWinSize();
    CCArray *aniframe=CCArray::createWithCapacity(4);
    CCSprite *sprite;
    char str[20];
    for(int i=0;i<4;i++){
        
        sprintf(str,"A1_%d.png",i);
        CCSpriteFrame *frame =CCSpriteFrame::create(str,CCRectMake(0,0,64,64));
        if(i==0){
            sprite =CCSprite::createWithSpriteFrame(frame);
            sprite->setPosition(ccp(sprite->getContentSize().width,s.height/2));
            addChild(sprite);
        }
        aniframe->addObject(frame);
    }
    CCAnimation *animation=CCAnimation::createWithSpriteFrames(aniframe,0.2f);
    CCAnimate *animate=CCAnimate::create(animation);
    CCActionInterval* seq=(CCActionInterval*)(CCSequence::create(animate,
                                                                 CCFlipX::create(true),
                                                                 animate->copy()->autorelease(),
                                                                 CCFlipX::create(false),
                                                                 NULL
                                                                 ));
    
    sprite->runAction(CCRepeatForever::create(seq));
    
    //----------------end
    
    //------------------sprite split-----------------//
    
    CCTexture2D *texture=CCTextureCache::sharedTextureCache()->addImage("split.png");
    CCArray *splitAniframe=CCArray::createWithCapacity(16);
    CCSprite *splitSprite ;
    for(int i=0;i<4;i++){
        for(int j=0;j<4;j++)
        {
            CCSpriteFrame *frame =CCSpriteFrame::createWithTexture(texture,CCRectMake(32*j,48*i,32,48));
            if(i==0){
                splitSprite= CCSprite::createWithSpriteFrame(frame);
                splitSprite->setPosition(ccp(s.width/2,s.height/2));
                splitSprite->setTag(112);
                addChild(splitSprite);
            }
            splitAniframe->addObject(frame);
        }
    }
    CCAnimation *splitAnimation=CCAnimation::createWithSpriteFrames(splitAniframe,1.0f);
    CCAnimate *splitAnimate=CCAnimate::create(splitAnimation);
    splitSprite->runAction(CCRepeatForever::create(splitAnimate));
    //------------------end
    
    
    //------------------sprite use plist--------------------
    
    CCSpriteFrameCache* cache =CCSpriteFrameCache::sharedSpriteFrameCache();
    cache->addSpriteFramesWithFile("attack.plist");
    CCSprite *plistSprite=CCSprite::createWithSpriteFrameName("A1_0.png");
    plistSprite->setPosition(ccp(CCDirector::sharedDirector()->getWinSize().width/2,CCDirector::sharedDirector()->getWinSize().height/2));
    CCSpriteBatchNode* spritebatch =CCSpriteBatchNode::create("attack.png");
    plistSprite->setTag(113);
    spritebatch->addChild(plistSprite);
    spritebatch->setTag(115);
    addChild(spritebatch);
    
    CCArray* plistArray=CCArray::createWithCapacity(4);
    char name[20];
    for(int i=0;i<4;i++){
        sprintf(name,"A1_%d.png",i);
        CCSpriteFrame* frame =cache->spriteFrameByName(name);
        plistArray->addObject(frame);
    }
    
    CCAnimation *plitAnimation=CCAnimation::createWithSpriteFrames(plistArray,0.2f);
    CCAnimate *plitAnimate=CCAnimate::create(plitAnimation);
    CCActionInterval* plitSeq=(CCActionInterval*)(CCSequence::create(plitAnimate,
                                                                     CCFlipX::create(true),
                                                                     plitAnimate->copy()->autorelease(),
                                                                     CCFlipX::create(false),
                                                                     NULL
                                                                     ));
    
    plistSprite->runAction(CCRepeatForever::create(plitSeq));
    
    
    
//    this->scheduleUpdate();
    return true;
}

void Welcome::update( float dt )
{
//    CCSprite* s = (CCSprite*)this->getChildByTag(110);
//    CCPoint p = s->getPosition();
//    p.x += 2;
//    p.y += 2;
//    s->setPosition(p);
    
    
    CCSpriteBatchNode* spritebatch =(CCSpriteBatchNode*)this->getChildByTag(115);
    CCSprite* s2 = (CCSprite*)spritebatch->getChildByTag(113);
    CCPoint p2 = s2->getPosition();
    p2.x += 2;
    p2.y += 2;
    s2->setPosition(p2);
    
    
//    UtilTool::sharedUtilTool()->moveWithBezier(s,s->getPosition(),p ,20);
}


void Welcome::StartGame(CCObject* pSender)
{
    CCScene* scene = Game::scene();
    
    scene->retain();
    //左翻页效果替换
    CCDirector::sharedDirector()->pushScene(CCTransitionFade::create(3, scene,ccGRAY));
    scene->release();
}