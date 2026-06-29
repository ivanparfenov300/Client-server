#include "TCPClient.h"
#include <iostream>
#include <cstring>
#include <unistd.h>
#include <cstdlib>
#include <vector>

using namespace std;  

TCPClient::TCPClient() {
    sock = -1;
    port = 0;
    address = "";
}

bool TCPClient::setup(string address, int port) {
    if (sock == -1) {
        sock = socket(AF_INET, SOCK_STREAM, 0);
        if (sock == -1) {
            cout << "Couldn't create socket" << endl;
            return false;
        }
    }
    

    struct hostent *he;
    struct in_addr **addr_list;
    
    // Исправленное условие
    if (inet_addr(address.c_str()) == -1) {
        he = gethostbyname(address.c_str());
        if (he == NULL) {
            herror("gethostbyname");
            cout << "Failed to resolve hostname\n";
            return false;
        }
        addr_list = (struct in_addr **)he->h_addr_list;
        for (int i = 0; addr_list[i] != NULL; ++i) {
            server.sin_addr = *addr_list[i];
            break;
        }
    } else {
        server.sin_addr.s_addr = inet_addr(address.c_str());
    }
    
    server.sin_family = AF_INET;
    server.sin_port = htons(port);
    
    if (connect(sock, (struct sockaddr *)&server, sizeof(server)) < 0) {
        perror("connect failed. Error");
        return false;
    }
    return true;
}

bool TCPClient::Send(string data) {
    if (sock != -1) {
        if (send(sock, data.c_str(), data.length(), 0) < 0) {
            cout << "Send failed : " << data << endl;
            return false;
        }
    } else {
        return false;
    }
    return true;
}

string TCPClient::receive(int size) {
    char buffer[size + 1]; 
    memset(buffer, 0, sizeof(buffer));
    
    int bytes_received = recv(sock, buffer, size, 0);
    if (bytes_received < 0) {
        cout << "receive failed!" << endl;
        return ""; 
    }
    
    buffer[bytes_received] = '\0';  
    return string(buffer);
}

string TCPClient::read() {
    char buffer[2] = {};  
    string reply;
    
    while (true) {
        int bytes_received = recv(sock, buffer, 1, 0);  
        if (bytes_received < 0) {
            cout << "receive failed!" << endl;
            return "";  
        }
        if (bytes_received == 0) {
            break;  
        }
        if (buffer[0] == '\n') {
            break;  
        }
        reply += buffer[0];
    }
    return reply;
}

void TCPClient::exit() {
    if (sock != -1) {
        close(sock);
        sock = -1;
    }
}