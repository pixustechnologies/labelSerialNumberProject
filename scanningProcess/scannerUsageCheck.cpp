#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>
#include <string.h>
#include <windows.h>
#include <cctype>
#include <algorithm>

using namespace std;

bool Contains(string data);
void addDatabase(string data, int orderedNum);
void updateDatabase(string barcode, int timesPrinting);
string SerialNumberGet();
int alreadyPrintedTimes(string data);
bool printStageTwo(string serialNum, string barcode, vector<string> labelReports, vector<string> partNumber);
void printStageTwoDocuments(string barcode, string serialNum, vector<string> documentType, vector<string> documentReport, boolean lastPrint, string firstSN);
void print075(int serial, int times);

int main(int argc, char* argv[]) {   
    // starts via autohotkey
    // scanner types into console
    string barcode, trash = "y";
    barcode = argv[1];
    // allows the user to change the SQL query before the program starts
    cout << "Pixus Technologies Label Printer" << endl << "Confirm that this is your barcode: " << barcode << " [y]" << endl;
    cin >> trash;
    if (trash != "y" && trash != "Y") {
        cout << "Closing..." << endl;
        string s = "removeSQLqueries.bat";
        system( s.c_str() );
        Sleep(2000);
        exit(1);
    }
    // checks if the barcode is in the database already
    bool inDatabase = Contains(barcode); 
    int timesOrderedTotal = 10;
    int timesPrinting = 10;
    string partNum, partNumAboveTemp, partNumAbove;
    vector<string> labelReports, labelNames;
    bool label075 = false;

    // pull data from text file (sql query saves to it every run)
    ifstream file("Labels.txt");
    string fInput, ordernum, inputProcesser;
    while(getline(file, fInput)){
        istringstream line(fInput);
        line >> ordernum; //ORDNUM_10
        if (ordernum == barcode) {
            line >> partNum; //PARPRT
            line >> timesOrderedTotal; //DUEQTY_10
            line >> trash; //trash
            line >> partNumAboveTemp; //PRTNUM_10
            if (partNumAbove != partNumAboveTemp) {
                labelNames.clear();
                labelReports.clear();
            }
            partNumAbove = partNumAboveTemp;
            line >> inputProcesser; //PRTNUM_11
            labelNames.push_back(inputProcesser);
            //get rest for note
            int pos = fInput.find(inputProcesser) + inputProcesser.size() + 1;
            inputProcesser = fInput.substr(pos);
            // removes whitespace from begining or end
            inputProcesser.erase(inputProcesser.find_last_not_of(" \n\r\t")+1);
            inputProcesser.erase(0, inputProcesser.find_first_not_of(" \n\r\t"));
            // escape character
            if (inputProcesser.substr(0,1) == "~" || inputProcesser == "") {
                labelNames.pop_back();
            } else {
                labelReports.push_back(inputProcesser);
                //cout << partNum << endl << timesOrderedTotal << endl << partNumAbove << endl << labelNames.back() << endl << labelReports.back() << endl;
            }
        } 
        ordernum="";
    }
    file.close();
    vector<string> documentReports, documentType;
    ifstream file2("Documents.txt");
    while(getline(file2, fInput)){
        istringstream line(fInput);
        line >> ordernum;
        if (ordernum == barcode) {
            line >> partNum;
            line >> timesOrderedTotal;
            line >> trash; //trash
            line >> inputProcesser; //PRTNUM_10
            partNumAboveTemp = inputProcesser;
            if (partNumAbove != partNumAboveTemp) {
                documentReports.clear();
            }
            partNumAbove = partNumAboveTemp;
            line >> inputProcesser; //PRTNUM_11
            documentType.push_back(inputProcesser);
            //get rest for note
            int pos = fInput.find(inputProcesser) + inputProcesser.size() + 1;
            inputProcesser = fInput.substr(pos);
            // removes whitespace from begining or end
            inputProcesser.erase(inputProcesser.find_last_not_of(" \n\r\t")+1);
            // escape character
            if (inputProcesser.substr(0,1) == "~" || inputProcesser == "") {
                documentType.pop_back();
            } else {
                documentReports.push_back(inputProcesser);
            }
        } 
        ordernum="";
    }
    file2.close();

    if (labelReports.size() == 0 || documentReports.size() == 0 ) {
        // pull data from text file (sql query saves to it every run) if there are no documents or labels
        ifstream file3("Orders.txt");
        while(getline(file3, fInput)){
            istringstream line(fInput);
            line >> ordernum; //ORDNUM_10
            if (ordernum == barcode) {
                line >> partNum; //PARPRT
                line >> timesOrderedTotal; //DUEQTY_10
                line >> trash; //trash
                line >> partNumAbove; //PRTNUM_10
                //cout << partNum << endl << timesOrderedTotal << endl << partNumAbove << endl << labelNames.back() << endl << labelReports.back() << endl;
            } 
            ordernum="";
        }
        file3.close();
    }


    // asks if the user would like to revert to the first stage, or continue
    string yesno;
    timesPrinting = timesOrderedTotal;
    if (inDatabase) {
        cout << "Second step: \nPrinting QA Sheets and Labels \n"
             << "Would you like to reprint the BOM + Assembly Documents + Serial Number List instead? (y/n)\n";
        cin >> yesno;
        if (yesno == "y") {
            inDatabase = false;
            cout << "First step: \nPrinting the BOM, Assembly Documents, Configuration Sheet, and multiple Serial Number Lists \n";
        } else {
            timesPrinting -= alreadyPrintedTimes(barcode);
        }
    } else {
        cout << "First step: \nPrinting the BOM, Assembly Documents, Configuration Sheet, and multiple Serial Number Lists \n";
    }
    cout << "How many times would you like to print? [default = " << timesPrinting <<
            " ]. \n[Enter] to continue with the default, otherwise submit a new number to change\n";
    string input;
    cin.ignore();
    getline(cin, input);
    if ( !input.empty() ) {
        std::istringstream stream( input );
        stream >> timesPrinting;
    }

    // main logic:
    string s, startingSNString = SerialNumberGet();
    int startingSN = stoi(startingSNString);

    if (inDatabase) { //if we have seen the barcode before, print labels
        updateDatabase(barcode, timesPrinting);

        // closes if there is no labels in that number
        if(labelNames.size() == 0){
            cout << "There appears no labels with that shop order";
            string s = "removeSQLqueries.bat";
            system( s.c_str() );
            Sleep(5000);
            exit(1);
        }

        // printing all of the labels/documents per serial number, and counting up
        for (int i = 0; i < timesPrinting; i++) {
            string serialNum = SerialNumberGet();
            label075 = printStageTwo(serialNum, barcode, labelReports, labelNames);
            if(i-1 == timesPrinting) {
                printStageTwoDocuments(barcode, serialNum, documentType, documentReports, true, startingSNString);
            } else {
                printStageTwoDocuments(barcode, serialNum, documentType, documentReports, false, startingSNString);
            }

            s = "serialNumberCountUp.bat";
            system( s.c_str() );
        }
        // prints out the 075 labels 4 wide
        if (label075){
            print075(startingSN, timesPrinting);
        }
        cout << "Finished printing\n";

        // checking if the user wishes to repeat some of the prints
        do {
            cout << "Reprint All, One, or None? (a/1/n)\n";
            cin >> yesno;
            if (yesno == "a" || yesno == "A") { // reprints all of the documents/label
                for (int i = 0; i < timesPrinting; i++) {
                    int serialNum = startingSN + i;
                    printStageTwo(to_string(serialNum), barcode, labelReports, labelNames);
                    if(i-1 == timesPrinting) {
                        printStageTwoDocuments(barcode, to_string(serialNum), documentType, documentReports, true, startingSNString);
                    } else {
                        printStageTwoDocuments(barcode, to_string(serialNum), documentType, documentReports, false, startingSNString);
                    }
                    //207 8 9
                }      
                if (label075){
                    print075(startingSN, timesPrinting);
                }     
            } else if (yesno == "1") { //reprints one of the serial numbers, and a specific document/label
                string sn, s, responce;
                cout << "Which Serial Number?\n";
                cin >> sn;
                if (sn[0] != startingSNString[0] && sn[1] != startingSNString[1] && 
                    sn[2] != startingSNString[2] && sn[3] != startingSNString[3] && sn[4] != startingSNString[4]) {
                        cout << "This Serial Number is not correct\n";
                } else {
                    for (int j = 0; j < labelReports.size(); j++) { 
                        string reportName, parm1 = "", parm2= "", parm3 = "", token;
                        vector<string> noteParts;
                        istringstream iss(labelReports[j]);
                        // parses with ? as the delimiter, up to 3 parameters 
                        while ( getline(iss, token, '?') ) { 
                            noteParts.push_back(token);
                        }
                        reportName = noteParts.at(0);
                        if(noteParts.size() > 1) 
                            parm1 = noteParts.at(1);
                        if(noteParts.size() > 2) 
                            parm2 = noteParts.at(2);
                        if(noteParts.size() > 3) 
                            parm3 = noteParts.at(3);
                        if(noteParts.size() > 4) 
                            trash = noteParts.at(4);
                        reportName.erase(reportName.find_last_not_of(" \n\r\t")+1);
                        cout << "Do you want to print " << reportName << " report with label " << labelNames[j] << " with parameters: " + parm1 + " " + parm2 + " " + parm3 << " [y/n]" << endl;
                        
                        cin >> responce;
                        if (responce == "y" || responce == "Y") {
                            s = "printLabelsv2.bat " + barcode + " " + sn + " " + reportName + " " + labelNames[j] + " \"" + parm1 + "\" \"" + parm2 + "\" \"" + parm3 + "\"";
                            system( s.c_str() );
                        }
                    }
                    for (int i = 0; i < documentType.size(); i++) {
                        string reportPath, reportName, s, token;
                        vector<string> noteParts;
                        istringstream iss(documentReports[i]);
                        // parses with ? as the delimiter, up to 3 parameters 
                        while ( getline(iss, token, '?') ) { 
                            noteParts.push_back(token);
                        }
                        reportPath = noteParts.at(0);
                        reportName = noteParts.at(1);
                        cout << "Do you want to print " << reportName << " report under path " << reportPath << " [y/n]" << endl;
                        cin >> responce;
                        if ((responce == "y" || responce == "Y") && documentType.at(i) == "Final DOCS") {

                            s = "printSerialDocuments.bat " + barcode + " " + sn + " \"" + reportPath + "\" " + reportName;
                            system( s.c_str() );
                        }
                    }
                }
            }
            cout << "Finished printing\n";
        } while (yesno != "n" && yesno != "N");
        s = "removeSQLqueries.bat";
        system( s.c_str() );
    } else { // haven't seen the barcode before, so print BOM, config, SN list
        if (!Contains(barcode)) { // *maybe they reverted, so cant assume it isnt there
            addDatabase(barcode, timesOrderedTotal);
        }
        printStageTwoDocuments(barcode, "0", documentType, documentReports, false, startingSNString);
        s = "printWIP.bat " + barcode + " " + partNum + " " + to_string(timesPrinting) + " " + partNumAbove;
        system( s.c_str() ); 
    }
}

