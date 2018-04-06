# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

# Attention : cet import permet d'avoir, en Python, le comportement
# de la division réelle pour les entiers, et non la division entière
# 1/2=0.5 (et non 0). Comportement par défaut dans Python 3.0.
from __future__ import division
import pickle

from N_ASSD import ASSD
from N_info import message, SUPERV
from N_Exception import AsException


def initial_context():
    """Returns `initial` Python context (independent of Stage and Command)

    Returns:
        dict: pairs of name per corresponding Python instance.
    """
    import __builtin__
    import math
    context = {}
    context.update(__builtin__.__dict__)
    for func in dir(math):
        if not func.startswith('_'):
            context[func] = getattr(math, func)

    return context


class FONCTION(ASSD):
    pass


class formule(ASSD):

    _initial_context = initial_context()

    def __init__(self, *args, **kwargs):
        ASSD.__init__(self, *args, **kwargs)
        self.nompar = None
        self.expression = None
        self.code = None
        self.ctxt = None

    def __call__(self, *val, **dval):
        """Evaluation of the formula.

        Arguments:
            val (tuple[float]): Value of each parameter in the order of
                the `nompar` attribute.
            dval (dict): Values passed as keyword arguments.

        Returns:
            float/complex: Value of the formula.
        """
        context = {}
        context.update(self.get_context())
        if val:
            for param, value in zip(self.nompar, val):
                context[param] = value
        else:
            context.update(dval)
        try:
            res = eval(self.code, self._initial_context, context)
        except Exception, exc:
            message.error(SUPERV, "ERREUR LORS DE L'ÉVALUATION DE LA FORMULE '%s' "
                          ":\n>> %s", self.nom, str(exc))
            raise
        return res

    def setFormule(self, nom_para, texte):
        """Cette methode sert a initialiser les attributs
        nompar, expression et code qui sont utilisés
        dans l'évaluation de la formule."""
        self.nompar = nom_para
        self.expression = texte
        try:
            self.code = compile(texte, texte, 'eval')
        except SyntaxError, exc:
            message.error(SUPERV, "ERREUR LORS DE LA CREATION DE LA FORMULE '%s' "
                          ":\n>> %s", self.nom, str(exc))
            raise

    def set_context(self, objects):
        """Stocke des objets de contexte.

        Il est conseillé de passer les objets sous forme d'une 'pickled string'
        pour en faire une copie connue uniquement de la formule.

        Avec le superviseur actuel, une fonction du jeu de commandes n'est pas
        'picklable'. On ne peut donc que stocker une référence vers ces objets.
        On passe alors `objects` en tant que dictionnaire.
        """
        if not isinstance(objects, dict):
            self.ctxt = pickle.loads(objects)
        else:
            self.ctxt = objects

    def get_context(self):
        """Retourne le contexte stocké avec la formule."""
        if self.ctxt is None:
            return {}
        return self.ctxt

    def __setstate__(self, state):
        """Cette methode sert a restaurer l'attribut code lors d'un unpickle."""
        self.__dict__.update(state)                   # update attributes
        self.setFormule(self.nompar, self.expression)  # restore code attribute

    def __getstate__(self):
        """Pour les formules, il faut enlever l'attribut code qui n'est
        pas picklable."""
        d = ASSD.__getstate__(self)
        del d['code']
        return d

    def supprime(self, force=False):
        """
        Cassage des boucles de références pour destruction du JDC.
        'force' est utilisée pour faire des suppressions complémentaires.

        Pour être évaluées, les formules ont besoin du contexte des "constantes"
        (objets autres que les concepts) qui sont soit dans (jdc).const_context.
        On le stocke dans 'parent_context'.
        Deux précautions valent mieux qu'une : on retire tous les concepts.

        Lors de la suppression du concept, 'supprime' est appelée par
        'build_detruire' avec force=True afin de supprimer le "const_context"
        conservé.
        """
        if force:
            for ctxt in ('parent_context', 'g_context'):
                if hasattr(self, ctxt):
                    setattr(self, ctxt, None)
        ASSD.supprime(self, force)

    def Parametres(self):
        """Equivalent de fonction.Parametres pour pouvoir utiliser des formules
        à la place de fonctions dans certaines macro-commandes.
        """
        from SD.sd_fonction import sd_formule
        from Utilitai.Utmess import UTMESS
        if self.accessible():
            TypeProl = {
                'E': 'EXCLU', 'L': 'LINEAIRE', 'C': 'CONSTANT', 'I': 'INTERPRE'}
            sd = sd_formule(self.get_name())
            prol = sd.PROL.get()
            nova = sd.NOVA.get()
            if prol is None or nova is None:
                UTMESS('F', 'SDVERI_2', valk=[objev])
            dico = {
                'INTERPOL': ['LIN', 'LIN'],
                'NOM_PARA': [s.strip() for s in nova],
                'NOM_RESU': prol[3][0:16].strip(),
                'PROL_DROITE': TypeProl['E'],
                'PROL_GAUCHE': TypeProl['E'],
            }
        else:
            raise AsException("Erreur dans fonction.Parametres en PAR_LOT='OUI'")
        return dico


class formule_c(formule):
    pass
