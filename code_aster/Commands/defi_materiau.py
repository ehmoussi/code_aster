# coding: utf-8

# Copyright (C) 1991 - 2020  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

# person_in_charge: mathieu.courtois@edf.fr

import numpy

from .. import Objects as all_types
from ..Cata.Language.SyntaxObjects import _F
from ..Messages import UTMESS
from ..Objects import (DataStructure, Formula, Function,
                       GenericMaterialProperty, Material, MaterialProperty,
                       Function2D, Table)
from ..Supervis import ExecuteCommand, replace_enum


class MaterialDefinition(ExecuteCommand):

    """Definition of the material properties.
    Returns a :class:`~code_aster.Objects.Material` object.
    """
    command_name = "DEFI_MATERIAU"

    def create_result(self, keywords):
        """Initialize the :class:`~code_aster.Objects.Material`.

        Arguments:
            keywords (dict): Keywords arguments of user's keywords.
        """
        if keywords.get("reuse"):
            assert keywords["reuse"] == keywords["MATER"]
            self._result = keywords["MATER"]
        else:
            self._result = Material()

    def exec_(self, keywords):
        """Execute the command.

        Arguments:
            keywords (dict): User's keywords.
        """

        # In this function, we can check the value of keywords
        check_keywords(keywords)
        print("AVANT: ", keywords)

        #ne marche pas
        replace_enum(self._cata, keywords)

        print("AVANT ENUM: ", keywords)

        #provosire
        if 'BETON_DOUBLE_DP' in keywords:
            txt2real = {"LINEAIRE":0,"PARABOLE":1}
            keywords['BETON_DOUBLE_DP']['ECRO_COMP_P_PIC'] = txt2real[keywords['BETON_DOUBLE_DP']['ECRO_COMP_P_PIC']]

            txt2real = {"LINEAIRE":0,"EXPONENT":1}
            keywords['BETON_DOUBLE_DP']['ECRO_TRAC_P_PIC'] = txt2real[keywords['BETON_DOUBLE_DP']['ECRO_TRAC_P_PIC']]
        if 'BETON_RAG' in keywords:
            txt2real = {"ENDO":1,"ENDO_FLUA":2,"ENDO_FLUA_RAG":3}
            keywords['BETON_RAG']['COMP_BETON'] = txt2real[keywords['BETON_RAG']['COMP_BETON']]
        if 'CABLE_GAINE_FROT' in keywords:
            txt2real = {"FROTTANT":1,"GLISSANT":2,"ADHERENT":3}
            keywords['CABLE_GAINE_FROT']['TYPE'] = txt2real[keywords['CABLE_GAINE_FROT']['TYPE']]
        if 'DIS_ECRO_TRAC' in keywords:
            txt2real = {'ISOTROPE':1,'CINEMATIQUE':2}
            if 'ECROUISSAGE' in keywords['DIS_ECRO_TRAC']:
                keywords['DIS_ECRO_TRAC']['ECROUISSAGE'] = txt2real[keywords['DIS_ECRO_TRAC']['ECROUISSAGE']]
        if 'DIS_CHOC_ENDO' in keywords:
            txt2real = {"INCLUS":1,"EXCLUS":2}
            keywords['DIS_CHOC_ENDO']['CRIT_AMOR'] = txt2real[keywords['DIS_CHOC_ENDO']['CRIT_AMOR']]
        if 'ELAS_META' in keywords:
            txt2real = {"CHAUD":1,"FROID":0}
            keywords['ELAS_META']['PHASE_REFE'] = txt2real[keywords['ELAS_META']['PHASE_REFE']]
        if 'ELAS_META_FO' in keywords:
            txt2real = {"CHAUD":1,"FROID":0}
            keywords['ELAS_META_FO']['PHASE_REFE'] = txt2real[keywords['ELAS_META_FO']['PHASE_REFE']]
        if 'RUPT_FRAG' in keywords:
            txt2real = {"UNILATER":0,"GLIS_1D":1,"GLIS_2D":2}
            keywords['RUPT_FRAG']['CINEMATIQUE'] = txt2real[keywords['RUPT_FRAG']['CINEMATIQUE']]
        if 'RUPT_FRAG_FO' in keywords:
            txt2real = {"UNILATER":0,"GLIS_1D":1,"GLIS_2D":2}
            keywords['RUPT_FRAG_FO']['CINEMATIQUE'] = txt2real[keywords['RUPT_FRAG_FO']['CINEMATIQUE']]
        if 'CZM_LAB_MIX' in keywords:
            txt2real = {"UNILATER":0,"GLIS_1D":1,"GLIS_2D":2}
            keywords['CZM_LAB_MIX']['CINEMATIQUE'] = txt2real[keywords['CZM_LAB_MIX']['CINEMATIQUE']]

        print("APRES DICT: ", keywords)

        mater = keywords.get("MATER")
        if keywords.get("reuse"):
            self._result.setReferenceMaterial(mater)
        elif mater is not None:
                if mater.getName() != self._result.getName():
                    self._result.setReferenceMaterial(mater)

        classByName = MaterialDefinition._byKeyword()
        materByName = self._buildInstance(keywords, classByName)
        for fkwName, fkw in keywords.items():
            if type(fkw) in (list, tuple):
                assert len(fkw) == 1
                fkw = fkw[0]
            # only see factor keyword
            if not isinstance(fkw, dict):
                continue
            if fkwName in materByName:
                matBehav = materByName[fkwName]
                klassName = matBehav.getName()
            else:
                klass = classByName.get(fkwName)
                if not klass:
                    raise NotImplementedError("Unsupported behaviour: '{0}'"
                                              .format(fkwName))
                matBehav = klass()
                klassName = klass.__name__
            for skwName, skw in fkw.items():
                if skwName == "ORDRE_PARAM":
                    matBehav.setSortedListParameters(list(skw))
                    continue
                iName = skwName.capitalize()
                if fkwName in ("MFRONT", "UMAT"):
                    matBehav.setVectorOfRealValue(iName, list(skw))
                    continue
                if fkwName in ("MFRONT_FO", "UMAT_FO"):
                    matBehav.setVectorOfFunctionValue(iName, list(skw))
                    continue
                if type(skw) in (float, int, numpy.float64):
                    cRet = matBehav.setRealValue(iName, float(skw))
                    if not cRet:
                        print(ValueError("Can not assign keyword '{1}'/'{0}' "
                                         "(as '{3}'/'{2}') "
                                         .format(skwName, fkwName, iName,
                                                 klassName)))
                elif type(skw) is complex:
                    cRet = matBehav.setComplexValue(iName, skw)
                    if not cRet:
                        print(ValueError("Can not assign keyword '{1}'/'{0}' "
                                         "(as '{3}'/'{2}') "
                                         .format(skwName, fkwName, iName,
                                                 klassName)))
                elif type(skw) is str:
                    cRet = matBehav.setStringValue(iName, skw)
                elif type(skw) is Table:
                    cRet = matBehav.setTableValue(iName, skw)
                elif type(skw) is Function:
                    cRet = matBehav.setFunctionValue(iName, skw)
                elif type(skw) is Function2D:
                    cRet = matBehav.setFunction2DValue(iName, skw)
                elif type(skw) is Formula:
                    cRet = matBehav.setFormulaValue(iName, skw)
                elif type(skw) is tuple and type(skw[0]) is str:
                    if skw[0] == "RI":
                        comp = complex(skw[1], skw[2])
                        cRet = matBehav.setComplexValue(iName, comp)
                    else:
                        raise NotImplementedError("Unsupported type for keyword: "
                                                  "{0} <{1}>"
                                                  .format(skwName, type(skw)))
                elif type(skw) in (list, tuple) and type(skw[0]) in (float, int, numpy.float64):
                    cRet = matBehav.setVectorOfRealValue(iName, list(skw))
                else:
                    raise NotImplementedError("Unsupported type for keyword: "
                                              "{0} <{1}>"
                                              .format(skwName, type(skw)))
                if not cRet:
                    raise NotImplementedError("Unsupported keyword: "
                                              "{0}"
                                              .format(iName))
            self._result.addMaterialProperty(matBehav)

        self._result.build()

    def _buildInstance(self, keywords, dictClasses):
        """Build a dict with MaterialProperty

        Returns:
            dict: Behaviour instances from keywords of command.
        """
        objects = {}
        for materName, skws in keywords.items():
            if materName in dictClasses:
                materClass = dictClasses[materName]
                if materClass().hasTractionFunction():
                    objects[materName] = materClass()
                    continue
                if materClass().hasEnthalpyFunction():
                    objects[materName] = materClass()
                    continue
            asterNewName = ""
            if materName[-2:] == "FO":
                asterNewName = materName[:-3]
            mater = MaterialProperty(materName, asterNewName)
            if type(skws) in (list, tuple):
                assert len(skws) == 1
                skws = skws[0]
            if isinstance(skws, _F) or type(skws) is dict:
                for kwName, kwValue in skws.items():
                    curType = type(kwValue)
                    mandatory = False
                    if kwName == "ORDRE_PARAM":
                        continue
                    if curType in (float, int, numpy.float64):
                        mater.addNewRealProperty(kwName, mandatory)
                    elif curType is complex:
                        mater.addNewComplexProperty(kwName, mandatory)
                    elif curType is str:
                        mater.addNewStringProperty(kwName, mandatory)
                    elif isinstance(kwValue, Function) or\
                            isinstance(kwValue, Function2D) or\
                            isinstance(kwValue, Formula):
                        mater.addNewFunctionProperty(kwName, mandatory)
                    elif isinstance(kwValue, Table):
                        mater.addNewTableProperty(kwName, mandatory)
                    elif type(kwValue) in (list, tuple):
                        if type(kwValue[0]) is float:
                            mater.addNewVectorOfRealProperty(
                                kwName, mandatory)
                        elif isinstance(kwValue[0], DataStructure):
                            mater.addNewVectorOfFunctionProperty(
                                kwName, mandatory)
                        elif kwValue[0] == 'RI':
                            mater.addNewComplexProperty(kwName, mandatory)
                        elif type(kwValue[0]) is str:
                            pass
                        else:
                            raise NotImplementedError("Type not implemented for"
                                                      " material property: '{0}'"
                                                      .format(kwName))
                    else:
                        raise NotImplementedError("Type not implemented for"
                                                  " material property: '{0}'"
                                                  .format(kwName))
            objects[materName] = mater
        return objects

    @staticmethod
    def _byKeyword():
        """Build a dict of all behaviours subclasses, indexed by keyword.

        Returns:
            dict: Behaviour classes by keyword in DEFI_MATERIAU.
        """
        objects = {}
        for _, obj in list(all_types.__dict__.items()):
            if not isinstance(obj, type):
                continue
            if not issubclass(obj, GenericMaterialProperty):
                continue
            if issubclass(obj, MaterialProperty):
                continue
            key = ""
            try:
                key = obj.getName()
            except:
                key = obj().getAsterName()
            objects[key] = obj
        return objects


