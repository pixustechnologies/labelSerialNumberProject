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
#include <sys/time.h>

using namespace std;

bool Contains(string data);
void addDatabase(string data, int orderedNum);
void updateDatabase(string barcode, int timesPrinting);
int SerialNumberGet();
int alreadyPrintedTimes(string data);

int main(int argc, char* argv[]) {   
    // starts via autohotkey
    // scanner types into console
    string barcode;
    barcode = argv[1];
    cout << barcode << endl;

    bool inDatabase = Contains(barcode);

   
    // EXEC SQL BEGIN DECLARE SECTION;
    //     char db[13] = "ExactMAXPixus", u[4] = "SQLR", ps[12] = "/SQ/R#3's5~.";
    //     char ordernum[8], name[30], notes[128??];
    //     float dueqty;
    // EXEC SQL END DECLARE SECTION;
    // EXEC SQL CONNECT TO :db USER :u USING :ps;
    // EXEC SQL WHENEVER SQLERROR  GO TO error;

    // strncpy(ordernum,barcode.c_str(),10);
    // EXEC SQL SELECT om.DUEQTY_10 INTO :dueqty
    //     FROM    Order_Master om
    //     WHERE   :ordernum LIKE om.ORDNUM_10 
    //             AND :name = om.PRTNUM_10;
               

// need another query for what labels to print
// put all assy into list, check list to start with labeling code
// if true, print dueQTY times
    vector<string> labelReports;
    vector<float> labelQty;
    // EXEC SQL DECLARE LabelSearch CURSOR FOR 
    //     SELECT  rd.PRTNUM_11, rd.DUEQTY_11 
    //     FROM    Requirement_Detail rd
    //     WHERE   :ordernum LIKE rd.ORDNUM_11
    //             AND :name = rd.PRTNUM_11
    //             AND :dueqty = rd.DUEQTY_11;
    //             AND :notes = SOME FIELD
            

    // EXEC SQL OPEN LabelSearch;
    // EXEC SQL WHENEVER NOT FOUND GO TO end;
    // for (;;) {
    //     EXEC SQL FETCH LabelSearch INTO :name, :dueqty, :notes;
    //     if (name == "" || name == "") {
    //         labelReports.push_back(notes);
    //         labelQty.push_back(dueqty);
    //     }
    // };



    int timesOrderedTotal = 10;
    int timesPrinting = 1; 
    //int timesPrinting = (int) dueqty;
    //int timesOrderedTotal = (int) dueqty;

    string yesno;
    if(inDatabase){
        cout << "Second step: \n Printing mutliple QA Sheets and Box + Product Labels \n"
             << "Revert to BOM/Config/Serial Number printing? (y/n)\n";
        cin >> yesno;
        if(yesno == "y"){
            inDatabase = false;
            cout << "First step: \n Printing the BOM, Configuration sheet, and multiple Serial Number Lists \n";
        } else {
            timesPrinting = timesOrderedTotal - alreadyPrintedTimes(barcode);
        }
    } else {
        cout << "First step: \n Printing the BOM, Config sheet, and multiple Serial Number Lists \n";
    }
        //TODO:
        // IF REPLACED, REMOVE scannerLogCleanerYearlyUpdate.cpp / yearlyLogCleanup.exe
        // AND REMOVE THE WINDOWS TASK SCHEDUALER TASK THAT RUNS THE EXE EVERY YEAR
        // the program is set to remove the log once the times printed equals the total times ordered
        // OUTDATED - ask to leave in for reprinting purposes :D
    cout << "How many times would you like to print? [default = " << timesPrinting <<
            " ]. \n [Enter] to continue with the default, otherwise submit a new number to change\n";
    string input;
    cin.ignore();
    getline(cin, input);
    if ( !input.empty() ) {
        std::istringstream stream( input );
        stream >> timesPrinting;
    }
    string s, s2, s3, s4;
    int startingSN = SerialNumberGet();

    if (inDatabase) { //if we have seen the barcode before, print labels
        cout << "What should the input specification be?\n [Enter] for nothing\n";
        string inputSpec;
        cin.ignore();
        getline(cin, input);
        if ( !input.empty() ) {
            std::istringstream stream( input );
            stream >> inputSpec;
        }

        //print labels through a bat file
        //printLabels.bat takes in ordnum, serial, code, inputspec, firstSerial
        updateDatabase(barcode, timesPrinting);
        for(int i = 0; i < timesPrinting; i++){
            int serialNum = SerialNumberGet();
            for(int j = 0; j < labelReports.size(); j++){ // prints all labels in assembly - some arnt?
                // inside of ONE notes section
                for(int k = 0; k < labelQty[j]; k++){
                    // take in first two tokens of label Reports and check?
                    // need standardization of this process
                    s = "printLabels.bat " + barcode + " " + to_string(serialNum) + " " + labelReports[j] + " "  + inputSpec ;
                }
            }
            // printlabels needs to be updated
            s = "printLabels.bat " + barcode + " " + to_string(serialNum) + " x " + inputSpec;
            system( s.c_str() );
            s = "serialNumberCountUp.bat";
            system( s.c_str() );
        }

        //reprint loop for eran
        do {
            cout << "Reprint All, One, or None? (a/1/n)\n";
            cin >> yesno;
            if (yesno == "a") {
                for(int i = 0 ; i < timesPrinting; i++){
                    s = "printLabels.bat " + barcode + " " + to_string(startingSN + i) + " x " + inputSpec + " ";
                    system( s.c_str() );
                }
            } else if (yesno == "1") {
                string sn, document;
                cout << "Which Serial Number?\n";
                cin >> sn;
                s = "printLabels.bat " + barcode + " " + sn + " x " + inputSpec  + " ";
                system( s.c_str() );
            }
        } while (yesno != "n");
        

    } else { // havn't seen it before, so print BOM, config, SN list
        if (!Contains(barcode)) {
            addDatabase(barcode, timesOrderedTotal);
        }
        s3 = " " + to_string(timesPrinting); // print times
        s2 = " " + to_string(timesOrderedTotal); // change to part num when mssql
        s = "printWIP.bat " + barcode + s2 + s3;   
        system( s.c_str() ); 
    }
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

int alreadyPrintedTimes(string data) {
    // checks how many times the barcode has been printed
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
            return printedTimes;
        }
    }
    return 0;
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
        //if(printedTimes != numOfOrders){  //this prevents repeat printing which could be an issue ASK
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


