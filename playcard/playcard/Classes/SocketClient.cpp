//
//  SocketClient.cpp
//  playcard
//
//  Created by wangwb on 13-6-8.
//
//
#include "SocketClient.h"

#define MAX_RECV_SIZE 1024
#define SERVER_IP "127.0.0.1"
#define SERVER_PORT 8000

#define SOKETTIMEOUT 10

#include "cocos2d.h"

using namespace cocos2d;

using namespace std;



void SocketClient::init(NetEngine *delegate){
//    testSocket();
//    return;
    engineDelegate = delegate;
    
    CreateSocket();
    
}
SocketClient::~SocketClient(void)
{
    
    m_socket->SendData("leave", strlen("leave")+1);
    delete m_socket;
    m_socket = NULL;

}
void SocketClient::CreateSocket()
{
    const char* serverIp=SERVER_IP;//"192.168.1.120";
    
    //定义客户端的ip，写客户端的ip
    
    int serverPort=SERVER_PORT;
    
    //定义客户端的端口
    
    //处理异常
    
    try {
        
        address.SetHostName(serverIp, false);
        
        //false的意思是是否用这个ip与网络连接
        
        m_socket=new TCPClientSocket(address,serverPort);
        
        // 设置超时
        
        struct timeval timeout;

        socklen_t len = sizeof(timeout);

        timeout.tv_sec = SOKETTIMEOUT;

        m_socket -> SetSockOpt(SOL_SOCKET, SO_RCVTIMEO, &timeout, len);
        
    } catch (SocketException &excep) {
        
        cout<<"Socket Exception:"<<(const  char *)excep<<endl;
        
    }
    
    catch(...){
        
        //这是c++里面的例外处理，catch(...)的意思是其他例外的出现
        
        cout<<"other error"<<endl;
        
    }
    
    if(pthread_create(&pthead_rec, NULL, recivePublicData, this)!=0){
        
        //pthead_recx线程标示，reciveData回调函数， m_socket传入的参数
        
        cout<<"创建reciveData失败"<<endl;
        
    }


}

void SocketClient::sendData(const char* data)
{
    if (!m_socket) {
        CreateSocket();
    }
    if (!m_socket) {
        callBack("服务器连接失败");
        return;
    }
    
//    try {
//    m_socket->SendData(data, strlen(data)+1);
//    }catch (SocketException &excep) {
//        
//        cout<<"收到参数意外"<<endl;
//        
//        cocos2d::CCLog("sendData recvDatas Error: %s \n\n",(const char*)excep);
//        return;
//    }
    
     strcpy(outData, data);
    cout<<"开始线程接受Socket数据"<<endl;
    if(pthread_create(&pthead_rec, NULL, reciveData, this)!=0){
        
        //pthead_recx线程标示，reciveData回调函数， m_socket传入的参数
        
        cout<<"创建reciveData失败"<<endl;
        
    }

}


void* SocketClient::reciveData(void* self){
    SocketClient *scoketClient =( SocketClient *) self;
    TCPClientSocket *mysocket=scoketClient->m_socket;

    bool tag = true;
    //while (1)
    {
        
        cout<<"reciveData"<<endl;
        
        unsigned char pcRecvBuf[MAX_RECV_SIZE];
        
        //在栈中建立的数组，用于盛放接收来的数据
        
        try {
            mysocket->SendData(scoketClient->outData, strlen(scoketClient->outData)+1);
            
            int iBytesRec=mysocket->RecvData(pcRecvBuf, MAX_RECV_SIZE);

            cout<<"收到服务端传来"<<iBytesRec<<endl;

            pcRecvBuf[iBytesRec]=0;
            cout<<pcRecvBuf<<endl;
            char* p = (char*)pcRecvBuf;
            scoketClient->callBack(p);
            
           
            // 处理收到的数据，如果他的最后一位是0，则表示接收数据完成

            
        } catch (SocketException &excep) {
            
            tag = false;
            cout<<"收到参数意外"<<endl;
            
            cocos2d::CCLog("recvDatas Error: %s \n\n",(const char*)excep);
            
//            scoketClient->callBack("收到参数意外");
            
        }catch (...){
            tag = false;
            cout<<"其他例外"<<endl;
            
            cocos2d::CCLog("recvDatas Error\n\n");
//            scoketClient->callBack("收到参数意外");
        }
        
        cocos2d::CCLog("net disconnect \n\n");
        
    }
    
    cocos2d::CCLog("end reciveData \n\n");
    
}


void* SocketClient::recivePublicData(void* self){
    SocketClient *scoketClient =( SocketClient *) self;
    TCPClientSocket *mysocket=scoketClient->m_socket;
    
    bool tag = true;
    while (1)
    {
        
        cout<<"public reciveData"<<endl;
        
        unsigned char pcRecvBuf[MAX_RECV_SIZE];
        
        //在栈中建立的数组，用于盛放接收来的数据
        
        try {
            
            int iBytesRec=mysocket->RecvData(pcRecvBuf, MAX_RECV_SIZE);
            
            cout<<"收到服务端传来"<<iBytesRec<<endl;
            
            pcRecvBuf[iBytesRec]=0;
            cout<<pcRecvBuf<<endl;
            char* p = (char*)pcRecvBuf;
            scoketClient->callBack(p);
            
            
            // 处理收到的数据，如果他的最后一位是0，则表示接收数据完成
            
            
        } catch (SocketException &excep) {
            
            tag = false;
            cout<<"收到参数意外"<<endl;
            
            cocos2d::CCLog("recvDatas Error: %s \n\n",(const char*)excep);
            
           
            
            //            scoketClient->callBack("收到参数意外");
            
        }catch (...){
            tag = false;
            cout<<"其他例外"<<endl;
            
            cocos2d::CCLog("recvDatas Error\n\n");
            //            scoketClient->callBack("收到参数意外");
        }
        
        cocos2d::CCLog("net disconnect \n\n");
        
    }
    
    cocos2d::CCLog("end reciveData \n\n");
    
}

void SocketClient::log(const char * content)
{
    cocos2d::CCLog("========= %s \n\n",content);

}

void SocketClient::callBack(const char * content)
{
    cocos2d::CCLog("========= %s \n\n",content);
    engineDelegate->returnRequest((void*)content);
    
}