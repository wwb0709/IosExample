//
//  StartScene.cpp
//  playcard
//
//  Created by wangwb on 13-6-27.
//
//

#include "StartScene.h"
#include "StartScene.h"
#include "GameScene.h"
#include "PersonalAudioEngine.h"
#include "StaticData.h"
//#include "Fish.h"
#include "UserData.h"
#include "WelcomScene.h"
#include "GameScene.h"
USING_NS_CC;
using namespace CocosDenshion;
CCScene* StartLayer::scene()
{
    CCScene* scene = CCScene::create();
    StartLayer* layer = StartLayer::create();
    scene->addChild(layer);
    return scene;
}
bool StartLayer::init()
{
    if(CCLayer::init()){
        this->setAccelerometerEnabled(true);
         this->scheduleUpdate();  
        CCSize winSize = CCDirector::sharedDirector()->getWinSize();
        
//        CCSprite* background = CCSprite::create(STATIC_DATA_STRING("background"));
//        background->setPosition(CCPointMake(winSize.width*0.5, winSize.height*0.5));
//        this->addChild(background);
        
        CCSprite* title = CCSprite::create(STATIC_DATA_STRING("title"));
        title->setScale(4);
        title->setPosition(CCPointMake(winSize.width*0.5, winSize.height*0.5));
        title->setTag(10000);
        this->addChild(title);

        if(CCDirector::sharedDirector()->getTotalFrames()<10){
            CCTextureCache::sharedTextureCache()->addImageAsync(STATIC_DATA_STRING("fishingjoy_texture"), this, callfuncO_selector(StartLayer::loading));
            
            CCSprite* progressBg = CCSprite::create(STATIC_DATA_STRING("progress_bg"));
            _progressFg = CCLabelTTF::create("0/100", "Thonburi", 16);
            _progressFg->setColor(ccc3(0, 0, 0));
            
            _progressBar = ProgressBar::create(this, CCSprite::create(STATIC_DATA_STRING("progress_bar")));
            _progressBar->setBackground(progressBg);
            _progressBar->setForeground(_progressFg);
            _progressBar->setPosition(CCPointMake(winSize.width*0.5, winSize.height*0.5));
            _progressBar->setSpeed(100.0);
            this->addChild(_progressBar);
            
            this->audioAndUserDataInit();
        }else{
            this->initializationCompleted();
        }
        
        return true;
    }
    return false;
}
void StartLayer::audioAndUserDataInit()
{
    FishingJoyData::sharedFishingJoyData();
    PersonalAudioEngine::sharedEngine();
}
void StartLayer::loading()
{
    _progressBar->progressTo(100.0);
}
void StartLayer::transition()
{
    CCScene* scene = CCTransitionFadeDown::create(1.0f,Game::scene());
    CCDirector::sharedDirector()->replaceScene(scene);
}
void StartLayer::cacheInit()
{
    CCSpriteFrameCache::sharedSpriteFrameCache()->addSpriteFramesWithFile("fishingjoy_resource.plist");
    
    int frameCount = STATIC_DATA_INT("fish_frame_count");
    for (int type = 0; type < 1; type++)
    {
        CCArray* spriteFrames = CCArray::createWithCapacity(frameCount);
        for(int i = 0;i < frameCount;i++){
            CCString* filename = CCString::createWithFormat(STATIC_DATA_STRING("fish_frame_name_format"),type,i);
            CCSpriteFrame* spriteFrame = CCSpriteFrameCache::sharedSpriteFrameCache()->spriteFrameByName(filename->getCString());
            spriteFrames->addObject(spriteFrame);
        }
        CCAnimation* fishAnimation = CCAnimation::createWithSpriteFrames(spriteFrames);
        fishAnimation->setDelayPerUnit(STATIC_DATA_FLOAT("fish_frame_delay"));
        CCString* animationName = CCString::createWithFormat(STATIC_DATA_STRING("fish_animation"), type);
        CCAnimationCache::sharedAnimationCache()->addAnimation(fishAnimation, animationName->getCString());
    }
}
void StartLayer::initializationCompleted()
{
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    CCMenuItemSprite* start = CCMenuItemSprite::create(CCSprite::createWithSpriteFrameName(STATIC_DATA_STRING("start_normal")), CCSprite::createWithSpriteFrameName(STATIC_DATA_STRING("start_selected")), this, menu_selector(StartLayer::transition));
    CCMenu* menu = CCMenu::create(start, NULL);
    menu->setPosition(CCPointMake(winSize.width*0.5, winSize.height*0.4));
    this->removeChild(_progressBar, true);
    this->addChild(menu);
    PersonalAudioEngine::sharedEngine()->playBackgroundMusic(STATIC_DATA_STRING("bg_music"));
}
void StartLayer::loadingFinished()
{
    this->cacheInit();
    this->initializationCompleted();
}
void StartLayer::progressPercentageSetter(float percentage)
{
    CCString* str = CCString::createWithFormat("%d/100",(int)percentage);
    _progressFg->setString(str->getCString());
}



void StartLayer::update(float dt)
{
    CCSprite* title = (CCSprite*)this->getChildByTag(10000);
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    
    float maxY = winSize.height - title->getContentSize().height/2;
    
    float minY = title->getContentSize().height/2;
    
    float diff = (_PointsPerSecY * dt) ;
    
    float newY = title->getPosition().y + diff;
    
    newY = MIN(MAX(newY, minY), maxY);
    
    title->setPosition(ccp(title->getPosition().x, newY));
    
}
void StartLayer::didAccelerate(CCAcceleration *pAccelerationValue){
    
    //pAccelerationValue包含x,y,z三个方向的重力值（由手机在这3个方向的偏移决定）
    CCLog("didAccelerate");
#define KFILTERINGFACTOR 0.1
    
#define KRESTACCELX -0.6
    
#define KSHIPMAXPOINTSPERSEC (winSize.height*0.5)
    
#define KMAXDIFFX 0.2
    
    double rollingX ;
    
    // Cocos2DX inverts X and Y accelerometer depending on device orientation
    
    // in landscape mode right x=-y and y=x !!! (Strange and confusing choice)
    
    pAccelerationValue->x = pAccelerationValue->y ;
    
    rollingX = (pAccelerationValue->x * KFILTERINGFACTOR) + (rollingX * (1.0 - KFILTERINGFACTOR));
    
    float accelX = pAccelerationValue->x - rollingX ;
    
    CCSize winSize = CCDirector::sharedDirector()->getWinSize();
    
    float accelDiff = accelX - KRESTACCELX;
    
    float accelFraction = accelDiff / KMAXDIFFX;
    
    _PointsPerSecY = KSHIPMAXPOINTSPERSEC * accelFraction;
    
    
}