#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <vector>
#include <sstream>
using namespace std;

int main(int argc, char* argv[]) { 
    // reads in the barcode log file 
    ifstream file("bLog.txt");
    vector<string> barcodes;
    vector<int> printNums, totalPrintNums;
    string input, barcode;
    int printedTimes, numOfOrders;
    while(getline(file, input)){
        istringstream line(input);
        line >> barcode;
        barcodes.push_back(barcode);
        line >> printedTimes;
        printNums.push_back(printedTimes);
        line >> numOfOrders;
        totalPrintNums.push_back(numOfOrders);
    }
    // removes the old barcode log file, and replaces it with a condensed version
    // by removing the oldest X percent of barcodes in the log
    remove("bLog.txt");
    ofstream bLogOut("bLog.txt");
    // this is percent of barcodes to remove after a year, ie 20%
    int removeOldPercent = 20;
    int start = (barcodes.size()*removeOldPercent)/100;
    for(int i = start; i < barcodes.size(); i++){
        bLogOut << barcodes[i] + " ";
        bLogOut << to_string(printNums[i]) + " ";
        bLogOut << to_string(totalPrintNums[i]) << "\n";
    }
    return 0;
}
