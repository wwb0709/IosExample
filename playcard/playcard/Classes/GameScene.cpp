#include "GameScene.h"
#include "SimpleAudioEngine.h"
#include "CardSprite.h"
using namespace cocos2d;
using namespace CocosDenshion;

CCScene* Game::scene()
{
    // 'scene' is an autorelease object
    CCScene *scene = CCScene::create();
    
    // 'layer' is an autorelease object
    Game *layer = Game::create();

    // add layer as a child to scene
    scene->addChild(layer);

    // return the scene
    return scene;
}

// on "init" you need to initialize your instance
bool Game::init()
{
    //////////////////////////////
    // 1. super init first
    if ( !CCLayer::init() )
    {
        return false;
    }

    loadBg();
    loadCards();
    
    CCSize size = CCDirector::sharedDirector()->getWinSize();
    char name[20];

     CCSpriteFrameCache* cache =CCSpriteFrameCache::sharedSpriteFrameCache();
    CCArray * sArr = CCArray::create();
    for(int i=1;i<14;i++){
        sprintf(name,"FP%d.BMP",i);
        CCSpriteFrame* frame =cache->spriteFrameByName(name);
        
        CardSprite* sprite =CardSprite::createWithFrame(frame);
        sprite->setPosition(ccp(-50,-50));
        sprite->setTag(i);
        sArr->addObject(sprite);
        addChild(sprite);
    }
    CCObject* pObj;
    int i=1;
    CCARRAY_FOREACH(sArr, pObj)
    {
        CardSprite* cs = (CardSprite*)pObj;
     	CCActionInterval *actionTo = CCMoveTo::create(4.0f,
                                                      ccp(140+i*25,size.height/4));
        cs->runAction(actionTo);
        i++;
    }

    
//    CardSprite* sprite =CardSprite::createWithFrame(frame);
//    sprite->setPosition(ccp(140+i*25,size.height/4));
//    sprite->setTag(i);
//    this->addChild(sprite, 4);
    
    
    
    return true;
}



void Game::loadBg()
{
    CCSize size = CCDirector::sharedDirector()->getWinSize();
    CCSprite* bg = CCSprite::create("bg.jpg");
    bg->setPosition( ccp(size.width/2, size.height/2) );
    this->addChild(bg, -1);
    CCSprite* table = CCSprite::create("table.jpg");
    table->setPosition( ccp(size.width/2, size.height/2) );
    this->addChild(table, 0);
}
void Game::loadCards()
{
    CCSpriteFrameCache* cache =CCSpriteFrameCache::sharedSpriteFrameCache();
    cache->addSpriteFramesWithFile("pukepai.plist");
}
void Game::menuCloseCallback(CCObject* pSender)
{
    CCDirector::sharedDirector()->popToRootScene();
}
