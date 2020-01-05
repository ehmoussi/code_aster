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

# person_in_charge: mathieu.courtois at edf.fr


"""
    Ce module contient la classe ETAPE qui sert à vérifier et à exécuter
    une commande
"""

import types

from ..Cata.Language.SyntaxUtils import add_none_sdprod
from .base_utils import force_list
from .report import CR


def check_sdprod(command, func_prod, sd_prod, verbose=True):
    """Check that 'sd_prod' is type allowed by the function 'func_prod'
    with '__all__' argument.
    """
    def _name(class_):
        return getattr(class_, '__name__', class_)

    if type(func_prod) != types.FunctionType:
        return

    cr = CR()
    args = {}
    add_none_sdprod(func_prod, args)
    args['__all__'] = True
    # eval sd_prod with __all__=True + None for other arguments
    try:
        allowed = force_list(func_prod(*(), **args))
        islist = [isinstance(i, (list, tuple)) for i in allowed]
        if True in islist:
            if False in islist:
                cr.fatal("Error: {0}: for macro-commands, each element must "
                        "be a list of possible types for each result"
                        .format(command))
            else:
                # can not know which occurrence should be tested
                allowed = tuple(set().union(*allowed))
        allowed = tuple(set().union(*[subtypes(i) for i in allowed]))
        if sd_prod and sd_prod not in allowed:
            cr.fatal("Error: {0}: type '{1}' is not in the list returned "
                     "by the 'sd_prod' function with '__all__=True': {2}"
                     .format(command, _name(sd_prod),
                             [_name(i) for i in allowed]))
    except Exception as exc:
        print("Error: {0}".format(exc))
        cr.fatal("Error: {0}: the 'sd_prod' function must support "
                 "the '__all__=True' argument".format(command))
    if not cr.estvide():
        if verbose:
            print(str(cr))
        raise TypeError(str(cr))

def subtypes(cls):
    """Return subclasses of 'cls'."""
    types = [cls]
    if not cls:
        return types
    for subclass in cls.__subclasses__():
        types.extend(subtypes(subclass))
    return types
