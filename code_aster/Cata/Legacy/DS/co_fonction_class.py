# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
# This file is part of code_aster.
#
# code_aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# code_aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
# --------------------------------------------------------------------

# person_in_charge: mathieu.courtois at edf.fr

import os
from math import pi

import aster
from code_aster.Cata.Syntax import ASSD, AsException


class fonction_class(ASSD):
    cata_sdj = "SD.sd_fonction.sd_fonction_aster"

    def Valeurs(self):
        pass

    def Parametres(self):
        """
        Retourne un dictionnaire contenant les parametres de la fonction ;
        le type jeveux (FONCTION, FONCT_C, NAPPE) n'est pas retourne,
        le dictionnaire peut ainsi etre fourni a CALC_FONC_INTERP tel quel.
        """
        from Utilitai.Utmess import UTMESS
        if self.accessible():
            TypeProl = {'E': 'EXCLU', 'L': 'LINEAIRE', 'C': 'CONSTANT'}
            objev = '%-19s.PROL' % self.get_name()
            prol = self.sdj.PROL.get()
            if prol == None:
                UTMESS('F', 'SDVERI_2', valk=[objev])
            dico = {
                'INTERPOL': [prol[1][0:3], prol[1][4:7]],
                'NOM_PARA': prol[2][0:16].strip(),
                'NOM_RESU': prol[3][0:16].strip(),
                'PROL_DROITE': TypeProl[prol[4][1]],
                'PROL_GAUCHE': TypeProl[prol[4][0]],
            }
        elif hasattr(self, 'etape') and self.etape.nom == 'DEFI_FONCTION':
            dico = {
                'INTERPOL': self.etape['INTERPOL'],
                'NOM_PARA': self.etape['NOM_PARA'],
                'NOM_RESU': self.etape['NOM_RESU'],
                'PROL_DROITE': self.etape['PROL_DROITE'],
                'PROL_GAUCHE': self.etape['PROL_GAUCHE'],
            }
            if type(dico['INTERPOL']) == tuple:
                dico['INTERPOL'] = list(dico['INTERPOL'])
            elif type(dico['INTERPOL']) == str:
                dico['INTERPOL'] = [dico['INTERPOL'], ]
            if len(dico['INTERPOL']) == 1:
                dico['INTERPOL'] = dico['INTERPOL'] * 2
        else:
            raise AsException("Erreur dans fonction.Parametres en PAR_LOT='OUI'")
        return dico

    def Trace(self, FORMAT='TABLEAU', **kargs):
        """Tracé d'une fonction"""
        if not self.accessible():
            raise AsException("Erreur dans fonction.Trace en PAR_LOT='OUI'")
        from Utilitai.Graph import Graph
        gr = Graph()
        gr.AjoutCourbe(Val=self.Valeurs(),
                       Lab=[
            self.Parametres(
            )['NOM_PARA'], self.Parametres()['NOM_RESU']],
            Leg=os.linesep.join(self.sdj.TITR.get()))
        gr.Trace(FORMAT=FORMAT, **kargs)


class fonction_sdaster(fonction_class):

    def convert(self, arg='real'):
        """
        Retourne un objet de la classe t_fonction
        représentation python de la fonction
        """
        from Cata_Utils.t_fonction import t_fonction, t_fonction_c
        class_fonction = t_fonction
        if arg == 'complex':
            class_fonction = t_fonction_c
        absc, ordo = self.Valeurs()
        return class_fonction(absc, ordo, self.Parametres(), nom=self.nom)

    def Valeurs(self):
        """
        Retourne deux listes de valeurs : abscisses et ordonnees
        """
        from Utilitai.Utmess import UTMESS
        if self.accessible():
            vale = '%-19s.VALE' % self.get_name()
            lbl = self.sdj.VALE.get()
            if lbl == None:
                UTMESS('F', 'SDVERI_2', valk=[vale])
            lbl = list(lbl)
            dim = len(lbl) / 2
            lx = lbl[0:dim]
            ly = lbl[dim:2 * dim]
        elif hasattr(self, 'etape') and self.etape.nom == 'DEFI_FONCTION':
            if self.etape['VALE'] is not None:
                lbl = list(self.etape['VALE'])
                dim = len(lbl)
                lx = [lbl[i] for i in range(0, dim, 2)]
                ly = [lbl[i] for i in range(1, dim, 2)]
            elif self.etape['VALE_PARA'] is not None:
                lx = self.etape['VALE_PARA'].Valeurs()
                ly = self.etape['VALE_FONC'].Valeurs()
            elif self.etape['ABSCISSE'] is not None:
                lx = self.etape['ABSCISSE']
                ly = self.etape['ORDONNEE']
            else:
                raise AsException("Erreur (fonction.Valeurs) : ne fonctionne en "
                                  "PAR_LOT='OUI' que sur des fonctions produites "
                                  "par DEFI_FONCTION dans le jdc courant.")
        else:
            raise AsException("Erreur (fonction.Valeurs) : ne fonctionne en "
                              "PAR_LOT='OUI' que sur des fonctions produites "
                              "par DEFI_FONCTION dans le jdc courant.")
        return [lx, ly]

    def Absc(self):
        """Retourne la liste des abscisses"""
        return self.Valeurs()[0]

    def Ordo(self):
        """Retourne la liste des ordonnées"""
        return self.Valeurs()[1]

    def __call__(self, val, tol=1.e-6):
        """Evaluate a function at 'val'. If provided, 'tol' is a relative
        tolerance to match an abscissa value."""
        # Pour EFICAS : substitution de l'instance de classe
        # parametre par sa valeur
        if isinstance(val, ASSD):
            val = val.valeur
        __ff = self.convert()
        return __ff(val, tol=tol)


