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

#                       TERMINAL GRAPHIQUE XMGRACE
# =========================================================================


import os
from glob import glob
from subprocess import Popen

import aster_core
import aster
from Utilitai.Utmess import UTMESS

TERMINAL = 0    # terminal actif ou non (au plus un terminal en meme temps)


class Xmgr:

    DEJA_ACTIF = 'Terminal xmgrace deja actif'

    def __init__(self, gr_max=10, options=None, xmgrace=os.path.join(aster_core.get_option('repout'), 'xmgrace')):

        # Declaration
        global TERMINAL

        # Precondition
        if TERMINAL:
            raise Xmgr.DEJA_ACTIF

        # Initialisation
        TERMINAL = 1
        self.gr_max = gr_max        # nombre de graphes
        self.gr_act = 0             # numero du graphe actif
        self.sets = [0] * gr_max    # nombre de sets par graphe
        self.nom_pipe = 'xmgr.pipe'   # nom du pipe de communication
        self.xmgrace = xmgrace

        # Ouverture du pipe de communication avec xmgrace
        if os.path.exists(self.nom_pipe):
            os.remove(self.nom_pipe)
        os.mkfifo(self.nom_pipe)
        self.pipe = open(self.nom_pipe, 'a+')

        # Lancement de xmgrace
        if options != None:
            cmd = self.xmgrace + ' -noask ' + options + \
                ' -graph ' + repr(gr_max - 1) + ' -npipe ' + self.nom_pipe
        else:
            cmd = self.xmgrace + ' -noask ' + \
                ' -graph ' + repr(gr_max - 1) + ' -npipe ' + self.nom_pipe

        # Teste le DISPLAY avant de lancer xmgrace...
        if os.environ.has_key('DISPLAY'):

            UTMESS('I', 'STANLEY_9', valk=[cmd])
            self.controle = Popen(cmd, shell=True)

            # Mise a l'echelle des graphes
            for i in xrange(gr_max):
                gr = 'G' + repr(i)
                self.Send('WITH ' + gr)
                self.Send('VIEW XMIN 0.10')
                self.Send('VIEW XMAX 0.95')
                self.Send('VIEW YMIN 0.10')
                self.Send('VIEW YMAX 0.95')

            # Activation du graphe G0
            self.Active(0)

        else:
            TERMINAL = 0
            UTMESS('A', 'STANLEY_3', valk=['XMGRACE'])

# --------------------------------------------------------------------

    def Terminal_ouvert(self):
        """
          Retourne 1 si le terminal est ouvert, 0 sinon
        """

        try:
            etat = self.controle.poll()
            if etat is None:
                return 1
            else:
                return 0
        except:
            return 0   # generalement c'est que le popen ne s'est pas ouvert
                       # car pas de DISPLAY

# --------------------------------------------------------------------

    def Fermer(self):
        """
          Ferme le terminal (si necessaire)
          Fais le menage dans l'objet
        """

        # Declaration
        global TERMINAL

        if self.Terminal_ouvert():
            self.Send('Exit')
        self.pipe.close()
        try:
            os.remove(self.nom_pipe)
        except:
            pass
        for fich in glob('xmgr.*.dat'):
            try:
                os.remove(fich)
            except:
                pass
        TERMINAL = 0

# --------------------------------------------------------------------

    def Attendre(self):
        """
          Attend que l'on quitte xmgrace
        """
        try:
            self.controle.wait()
        except:
            pass
        self.Fermer()

# --------------------------------------------------------------------

    def Send(self, command, echo=None):
        """
          Envoie une commande a l'interpreteur de xmgrace
        """

        if self.Terminal_ouvert():
            self.pipe.write(command + '\n')
            self.pipe.flush()
            if echo:
                print command

# --------------------------------------------------------------------

    def Active(self, graphe):
        """
          Active un graphique
          IN  graphe : Numero du graphe a activer
        """

        if graphe >= self.gr_max:
            raise 'Graphe inexistant'

        # On efface tous les graphes
        for i in xrange(self.gr_max):
            gr = 'G' + repr(i)
            self.Send(gr + ' OFF')

        # On active et on affiche le graphe courant
        gr = 'G' + repr(graphe)
        self.Send(gr + ' ON')
        self.Send('redraw')

        # On met a jour le graphe actif
        self.gr_act = graphe

# --------------------------------------------------------------------

    def Nouveau_graphe(self):
        """
          Active un nouveau graphe
          (en pratique, celui qui suit le graphe actuel)
        """

        gr_act = self.gr_act
        self.Active(gr_act + 1)

    # --------------------------------------------------------------------

    def Titre(self, titre, sous_titre=''):

        if self.Terminal_ouvert():
            self.Send('WITH G' + repr(self.gr_act))
            self.Send('TITLE SIZE 1.2')
            self.Send('TITLE "' + titre + '"')
            self.Send('SUBTITLE "' + sous_titre + '"')
            self.Send('redraw')

# --------------------------------------------------------------------

    def Axe_x(self, label):

        if self.Terminal_ouvert():
            self.Send('WITH G' + repr(self.gr_act))
            self.Send('XAXIS LABEL "' + label + '"')
            self.Send('XAXIS LABEL CHAR SIZE 0.75')
            self.Send('REDRAW')

# --------------------------------------------------------------------

    def Axe_y(self, label):

        if self.Terminal_ouvert():
            self.Send('WITH G' + repr(self.gr_act))
            self.Send('YAXIS LABEL "' + label + '"')
            self.Send('YAXIS LABEL CHAR SIZE 0.75')
            self.Send('REDRAW')

# --------------------------------------------------------------------

    def Legende(self, set, legende):

        if self.Terminal_ouvert():
            self.Send('WITH G' + repr(self.gr_act))
            self.Send('LEGEND ON')
            self.Send('LEGEND LOCTYPE VIEW')
            self.Send('LEGEND 0.79, 0.85')
            self.Send('LEGEND CHAR SIZE 0.75')
            self.Send('LEGEND BOX OFF')
            self.Send('LEGEND STRING ' + repr(set) + ' "' + legende + '"')
            self.Send('REDRAW')

# --------------------------------------------------------------------

    def Sortie_EPS(self, nom_fich):

        if self.Terminal_ouvert():
            self.Send('HARDCOPY DEVICE "EPS" ')
            self.Send('PRINT TO "' + nom_fich + '"')
            self.Send('PRINT')

# --------------------------------------------------------------------

    def Courbe(self, courbe, legende=None):
        """
          Trace une courbe dans le graphique actif
          IN  courbe : objet de type courbe a tracer
        """

        set = self.sets[self.gr_act]
        self.sets[self.gr_act] = set + 1

        name = 'xmgr.' + repr(self.gr_act) + '.' + repr(set) + '.dat'
        courbe.Sauve(name)
        if self.Terminal_ouvert():
            self.Send('WITH G' + repr(self.gr_act))
            self.Send('read "' + name + '"')
            self.Send('redraw')
            if legende:
                self.Legende(set, legende)

        return set
