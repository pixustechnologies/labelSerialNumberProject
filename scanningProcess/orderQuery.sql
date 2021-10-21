SELECT DISTINCT om.ORDNUM_10, om.PRTNUM_10, om.DUEQTY_10, 
        CASE pm.TYPE_01 WHEN 'S'        THEN pm.PRTNUM_01
                                        ELSE om.PRTNUM_10
        END AS ASSPRT
FROM    Requirement_Detail rd, Order_Master om, Product_Structure ps, Part_Master pm
WHERE   om.ORDNUM_10 = rd.ORDNUM_11
        AND LEFT(om.ORDNUM_10, 1) = '5'
        AND om.DUEQTY_10 > 0 
        AND pm.PRTNUM_01 = ps.COMPRT_02
        AND ps.PARPRT_02 = om.PRTNUM_10
        AND om.STATUS_10 = '3'
        AND ((pm.TYPE_01 = 'S' 
                AND (LEFT(pm.PRTNUM_01, 3) = '0' + '2' + 'A' OR LEFT(pm.PRTNUM_01, 4) = 'K' + '0' + '2' + 'A') )
        OR rd.PRTNUM_11 = ps.COMPRT_02)

ORDER BY om.ORDNUM_10, ASSPRT

