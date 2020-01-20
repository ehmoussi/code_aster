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

# person_in_charge: mathieu.courtois@edf.fr

import libaster

from ..Helpers import saveObjects
from ..Supervis import ExecuteCommand
from ..Utilities import ExecutionParameter, logger


class Closer(ExecuteCommand):
    """Command that closes the execution."""
    command_name = "FIN"

    def _call_oper(self, dummy):
        """Save objects that exist in the context of the caller.

        The memory manager is closed when :mod:`libaster` is unloaded.
        """
        # Ensure that `saveObjects` has not been already called
        if libaster.jeveux_status():
            # 1: here, 2: exec_, 3: run, 4: user space
            saveObjects(level=4)

        logger.info(repr(ExecutionParameter().timer))


FIN = Closer.run
