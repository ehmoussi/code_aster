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

"""
:py:mod:`run` --- Main classes for execution
--------------------------------------------

This module defines the objects that prepare the working directory, copy the
data files, execute code_aster and copy the result files.
"""

import os
import os.path as osp
import stat
import tempfile
from contextlib import contextmanager
from glob import glob
from math import log10
from subprocess import PIPE, run

from .command_files import add_import_commands, stop_at_end
from .config import CFG
from .export import Export
from .logger import logger
from .status import StateOptions, Status, get_status
from .timer import Timer
from .utils import (ROOT, compress, copy, get_mpirun_script, make_writable,
                    run_command, uncompress)

MPI_SCRIPT = "mpi_script.sh"
TMPMESS = "fort.6"
FMT_DIAG = """
------------------------------------------------------------
--- DIAGNOSTIC JOB : {state}
------------------------------------------------------------
"""

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
        export (Export): Export object defining the calculation.
    """

    @classmethod
    def factory(cls, export):
        """Return a *RunAster* object from an *Export* object.

        Arguments:
            export (Export): Export object defining the calculation.
        """
        class_ = RunAster
        if "make_env" in export.get("actions", []):
            class_ = RunOnlyEnv
        return class_(export)

    def __init__(self, export):
        self.export = export
        self.jobnum = str(os.getpid())
        logger.debug(f"Export content: {self.export.filename}")
        logger.debug("\n" + repr(self.export))
        self._basetmp = None
        self._globtmp = None
        self._parallel = CFG.get("parallel", 0)
        self._test = "make_test" in export.get("actions", [])
        self._tee = True

    @property
    def tee(self):
        """bool: Attribute that holds the 'tee' property."""
        return self._tee

    @tee.setter
    def tee(self, value):
        self._tee = value

    def execute(self):
        """Execution in a temporary directory.

        Returns:
            Status: Status object.
        """
        timer = Timer()
        logger.info("TITLE Execution of code_aster")
        timer.start("Preparation of environment")
        self.prepare_current_directory()
        timer.stop()
        timer.start("Execution of code_aster")
        status = self.execute_study()
        timer.stop()
        timer.start("Copying results")
        self.ending_execution(status.is_completed())
        logger.info("TITLE Execution summary")
        logger.info(timer.report())
        return status

    def prepare_current_directory(self):
        """Prepare the working directory."""
        self._basetmp = os.getcwd()
        self._globtmp = osp.join(self._basetmp, "global")
        if self._parallel:
            os.makedirs(self._globtmp)
            os.chdir(self._globtmp)

        logger.info(f"TITLE Prepare environment in {os.getcwd()}")

        self.export.write_to(self.jobnum + ".export")
        os.makedirs("REPE_IN", exist_ok=True)
        os.makedirs("REPE_OUT", exist_ok=True)
        copy_datafiles(self.export.datafiles)

    def execute_study(self, show_content=True):
        """Execute the study.

        Arguments:
            show_content (bool): Show the working directory content or not.
        Returns:
            Status: Status object.
        """
        if show_content:
            logger.info(f"TITLE Content of {os.getcwd()} before execution:")
            logger.info(_ls(".", "REPE_IN"))
        commfiles = sorted(glob("fort.1.*"))
        nbcomm = len(commfiles)
        if not commfiles:
            logger.error("no .comm file found")
        elif nbcomm > 1:
            os.makedirs("BASE_PREC", exist_ok=True)

        timeout = self.export.get("time_limit", 0) * 1.25
        status = Status()
        for idx, comm in enumerate(commfiles):
            last = idx + 1 == nbcomm
            logger.info(f"TITLE Command file #{idx + 1} / {nbcomm}")
            self._change_comm_file(comm, not self.export.get("hide-command"))
            status.update(self._exec_one(comm, idx, last,
                                         timeout - status.times[-1]))
            if not status.is_completed():
                break
        # TODO coredump analysis

        return status

    def _exec_one(self, comm, idx, last, timeout):
        """Show instructions for a command file.

        Arguments:
            comm (str): Command file name.
            idx (int): Index of execution.
            last (bool): *True* for the last command file.
            timeout (float): Remaining time.
        """
        logger.info(f"TITLE Command line #{idx + 1}:")
        cmd = self._get_cmdline(comm)
        logger.info(f"    {' '.join(cmd)}")

        exitcode = run_command(cmd, timeout)
        msg = f"\nEXECUTION_CODE_ASTER_EXIT_{self.jobnum}={exitcode}\n\n"
        logger.info(msg)
        _log_mess(msg)
        status = self._get_status(exitcode, last)

        if status.is_completed():
            if not last:
                for vola in glob("vola.*"):
                    os.remove(vola)
                logger.info("saving result databases to 'BASE_PREC'...")
                for base in glob("glob.*") + glob("bhdf.*") + glob("pick.*"):
                    copy(base, "BASE_PREC")
            msg = f"execution ended (command file #{idx + 1}): {status.diag}"
            logger.info(msg)
        else:
            logger.info("restoring result databases from 'BASE_PREC'...")
            for base in glob(osp.join("BASE_PREC", "*")):
                copy(base, os.getcwd())
            msg = f"execution failed (command file #{idx + 1}): {status.diag}"
            logger.warning(msg)
        _log_mess(FMT_DIAG.format(state=status.diag))
        return status

    def _change_comm_file(self, comm, show):
        """Change a command file.

        Arguments:
            comm (str): Command file name.
            show (bool): *True* to print the content.
        """
        with open(comm, "rb") as fobj:
            text = fobj.read().decode(errors='replace')
            text = add_import_commands(text)
            if self.export.get("interact"):
                text = stop_at_end(text)
        with open(comm, 'w') as fobj:
            fobj.write(text)
        if show:
            logger.info(f"\nContent of the file to execute:\n{text}\n")

    def _get_cmdline(self, commfile):
        """Build the command line.

        Returns:
            list[str]: List of command line arguments.
        """
        cmd = [CFG.get("python")]
        if self.export.get("interact"):
            cmd.append("-i")
        cmd.append(commfile)
        cmd.extend(self.export.args)
        if self._tee:
            cmd.extend(["2>&1", "|", "tee", "-a", TMPMESS])
        else:
            cmd.extend(["2>&1", ">>", TMPMESS])
        # TODO add pid + mode to identify the process

        if self._parallel:
            logger.info(f"    {' '.join(cmd)}")
            logger.info(">>> executed by:")
            args = dict(cmdline=" ".join(cmd),
                        cp_cmd="scp -r",
                        jobnum=self.jobnum,
                        global_wrkdir=self._globtmp,
                        local_wrkdir=self._basetmp,
                        mpirun_rank=CFG.get("mpirun_rank"))
            with open(MPI_SCRIPT, "w") as fobj:
                fobj.write(get_mpirun_script(args))
            os.chmod(MPI_SCRIPT, stat.S_IRWXU)

            args_cmd = dict(mpi_nbcpu=self.export.get("mpi_nbcpu"),
                            program=MPI_SCRIPT)
            cmd = [CFG.get("mpirun").format(**args_cmd)]
        return cmd

    def _get_status(self, exitcode, last):
        """Get the execution status.

        Arguments:
            exitcode (int): Return code.
            last (bool): *True* for the last command file, *False* otherwise.
        """
        status = get_status(exitcode, TMPMESS, test=self._test and last)
        expected = self.export.get("expected_diag", [])
        if status.diag in expected:
            status.state = StateOptions.Ok
            status.exitcode = 0
        return status

    def ending_execution(self, is_completed):
        """Post execution phase : copying results, cleanup...

        Arguments:
            is_completed (bool): *True* if execution succeeded,
                *False* otherwise.
        """
        logger.info(f"TITLE Content of {os.getcwd()} after execution:")
        logger.info(_ls(".", "REPE_OUT"))
        results = self.export.resultfiles
        if results:
            logger.info("TITLE Copying results")
            copy_resultfiles(results, is_completed)


class RunOnlyEnv(RunAster):
    """Prepare a working directory for a manual execution.

    Arguments:
        export (Export): Export object defining the calculation.
    """

    def execute_study(self):
        """Execute the study.

        Returns:
            Status: Status object.
        """
        logger.info("TITLE Copy/paste these command lines:")
        profile = osp.join(ROOT, "share", "aster", "profile.sh")
        logger.info(f"    cd {os.getcwd()}")
        logger.info(f"    . {profile}")
        return super().execute_study(show_content=False)

    def _exec_one(self, comm, idx, last, timeout):
        """Show instructions for a command file.

        Arguments:
            comm (str): Command file name.
            idx (int): Index of execution.
            last (bool): *True* for the last command file.
            timeout (float): Remaining time.
        """
        cmd = self._get_cmdline(comm)
        logger.info(f"    {' '.join(cmd)}")
        return Status(StateOptions.Ok, exitcode=0)

    def _change_comm_file(self, comm, show):
        """Change a command file.

        Arguments:
            comm (str): Command file name.
            show (bool): Not use here..
        """
        super()._change_comm_file(comm, show=False)

    def ending_execution(self, _):
        """Nothing to do in this case."""


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


def _ls(*paths):
    proc = run(["ls", "-l"] + list(paths), stdout=PIPE, universal_newlines=True)
    return proc.stdout

def _log_mess(msg):
    """Log a message into the *message* file."""
    with open(TMPMESS, "a") as fobj:
        fobj.write(msg + "\n")
