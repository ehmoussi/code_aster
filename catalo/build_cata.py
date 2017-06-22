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

"""%prog --output=cata_elem.ojb

This script build an .ojb file that contains the overall information
included in all catalogs.
"""

import os
import os.path as osp
import shutil


def build(target, debug, *args):
    """Create the jeveux object of the catalog"""
    from Execution.i18n import localization
    from Utilitai.as_timer import ASTER_TIMER
    from cataelem.elem import CataElem
    from cataelem.Tools.build_jeveux import impr_cata
    if args:
        from cataelem import __DEBUG_ELEMENTS__
        __DEBUG_ELEMENTS__.extend(args)
    timer = ASTER_TIMER()
    timer.Start('T0')
    cel = CataElem()
    cel.build()
    timer.Stop('T0')
    if args:
        return
    debugdir = None
    if debug:
        debugdir = osp.join(osp.dirname(target), 'debug')
        if osp.exists(debugdir):
            shutil.rmtree(debugdir)
        os.makedirs(debugdir)
    impr_cata(cel, target, timer, debugdir)


if __name__ == '__main__':
    import optparse
    parser = optparse.OptionParser(usage=__doc__)
    parser.add_option('-g', '--debug', action='store_true',
                      help='enable debugging')
    parser.add_option('-o', '--output', dest='ojb', metavar='FILE',
                      help='output object file')
    opts, args = parser.parse_args()
    if not opts.ojb:
        parser.error('You must provide the destination file')
    build(opts.ojb, opts.debug, *args)
