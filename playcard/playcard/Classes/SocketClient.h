//
//  SocketClient.h
//  playcard
//
//  Created by wangwb on 13-6-8.
//
//

#ifndef __playcard__SocketClient__
#define __playcard__SocketClient__

#include <iostream>
#include "socketcc.h"


using namespace std;
class NetEngine
{
public:
    NetEngine(){};
    virtual ~NetEngine(){};
    virtual void returnRequest(void *content){};
};

class SocketClient {
private:
    TCPClientSocket *m_socket;
    
    IPAddress address;
    
    pthread_t pthead_rec;

    NetEngine *engineDelegate;
    
    char outData[10];
    
public:
    
    void init(NetEngine *delegate);
    virtual ~SocketClient(void);
    static void* reciveData(void* pthread);
    static void* recivePublicData(void* self);
    void sendData(const char* data);
    static void log(const char * content);
    void callBack(const char * content);
    void CreateSocket();
};
#endif /* defined(__playcard__SocketClient__) */
