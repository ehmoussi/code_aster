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
import tempfile
from glob import glob
from math import log10

from .config import CFG
from .execute import execute
from .export import Export
from .logger import logger
from .utils import copy, gunzip, make_writable


class RunAster:
    """Execute code_aster from a `.export` file.

    Arguments:
        export_file (str): File name of the export file.
    """

    def __init__(self, export_file):
        self.export_file = osp.abspath(export_file)
        self._orig = osp.dirname(self.export_file)
        self.export = Export(self.export_file)
        self.workdir = None
        self.jobnum = str(os.getpid())
        logger.debug(f"Export file: {self.export_file}")
        logger.debug(self.export)

    def wrk(self, path):
        """Return the absolute path of a pathname that may be relative to the
        working directory.

        Arguments:
            path (str): Path, relative to the working directory.

        Returns:
            str: Absolute path.
        """
        return osp.normpath(osp.join(self.workdir, path))

    def exp(self, path):
        """Return the absolute path of a pathname that may be relative to the
        directory of the export file.

        Arguments:
            path (str): Path, relative to the directory of the export file.

        Returns:
            str: Absolute path.
        """
        return osp.normpath(osp.join(self._orig, path))

    def run(self):
        """Execution in a temporary directory."""
        previous = os.getcwd()
        with tempfile.TemporaryDirectory(prefix="run_aster_",
                                         dir=CFG.get("tmpdir")) as workdir:
            self.workdir = workdir
            os.chdir(workdir)
            exit_code = self._run()
            os.chdir(previous)
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

        copy(self.export_file, self.wrk(self.jobnum + ".export"))
        os.makedirs(self.wrk("REPE_OUT"))

        copy_datafiles(self.export.datafiles)

        logger.info(f"Content of directory '{self.workdir}' before execution:")
        os.system('ls -la')
        # Execution
        self.execute_study()
        # Copying results

        return 0

    def command_line(self, commfile):
        """Build the command line.

        Returns:
            list[str]: List of command line arguments.
        """
        cmd = [CFG.get("python")]
        if self.export.has_param("interact"):
            cmd.append("-i")
        cmd.append(commfile)
        cmd.extend(self.export.args)
        # TODO add pid + mode to identify the process
        logger.debug(f"command line: {cmd}")
        return cmd

    def execute_study(self):
        """Execute the study."""
        commfiles = [i for i in self.export.datafiles if i.filetype == "comm"]
        for comm in commfiles:
            cmd = self.command_line(comm.path)



def copy_datafiles(files):
    """Copy data files into the working directory.

    Arguments:
        files (list[File]): List of File objects.
    """
    idx = 0
    nbcomm = len([i for i in files if i.filetype == "comm"])
    fmt = "{{:0{}d}}".format(int(log10(max(1, nbcomm))) + 1)
    for obj in files:
        dest = None
        # fort.*
        if obj.unit != 0 or obj.filetype == "nom":
            dest = "fort." + str(obj.unit)
            if obj.filetype == "nom":
                dest = osp.basename(obj.path)
            # exception for multiple command files (adding _N)
            if obj.unit == 1:
                idx += 1
                dest += '.' + fmt.format(idx)
            # warning if file already exists
            if osp.exists(dest):
                logger.warning("'{0}' overwrites '{1}'"
                                .format(obj.path, dest))
            if obj.compr:
                dest += '.gz'
        # for directories
        else:
            if obj.filetype in ('base', 'bhdf'):
                dest = osp.basename(obj.path)
            elif obj.filetype == 'repe':
                dest = 'REPE_IN'

        if dest is not None:
            copy(obj.path, dest)
            if obj.compr:
                dest = gunzip(dest)
            # move the bases in main directory
            if obj.filetype in ('base', 'bhdf'):
                for fname in glob(osp.join(dest, '*')):
                    os.rename(fname, osp.basename(fname))
            # force the file to be writable
            make_writable(dest)