bool Contains(string data) {
    // checks if the barcode is already in the system
    ifstream file("bLog.txt");
    string input, barcode;
    while(getline(file, input)){
        istringstream line(input);
        line >> barcode;
        if (barcode == data) {
        file.close();
            return true;
        }
        line >> barcode;
        line >> barcode;
    }
    file.close();
    return false;
}

int alreadyPrintedTimes(string data) {
    // checks how many times the barcode has been printed
    ifstream file("bLog.txt");
    string input, barcode;
    int printedTimes, numOfOrders;
    while(getline(file, input)){
        istringstream line(input);
        line >> barcode;
        line >> printedTimes;
        line >> numOfOrders;
        if (barcode == data) {
            file.close();
            return printedTimes;
        }
    }
    file.close();
    return 0;
}

string SerialNumberGet() {
    // gets the serial number from the text file
    ifstream file("serialNumberCount.txt");
    string input;
    string serialNumber;
    while(getline(file, input)){
        istringstream line(input);
        line >> serialNumber;
    }
    file.close();
    return serialNumber;
}

void updateDatabase(string data, int currentPrintedTimes) {
    // updates the database when something has been printed, removes if printed is equal to ordered
    ifstream file("bLog.txt");
    vector<string> barcodes;
    vector<int> printNums, totalPrintNums;
    string input, barcode;
    int printedTimes, numOfOrders;
    while(getline(file, input)){
        istringstream line(input);
        line >> barcode;
        line >> printedTimes;
        line >> numOfOrders;
        if (barcode == (data)) {
            printedTimes += currentPrintedTimes;
        }
        //if(printedTimes != numOfOrders){  //this would prevents repeat printing 
            barcodes.push_back(barcode);
            printNums.push_back(printedTimes);
            totalPrintNums.push_back(numOfOrders);
        //}
    }
    file.close();
    remove("bLog.txt");
    ofstream bLogOut("bLog.txt");
    for(int i = 0; i < barcodes.size(); i++){
        bLogOut << barcodes[i] + " ";
        bLogOut << to_string(printNums[i]) + " ";
        bLogOut << to_string(totalPrintNums[i]) << "\n";
    }
}