DEFI_MATERIAU = MaterialDefinition.run


def check_keywords(kwargs):
    """Check for DEFI_MATERIAU keywords

    Arguments:
        kwargs (dict): User's keywords, changed in place.
    """

    if 'DIS_ECRO_TRAC' in kwargs:
        kwargs['DIS_ECRO_TRAC'] = check_dis_ecro_trac(kwargs['DIS_ECRO_TRAC'])
    if 'DIS_CHOC_ENDO' in kwargs:
        kwargs['DIS_CHOC_ENDO'] = check_dis_choc_endo(kwargs['DIS_CHOC_ENDO'])


def check_dis_ecro_trac(keywords):
    """Check for function for DIS_ECRO_TRAC

    Arguments:
        keywords (dict): DIS_ECRO_TRAC keyword, changed in place.

    Returns:
        dict: DIS_ECRO_TRAC keyword changed in place.

        Raises '<F>' in case of error.
    """
    #
    # jean-luc.flejou@edf.fr
    #
    def _message(num, mess=''):
        UTMESS('F', 'DISCRETS_62',
               valk=('DIS_ECRO_TRAC', 'FX=f(DX) | FTAN=f(DTAN)', mess),
               vali=num)

    precis = 1.0e-08
    #
    Clefs = keywords
    #
    if 'FX' in Clefs:
        iffx = True
        fct = Clefs['FX']
    elif 'FTAN' in Clefs:
        iffx = False
        fct = Clefs['FTAN']
    else:
        _message(1)
    # Les vérifications sur la fonction
    #       interpolation LIN LIN
    #       prolongée à gauche et à droite exclue
    #       paramètre 'DX' ou 'DTAN'
    OkFct = type(fct) is Function
    param = fct.Parametres()
    OkFct = OkFct and param['INTERPOL'][0] == 'LIN'
    OkFct = OkFct and param['INTERPOL'][1] == 'LIN'
    OkFct = OkFct and param['PROL_DROITE'] == 'EXCLU'
    OkFct = OkFct and param['PROL_GAUCHE'] == 'EXCLU'
    if iffx:
        OkFct = OkFct and param['NOM_PARA'] == 'DX'
    else:
        OkFct = OkFct and param['NOM_PARA'] == 'DTAN'
    if not OkFct:
        _message(2, "%s" % param)
    # avoir 3 points minimum ou exactement
    absc, ordo = fct.Valeurs()
    if iffx:
        OkFct = OkFct and len(absc) >= 3
    else:
        if Clefs['ECROUISSAGE'] == 'ISOTROPE':
            OkFct = OkFct and len(absc) >= 3
        elif Clefs['ECROUISSAGE'] == 'CINEMATIQUE':
            OkFct = OkFct and len(absc) == 3
        else:
            raise RuntimeError("Unknown value")
    #
    if not OkFct:
        _message(3, "%s" % len(absc))
    # Point n°1: (DX=0, FX=0)
    dx = absc[0]
    fx = ordo[0]
    OkFct = OkFct and dx >= 0.0 and abs(dx) <= precis
    OkFct = OkFct and fx >= 0.0 and abs(fx) <= precis
    if not OkFct:
        _message(4,"[%s %s]" % (dx, fx))
    # FX et DX sont strictement positifs, dFx >0 , dDx >0
    #   Au lieu de la boucle, on peut faire :
    #       xx=np.where(np.diff(absc) <= 0.0 or np.diff(ordo) <= 0.0)[0]
    #       if ( len(xx) != 0):
    #           message 6 : absc[xx[0]] ordo[xx[0]] absc[xx[0]+1] ordo[xx[0]+1]
    #       dfx= np.diff(ordo)/np.diff(absc)
    #       xx=np.where(np.diff(dfx) <= 0.0 )[0]
    #       if ( len(xx) != 0):
    #           message 7 : xx[0] dfx[xx[0]] dfx[xx[0]+1]
    for ii in range(1, len(absc)):
        if absc[ii] <= dx or ordo[ii] <= fx:
            _message(5, "Ddx, Dfx > 0 : p(i)[%s %s]  "
                     "p(i+1)[%s %s]" % (dx, fx, absc[ii], ordo[ii]))
        if ii == 1:
            dfx = (ordo[ii] - fx)/(absc[ii] - dx)
            raidex = dfx
        else:
            dfx = (ordo[ii] - fx)/(absc[ii] - dx)
            if dfx > raidex:
                _message(6, "(%d) : %s > %s" % (ii, dfx, raidex))

        dx = absc[ii]
        fx = ordo[ii]
        raidex = dfx

    return Clefs


