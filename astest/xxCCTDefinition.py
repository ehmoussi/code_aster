#!/usr/bin/python
# coding: utf-8

import code_aster
from code_aster.Commands import *

code_aster.init()

test = code_aster.TestCase()

TRC=DEFI_TRC( HIST_EXP=(
        _F(  VALE = ( -1.106E+03,  1.100E+01,  8.563E+00, -2.760E-02,
                    1.220E-04, -2.955E-07,  3.402E-10, -1.517E-13,
                    0.000E+00,  0.000E+00,  0.000E+00,  8.360E+00,
                    1.000E-01, -2.000E-01,  0.000E+00,  6.001E+00,
                    5.000E-01,  0.000E+00,  1.000E+00,  3.450E+00, )),
        _F(  VALE = ( -2.206E+03,  1.100E+01,  8.563E+00, -2.760E-02,
                    1.220E-04, -2.955E-07,  3.402E-10, -1.517E-13,
                    0.000E+00,  0.000E+00,  0.000E+00,  8.360E+00,
                    0.000E+00,  1.000E-02,  3.000E-01,  6.001E+00,
                    2.000E-01,  1.000E-01,  1.000E+00,  3.450E+00, ))),
              TEMP_MS=(
                    _F(
                              SEUIL = -1.6,
                              AKM = 1.45,
                              BKM = 0.85,
                              TPLM = -2.6),
                    ) )


test.assertEqual(TRC.getType(), "TABLE_SDASTER")

test.printSummary()

FIN()