void addDatabase(string data, int orderedNum) {
    // adds the new barcode into the system
    ifstream file("bLog.txt");
    vector<string> barcodes;
    vector<int> printNums, totalPrintNums;
    string input, barcode;
    int printedTimes, numOfOrders;
    while(getline(file, input)){
        istringstream line(input);
        line >> barcode;
        line >> printedTimes;
        line >> numOfOrders;
        barcodes.push_back(barcode);
        printNums.push_back(printedTimes);
        totalPrintNums.push_back(numOfOrders);
    }
    file.close();
    remove("bLog.txt");
    ofstream bLogOut("bLog.txt");
    for(int i = 0; i < barcodes.size(); i++){
        bLogOut << barcodes[i] + " ";
        bLogOut << to_string(printNums[i]) + " ";
        bLogOut << to_string(totalPrintNums[i]) << "\n";
    }
    string s = " 0 " + to_string(orderedNum);
    bLogOut << data + s << endl;
}

bool printStageTwo(string serialNumber, string orderNumber, vector<string> labelReports, vector<string> partNumber) {
    // prints all of the labels
    bool label075 = false;
    cout << "Serial Number: " << serialNumber << endl;
    for (int j = 0; j < labelReports.size(); j++) { 
        string reportName, parm1 = "", parm2= "", parm3 = "", trash = "";
        string token, s;
        vector<string> noteParts;
        istringstream iss(labelReports[j]);
        // parses with ? as the delimiter, up to 3 parameters 
        while ( getline(iss, token, '?') ) { 
            noteParts.push_back(token);
        }
        reportName = noteParts.at(0);
        if(noteParts.size() > 1) 
            parm1 = noteParts.at(1);
        if(noteParts.size() > 2) 
            parm2 = noteParts.at(2);
        if(noteParts.size() > 3) 
            parm3 = noteParts.at(3);
        if(noteParts.size() > 4) 
            trash = noteParts.at(4);
        cout << "Printing " << reportName << " report with label " << partNumber[j] << " with parameters: " + parm1 + " " + parm2 + " " + parm3 << endl;
        if (reportName == "01A000199-A01") { // add new "by 4" formats for 075 here
            label075 = true;
        } else {
            s = "printLabelsv2.bat " + orderNumber + " " + serialNumber + " " + reportName + " " + partNumber[j] + " \"" + parm1 + "\" \"" + parm2 + "\" \"" + parm3 + "\"";
            system( s.c_str() );
        }
    }


    return label075;
}

