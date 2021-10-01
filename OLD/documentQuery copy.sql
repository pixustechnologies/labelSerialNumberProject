SELECT DISTINCT om.ORDNUM_10, 
        CASE pm.TYPE_01 WHEN 'S'        THEN ps.COMPRT_02 = om.PRTNUM_10 AND ps.PARPRT_02
                                        ELSE om.PRTNUM_10
        END AS PARPRT,
om.DUEQTY_10, rd.PRTNUM_11, wn.NOTES_61
FROM    Requirement_Detail rd, Windows_Notes wn, Order_Master om, Product_Structure ps, Part_Master pm
WHERE   om.ORDNUM_10 = rd.ORDNUM_11
        AND wn.COMPRT_61 = rd.PRTNUM_11
        AND wn.PRTNUM_61 = om.PRTNUM_10
        AND LEFT(om.ORDNUM_10, 1) = '5'
        AND rd.PRTNUM_11 = 'D' + 'o' + 'c' + 'u'  + 'm'  + 'e'  + 'n'  + 't'  + ' '  + 'B'  + 'O'  + 'M' 
        AND om.DUEQTY_10 > 0 
        AND pm.PRTNUM_01 = om.PRTNUM_10

ORDER BY om.ORDNUM_10






SELECT DISTINCT om.ORDNUM_10, 
        CASE pm.TYPE_01 WHEN 'S'        THEN ps.PARPRT_02
                                        ELSE om.PRTNUM_10
        END AS PARPRT,
om.DUEQTY_10, rd.PRTNUM_11, wn.NOTES_61
FROM    Requirement_Detail rd, Windows_Notes wn, Order_Master om, Product_Structure ps, Part_Master pm
WHERE   EXISTS (
                SELECT DISTINCT om.ORDNUM_10, pm.TYPE_01, 
                om.DUEQTY_10, rd.PRTNUM_11, wn.NOTES_61, om.PRTNUM_10
                WHERE   om.ORDNUM_10 = rd.ORDNUM_11
                        AND wn.COMPRT_61 = rd.PRTNUM_11
                        AND wn.PRTNUM_61 = om.PRTNUM_10
                        AND LEFT(om.ORDNUM_10, 1) = '5'
                        AND rd.PRTNUM_11 = 'D' + 'o' + 'c' + 'u'  + 'm'  + 'e'  + 'n'  + 't'  + ' '  + 'B'  + 'O'  + 'M' 
                        AND om.DUEQTY_10 > 0 
                        AND pm.PRTNUM_01 = om.PRTNUM_10

                ORDER BY om.ORDNUM_10 ) 
        AND (ps.COMPRT_02 = om.PRTNUM_10 OR 1=1)







SELECT DISTINCT om.ORDNUM_10, 
        CASE pm.TYPE_01 WHEN 'S'        THEN ps.PARPRT_02
                                        ELSE om.PRTNUM_10
        END AS PARPRT,
om.DUEQTY_10, rd.PRTNUM_11, wn.NOTES_61
FROM    Requirement_Detail rd, Windows_Notes wn, Order_Master om,  Product_Structure ps, Part_Master pm
WHERE   EXISTS (
        SELECT DISTINCT rd.ORDNUM_11, rd.PRTNUM_11, wn.NOTES_61
        FROM    Requirement_Detail rd, Windows_Notes wn, Order_Master om,  Product_Structure ps, Part_Master pm
        WHERE   om.ORDNUM_10 = rd.ORDNUM_11
                AND wn.COMPRT_61 = rd.PRTNUM_11
                AND wn.PRTNUM_61 = om.PRTNUM_10
                AND LEFT(om.ORDNUM_10, 1) = '5'
                AND rd.PRTNUM_11 = 'D' + 'o' + 'c' + 'u'  + 'm'  + 'e'  + 'n'  + 't'  + ' '  + 'B'  + 'O'  + 'M' 
                AND pm.PRTNUM_01 = om.PRTNUM_10
                AND om.DUEQTY_10 > 0 
)