#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <vector>
#include <sstream>
#include <stdio.h>
#include <string.h>
#include "util.h"
#include <cstdlib>

using namespace std;

bool Contains(string data);
void addDatabase(string data, int orderedNum);
void updateDatabase(string barcode, int timesPrinting);
int SerialNumberGet();

int main(int argc, char* argv[]) {   
    // starts via autohotkey
    // scanner types into console
    string barcode;
    cin >> barcode;
    bool inDatabase = Contains(barcode);

    //SQL
    /*  U:   SQLR
        p:  /SQ/R#3's5~.
    */
   /*
    EXEC SQL BEGIN DECLARE SECTION;
        char db[6] = "ExactMAXPixus", u[20] = "SQLR", ps[20] = "/SQ/R#3's5~.";
        char ordernum[10], amountordered[4];
        char name[64], company[16], idNum[12];
    EXEC SQL END DECLARE SECTION;
    EXEC SQL CONNECT TO :db USER :u USING :ps;
    EXEC SQL WHENEVER SQLERROR  GO TO error;

        
    strncpy(ordernum,barcode.c_str(),10);
    //TODO: logic, need database answers
    EXEC SQL SELECT om.DUEQTY_10 INTO :amountordered
        FROM    Order_Master om, SO_Detail sod
        WHERE   :ordernum LIKE om.ORDNUM_10 
                AND :name = om.PRTNUM_10
                AND om.ORDREF_10 = sod.REFRNC_28
                AND :company = sod.CUSTID_28
                AND :idNum = om.ORDREF_10;
    // want 5-8 digits of idNum for wordDoc name
*/
    int timesOrderedTotal = 100; // REPLACE WITH SQL IN FUTURE
    int timesPrinting = 1; // REPLACE WITH SQL IN FUTURE
    //int timesPrinting = atoi(amountordered);
    //int timesOrderedTotal = atoi(amountordered);

    string s, s2;
    if (inDatabase) {

        //TODO:
        // IF REPLACED, REMOVE scannerLogCleanerYearlyUpdate.cpp / yearlyLogCleanup.exe
        // AND REMOVE THE WINDOWS TASK SCHEDUALER TASK THAT RUNS THE EXE EVERY YEAR
        // the program is set to remove the log once the times printed equals the 
        cout << "How many times would you like to print? [default =" << timesPrinting <<
            "]. \n [Enter] to continue with the default, otherwise submit a new number to change\n";

        string input;
        cin.ignore();
        getline(cin, input);
        if ( !input.empty() ) {
            std::istringstream stream( input );
            stream >> timesPrinting;
        }

        //print labels through a bat file
        updateDatabase(barcode, timesPrinting);
        for(int i = 0; i < timesPrinting; i++){
            int serialNum = SerialNumberGet();
            s2 = " " + to_string(serialNum);
            string s3 = " 0";
            if(i +1 == timesPrinting){
                s3 = " 1";
            }
            s = "printLabels.bat " + barcode + s2 + s3;
            system( s.c_str() );
            s = "serialNumberCountUp.bat";
            system( s.c_str() );
        }
    } else {
        addDatabase(barcode, timesOrderedTotal);
        string s3 = " " + to_string(timesOrderedTotal); // print times
        s2 = " " + to_string(timesOrderedTotal); // change to part num
        s = "printWIP.bat " + barcode + s3 + s2;   
        system( s.c_str() ); 
    }
    /*
    EXEC SQL COMMIT;
    EXEC SQL CONNECT reset;
    exit(0);

error:
    check_error("Error",&sqlca);
    EXEC SQL WHENEVER SQLERROR CONTINUE;

    EXEC SQL ROLLBACK;
    EXEC SQL CONNECT reset;
    exit(1);

    return 0;
    */
}

bool Contains(string data) {
    // checks if there it is already in the system
    ifstream file("bLog.txt");
    string input;
    string barcode;
    int printedTimes;
    int numOfOrders;
    while(getline(file, input)){
        istringstream line(input);
        line >> barcode;
        line >> printedTimes;
        line >> numOfOrders;
        if (barcode == data) {
            return true;
        }
    }
    return false;
}

int SerialNumberGet() {
    // gets the serial number
    ifstream file("serialNumberCount.txt");
    string input;
    int serialNumber;
    while(getline(file, input)){
        istringstream line(input);
        line >> serialNumber;
    }
    return serialNumber;
}

void updateDatabase(string data, int currentPrintedTimes) {
    // updates the database when something has been printed, removes if printed is equal to ordered
    ifstream file("bLog.txt");
    vector<string> barcodes;
    vector<int> printNums;
    vector<int> totalPrintNums;
    string input;
    string barcode;
    int printedTimes;
    int numOfOrders;
    while(getline(file, input)){
        istringstream line(input);
        line >> barcode;
        line >> printedTimes;
        line >> numOfOrders;
        if (barcode == (data)) {
            printedTimes += currentPrintedTimes;
        }
        if(printedTimes != numOfOrders){
            barcodes.push_back(barcode);
            printNums.push_back(printedTimes);
            totalPrintNums.push_back(numOfOrders);
        }
    }
    remove("bLog.txt");
    ofstream bLogOut("bLog.txt");
    for(int i = 0; i < barcodes.size(); i++){
        bLogOut << barcodes[i] + " ";
        bLogOut << to_string(printNums[i]) + " ";
        bLogOut << to_string(totalPrintNums[i]);
        if(i+1 != barcodes.size()){
            bLogOut << "\n";
        }
    }
}

void addDatabase(string data, int orderedNum) {
    // adds the new barcode into the system
    ofstream bLog("bLog.txt");
    string s = " 0 " + to_string(orderedNum);
    bLog << data + s << endl;
}


