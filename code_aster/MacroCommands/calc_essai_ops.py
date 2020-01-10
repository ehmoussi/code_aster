# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

"""
Implémentation de la macro CALC_ESSAI

Ce module contient la partie controle de la macro CALC_ESSAI
"""

from libaster import onFatalError

from .CalcEssai.cata_ce import CalcEssaiObjects
from .CalcEssai.ce_calc_spec import InterfaceCalcSpec
from .CalcEssai.ce_ihm_expansion import InterfaceCorrelation
from .CalcEssai.ce_ihm_identification import InterfaceIdentification
from .CalcEssai.ce_ihm_modifstruct import InterfaceModifStruct
from .CalcEssai.ce_ihm_parametres import InterfaceParametres
from .CalcEssai.ce_test import MessageBox, TestCalcEssai
from .CalcEssai.outils_ihm import MessageBoxInteractif, TabbedWindow


def calc_essai_ops(self,
                   INTERACTIF=None,
                   UNITE_RESU=None,
                   EXPANSION=None,
                   IDENTIFICATION=None,
                   MODIFSTRUCT=None,
                   TRAITEMENTSIG=None,
                   GROUP_NO_CAPTEURS=None,
                   GROUP_NO_EXTERIEUR=None,
                   RESU_IDENTIFICATION=None,
                   RESU_MODIFSTRU=None,
                   **args):

    ier = 0

    prev = onFatalError()

    # gestion des concepts sortants de la macro, declares a priori
    table_fonction = []

    if not RESU_MODIFSTRU:
        out_modifstru = {}
    else:
        out_modifstru = RESU_MODIFSTRU[0]  # max=1 dans le capy

    if not RESU_IDENTIFICATION:
        RESU_IDENTIFICATION = []
    else:
        for res in RESU_IDENTIFICATION:
            table_fonction.append(res['TABLE'])
    out_identification = {"DeclareOut": self.DeclareOut,
                          "TypeTables": 'TABLE_FONCTION',
                          "ComptTable": 0,
                          "TablesOut": table_fonction}

    # Mode interactif : ouverture d'une fenetre Tk
    if INTERACTIF == "OUI":
        onFatalError('EXCEPTION')

        create_interactive_window(self,
                                  out_identification,
                                  out_modifstru,
                                  )
    else:
        mess = MessageBox(UNITE_RESU)
        mess.disp_mess("Mode non intéractif")

        objects = CalcEssaiObjects(self, mess)

        # importation des concepts aster existants de la memoire jeveux
        TestCalcEssai(self,
                      mess,
                      out_identification,
                      out_modifstru,
                      objects,
                      EXPANSION,
                      IDENTIFICATION,
                      MODIFSTRUCT,
                      GROUP_NO_CAPTEURS,
                      GROUP_NO_EXTERIEUR
                      )

        mess.close_file()
    onFatalError(prev)
    return ier


def create_tab_mess_widgets(tk, tabskeys):
    """Construits les objects table et boîte à messages."""
    tabsw = tk
    msgw = tk
    tk.rowconfigure(0, weight=2)
    tk.rowconfigure(1, weight=1)

    tabs = TabbedWindow(tabsw, tabskeys)

    tabs.grid(row=0, column=0, sticky='nsew')
    # pack(side='top',expand=1,fill='both')

    # ecriture des message dans un fichier message
    mess = MessageBoxInteractif(msgw)
    mess.grid(row=1, column=0, sticky='nsew')

    return tabs, mess


class FermetureCallback:

    """Opérations à appliquer lors de la fermeture de la
    fenêtre Tk.
    """

    def __init__(self, main_tk, turbulent):
        self.main_tk = main_tk
        self.turbulent = turbulent

    def apply(self):
        """Enlève les fichiers temporaires de Xmgrace"""
        if self.turbulent.param_visu.logiciel_courbes is not None:
            self.turbulent.param_visu.logiciel_courbes.fermer()
        self.main_tk.quit()


def create_interactive_window(macro,
                              out_identification,
                              out_modifstru,
                              ):
    """Construit la fenêtre interactive comprenant une table pour
    les 4 domaines de CALC_ESSAI."""

    # fenetre principale
    tk = Tk()
    tk.title("CALC_ESSAI")
    tk.rowconfigure(0, weight=1)
    tk.rowconfigure(1, weight=20)
    tk.rowconfigure(2, weight=1)

    tabskeys = ["Expansion de modeles",
                "Modification structurale",
                "Identification de chargement",
                "Traitement du signal",
                "Paramètres et visualisation"]
# "Visualisation"]

    tabs, mess = create_tab_mess_widgets(tk, tabskeys)
    main = tabs.root()

    # importation des concepts aster de la memoire jeveux
    objects = CalcEssaiObjects(macro, mess)
    tabs.set_objects(objects)

    param_visu = InterfaceParametres(main, objects, macro, mess)
    iface = InterfaceCorrelation(main, objects, macro, mess, param_visu)
    imodifstruct = InterfaceModifStruct(
        main, objects, macro, mess, out_modifstru, param_visu)
    identification = InterfaceIdentification(
        main, objects, mess, out_identification, param_visu)
    calc_spec = InterfaceCalcSpec(main, objects, mess, param_visu)
#
    tabs.set_tab(tabskeys[0], iface)
    tabs.set_tab(tabskeys[1], imodifstruct.main)
    tabs.set_tab(tabskeys[2], identification)
    tabs.set_tab(tabskeys[3], calc_spec)
    tabs.set_tab(tabskeys[4], param_visu)
# tabs.set_tab(tabskeys[5], visual)

    tabs.set_current_tab(tabskeys[4])

    tk.protocol("WM_DELETE_WINDOW",
                FermetureCallback(tk, identification).apply)

    try:
        tk.mainloop()
    except:
        print("CALC_ESSAI : *ERREUR*")
