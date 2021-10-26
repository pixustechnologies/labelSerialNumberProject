SELECT  om.ORDNUM_10, om.PRTNUM_10, om.DUEQTY_10, rd.PRTNUM_11
FROM    Requirement_Detail rd, Order_Master om, Product_Structure ps, Part_Master pm
WHERE   om.ORDNUM_10 = rd.ORDNUM_11
        AND LEFT(om.ORDNUM_10, 1) = '5'
        AND LEFT(om.ORDNUM_10, 8) = '5' + '0' + '0' + '0' + '2' + '0' + '8' + '0'
        AND pm.PRTNUM_01 = ps.COMPRT_02
        AND ps.PARPRT_02 = om.PRTNUM_10
        AND ( pm.TYPE_01 = 'S'
        OR rd.PRTNUM_11 = ps.COMPRT_02)

ORDER BY om.ORDNUM_10