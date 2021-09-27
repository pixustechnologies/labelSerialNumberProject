#include <iostream>
#include <vector>
#include <sstream>
#include <string.h>
#include <windows.h>

using namespace std;

int main(int argc, char* argv[]) {   
    string input = "01A0000164?Input: Voltage 50?part2?part3?part4 maybe?";
    string reportName, parm1 = "", parm2= "", parm3 = "";
    string token;
    vector<string> noteParts;
    istringstream iss(input);
    cout << "test 1";
    while ( getline(iss, token, '?') ) { 
        cout << "test 22";
        noteParts.push_back(token);
    }
    cin >> input;
    reportName = noteParts.at(0);
        if(noteParts.size() > 1) 
            parm1 = noteParts.at(1);
        if(noteParts.size() > 2) 
            parm2 = noteParts.at(2);
        if(noteParts.size() > 3) 
            parm3 = noteParts.at(3);
            
    cout << reportName << endl << parm1 << endl << parm2 << endl << parm3 << endl;
    cout << "test 2";
    cin >> input;
}