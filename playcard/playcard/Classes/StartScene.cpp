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



//定义宏，限定_pos的有效范围值。
#define FIX_POS(_pos, _min, _max) \
if (_pos < _min)        \
_pos = _min;        \
else if (_pos > _max)   \
_pos = _max;        \


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
//         this->scheduleUpdate();  
        CCSize winSize = CCDirector::sharedDirector()->getWinSize();
        
//        CCSprite* background = CCSprite::create(STATIC_DATA_STRING("background"));
//        background->setPosition(CCPointMake(winSize.width*0.5, winSize.height*0.5));
//        this->addChild(background);
        
        CCSprite* title = CCSprite::create(STATIC_DATA_STRING("title"));
//        title->setScale(4);
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
void StartLayer::onEnter()
{
    //调用基类的相应函数。
    CCLayer::onEnter();
    //设置开启响应加速键
    setAccelerometerEnabled(true);
    scheduleUpdate();
    
}
void StartLayer::audioAndUserDataInit()
{
    FishingJoyData::sharedFishingJoyData();
//    PersonalAudioEngine::sharedEngine();
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
    return;
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
    CCDirector* pDir = CCDirector::sharedDirector();
    CCSize winSize   = pDir->getWinSize();
    
    //判断小球精灵是否有效。
    if ( title == NULL ) {
        return;
    }
    //取得小球的图像区域大小。
    CCSize ballSize  = title->getContentSize();
    //取得小球的当前位置。
    CCPoint ptNow  = title->getPosition();
    //将当前位置转换成界面坐标系的位置。
    CCPoint ptTemp = pDir->convertToUI(ptNow);
    //由收到的速度乘以一个系数后来影响位置。
    ptTemp.x += posChange.x;
    ptTemp.y -= posChange.y;
    //再转换为OPENGL坐标系的位置。貌似有点麻烦，其实直接在上面X,Y的加减上做上正确的方向即可。
    CCPoint ptNext = pDir->convertToGL(ptTemp);
    //限定位置的X,Y的有效范围，等于小球边缘始终在窗口内。
    FIX_POS(ptNext.x, (ballSize.width / 2.0), (winSize.width - ballSize.width / 2.0));
    FIX_POS(ptNext.y, (ballSize.height / 2.0), (winSize.height - ballSize.height / 2.0));
    //将位置传给小球。
    title->setPosition(ptNext);
    

}
void StartLayer::didAccelerate(CCAcceleration *pAccelerationValue){
    
    posChange.x = pAccelerationValue->x * 9.81f;
    posChange.y = pAccelerationValue->y * 9.81f;
}