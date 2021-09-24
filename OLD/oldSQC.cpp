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
#include <stdio.h>
// #include <sqlca.h>
// #include "util.h"

using namespace std;

// EXEC SQL INCLUDE SQLCA;

int main(int argc, char* argv[]) {   
    // starts via autohotkey
    // scanner types into console
    string barcode;
    barcode = argv[1];
    cout << barcode << endl;
    string impdb = "WATDBS01";
    string impu  = "report";
    string impps = "/SQ/R#3's5~.";


    // queries the database to get the part name and quantity
    // EXEC SQL BEGIN DECLARE SECTION;
    //     char db[13], u[6], ps[12];
    //     char ordernum[8], name[30];
    //     varchar notes[500];
    //     float dueqty;
    // EXEC SQL END DECLARE SECTION;
    // strncpy(db,impdb.c_str(),13);
    // strncpy(u,impu.c_str(),6);
    // strncpy(ps,impps.c_str(),12);
    // EXEC SQL CONNECT TO :db USER :u USING :ps;
    // EXEC SQL WHENEVER SQLERROR  GO TO error;
    // strncpy(ordernum,barcode.c_str(),10);
    // EXEC SQL SELECT om.DUEQTY_10 INTO :dueqty
    //     FROM    Order_Master om
    //     WHERE   :ordernum LIKE om.ORDNUM_10 
    //             AND :name = om.PRTNUM_10;
             
    int timesOrderedTotal = 10;
    int timesPrinting = 10;
    string partNum;
    // partNum = name;
    // timesPrinting = (int) dueqty;
    // timesOrderedTotal = (int) dueqty;  

    //now searching for the labels associated with the part name
    vector<string> labelReports;
    vector<string> labelNames;
    // EXEC SQL DECLARE LabelSearch CURSOR FOR 
    //     SELECT  rd.PRTNUM_11 
    //     FROM    Requirement_Detail rd, Windows_Notes wn, Order_Master om
    //     WHERE   :ordernum LIKE rd.ORDNUM_11
    //             AND om.ORDNUM_10 = rd.ORDNUM_11
    //             AND :name = rd.PRTNUM_11
    //             AND :notes = wn.NOTES_61
    //             AND wn.COMPRT_61 = rd.PRTNUM_11
    //             AND om.PRTNUM_10 = wn.PRTNUM_61
            
    // // reduces full components down to just labels
    // EXEC SQL OPEN LabelSearch;
    // EXEC SQL WHENEVER NOT FOUND GO TO end;
    // for (;;) {
    //     EXEC SQL FETCH LabelSearch INTO :name, :notes;
    //     if (name[0] == '9' && name[1] == '4' && name[2] == 'A' || 
    //     name[0] == 'K' && name[1] == '9' && name[2] == '4' && name[3] == 'A') {
    //         labelNames.push_back(name);
    //         labelReports.push_back(notes);
    //     }
    // };



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
