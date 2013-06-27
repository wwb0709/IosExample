//
//  StartScene.h
//  playcard
//
//  Created by wangwb on 13-6-27.
//
//

#ifndef __playcard__StartScene__
#define __playcard__StartScene__

#include <iostream>
#include "cocos2d.h"
#include "ProgressBar.h"
#include "ProgressProtocol.h"
#include "CCAccelerometerDelegate.h"
USING_NS_CC;
class StartLayer: public CCLayer, public ProgressDelegate{
    float _PointsPerSecY;
public:
    static cocos2d::CCScene* scene();
    bool init();
    CREATE_FUNC(StartLayer);
    void loadingFinished();
    void progressPercentageSetter(float percentage);
    
    void didAccelerate(CCAcceleration* pAccelerationValue);
    void update(float dt);
protected:
    ProgressBar* _progressBar;
    cocos2d::CCLabelTTF* _progressFg;
    void transition();
    void loading();
    void cacheInit();
    void audioAndUserDataInit();
    void initializationCompleted();
};
#endif /* defined(__playcard__StartScene__) */
