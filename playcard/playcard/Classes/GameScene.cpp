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

    /////////////////////////////
    // 2. add a menu item with "X" image, which is clicked to quit the program
    //    you may modify it.

    // add a "close" icon to exit the progress. it's an autorelease object
    CCMenuItemImage *pCloseItem = CCMenuItemImage::create(
                                        "CloseNormal.png",
                                        "CloseSelected.png",
                                        this,
                                        menu_selector(Game::menuCloseCallback) );
    pCloseItem->setPosition( ccp(CCDirector::sharedDirector()->getWinSize().width - 20, 20) );

    // create menu, it's an autorelease object
    CCMenu* pMenu = CCMenu::create(pCloseItem, NULL);
    pMenu->setPosition( CCPointZero );
    this->addChild(pMenu, 1);

    /////////////////////////////
    // 3. add your codes below...

    // add a label shows "Hello World"
    // create and initialize a label
    CCLabelTTF* pLabel = CCLabelTTF::create("Hello World", "Thonburi", 34);

    // ask director the window size
    CCSize size = CCDirector::sharedDirector()->getWinSize();

    // position the label on the center of the screen
    pLabel->setPosition( ccp(size.width / 2, size.height - 20) );

    // add the label as a child to this layer
    //this->addChild(pLabel, 1);

    // add "HelloWorld" splash screen"
    CCSprite* pSprite = CCSprite::create("HelloWorld.png");

    // position the sprite on the center of the screen
    pSprite->setPosition( ccp(size.width/2, size.height/2) );

    // add the sprite as a child to this layer
    //this->addChild(pSprite, 0);
    this->loadBg();
    this->loadCards();
    
    char name[20];
//    CCArray* plistArray=CCArray::createWithCapacity(14);
     CCSpriteFrameCache* cache =CCSpriteFrameCache::sharedSpriteFrameCache();
    for(int i=1;i<14;i++){
        sprintf(name,"FP%d.BMP",i);
        CCSpriteFrame* frame =cache->spriteFrameByName(name);
        
        CardSprite* sprite =CardSprite::createWithFrame(frame);
        sprite->setPosition(ccp(140+i*25,size.height/4));
        sprite->setTag(i);
        this->addChild(sprite, 4);
    }
    
    
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
    CCSprite *plistSprite=CCSprite::createWithSpriteFrameName("FP1.BMP");
    plistSprite->setPosition(ccp(CCDirector::sharedDirector()->getWinSize().width/2,CCDirector::sharedDirector()->getWinSize().height/2));
    CCSpriteBatchNode* spritebatch =CCSpriteBatchNode::create("pukepai.png");
//    spritebatch->addChild(plistSprite);
//    addChild(spritebatch);
//
//    CCArray* plistArray=CCArray::createWithCapacity(14);
//    char name[200];
//    for(int i=1;i<14;i++){
//        sprintf(name,"FP%d.BMP",i);
//        CCSpriteFrame* frame =cache->spriteFrameByName(name);
//        plistArray->addObject(frame);
//    }
//    
//    CCAnimation *plitAnimation=CCAnimation::createWithSpriteFrames(plistArray,0.3f);
//    CCAnimate *plitAnimate=CCAnimate::create(plitAnimation);
//    CCActionInterval* plitSeq=(CCActionInterval*)(CCSequence::create(plitAnimate,
//                                                                     CCFlipX::create(false),
//                                                          
//                                                                     NULL
//                                                                     ));
//    
//    plistSprite->runAction(CCRepeatForever::create(plitSeq));

}
void Game::menuCloseCallback(CCObject* pSender)
{
    CCDirector::sharedDirector()->popToRootScene();
//    CCDirector::sharedDirector()->end();
//
//#if (CC_TARGET_PLATFORM == CC_PLATFORM_IOS)
//    exit(0);
//#endif
}
