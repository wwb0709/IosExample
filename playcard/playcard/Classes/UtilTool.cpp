//
//  UtilTool.cpp
//  playcard
//
//  Created by wangwb on 13-6-6.
//
//
#include "UtilTool.h"
#include <string>
#include "json.h"
using namespace std;
static UtilTool *utilt = NULL;
UtilTool::UtilTool(void)
{

}
UtilTool::~UtilTool(void)
{
}
bool UtilTool::init(void)
{
    
    return true;
}
UtilTool* UtilTool::sharedUtilTool(void)
{
    if (!utilt)
    {
        utilt = new UtilTool();
        utilt->init();
    }
    
    return utilt;
}
CCSize UtilTool::getScreenSize()
{

    return CCSize(0, 0);
}
void UtilTool::moveWithBezier(CCSprite*mSprite,CCPoint startPoint ,CCPoint endPoint ,float time){
    float sx = startPoint.x;
    float sy = startPoint.y;
    float ex =endPoint.x+50;
    float ey =endPoint.y+150;
    
    int h = mSprite->getContentSize().height*0.5;
    ccBezierConfig bezier; // 创建贝塞尔曲线
    bezier.controlPoint_1 = ccp(sx, sy); // 起始点
    bezier.controlPoint_2 = ccp(sx+(ex-sx)*0.5, sy+(ey-sy)*0.5+200); //控制点
    bezier.endPosition = ccp(endPoint.x-30, endPoint.y+h); // 结束位置
    CCBezierTo *actionMove =CCBezierTo::create(time, bezier);
    //    [mSprite runAction:actionMove];
    mSprite->runAction(actionMove);
}


void UtilTool::getMessageByType(MESSAGE_TYPE t,const char* content)
{
//    uint8_t head1=0x13;//0位 固定标识
//    
//    uint8_t head2=0x14;//1位 固定标识
//    
//    uint16_t length=htons(2+strlen(content)+2+2);//2-3位 包长度(包头＋包体)
//    
//    uint16_t type=htons(t);//4-5位 命令编号
//    
//    
//    uint16_t packlength = 100;
//    
//    char request[2];
//    request[0] = head1;
//    request[1] = head2;
////    memset(request, 0, sizeof(request));
////    sprintf(request, "wwb");
//    
//    int i = 100;
//    
//    sprintf(request, "%x", htons(i));
//    strcat(request,content);
//
//    cocos2d::CCLog("========= %s \n\n",request);
//    
//    
//    printf("%x\n",htons(0x4020));
//    
//    
//    
//
//    char temp[100];//临时字符串，
//    
//    char *value = (char*)malloc(sizeof(char) * 100);//动态分配空间
//    
//    strcpy(value, "test");//将value初始化为test
//    for(int j = 1; j <= 10; j++)
//    {
//        itoa1(j, temp, 10);//将数字转化为字符串
//        strcat(value, temp);//连接字符串
//        printf("%s\n", value);
//    }
//    free(value);
    
    
    
    // more data
//    cout << endl << "example 2:" << endl;
//    string test = "{\"array\":[{\"id\":1,\"name\":\"hello\"},{\"id\":2,\"name\":\"world\"}]}";
//    Json::Reader reader;
//    Json::Value value;
//    if (reader.parse(test, value)) {
//        const Json::Value arrayObj = value["array"];
//        for (size_t i=0; i<arrayObj.size(); i++) {
//            int id = arrayObj[i]["id"].asInt();
//            string name = arrayObj[i]["name"].asString();
//            cout << id << " " << name << endl;
//        }
//    } else {
//        cout << "parse error" << endl;
//    }
    
    
    

    Json::FastWriter writer;
    
    Json::Value allperson;
    Json::Value arrp;
    Json::Value person;
    person["name"] = "hello world";
    person["age"] = 100;
    arrp.append(person);
    
    Json::Value person2;
    person2["name"] = "hello";
    person2["age"] = 102;
    arrp.append(person2);
    
    allperson["array"] = arrp;

    
    std::string json_file = writer.write(allperson);
    
     cout << " json_file " << json_file << endl;
    
    
    
    Json::Reader reader;
    Json::Value value;
    if (reader.parse(json_file, value)) {
        const Json::Value arrayObj = value["array"];
        for (size_t i=0; i<arrayObj.size(); i++) {
            int id = arrayObj[i]["age"].asInt();
            string name = arrayObj[i]["name"].asString();
            cout << id << " " << name << endl;
        }
    } else {
        cout << "parse error" << endl;
    }


    
//    cocos2d::CCLog("========= %d \n\n",request)
//    sprintf(request,
//            "",RESOURCE,IP,PORT);
    
//    CCMutableData * sData=new CCMutableData();
//    
//    sData->addBytes(&head1, 1);
//    
//    sData->addBytes(&head2, 1);
//    
//    sData->addBytes(&length, 2);
//    
//    sData->addBytes(&type, 2);
//    
//    sData->addString((char*)coentent, strlen(coentent));




}

char * UtilTool::itoa1(int val, char *buf, unsigned radix)
{
    char   *p;
    char   *firstdig;
    char   temp;
    unsigned   digval;
    
    p = buf;
    
    if(val <0)
    {
        *p++ = '-';
        val = (unsigned long)(-(long)val);
    }
    
    firstdig = p;
    
    do{
        digval = (unsigned)(val % radix);
        val /= radix;
        
        
        if  (digval > 9)
            *p++ = (char)(digval - 10 + 'a');
        else
            *p++ = (char)(digval + '0');
    }while(val > 0);
    
    
    
    *p-- = '\0';
    
    do{
        temp = *p;
        *p = *firstdig;
        *firstdig = temp;
        --p;
        ++firstdig;
    }while(firstdig < p);
    
    return buf;
}