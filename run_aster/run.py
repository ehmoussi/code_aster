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

import os
import os.path as osp
import shutil
import tempfile
from math import log10

from .export import Export
from .logger import logger


class RunAster:
    """Execute code_aster from a `.export` file.

    Arguments:
        export_file (str): File name of the export file.
    """

    def __init__(self, export_file):
        self.export_file = export_file
        self.export = Export(export_file)
        self.workdir = None
        self.jobnum = str(os.getpid())
        logger.debug(f"Export file: {export_file}")
        logger.debug(self.export)

    def _wrk(self, path):
        return osp.join(self.workdir, path)

    def run(self):
        """Execution in a temporary directory."""
        with tempfile.TemporaryDirectory() as self.workdir:
            exit_code = self._run()
        return exit_code

    def _run(self):
        """Execution.

        Returns:
            int: 0 if the execution is successful, non null otherwise.
        """
        # add reptrav to LD_LIBRARY_PATH (to find dynamic libs provided by user)
        old = os.environ.get("LD_LIBRARY_PATH", "")
        new = (self.workdir + os.pathsep + old).strip(os.pathsep)
        os.environ["LD_LIBRARY_PATH"] = new
        # Preparation of environment
        # copy export in rep_trav
        shutil.copyfile(self.export_file,
                        self._wrk(self.jobnum + ".export"))
        os.makedirs(self._wrk("REPE_OUT"))

        # Copying datas
        self.copy_data()
        # Execution
        # Copying results

        return 0


    def copy_data(self):
        """Copy data files into the working directory."""
        data = self.export.datafiles
        nbcomm = len([i for i in data if i.filetype == "comm"])
        fmt = '%%0%dd' % (int(log10(max(1, nbcomm))) + 1)
