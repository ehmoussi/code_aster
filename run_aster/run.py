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
from contextlib import contextmanager
from glob import glob
from math import log10
from subprocess import run

from .command_files import add_import_commands, stop_at_end
from .config import CFG
from .execute import execute
from .export import Export
from .logger import logger
from .status import get_status
from .utils import compress, copy, make_writable, run_command, uncompress


@contextmanager
def temporary_dir(delete=True):
    """"""
    previous = os.getcwd()
    if delete:
        with tempfile.TemporaryDirectory(prefix="run_aster_",
                                         dir=CFG.get("tmpdir")) as wrkdir:
            os.chdir(wrkdir)
            yield wrkdir
            os.chdir(previous)
    else:
        wrkdir = tempfile.mkdtemp(prefix="run_aster_", dir=CFG.get("tmpdir"))
        os.chdir(wrkdir)
        yield wrkdir
        os.chdir(previous)


class RunAster:
    """Execute code_aster from a `.export` file.

    Arguments:
        export_file (str): File name of the export file.
    """

    def __init__(self, export_file):
        self.export_file = osp.abspath(export_file)
        self._orig = osp.dirname(self.export_file)
        self.export = Export(self.export_file)
        self.jobnum = str(os.getpid())
        logger.debug(f"Export file: {self.export_file}")
        logger.debug(self.export)

    def exp(self, path):
        """Return the absolute path of a pathname that may be relative to the
        directory of the export file.

        Arguments:
            path (str): Path, relative to the directory of the export file.

        Returns:
            str: Absolute path.
        """
        return osp.normpath(osp.join(self._orig, path))

    def execute(self, test=False):
        """Execution in a temporary directory.

        Arguments:
            test (bool, optional): *True* for a testcase, *False* for a study.

        Returns:
            Status: Status object.
        """
        logger.info("TITLE Execution of code_aster")
        self.prepare_current_directory()
        status = self.execute_study(test)

        if not test:
            logger.info("TITLE Copying results")
            copy_resultfiles(self.export.resultfiles, status.is_completed())
        return status

    def prepare_current_directory(self):
        """Execution.
        """
        logger.info(f"TITLE Prepare environment in {os.getcwd()}")
        # add reptrav to LD_LIBRARY_PATH (to find dynamic libs provided by user)
        old = os.environ.get("LD_LIBRARY_PATH", "")
        new = (os.getcwd() + os.pathsep + old).strip(os.pathsep)
        os.environ["LD_LIBRARY_PATH"] = new

        copy(self.export_file, self.jobnum + ".export")
        os.makedirs("REPE_IN")
        os.makedirs("REPE_OUT")
        copy_datafiles(self.export.datafiles)

    def command_line(self, commfile):
        """Build the command line.

        Returns:
            list[str]: List of command line arguments.
        """
        cmd = [CFG.get("python")]
        if self.export.get("interact"):
            cmd.append("-i")
        cmd.append(commfile)
        cmd.extend(self.export.args)
        # TODO add pid + mode to identify the process
        return cmd

    def execute_study(self, test=False):
        """Execute the study.

        Arguments:
            test (bool, optional): *True* for a testcase, *False* for a study.

        Returns:
            Status: Status object.
        """
        logger.info(f"TITLE Content of {os.getcwd()} before execution:")
        run(["ls", "-l", ".", "REPE_IN"])
        commfiles = glob("fort.1.*")
        if not commfiles:
            logger.error("no .comm file found")

        timeout = self.export.get("time_limit") * 1.05
        jobnum = self.jobnum
        for idx, comm in enumerate(commfiles):
            logger.info(f"TITLE Command file #{idx + 1} / {len(commfiles)}")
            cmd = self.command_line(comm)
            logger.info(f"    {' '.join(cmd)}")

            with open(comm, "rb") as fobj:
                text = fobj.read().decode(errors='replace')
                text = add_import_commands(text)
                if self.export.get("interact"):
                    text = stop_at_end(text)
            with open(comm, 'w') as fobj:
                fobj.write(text)
            if not self.export.get("hide-command"):
                logger.info(f"\nContent of the file to execute:\n{text}\n")

            with open("exec.output", "wb") as log:
                exitcode = run_command(cmd, log, timeout)
            logger.info(f"\nEXECUTION_CODE_ASTER_EXIT_{jobnum}={exitcode}\n\n")
            status = get_status(exitcode, "exec.output", test)
            # TODO backup bases
        # TODO coredump analysis

        logger.info(f"TITLE Content of {os.getcwd()} after execution:")
        run(["ls", "-l", ".", "REPE_OUT"])
        return status


    def use_interactive(self, value):
        """Set the parameter for interactive execution to `value`.
        It also increases the time limit to 24 hours.

        Arguments:
            value (bool): *True* to enable interactive execution,
                *False* otherwise.
        """
        self.export.set_parameter("interact", value)
        self.export.set_time_limit(86400.)


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
                logger.warning(f"'{obj.path}' overwrites '{dest}'")
            if obj.compr:
                dest += '.gz'
        # for directories
        else:
            if obj.filetype in ('base', 'bhdf'):
                dest = osp.basename(obj.path)
            elif obj.filetype == 'repe':
                dest = 'REPE_IN'

        if dest is not None:
            copy(obj.path, dest, verbose=True)
            if obj.compr:
                dest = uncompress(dest)
            # move the bases in main directory
            if obj.filetype in ('base', 'bhdf'):
                for fname in glob(osp.join(dest, '*')):
                    os.rename(fname, osp.basename(fname))
            # force the file to be writable
            make_writable(dest)


def copy_resultfiles(files, copybase):
    """Copy result files from the working directory.

    Arguments:
        files (list[File]): List of File objects.
        copybase (bool): Tell if result databases will be copied.
    """
    for obj in files:
        lsrc = []
        # fort.*
        if obj.unit != 0:
            lsrc.append("fort." + str(obj.unit))
        elif obj.filetype == "nom":
            lsrc.append(osp.basename(obj.path))
        # for directories
        else:
            if copybase and obj.filetype in ("base", "bhdf"):
                lbase = glob("bhdf.*")
                if not lbase or obj.filetype == "base":
                    lbase = glob("glob.*")
                lsrc.extend(lbase)
                lsrc.extend(glob("pick.*"))
            elif obj.filetype == "repe":
                lsrc.extend(glob(osp.join("REPE_OUT", "*")))

        for filename in lsrc:
            if not osp.exists(filename):
                logger.warning(f"file not found: {filename}")
            else:
                if obj.compr:
                    filename = compress(filename)
                if obj.isdir and not osp.exists(obj.path):
                    os.makedirs(obj.path)
                copy(filename, obj.path, verbose=True)
