# coding=utf-8
# ======================================================================
# COPYRIGHT (C) 1991 - 2017  EDF R&D                  WWW.CODE-ASTER.ORG
# THIS PROGRAM IS FREE SOFTWARE; YOU CAN REDISTRIBUTE IT AND/OR MODIFY
# IT UNDER THE TERMS OF THE GNU GENERAL PUBLIC LICENSE AS PUBLISHED BY
# THE FREE SOFTWARE FOUNDATION; EITHER VERSION 2 OF THE LICENSE, OR
# (AT YOUR OPTION) ANY LATER VERSION.
#
# THIS PROGRAM IS DISTRIBUTED IN THE HOPE THAT IT WILL BE USEFUL, BUT
# WITHOUT ANY WARRANTY; WITHOUT EVEN THE IMPLIED WARRANTY OF
# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. SEE THE GNU
# GENERAL PUBLIC LICENSE FOR MORE DETAILS.
#
# YOU SHOULD HAVE RECEIVED A COPY OF THE GNU GENERAL PUBLIC LICENSE
# ALONG WITH THIS PROGRAM; IF NOT, WRITE TO EDF R&D CODE_ASTER,
#    1 AVENUE DU GENERAL DE GAULLE, 92141 CLAMART CEDEX, FRANCE.
# ======================================================================
# person_in_charge: mathieu.courtois at edf.fr

import os
import os.path as osp

import Accas
from Accas import *
from Accas import _F
from . import ops


JdC = JDC_CATA(code='ASTER',
               execmodul=None,
               regles=(UN_PARMI('DEBUT', 'POURSUITE'),
                       AU_MOINS_UN('FIN'),
                       A_CLASSER(('DEBUT', 'POURSUITE'), 'FIN')))


class FIN_ETAPE(PROC_ETAPE):
    """Particularisation pour FIN"""
    def Build_sd(self):
        """Fonction Build_sd pour FIN"""
        PROC_ETAPE.Build_sd(self)
        if self.nom == 'FIN':
            try:
                from Noyau.N_Exception import InterruptParsingError
                raise InterruptParsingError
            except ImportError:
                # eficas does not known this exception
                pass
        return None


class FIN_PROC(PROC):
    """Procédure FIN"""
    class_instance = FIN_ETAPE
