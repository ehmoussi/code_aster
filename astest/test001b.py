#!/usr/bin/python

import code_aster

acier = code_aster.Material()
tmp = code_aster.ElasticMaterialBehaviour()
tmp.setDoubleValue("E", 2.e11)
tmp.setDoubleValue("Nu", 0.3)

acier.addMaterialBehaviour(tmp)
acier.build()
