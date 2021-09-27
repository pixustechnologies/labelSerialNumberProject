SELECT DISTINCT ps.PARPRT_02, ps.COMPRT_02, wn.NOTES_61
FROM    Windows_Notes wn, Product_Structure ps, Part_Master pm
WHERE   wn.COMPRT_61 = ps.COMPRT_02
        AND wn.PRTNUM_61 = ps.PARPRT_02
        AND ps.COMPRT_02 = 'D' + 'o' + 'c' + 'u'  + 'm'  + 'e'  + 'n'  + 't'  + ' '  + 'B'  + 'O'  + 'M' 
        