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

"""
   Utilitaire sur le catalogue des structures de données.
"""

__revision__ = "$Id: $"

import sys
import os
from glob import glob
from optparse import OptionParser

# ----- get bibpyt location
main = sys.argv[0]
if os.path.islink(main):
    main = os.path.realpath(main)
bibpyt = os.path.normpath(os.path.join(
                          os.path.dirname(os.path.abspath(main)), os.pardir))
sys.path.append(bibpyt)

# -----------------------------------------------------------------------------


def import_sd(nomsd):
    """Import une SD.
    """
    try:
        mod = __import__('SD.%s' % nomsd, globals(), locals(), [nomsd])
        klass = getattr(mod, nomsd)
    except (ImportError, AttributeError), msg:
        print msg
        raise ImportError, "impossible d'importer la SD '%s'" % nomsd
    return klass

# -----------------------------------------------------------------------------


def tree(nom, *args):
    """Retourne l'arbre des sd en arguments
    """
    l = []
    for i, sd in enumerate(args):
        if len(args) > 1 and i > 0:
            l.append('-' * 80)
        sd_class = import_sd(sd)
        tmpobj = sd_class(nomj=nom)
        l.append(tmpobj.dump())
    return os.linesep.join(l)

# -----------------------------------------------------------------------------
# -----------------------------------------------------------------------------
if __name__ == '__main__':
    # command arguments parser
    parser = OptionParser(usage=__doc__)
    parser.add_option('-t', '--tree', dest='tree',
                      action='store_true', default=False,
                      help="affiche une SD sous forme d'arbre")
    parser.add_option('--nom', dest='nom',
                      action='store', default='^' * 8,
                      help="nom du concept dans les représentations")
    parser.add_option('-a', '--all', dest='all',
                      action='store_true', default=False,
                      help="construit la liste des SD à partir des fichiers 'sd_*.py' trouvés")

    opts, l_sd = parser.parse_args()
    if opts.all:
        l_fich = glob(os.path.join(bibpyt, 'SD', 'sd_*.py'))
        l_sd = [os.path.splitext(os.path.basename(f))[0] for f in l_fich]

    if len(l_sd) == 0:
        parser.error('quelle(s) structure(s) de données ?')

    if opts.tree:
        print tree(opts.nom, *l_sd)