class fonction_c(fonction_class):

    def convert(self, arg='real'):
        """
        Retourne un objet de la classe t_fonction ou t_fonction_c,
        représentation python de la fonction complexe
        """
        import numpy
        from Cata_Utils.t_fonction import t_fonction, t_fonction_c
        class_fonction = t_fonction
        if arg == 'complex':
            class_fonction = t_fonction_c
        absc = self.Absc()
        para = self.Parametres()
        if arg == 'real':
            ordo = self.Ordo()
        elif arg == 'imag':
            ordo = self.OrdoImg()
        elif arg == 'modul':
            ordo = numpy.sqrt(
                numpy.array(self.Ordo())**2 + numpy.array(self.OrdoImg())**2)
        elif arg == 'phase':
            ordo = numpy.arctan2(
                numpy.array(self.OrdoImg()), numpy.array(self.Ordo())) * 180. / pi
        elif arg == 'complex':
            ordo = map(complex, self.Ordo(), self.OrdoImg())
        else:
            assert False, 'unexpected value for arg: %r' % arg
        return class_fonction(self.Absc(), ordo, self.Parametres(), nom=self.nom)

    def Valeurs(self):
        """
        Retourne trois listes de valeurs : abscisses, parties reelles et imaginaires.
        """
        from Utilitai.Utmess import UTMESS
        if self.accessible():
            vale = '%-19s.VALE' % self.get_name()
            lbl = self.sdj.VALE.get()
            if lbl == None:
                UTMESS('F', 'SDVERI_2', valk=[vale])
            lbl = list(lbl)
            dim = len(lbl) / 3
            lx = lbl[0:dim]
            lr = []
            li = []
            for i in range(dim):
                lr.append(lbl[dim + 2 * i])
                li.append(lbl[dim + 2 * i + 1])
        elif hasattr(self, 'etape') and self.etape.nom == 'DEFI_FONCTION' \
                and self.etape['VALE_C'] is not None:
            lbl = list(self.etape['VALE_C'])
            dim = len(lbl)
            lx = [lbl[i] for i in range(0, dim, 3)]
            lr = [lbl[i] for i in range(1, dim, 3)]
            li = [lbl[i] for i in range(2, dim, 3)]
        else:
            raise AsException("Erreur (fonction_c.Valeurs) : ne fonctionne en "
                              "PAR_LOT='OUI' que sur des fonctions produites "
                              "par DEFI_FONCTION dans le jdc courant.")
        return [lx, lr, li]

    def Absc(self):
        """Retourne la liste des abscisses"""
        return self.Valeurs()[0]

    def Ordo(self):
        """Retourne la liste des parties réelles des ordonnées"""
        return self.Valeurs()[1]

    def OrdoImg(self):
        """Retourne la liste des parties imaginaires des ordonnées"""
        return self.Valeurs()[2]

    def Trace(self, FORMAT='TABLEAU', **kargs):
        """Tracé d'une fonction complexe"""
        if not self.accessible():
            raise AsException(
                "Erreur dans fonction_c.Trace en PAR_LOT='OUI'")
        from Utilitai.Graph import Graph
        para = self.Parametres()
        gr = Graph()
        gr.AjoutCourbe(Val=self.Valeurs(),
                       Lab=[para['NOM_PARA'], '%s_R' %
                            para['NOM_RESU'], '%s_I' % para['NOM_RESU']],
                       Leg=os.linesep.join(self.sdj.TITR.get()))
        gr.Trace(FORMAT=FORMAT, **kargs)

    def __call__(self, val, tol=1.e-6):
        """Evaluate a function at 'val'. If provided, 'tol' is a relative
        tolerance to match an abscissa value."""
        # Pour EFICAS : substitution de l'instance de classe
        # parametre par sa valeur
        if isinstance(val, ASSD):
            val = val.valeur
        __ff = self.convert(arg='complex')
        return __ff(val, tol=tol)


