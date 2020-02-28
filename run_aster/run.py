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

# imports are in a string
# aslint: disable=C4009

import os
import os.path as osp
import re
import tempfile
from contextlib import contextmanager
from glob import glob
from math import log10
from subprocess import run

from .config import CFG
from .execute import execute
from .export import Export
from .logger import logger
from .utils import copy, gunzip, make_writable


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

    def execute(self):
        """Execution in a temporary directory."""
        self.prepare_current_directory()
        exit_code = self.execute_study()
        # Copying results
        return exit_code

    def prepare_current_directory(self):
        """Execution.
        """
        logger.info(f"TITLE Prepare environment in {os.getcwd()}")
        # add reptrav to LD_LIBRARY_PATH (to find dynamic libs provided by user)
        old = os.environ.get("LD_LIBRARY_PATH", "")
        new = (os.getcwd() + os.pathsep + old).strip(os.pathsep)
        os.environ["LD_LIBRARY_PATH"] = new

        copy(self.export_file, self.jobnum + ".export")
        os.makedirs("REPE_OUT")
        copy_datafiles(self.export.datafiles)

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
        return cmd

    def execute_study(self):
        """Execute the study.

        Returns:
            int: 0 if the execution is successful, non null otherwise.
        """
        logger.info(f"TITLE Content of {os.getcwd()} before execution:")
        run(["ls", "-l"])
        commfiles = glob("fort.1.*")
        if not commfiles:
            logger.error("no .comm file found")

        for idx, comm in enumerate(commfiles):
            logger.info(f"TITLE Command file #{idx + 1} / {len(commfiles)}")
            cmd = self.command_line(comm)
            logger.info(f"    {' '.join(cmd)}")

            text = add_import_commands(comm)
            with open(comm, 'w') as fobj:
                fobj.write(text)
            if not self.export.get("hide-command"):
                logger.info(f"\nContent of the file to execute:\n{text}\n")

            proc = run(cmd)
            iret = proc.returncode
            if iret != 0:
                logger.info(f"\n <I>_EXIT_CODE = {iret}\n\n")

        return iret

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
            copy(obj.path, dest, verbose=True)
            if obj.compr:
                dest = gunzip(dest)
            # move the bases in main directory
            if obj.filetype in ('base', 'bhdf'):
                for fname in glob(osp.join(dest, '*')):
                    os.rename(fname, osp.basename(fname))
            # force the file to be writable
            make_writable(dest)


AUTO_IMPORT = """
# temporarly added for compatibility with code_aster legacy
from math import *

import code_aster
from code_aster.Commands import *

{starter}"""

def add_import_commands(filename):
    """Add import of code_aster commands if not present.

    Arguments:
        filename (str): Path of the comm file to check.

    Returns:
        str: New file content.
    """
    with open(filename, "rb") as fobj:
        txt = fobj.read().decode(errors='replace')

    re_done = re.compile(r"^from +code_aster\.Commands", re.M)
    if re_done.search(txt):
        return txt

    re_init = re.compile("^(?P<init>(DEBUT|POURSUITE))", re.M)
    if re_init.search(txt):
        starter = r"\g<init>"
    else:
        starter = "code_aster.init()\n"
    txt = re_init.sub(AUTO_IMPORT.format(starter=starter), txt)

    re_coding = re.compile(r'^#( *(?:|\-\*\- *|en)coding.*)' + '\n', re.M)
    if not re_coding.search(txt):
        txt = "# coding=utf-8\n" + txt

    return txt
