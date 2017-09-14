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

# person_in_charge: mathieu.courtois@edf.fr

from libaster import Function
import aster


class injector(object):
    class __metaclass__(Function.__class__):
        def __init__(self, name, bases, dict):
            for b in bases:
                if type(b) not in (self, type):
                    for k, v in dict.items():
                        setattr(b, k, v)
            return type.__init__(self, name, bases, dict)


# inject some methods in the point foo
class ExtendedFunction(injector, Function):
    cata_sdj = "SD.sd_fonction.sd_fonction_aster"

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
