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

import string
import copy
import Numeric
import types
import Cata
from code_aster.Cata.Commands import DEFI_FICHIER, IMPR_FONCTION
from code_aster.Cata.Syntax import _F

try:
    import Gnuplot
    isGnuplot = True
except:
    isGnuplot = False


#_____________________________________________
#
# IMPRESSIONS GRAPHIQUES
#_____________________________________________

def graphique(FORMAT, L_F, res_exp, reponses, iter, UL_out, interactif):

    if FORMAT == 'XMGRACE':
        for i in range(len(L_F)):
            _tmp = []
            courbe1 = res_exp[i]
            _tmp.append(
                {'ABSCISSE': courbe1[:, 0].tolist(), 'ORDONNEE': courbe1[:, 1].tolist(), 'COULEUR': 1})
            courbe2 = L_F[i]
            _tmp.append(
                {'ABSCISSE': courbe2[:, 0].tolist(), 'ORDONNEE': courbe2[:, 1].tolist(), 'COULEUR': 2})

            motscle2 = {'COURBE': _tmp}
            if interactif:
                motscle2['PILOTE'] = 'INTERACTIF'
            else:
                motscle2['PILOTE'] = 'POSTSCRIPT'

            IMPR_FONCTION(FORMAT='XMGRACE',
                          UNITE=int(UL_out),
                          TITRE='Courbe de : ' + reponses[i][0],
                          SOUS_TITRE='Iteration : ' + str(iter),
                          LEGENDE_X=reponses[i][1],
                          LEGENDE_Y=reponses[i][2],
                          **motscle2
                          )

    elif FORMAT == 'GNUPLOT':
        if isGnuplot:
            graphe = []
            impr = Gnuplot.Gnuplot()
            Gnuplot.GnuplotOpts.prefer_inline_data = 1
            # impr('set data style linespoints')
            impr('set grid')
            impr('set pointsize 2.')
            impr('set terminal postscript color')
            impr('set output "fort.' + str(UL_out) + '"')

            for i in range(len(L_F)):
                if interactif:
                    graphe.append(Gnuplot.Gnuplot(persist=0))
                    # graphe[i]('set data style linespoints')
                    graphe[i]('set grid')
                    graphe[i]('set pointsize 2.')
                    graphe[i].xlabel(reponses[i][1])
                    graphe[i].ylabel(reponses[i][2])
                    graphe[i].title(
                        reponses[i][0] + '  Iteration ' + str(iter))
                    graphe[i].plot(
                        Gnuplot.Data(L_F[i], title='Calcul'), Gnuplot.Data(res_exp[i], title='Experimental'))
                    graphe[i]('pause 5')

                impr.xlabel(reponses[i][1])
                impr.ylabel(reponses[i][2])
                impr.title(reponses[i][0] + '  Iteration ' + str(iter))
                impr.plot(Gnuplot.Data(L_F[i], title='Calcul'), Gnuplot.Data(
                    res_exp[i], title='Experimental'))

    else:
        pass