class nappe_sdaster(fonction_class):

    def convert(self):
        """
        Retourne un objet de la classe t_nappe, représentation python de la nappe
        """
        from Cata_Utils.t_fonction import t_fonction, t_nappe
        para = self.Parametres()
        vale = self.Valeurs()
        l_fonc = []
        i = 0
        for pf in para[1]:
            para_f = {'INTERPOL': pf['INTERPOL_FONC'],
                      'PROL_DROITE': pf['PROL_DROITE_FONC'],
                      'PROL_GAUCHE': pf['PROL_GAUCHE_FONC'],
                      'NOM_PARA': para[0]['NOM_PARA_FONC'],
                      'NOM_RESU': para[0]['NOM_RESU'],
                      }
            l_fonc.append(t_fonction(vale[1][i][0], vale[1][i][1], para_f))
            i += 1
        return t_nappe(vale[0], l_fonc, para[0], nom=self.nom)

    def Valeurs(self):
        """
        Retourne la liste des valeurs du parametre,
        et une liste de couples (abscisses,ordonnees) de chaque fonction.
        """
        from Utilitai.Utmess import UTMESS
        if not self.accessible():
            raise AsException(
                "Erreur dans nappe.Valeurs en PAR_LOT='OUI'")
        nsd = '%-19s' % self.get_name()
        dicv = aster.getcolljev(nsd + '.VALE')
        # les cles de dicv sont 1,...,N (indice du parametre)
        lpar = aster.getvectjev(nsd + '.PARA')
        if lpar == None:
            UTMESS('F', 'SDVERI_2', valk=[nsd + '.PARA'])
        lval = []
        for k in range(len(dicv)):
            lbl = dicv[k + 1]
            dim = len(lbl) / 2
            lval.append([lbl[0:dim], lbl[dim:2 * dim]])
        return [list(lpar), lval]

    def Parametres(self):
        """
        Retourne un dictionnaire contenant les parametres de la nappe,
        le type jeveux (NAPPE) n'est pas retourne,
        le dictionnaire peut ainsi etre fourni a CALC_FONC_INTERP tel quel,
        et une liste de dictionnaire des parametres de chaque fonction.
        """
        from Utilitai.Utmess import UTMESS
        if not self.accessible():
            raise AsException(
                "Erreur dans nappe.Parametres en PAR_LOT='OUI'")
        TypeProl = {'E': 'EXCLU', 'L': 'LINEAIRE', 'C': 'CONSTANT'}
        objev = '%-19s.PROL' % self.get_name()
        prol = aster.getvectjev(objev)
        if prol == None:
            UTMESS('F', 'SDVERI_2', valk=[objev])
        dico = {
            'INTERPOL': [prol[1][0:3], prol[1][4:7]],
           'NOM_PARA': prol[2][0:16].strip(),
           'NOM_RESU': prol[3][0:16].strip(),
           'PROL_DROITE': TypeProl[prol[4][1]],
           'PROL_GAUCHE': TypeProl[prol[4][0]],
           'NOM_PARA_FONC': prol[6][0:4].strip(),
        }
        lparf = []
        nbf = (len(prol) - 7) / 2
        for i in range(nbf):
            dicf = {
                'INTERPOL_FONC': [prol[7 + i * 2][0:3], prol[7 + i * 2][4:7]],
               'PROL_DROITE_FONC': TypeProl[prol[8 + i * 2][1]],
               'PROL_GAUCHE_FONC': TypeProl[prol[8 + i * 2][0]],
            }
            lparf.append(dicf)
        return [dico, lparf]

    def Absc(self):
        """Retourne la liste des abscisses"""
        return self.Valeurs()[0]

    def Trace(self, FORMAT='TABLEAU', **kargs):
        """Tracé d'une nappe"""
        if not self.accessible():
            raise AsException("Erreur dans nappe.Trace en PAR_LOT='OUI'")
        from Utilitai.Graph import Graph
        gr = Graph()
        lv = self.Valeurs()[1]
        dp = self.Parametres()[0]
        for lx, ly in lv:
            gr.AjoutCourbe(
                Val=[lx, ly], Lab=[dp['NOM_PARA_FONC'], dp['NOM_RESU']],
               Leg=os.linesep.join(self.sdj.TITR.get()))
        gr.Trace(FORMAT=FORMAT, **kargs)

    def __call__(self, val1, val2, tol=1.e-6):
        """Evaluate a function at 'val'. If provided, 'tol' is a relative
        tolerance to match an abscissa value."""
        # Pour EFICAS : substitution de l'instance de classe
        # parametre par sa valeur
        if isinstance(val1, ASSD):
            val1 = val1.valeur
        if isinstance(val2, ASSD):
            val2 = val2.valeur
        __ff = self.convert()
        return __ff(val1, val2, tol=tol)