void print075(int startingSN, int times) {
    // prints out the 075 serial numbers 
    // reconfigure this function if another by4 format is needed
    // ASSUMES PLANT 0
    string s;
    string s1="0", s2="0", s3="0", s4="0";
    for (int i = startingSN; i < startingSN+times; i+=4) {
        if(i%4==0){
            if(s1!="0"){
                s = "print075Labels.bat " + s1 + " " + s2 + " " + s3 + " " + s4;
                system( s.c_str() );
            } 
            s1="0" + i;
        } else if(i%4==1){
            s2="0" + i;
        } else if(i%4==2){
            s3="0" + i;
        } else if(i%4==3){
            s4="0" + i;
        } 
    }
    s = "print075Labels.bat " + s1 + " " + s2 + " " + s3 + " " + s4;
    system( s.c_str() );
}

void printStageTwoDocuments(string barcode, string serialNum, vector<string> documentType, vector<string> documentName, boolean lastPrint, string serialNumStart) {
    // prints out all of the documents related to post production
    for (int i = 0; i < documentType.size(); i++) {
        string searchPath, reportName, s, token;
        vector<string> noteParts;
        istringstream iss(documentName[i]);
        // parses with ? as the delimiter, up to 3 parameters 
        while ( getline(iss, token, '?') ) { 
            noteParts.push_back(token);
        }
        searchPath = noteParts.at(0);
        reportName = noteParts.at(1);
        if((reportName == "01A000207-A01" || reportName == "01A000208-A01" || reportName == "01A000209-A01") && lastPrint == false ) {
            
        } else if ((reportName == "01A000207-A01" || reportName == "01A000208-A01" || reportName == "01A000209-A01") && lastPrint == true) {
            s = "printSpecialQA.bat " + barcode + " " + serialNum + " \"" + searchPath + "\" " + reportName + " " + serialNumStart; 
        } else {
            if (documentType.at(i) == "Initial DOCS") {
                s = "printWIPDocuments.bat \"" + searchPath + "\" " + reportName; 
            } else if (documentType.at(i) == "Final DOCS") {
                s = "printSerialDocuments.bat " + barcode + " " + serialNum + " \"" + searchPath + "\" " + reportName; 
            }
        }
    }
}