def check_dis_choc_endo(keywords):
    """Check for functions for DIS_CHOC_ENDO

    Arguments:
        keywords (dict): DIS_CHOC_ENDO keyword, changed in place.

    Returns:
        dict: DIS_CHOC_ENDO keyword changed in place. Raises '<F>' in case of
        error.
    """
    #
    # jean-luc.flejou@edf.fr
    #
    def _message(num, mess2='', mess3=''):
        UTMESS('F', 'DISCRETS_63',
               valk=('DIS_CHOC_ENDO', mess2, mess3),
               vali=(num,))

    precis = 1.0e-08
    #
    Clefs = keywords

    # Conditions communes aux 3 fonctions
    #   paramètre 'DX'
    #   interpolation LIN LIN
    #   prolongée à gauche et à droite : constant ou exclue (donc pas linéaire)
    LesFcts = [Clefs['FX'], Clefs['RIGI_NOR'], Clefs['AMOR_NOR']]
    LesFctsName = []
    for fct in LesFcts:
        OkFct = type(fct) is Function
        param = fct.Parametres()
        OkFct = OkFct and param['NOM_PARA'] == 'DX'
        OkFct = OkFct and param['INTERPOL'][0] == 'LIN'
        OkFct = OkFct and param['INTERPOL'][1] == 'LIN'
        OkFct = OkFct and param['PROL_DROITE'] != 'LINEAIRE'
        OkFct = OkFct and param['PROL_GAUCHE'] != 'LINEAIRE'
        LesFctsName.append(fct.getName())
        if not OkFct:
            _message(2, fct.getName(), "%s" % param)
    # Même nombre de point, 5 points minimum
    Fxx, Fxy = Clefs['FX'].Valeurs()
    Rix, Riy = Clefs['RIGI_NOR'].Valeurs()
    Amx, Amy = Clefs['AMOR_NOR'].Valeurs()
    OkFct = len(Fxx) == len(Rix) == len(Amx)
    OkFct = OkFct and (len(Fxx) >= 5)
    if not OkFct:
        _message(3, "%s" % LesFctsName, "%d, %d, %d" % (len(Fxx), len(Rix), len(Amx)))
    # La 1ère abscisse c'est ZERO
    x1 = Fxx[0]
    if not (0.0 <= x1 <= precis):
        _message(4, "%s" % LesFctsName, "%s" % x1)
    # Même abscisses pour les 3 fonctions, à la précision près
    # Abscisses strictement croissantes, à la précision près
    #   Au lieu de la boucle, on peut faire :
    #       xx=np.where(np.abs(Fxx-Rix) + np.abs(Fxx-Amx) > precis )[0]
    #       if ( len(xx) != 0):
    #           message 5 : xx[0] Fxx[xx[0]] Rix[xx[0]] Amx[xx[0]]
    #       xx=np.where(np.diff(Fxx)<0 or np.diff(Rix)<0 or np.diff(Amx)<0)[0]
    #       if ( len(xx) != 0):
    #           message 6 : xx[0] Fxx[xx[0]] Fxx[xx[0]+1]
    xp1 = -1.0
    for ii in range(len(Fxx)):
        x1 = Fxx[ii]
        x2 = Rix[ii]
        x3 = Amx[ii]
        ddx = abs(x1-x2)+abs(x1-x3)
        if ddx > precis:
            _message(5, "%s" % LesFctsName, "(%d) : %s, %s, %s" % (ii+1, x1, x2, x3))
        if xp1 >= x1:
            _message(6, "%s" % LesFctsName, "(%d) : %s, %s" % (ii+1, xp1, x1))
        xp1 = x1
    # FX : les 2 premiers points ont la même valeur à la précision relative près
    if abs(Fxy[0]-Fxy[1]) > Fxy[0]*precis:
        _message(7, Clefs['FX'].getName())
    # RIGI_NOR : les 2 premiers points ont la même valeur à la précision relative près
    if abs(Riy[0]-Riy[1]) > Riy[0]*precis:
        _message(8, Clefs['RIGI_NOR'].getName())
    # RIGI_NOR : pente décroissante, à partir du 3ème point.
    #   Au lieu de la boucle, on peut faire :
    #       xx=np.where(np.diff(Riy[2:]) > 0.0 )[0]+2
    #       if ( len(xx) != 0):
    #           message 9 : xx[0] Riy[xx[0]] Riy[xx[0]+1]
    pente = Riy[2]
    for ii in range(3, len(Riy)):
        if Riy[ii]-pente > Riy[0]*precis:
            _message(9, "%s" % Clefs['RIGI_NOR'].getName(),"(%d) : %s %s" %(ii,pente, Riy[ii]))
        pente = Riy[ii]
    # --------------------------------------------------------------- Fin des vérifications
    # Création des fonctions
    newFx = Function()
    newFx.setResultName('Force   (plast cumulée)')
    newRi = Function()
    newRi.setResultName('Raideur (plast cumulée)')
    newAm = Function()
    newAm.setResultName('Amort.  (plast cumulée)')
    newFx.setExtrapolation('CC')
    newRi.setExtrapolation('CC')
    newAm.setExtrapolation('CC')
    newFx.setInterpolation('LIN LIN')
    newRi.setInterpolation('LIN LIN')
    newAm.setInterpolation('LIN LIN')
    newFx.setParameterName('PCUM')
    newRi.setParameterName('PCUM')
    newAm.setParameterName('PCUM')
    # Modification des abscisses pour avoir la plasticité cumulée et plus le déplacement
    pp9 = numpy.round(numpy.array(Fxx) - numpy.array(Fxy) / numpy.array(Riy), 10)
    # Le 1er point a une abscisse négative et la valeur du 2ème point
    pp9[0] = -pp9[2]
    # Vérification que p est strictement croissant.
    #   Au lieu de la boucle, on peut faire :
    #       xx=np.where(np.diff(pp9) < 0)[0]
    #       if ( len(xx) != 0):
    #           message 10 : xx[0] pp9[xx[0]] pp9[xx[0]+1]
    pp = pp9[0]
    for ii in range(1, len(pp9)):
        if pp > pp9[ii]:
            _message(10, mess3="(%d) : %s %s" % (ii, pp, pp9[ii]))
        pp = pp9[ii]
    #
    # Affectations des valeurs
    newFx.setValues(pp9, Fxy)
    newRi.setValues(pp9, Riy)
    newAm.setValues(pp9, Amy)
    # Affectation des nouvelles fonctions
    Clefs['FXP'] = newFx
    Clefs['RIGIP'] = newRi
    Clefs['AMORP'] = newAm
    #
    return Clefs
