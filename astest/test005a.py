import code_aster

a=code_aster.Loads.DoubleImposedTemperature(456.0)

a.addGroupOfNodes("test_node")

b=code_aster.Loads.DoubleDistributedFlow(999.5)
b.setLowerNormalFlow ( -101.0 ) 
b.setUpperNormalFlow ( +101.0 ) 
b.setFlowXYZ ( 25.0, 35.0, 45.0 )
b.addGroupOfElements("test_element")

bb=code_aster.Loads.DoubleNonLinearFlow(999.5)
bb.setFlow( 111.5 )
bb.addGroupOfElements("test_fluxnl_element")

c=code_aster.Loads.DoubleExchange(25.0)
c.setExternalTemperature( 333.55 )
c.setExchangeCoefficient( 134.56 )
c.setExternalTemperatureInfSup( 120.0 , 230.0 )
c.addGroupOfElements("test_echange_element")

cc=code_aster.Loads.DoubleExchangeWall(50.0)
cc.setTranslation( 11.0 , 22.0 , 33.0 )
cc.setExchangeCoefficient( 789.01 )
cc.addGroupOfElements("test_echange_paroi_element")

d=code_aster.Loads.DoubleThermalRadiation()
d.setExternalTemperature( 555.0 )
d.setEpsilon( 1.E-5 )
d.setSigma( 33.3 )

e=code_aster.Loads.DoubleThermalGradient()
e.setFlowXYZ( 111.0, 222.0, 333.0 )


print " fin execution "

