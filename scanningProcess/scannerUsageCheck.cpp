#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <vector>
#include <sstream>
using namespace std;

bool Contains(string data);
void addDatabase(string data, int orderedNum);
void updateDatabase(string barcode, int timesPrinting);

int main(int argc, char* argv[]) {   
    // starts via autohotkey
    // scanner types into console
    string barcode;
    cin >> barcode;
    bool inDatabase = Contains(barcode);
    //TODO::
    int timesOrderedTotal = 100; // REPLACE WITH SQL IN FUTURE
    int timesPrinting = 1; // REPLACE WITH SQL IN FUTURE
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

    string s, s2;
    if (inDatabase) {
        //print labels through a bat file
        updateDatabase(barcode, timesPrinting);
        s2 = " " + to_string(timesPrinting);
        s = "printLabels.bat " + barcode + s2;
        system( s.c_str() );
    } else {
        addDatabase(barcode, timesOrderedTotal);
        s = "printWIP.bat " + barcode;   
        system( s.c_str() ); 
    }
    
    return 0;
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
