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

# person_in_charge: mathieu.courtois@edf.fr

import libaster

from ..Supervis import ExecutionParameter, logger
from ..RunManager import saveObjects


def FIN(**keywords):
    """Save objects that exist in the context of the caller.

    The memory manager is closed when :mod:`libaster` is unloaded.

    Arguments:
        keywords (dict): Ignored
    """
    # Ensure that `saveObjects` has not been already called
    if libaster.jeveux_status():
        saveObjects(level=2)

    logger.info(repr(ExecutionParameter().timer))
