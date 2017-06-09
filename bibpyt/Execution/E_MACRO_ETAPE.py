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


import E_ETAPE
from os import times
import aster
import string
from Noyau.N__F import _F
from Noyau.N_info import message, SUPERV
from strfunc import ufmt


class MACRO_ETAPE(E_ETAPE.ETAPE):

    """
    Cette classe implémente les méthodes relatives à la phase d'execution
    des macro-commandes.

    Les principales méthodes sont:
       - Exec, pour l'execution en mode par lot
       - Execute, pour l'execution en mode commande par commande (par_lot="NON")
    """

    def AfficheCommande(self):
        """
        Affiche l'echo de la macro commande
        """
        if self.definition.proc is not None or self.definition.op < 0:
            # affichage du texte de la macro-commande.
            self.AfficheTexteCommande()

    def affiche_cmd(self):
        if self.jdc.par_lot == "NON":
            self.AfficheCommande()

    def Execute(self):
        """
        Cette methode realise la phase d'execution en mode commande
        par commande pour une etape :
               - construction,
               - verification,
               - execution
        en une seule passe. Utilise en mode par_lot='NON'

        L'attribut d'instance executed indique que l'etape a deja ete executee
        Cette methode peut etre appelee plusieurs fois mais ne doit etre
        executee qu'une seule fois.
        Le seul cas ou on appelle plusieurs fois Execute est pour INCLUDE
        (appel dans op_init)
        """
        # message.debug(SUPERV, "%s par_lot=%s", self.nom, self.jdc and
        # self.jdc.par_lot)
        if not self.jdc or self.jdc.par_lot != "NON":
            return

        if not hasattr(self, "executed") or self.executed == 0:
            self.executed = 1

            cr = self.report()
            if not cr.estvide():
                self.parent.cr.add(cr)
                raise EOFError

            if self.jdc.syntax_check():
                return
            try:
                # Apres l appel a Build  les executions de toutes les
                # sous commandes ont ete realisees
                ier = self.Build()
            except self.codex.error:
                self.detruit_sdprod()
                self.parent.clean(1)
                raise

            if ier > 0:
                # On termine le traitement
                cr.fatal(_(u"Erreurs à l'exécution de la macro %s"), self.nom)
                raise EOFError

            E_ETAPE.ETAPE.Exec(self)
            # "publie" les concepts produits par la macro
            self.update_context(self.parent.g_context)

            if self.icmd != None:
                self.AfficheFinCommande()
            else:
                self.AfficheFinCommande(avec_temps=False)
        elif self.nom == 'INCLUDE':
            self.AfficheFinCommande(avec_temps=False)

        if hasattr(self, 'postexec'):
            self.postexec(self)

        self.set_current_step()
        # destruction
        self.delete_tmp_sd()
        self.parent.clean(1)
        self.reset_current_step()

    def Execute_alone(self):
        """
        Cette methode est une methode speciale reservee au traitement de
        certaines macro-commandes (INCLUDE) en mode par_lot='NON'

        Elle realise l execution d une etape :
               - construction,
               - verification,
               - execution
        en une seule passe. Utilise en mode par_lot='NON'.
        Cette methode est semblable a Execute mais appelle Build_alone
        au lieu de Build (permet d'executer la macro avant de construire les sous commandes)

        L'attribut d'instance executed indique que l'etape a deja ete executee.
        Les methodes Execute et Execute_alone peuvent etre appelees plusieurs fois mais
        l'execution effective ne doit avoir lieu qu'une seule fois.
        Le seul cas ou on appelle plusieurs fois Execute_alone et Execute est pour la
        commande INCLUDE (appel dans op_init)
        """
        if hasattr(self, "executed") and self.executed == 1:
            return
        self.executed = 1

        cr = self.report()
        if not cr.estvide():
            self.parent.cr.add(cr)
            raise EOFError

        ier = self.Build_alone()

        if ier > 0:
            # On termine le traitement
            cr.fatal(
                _(u"Erreurs dans la construction de la macro %s"), self.nom)
            raise EOFError

        E_ETAPE.ETAPE.Exec(self)

    def BuildExec(self):
        """
        Cette methode enchaine en une seule passe les phases de construction et d'execution.
        Utilisée en PAR_LOT='OUI'.
        """
        # message.debug(SUPERV, "BuildExec %s", self.nom)
        self.set_current_step()
        self.building = None
        # Chaque macro_etape doit avoir un attribut cr du type CR
        # (compte-rendu) pour stocker les erreurs eventuelles
        # et doit l'ajouter au cr de l'etape parent pour construire un
        # compte-rendu hierarchique
        self.cr = self.CR(debut='Etape : ' + self.nom + '    ligne : ' + `self.appel[0]` +
                          '    fichier : ' + `self.appel[1]`,
                          fin='Fin Etape : ' + self.nom)

        # Si la liste des etapes est remplie avant l'appel à Build
        # on a affaire à une macro de type INCLUDE
        # Il faut executer les etapes explicitement apres Build
        if self.etapes:
            has_etapes = 1
        else:
            has_etapes = 0

        try:
            # Apres l appel a _Build  les executions de toutes les
            # sous commandes ont ete realisees sauf dans le cas des INCLUDE
            ier = self._Build()

            if ier > 0:
                # On termine le traitement
                self.cr.fatal(
                    _(u"Erreurs dans la construction de la macro %s"), self.nom)
                raise EOFError

            # La macro de type INCLUDE doit etre executee avant ses sous etapes
            E_ETAPE.ETAPE.Exec(self)

            if has_etapes:
                for e in self.etapes:
                    if e.isactif():
                        e.BuildExec()

            if hasattr(self, 'postexec'):
                self.postexec(self)
            if self.icmd != None:
                self.AfficheFinCommande()
            else:
                self.AfficheFinCommande(avec_temps=False)

            if not self.cr.estvide():
                self.parent.cr.add(self.cr)
        except:
            if not self.cr.estvide():
                self.parent.cr.add(self.cr)
            self.reset_current_step()
            raise
        # destruction
        self.delete_tmp_sd()
        self.reset_current_step()

    def delete_tmp_sd(self):
        """Destruction des concepts temporaires internes à la macro
        préfixés par '.' dans la base jeveux"""
        if self.nom != 'DETRUIRE':
            s_obj = set()
            for etape in self.etapes:
                if etape.sd != None and etape.sd.nom != None and etape.sd.nom[:1] == '.':
                    s_obj.add(etape.sd)
            # au cas où self.sd serait arrivé dans s_obj
            s_obj.discard(self.sd)
            if len(s_obj) > 0:
                DETRUIRE = self.get_cmd('DETRUIRE')
                DETRUIRE(CONCEPT=_F(NOM=list(s_obj)), INFO=1)

    def get_liste_etapes(self, liste):
        if self.nom == 'INCLUDE':
            for e in self.etapes:
                e.get_liste_etapes(liste)
        else:
            liste.append(self.etape)
