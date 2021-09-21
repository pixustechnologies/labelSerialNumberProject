#include <iostream>
#include <fstream>
#include <stdlib.h>
#include <vector>
#include <sstream>
#include <stdio.h>
#include <string.h>
#include <cstdlib>
// #include <sqlenv.h>
// #include <sqlcodes.h>
// #include <sqlca.h>

using namespace std;

bool Contains(string data);
void addDatabase(string data, int orderedNum);
void updateDatabase(string barcode, int timesPrinting);
int SerialNumberGet();
int alreadyPrintedTimes(string data);
void printStageTwo(int serialNum, string barcode, vector<string> labelReports, string inputSpec, string partNumber);
void removeFiles(int startingSN, int endingSN);

int main(int argc, char* argv[]) {   
    // starts via autohotkey
    // scanner types into console
    string barcode;
    barcode = argv[1];
    cout << barcode << endl;

    // checks if the barcode is in the database already
    bool inDatabase = Contains(barcode);

    // queries the database to get the part name and quantity
    // EXEC SQL BEGIN DECLARE SECTION;
    //     char db[13] = "ExactMAXPixus", u[4] = "SQLR", ps[12] = "/SQ/R#3's5~.";
    //     char ordernum[8], name[30];
    //     varchar notes[500];
    //     float dueqty;
    // EXEC SQL END DECLARE SECTION;
    // EXEC SQL CONNECT TO :db USER :u USING :ps;
    // EXEC SQL WHENEVER SQLERROR  GO TO error;

    // strncpy(ordernum,barcode.c_str(),10);
    // EXEC SQL SELECT om.DUEQTY_10 INTO :dueqty
    //     FROM    Order_Master om
    //     WHERE   :ordernum LIKE om.ORDNUM_10 
    //             AND :name = om.PRTNUM_10;
             
    int timesOrderedTotal = 10;
    int timesPrinting = 1;
    string partNum;
    // partNum = name;
    // timesPrinting = (int) dueqty;
    // timesOrderedTotal = (int) dueqty;  

    //now searching for the labels associated with the part name
    vector<string> labelReports;
    // EXEC SQL DECLARE LabelSearch CURSOR FOR 
    //     SELECT  rd.PRTNUM_11 
    //     FROM    Requirement_Detail rd, Windows_Notes wn, Order_Master om
    //     WHERE   :ordernum LIKE rd.ORDNUM_11
    //             AND om.ORDNUM_10 = rd.ORDNUM_11
    //             AND :name = rd.PRTNUM_11
    //             AND :notes = wn.NOTES_61
    //             AND wn.COMPRT_61 = rd.PRTNUM_11
    //             AND om.PRTNUM_10 = wn.PRTNUM_61
            
    // reduces full components down to just labels
    // EXEC SQL OPEN LabelSearch;
    // EXEC SQL WHENEVER NOT FOUND GO TO end;
    // for (;;) {
    //     EXEC SQL FETCH LabelSearch INTO :name, :notes;
    //     if (name[0] == "9" && name[1] == "4" && name[2] == "A" || 
    //     name[0] == "K" && name[1] == "9" && name[2] == "4" && name[3] == "A") {
    //         labelReports.push_back(notes);
    //     }
    // };

    // asks if the user would like to revert to the first stage, or continue
    string yesno;
    if (inDatabase) {
        cout << "Second step: \n Printing mutliple QA Sheets and Box + Product Labels \n"
             << "Revert to BOM/Config/Serial Number printing? (y/n)\n";
        cin >> yesno;
        if (yesno == "y") {
            inDatabase = false;
            cout << "First step: \n Printing the BOM, Configuration sheet, and multiple Serial Number Lists \n";
        } else {
            timesPrinting = timesOrderedTotal - alreadyPrintedTimes(barcode);
        }
    } else {
        cout << "First step: \n Printing the BOM, Config sheet, and multiple Serial Number Lists \n";
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
        cout << "What should the input specification be?\n [Enter] x2 for nothing\n";
        string inputSpec;
        cin.ignore();
        getline(cin, input);
        if ( !input.empty() ) {
            std::istringstream stream( input );
            stream >> inputSpec;
        }
        
        updateDatabase(barcode, timesPrinting);
        // printing all of the labels/documents per serial number, and counting up
        for (int i = 0; i < timesPrinting; i++) {
            int serialNum = SerialNumberGet();
            printStageTwo(serialNum, barcode, labelReports, inputSpec, partNum);
            s = "serialNumberCountUp.bat";
            system( s.c_str() );
        }
        cout << "Finished printing\n";

        // checking if the user wishes to repeat some of the prints
        do {
            cout << "Reprint All, One, or None? (a/1/n)\n";
            cin >> yesno;
            if (yesno == "a") {
                for (int i = 0; i < timesPrinting; i++) {
                    int serialNum = startingSN + i;
                    printStageTwo(serialNum, barcode, labelReports, inputSpec, partNum);
                }           
            } else if (yesno == "1") {
                string sn;
                cout << "Which Serial Number?\n";
                cin >> sn;
                printStageTwo(stoi(sn), barcode, labelReports, inputSpec, partNum);
            }
            cout << "Finished printing\n";
        } while (yesno != "n");
        
        removeFiles(startingSN, SerialNumberGet());
        
    } else { // haven't seen the barcode before, so print BOM, config, SN list
        if (!Contains(barcode)) { // *maybe they reverted, so cant assume it isnt there
            addDatabase(barcode, timesOrderedTotal);
        }
        s = "printWIP.bat " + barcode + " " + partNum + " " + to_string(timesPrinting);   
        system( s.c_str() ); 
    }
    // closing SQL
    /*
end:

    EXEC SQL CLOSE LabelSearch;
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
    // checks if the barcode is already in the system
    ifstream file("bLog.txt");
    string input, barcode;
    while(getline(file, input)){
        istringstream line(input);
        line >> barcode;
        if (barcode == data) {
            return true;
        }
        line >> barcode;
        line >> barcode;
    }
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
            return printedTimes;
        }
    }
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

void printStageTwo(int serialNumber, string orderNumber, vector<string> labelReports, string inputSpecification, string partNumber) {
    // prints the QA sheet, and all of the labels in the respective
    string s = "printQA.bat " + orderNumber + " " + to_string(serialNumber);
    system( s.c_str() );
    for (int j = 0; j < labelReports.size(); j++) { 
        string reportName;
        istringstream iss(labelReports[j], istringstream::in);
        while ( iss >> reportName ) {
            s = "printLabelsv2.bat " + orderNumber + " " + to_string(serialNumber) + " " + reportName + " "  + inputSpecification + " " + partNumber;
            system( s.c_str() );
        }
    }
}

void removeFiles(int startingSN, int endingSN) {
    // removes the folder for each serial number's label files
    for (int i = startingSN; i < endingSN; i++) {
        string s = "deleteSavedFiles.bat " + i;
        system( s.c_str() );
    }
}