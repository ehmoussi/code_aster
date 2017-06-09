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

from N_utils import import_object


class OPS:

    """Wrapper to ops functions.
    This allows to import them only when they are needed."""

    def __init__(self, uri):
        """Initialization"""
        self.uri = uri

    def __call__(self, *args, **kwargs):
        """Import the real function and call it."""
        func = import_object(self.uri)
        return func(*args, **kwargs)


# utilisé par exemple par des macros où tout est fait dans l'init.
class NOTHING(OPS):

    """OPS which does nothing."""

    def __call__(self, macro, *args, **kwargs):
        macro.set_icmd(1)
        return 0

EMPTY_OPS = NOTHING(None)
