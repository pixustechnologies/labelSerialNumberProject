#include <iostream>
#include <fstream>
#include <vector>
#include <sstream>
#include <string.h>
#include <windows.h>

using namespace std;

bool Contains(string data);
void addDatabase(string data, int orderedNum);
void updateDatabase(string barcode, int timesPrinting);
int SerialNumberGet();
int alreadyPrintedTimes(string data);
bool printStageTwo(int serialNum, string barcode, vector<string> labelReports, vector<string> partNumber);
void removeFiles(int startingSN, int endingSN);
void print075(int serial, int times);

int main(int argc, char* argv[]) {   
    // starts via autohotkey
    // scanner types into console
    string barcode;
    barcode = argv[1];
    cout << barcode << endl;

    // checks if the barcode is in the database already
    bool inDatabase = Contains(barcode); 
    int timesOrderedTotal = 10;
    int timesPrinting = 10;
    string partNum, partNumAbove;
    vector<string> labelReports, labelNames;
    bool label075 = false;

    // pull data from text file (sql query saves to it every run)
    ifstream file("Labels.txt");
    string fInput, ordernum, inputProcesser;
    while(getline(file, fInput)){
        istringstream line(fInput);
        line >> ordernum;
        if (ordernum == barcode) {
            line >> partNum;
            line >> timesOrderedTotal;
            line >> partNumAbove;
            line >> inputProcesser;
            labelNames.push_back(inputProcesser);
            //get rest for note
            int pos = fInput.find(inputProcesser) + inputProcesser.size() + 1;
            inputProcesser = fInput.substr(pos);
            labelReports.push_back(inputProcesser);
        } 
        ordernum="";
    }
    file.close();
    vector<string> documentReports;
    ifstream file2("Documents.txt");
    while(getline(file2, fInput)){
        istringstream line(fInput);
        line >> ordernum;
        if (ordernum == barcode) {
            line >> inputProcesser;
            line >> inputProcesser;
            line >> inputProcesser;
            //get rest for note
            int pos = fInput.find(inputProcesser) + inputProcesser.size() + 1;
            inputProcesser = fInput.substr(pos);
            documentReports.push_back(inputProcesser);
        } 
        ordernum="";
    }
    file2.close();

    // asks if the user would like to revert to the first stage, or continue
    string yesno;
    timesPrinting = timesOrderedTotal;
    if (inDatabase) {
        cout << "Second step: \n Printing QA Sheets and Labels \n"
             << "Revert to Assembly Documents + Serial Number List printing? (y/n)\n";
        cin >> yesno;
        if (yesno == "y") {
            inDatabase = false;
            cout << "First step: \n Printing the BOM, Configuration sheet, and multiple Serial Number Lists \n";
        } else {
            timesPrinting -= alreadyPrintedTimes(barcode);
        }
    } else {
        cout << "First step: \n Printing the Assembly Documents, and multiple Serial Number Lists \n";
    }
    cout << "How many times would you like to print? [default = " << timesPrinting <<
            " ]. \n [Enter] to continue with the default, otherwise submit a new number to change\n";
    string input;
    cin.ignore();
    getline(cin, input);
    if ( !input.empty() ) {
        std::istringstream stream( input );
        stream >> timesPrinting;
    }

    // main logic:
    string s;
    int startingSN = SerialNumberGet();

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
            int serialNum = SerialNumberGet();
            label075 = printStageTwo(serialNum, barcode, labelReports, labelNames);
            s = "serialNumberCountUp.bat";
            system( s.c_str() );
        }
        if (label075){
            print075(startingSN, timesPrinting);
        }
        cout << "Finished printing\n";

        // checking if the user wishes to repeat some of the prints
        do {
            cout << "Reprint All, One, or None? (a/1/n)\n";
            cin >> yesno;
            if (yesno == "a") {
                for (int i = 0; i < timesPrinting; i++) {
                    int serialNum = startingSN + i;
                    printStageTwo(serialNum, barcode, labelReports, labelNames);
                }           
            } else if (yesno == "1") {
                string sn;
                cout << "Which Serial Number?\n";
                cin >> sn;
                printStageTwo(stoi(sn), barcode, labelReports, labelNames);
            }
            cout << "Finished printing\n";
        } while (yesno != "n");
        
        removeFiles(startingSN, SerialNumberGet());
        
    } else { // haven't seen the barcode before, so print BOM, config, SN list
        if (!Contains(barcode)) { // *maybe they reverted, so cant assume it isnt there
            addDatabase(barcode, timesOrderedTotal);
        }
        // goes through each of the files 
        for (int i = 0; i < documentReports.size(); i++) {
            string reportName, parm1 = "";
            string token;
            vector<string> noteParts;
            istringstream iss(documentReports[i]);
            // parses with ? as the delimiter, up to 3 parameters 
            while ( getline(iss, token, '?') ) { 
                noteParts.push_back(token);
            }
            reportName = noteParts.at(0);
            parm1 = noteParts.at(1);
            s = "printWIPDocuments.bat " + reportName + " " + parm1; 
        }
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

int SerialNumberGet() {
    // gets the serial number from the text file
    ifstream file("serialNumberCount.txt");
    string input;
    int serialNumber;
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

bool printStageTwo(int serialNumber, string orderNumber, vector<string> labelReports, vector<string> partNumber) {
    // prints the QA sheet, and all of the labels
    string s = "printQA.bat " + orderNumber + " " + to_string(serialNumber);
    bool label075 = false;
    system( s.c_str() );
    for (int j = 0; j < labelReports.size(); j++) { 
        string reportName, parm1 = "", parm2= "", parm3 = "";
        string token;
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
        cout << "Printing " << reportName << " report with label " << partNumber[j] << " with parameters:  " + parm1 + " " + parm2 + " " + parm3 ;
        if (partNumber[j] == "94A000004-A01") {
            label075 = true;
        } else {
            s = "printLabelsv2.bat " + orderNumber + " " + to_string(serialNumber) + " " + reportName + " " + partNumber[j] + " " + parm1 + " " + parm2 + " " + parm3;
            system( s.c_str() );
        }
        return label075;
    }
}

void removeFiles(int startingSN, int endingSN) {
    // removes the folder for each serial number's label files
    string s;
    for (int i = startingSN; i < endingSN; i++) {
        s = "deleteSavedFiles.bat " + i;
        system( s.c_str() );
    }
    s = "removeSQLqueries.bat";
    system( s.c_str() );
}

void print075(int startingSN, int times) {
    string s;
    int s1=0, s2=0, s3=0, s4=0;
    for (int i = 0; i < times; i+=4) {
        if(i%4==0){
            if(s1!=0){
                s = "print075Labels.bat " + to_string(s1) + " " + to_string(s2) + " " + to_string(s3) + " " + to_string(s4);
                system( s.c_str() );
            } 
            s1=i;
        } else if(i%4==1){
            s2=i;
        } else if(i%4==2){
            s3=i;
        } else if(i%4==3){
            s4=i;
        } 
    }
    s = "print075Labels.bat " + to_string(s1) + " " + to_string(s2) + " " + to_string(s3) + " " + to_string(s4);
    system( s.c_str() );
}
