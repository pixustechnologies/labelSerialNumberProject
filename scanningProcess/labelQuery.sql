SELECT  om.ORDNUM_10, om.PRTNUM_10, om.DUEQTY_10, 
        CASE pm.TYPE_01 WHEN 'S'        THEN ps.COMPRT_02
                                        ELSE om.PRTNUM_10
        END AS ASSPRT,
rd.PRTNUM_11, wn.NOTES_61
FROM    Requirement_Detail rd, Windows_Notes wn, Order_Master om, Product_Structure ps, Part_Master pm
WHERE   om.ORDNUM_10 = rd.ORDNUM_11
        AND wn.COMPRT_61 = rd.PRTNUM_11
        AND LEFT(om.ORDNUM_10, 1) = '5'
        AND (LEFT(rd.PRTNUM_11, 3) = '9' + '4' + 'A'
        OR LEFT(rd.PRTNUM_11, 4) = 'K' + '9' + '4' + 'A')
        AND om.DUEQTY_10 > 0 
        AND pm.PRTNUM_01 = ps.COMPRT_02
        AND ps.PARPRT_02 = om.PRTNUM_10
        AND om.STATUS_10 = '3'
        AND ( (pm.TYPE_01 = 'S' AND wn.PRTNUM_61 = ps.COMPRT_02)
        OR (rd.PRTNUM_11 = ps.COMPRT_02 AND wn.PRTNUM_61 = om.PRTNUM_10))

ORDER BY om.ORDNUM_10, ASSPRT