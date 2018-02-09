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


"""
   Ce module contient la classe mixin ETAPE qui porte les méthodes
   nécessaires pour réaliser la validation d'un objet de type ETAPE
   dérivé de OBJECT.

   Une classe mixin porte principalement des traitements et est
   utilisée par héritage multiple pour composer les traitements.
"""
# Modules Python
import types
import sys
import traceback
import re

# Modules EFICAS
import V_MCCOMPO
from Noyau import MAXSIZE, MAXSIZE_MSGCHK
from Noyau.N_Exception import AsException
from Noyau.N_utils import AsType
from Noyau.strfunc import ufmt


class ETAPE(V_MCCOMPO.MCCOMPO):

    """
    """

    def valid_child(self):
        """ Cette methode teste la validite des mots cles de l'etape """
        for child in self.mc_liste:
            if not child.isvalid():
                return 0
        return 1

    def valid_regles(self, cr):
        """ Cette methode teste la validite des regles de l'etape """
        text_erreurs, test_regles = self.verif_regles()
        if not test_regles:
            if cr == 'oui':
                self.cr.fatal(
                    _(u"Règle(s) non respectée(s) : %s"), text_erreurs)
            return 0
        return 1

    def valid_sdnom(self, cr):
        """ Cette methode teste la validite du nom du concept produit par l'etape """
        valid = 1
        if self.sd.nom != None:
            if self.jdc and self.jdc.definition.code == 'ASTER' and len(self.sd.nom) > 8:
                # le nom de la sd doit avoir une longueur <= 8 caractères pour
                # ASTER
                if cr == 'oui':
                    self.cr.fatal(
                        _(u"Le nom de concept %s est trop long (8 caractères maxi)"),
                        self.sd.nom)
                valid = 0
            if self.sd.nom.find('sansnom') != -1:
                # la SD est 'sansnom' : --> erreur
                if cr == 'oui':
                    self.cr.fatal(_(u"Pas de nom pour le concept retourné"))
                valid = 0
            elif re.search('^SD_[0-9]*$', self.sd.nom):
                # la SD est 'SD_' cad son nom = son id donc pas de nom donné
                # par utilisateur : --> erreur
                if cr == 'oui':
                    self.cr.fatal(
                        _(u"Nom de concept invalide ('SD_' est réservé)"))
                valid = 0
        return valid

    def get_valid(self):
        if hasattr(self, 'valid'):
            return self.valid
        else:
            self.valid = None
            return None

    def set_valid(self, valid):
        old_valid = self.get_valid()
        self.valid = valid
        self.state = 'unchanged'
        if not old_valid or old_valid != self.valid:
            self.init_modif_up()

    def isvalid(self, sd='oui', cr='non'):
        """
           Methode pour verifier la validité de l'objet ETAPE. Cette méthode
           peut etre appelée selon plusieurs modes en fonction de la valeur
           de sd et de cr.

           Si cr vaut oui elle crée en plus un compte-rendu.

           Cette méthode a plusieurs fonctions :

            - mettre à jour l'état de self (update)

            - retourner un indicateur de validité 0=non, 1=oui

            - produire un compte-rendu : self.cr

        """
        if CONTEXT.debug:
            print "ETAPE.isvalid ", self.nom
        if self.state == 'unchanged':
            return self.valid
        else:
            valid = self.valid_child()
            valid = valid * self.valid_regles(cr)

            if self.reste_val != {}:
                if cr == 'oui':
                    self.cr.fatal(
                        _(u"Mots clés inconnus : %s"), ','.join(self.reste_val.keys()))
                valid = 0

            if sd == "non":
                # Dans ce cas, on ne teste qu'une validité partielle (sans tests sur le concept produit)
                # Conséquence : on ne change pas l'état ni l'attribut valid, on retourne simplement
                # l'indicateur de validité valid
                return valid

            if self.definition.reentrant[0] == 'n' and self.reuse:
                # Il ne peut y avoir de concept reutilise avec un OPER non
                # reentrant
                if cr == 'oui':
                    self.cr.fatal(
                        _(u'Opérateur non réentrant : ne pas utiliser reuse'))
                valid = 0

            if self.sd == None:
                # Le concept produit n'existe pas => erreur
                if cr == 'oui':
                    self.cr.fatal(_(u"Concept retourné non défini"))
                valid = 0
            else:
                valid = valid * self.valid_sdnom(cr)

            if valid:
                valid = self.update_sdprod(cr)

            self.set_valid(valid)

            return self.valid

    def update_sdprod(self, cr='non'):
        """
             Cette méthode met à jour le concept produit en fonction des conditions initiales :

              1. Il n'y a pas de concept retourné (self.definition.sd_prod == None)

              2. Le concept retourné n existait pas (self.sd == None)

              3. Le concept retourné existait. On change alors son type ou on le supprime

             En cas d'erreur (exception) on retourne un indicateur de validité de 0 sinon de 1
        """
        sd_prod = self.definition.sd_prod
        if type(sd_prod) == types.FunctionType:  # Type de concept retourné calculé
            d = self.cree_dict_valeurs(self.mc_liste)
            try:
                sd_prod = apply(sd_prod, (), d)
            except:
                # Erreur pendant le calcul du type retourné
                if CONTEXT.debug:
                    traceback.print_exc()
                self.sd = None
                if cr == 'oui':
                    l = traceback.format_exception(sys.exc_info()[0],
                                                   sys.exc_info()[1],
                                                   sys.exc_info()[2])
                    self.cr.fatal(
                        _(u'Impossible d affecter un type au résultat\n %s'), ' '.join(l[2:]))
                return 0
        # on teste maintenant si la SD est r\351utilis\351e ou s'il faut la
        # cr\351er
        valid = 1
        if self.reuse:
            if AsType(self.reuse) != sd_prod:
                if cr == 'oui':
                    self.cr.fatal(
                        _(u'Type de concept réutilisé incompatible avec type produit'))
                valid = 0
            if self.sdnom != '':
                if self.sdnom[0] != '_' and self.reuse.nom != self.sdnom:
                    # Le nom de la variable de retour (self.sdnom) doit etre le
                    # meme que celui du concept reutilise (self.reuse.nom)
                    if cr == 'oui':
                        self.cr.fatal(_(u'Concept réutilisé : le nom de la variable de '
                                        u'retour devrait être %s et non %s'),
                                      self.reuse.nom, self.sdnom)
                    valid = 0
            if valid:
                d = self.cree_dict_valeurs(self.mc_liste)
                orig = self.definition.reentrant.split(":")[1:]
                keyword = d.get(orig[0])
                if keyword is None:
                    if cr == 'oui':
                        self.cr.fatal(_(u'Concept réutilisé : non trouvé sous %s'),
                                      "/".join(orig))
                    valid = 0
                if valid and len(orig) == 2:
                    try:
                        keyword = keyword[0]
                        print "DEBUG: use first occurrence", keyword
                    except IndexError:
                        pass
                    try:
                        keyword = keyword.get(orig[1])
                    except Exception as exc:
                        self.cr.fatal(str(exc))
                        keyword = None
                    if keyword is None:
                        if cr == 'oui':
                            self.cr.fatal(_(u'Concept réutilisé : non trouvé sous %s'),
                                          "/".join(orig))
                        valid = 0
                if valid and AsType(keyword) != sd_prod:
                    if cr == 'oui':
                        self.cr.fatal(_(u'Concept réutilisé : type incorrect '
                                        u' %s au lieu de %s'),
                                        AsType(keyword), sd_prod)
                    valid = 0
                if (valid and self.sdnom != '' and self.sdnom[0] != '_'
                    and keyword.nom != self.sdnom):
                    if cr == 'oui':
                        self.cr.fatal(_(u'Concept réutilisé : concept '
                                        u'inattendu %s au lieu de %s'),
                                        keyword.nom, self.sdnom)
                    valid = 0
            if valid:
                self.sd = self.reuse
        else:
            if sd_prod == None:  # Pas de concept retourné
                # Que faut il faire de l eventuel ancien sd ?
                self.sd = None
            else:
                if self.sd:
                    # Un sd existe deja, on change son type
                    if CONTEXT.debug:
                        print "changement de type:", self.sd, sd_prod
                    if self.sd.__class__ != sd_prod:
                        self.sd.change_type(sd_prod)
                else:
                    # Le sd n existait pas , on ne le crée pas
                    if cr == 'oui':
                        self.cr.fatal(_(u"Concept retourné non défini"))
                    valid = 0
            if self.definition.reentrant[0] == 'o':
                if cr == 'oui':
                    self.cr.fatal(
                        _(u'Commande obligatoirement réentrante : spécifier reuse=concept'))
                valid = 0
        return valid

    def report(self):
        """
            Methode pour generation d un rapport de validite
        """
        self.cr = self.CR(debut=u'Etape : ' + self.nom
                          + u'    ligne : ' + `self.appel[0]`
                          + u'    fichier : ' + `self.appel[1]`,
                          fin=u'Fin Etape : ' + self.nom)
        self.state = 'modified'
        try:
            self.isvalid(cr='oui')
        except AsException, e:
            if CONTEXT.debug:
                traceback.print_exc()
            self.cr.fatal(_(u'Etape : %s ligne : %r fichier : %r %s'),
                          self.nom, self.appel[0], self.appel[1], e)
        i = 0
        for child in self.mc_liste:
            i += 1
            if i > MAXSIZE:
                print(MAXSIZE_MSGCHK.format(MAXSIZE, len(self.mc_liste)))
                break
            self.cr.add(child.report())
        return self.cr
