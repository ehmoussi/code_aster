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
from .utils import ROOT, compress, copy, make_writable, run_command, uncompress

EXITCODE_FILE = "_exit_code_"
TMPMESS = "fort.6"
FMT_DIAG = """
------------------------------------------------------------
--- DIAGNOSTIC JOB : {state}
------------------------------------------------------------
"""

@contextmanager
def temporary_dir(suffix=""):
    """"""
    previous = os.getcwd()
    with tempfile.TemporaryDirectory(prefix="run_aster_", suffix=suffix,
                                        dir=CFG.get("tmpdir")) as wrkdir:
        os.chdir(wrkdir)
        yield wrkdir
        os.chdir(previous)


class RunAster:
    """Execute code_aster from a `.export` file.

    Arguments:
        export (Export): Export object defining the calculation.
    """
    _show_comm = True

    @classmethod
    def factory(cls, export, test=False, env=False, tee=False,
                interactive=False):
        """Return a *RunAster* object from an *Export* object.

        Arguments:
            export (Export): Export object defining the calculation.
            test (bool): for a testcase,
            env (bool): to only prepare the working directory and show
                command lines to be run,
            tee (bool): to follow execution output,
            interactive (bool): to keep Python interpreter active.
        """
        class_ = RunAster
        if env:
            class_ = RunOnlyEnv
        return class_(export, test, tee, interactive)

    def __init__(self, export, test=False, tee=False, interactive=False):
        self.export = export
        self.jobnum = str(os.getpid())
        logger.debug(f"Export content: {self.export.filename}")
        logger.debug("\n" + repr(self.export))
        self._parallel = CFG.get("parallel", 0)
        self._test = test
        self._tee = tee
        self._interact = interactive
        if self.export.get("hide-command"):
            self._show_comm = False
        procid = 0
        if self._parallel:
            procid = get_procid()
        procid = max(procid, 0)
        self._procid = procid

    def execute(self, wrkdir=None):
        """Execution in a temporary directory.

        Arguments:
            wrkdir (str, optional): Working directory.

        Returns:
            Status: Status object.
        """
        if wrkdir:
            if self._parallel:
                wrkdir = osp.join(wrkdir, f"proc.{self._procid}")
            os.makedirs(wrkdir, exist_ok=True)
            os.chdir(wrkdir)
            status = self._execute()
        else:
            with temporary_dir(suffix=f".proc.{self._procid}"):
                status = self._execute()
        return status

    def _execute(self):
        """Execution in the current working directory.

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
        if self._procid == 0:
            logger.info(FMT_DIAG.format(state=status.diag))
        return status

    def prepare_current_directory(self):
        """Prepare the working directory."""
        logger.info(f"TITLE Prepare environment in {os.getcwd()}")
        self.export.write_to(self.jobnum + ".export")
        os.makedirs("REPE_IN", exist_ok=True)
        os.makedirs("REPE_OUT", exist_ok=True)

    def execute_study(self):
        """Execute the study.

        Returns:
            Status: Status object.
        """
        commfiles = [obj.path for obj in self.export.commfiles]
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
            comm = change_comm_file(comm, interact=self._interact,
                                    show=self._show_comm)
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

        exitcode = run_command(cmd, timeout, exitcode_file=EXITCODE_FILE)
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
        if self._procid == 0:
            _log_mess(FMT_DIAG.format(state=status.diag))
        return status

    def _get_cmdline(self, commfile):
        """Build the command line.

        Returns:
            list[str]: List of command line arguments.
        """
        cmd = [CFG.get("python")]
        if self._interact:
            cmd.append("-i")
        cmd.append(commfile)
        if self._test:
            cmd.append("--test")
        for obj in self.export.datafiles:
            cmd.append(f'--link="{obj.as_argument}"')
        cmd.extend(self.export.args)

        if self._tee:
            orig = " ".join(cmd)
            cmd = [
                f"( {orig} ; echo $? > {EXITCODE_FILE} )",
                "2>&1", "|", "tee", "-a", TMPMESS
            ]
        else:
            cmd.extend([">>", TMPMESS, "2>&1"])
        # TODO add pid + mode to identify the process by asrun
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
        if self._procid != 0:
            return

        results = self.export.resultfiles
        if results:
            logger.info("TITLE Copying results")
            copy_resultfiles(results, is_completed, test=self._test)


class RunOnlyEnv(RunAster):
    """Prepare a working directory for a manual execution.

    Arguments:
        export (Export): Export object defining the calculation.
    """
    _show_comm = False

    def execute_study(self):
        """Execute the study.

        Returns:
            Status: Status object.
        """
        logger.info("TITLE Copy/paste these command lines:")
        profile = osp.join(ROOT, "share", "aster", "profile.sh")
        logger.info(f"    cd {os.getcwd()}")
        logger.info(f"    . {profile}")
        return super().execute_study()

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

    def ending_execution(self, _):
        """Nothing to do in this case."""


def get_procid():
    """Return the identifier of the current process.

    Returns:
        int: Process ID, -1 if a parallel version is not run under *mpirun*.
    """
    proc = run(CFG.get("mpirun_rank"), shell=True, stdout=PIPE,
               universal_newlines=True)
    try:
        procid = int(proc.stdout.strip())
    except ValueError:
        procid = -1
    return procid


def get_nbcores():
    """Return the number of available cores.

    Return:
        int: Number of cores.
    """
    proc = run(['nproc'], stdout=PIPE, universal_newlines=True)
    try:
        value = int(proc.stdout.strip())
    except ValueError:
        value = 1
    return value


def change_comm_file(comm, interact=False, wrkdir=None, show=False):
    """Change a command file.

    Arguments:
        comm (str): Command file name.
        wrkdir (str, optional): Working directory to write the changed file
            if necessary (defaults: current working directory).
        show (bool): Show file content if *True*.

    Returns:
        str: Name of the file to be executed (== *comm* if nothing changed)
    """
    with open(comm, "rb") as fobj:
        text_init = fobj.read().decode(errors='replace')
    text = add_import_commands(text_init)
    if interact:
        text = stop_at_end(text)
    if text.strip() == text_init.strip():
        return comm

    filename = osp.join(wrkdir or ".",
                        osp.splitext(osp.basename(comm))[0] + ".changed.py")
    with open(filename, 'w') as fobj:
        fobj.write(text)
    if show:
        logger.info(f"\nContent of the file to execute:\n{text}\n")
    return filename


def copy_datafiles(files):
    """Copy data files into the working directory.

    Arguments:
        files (list[File]): List of File objects.
    """
    for obj in files:
        dest = None
        # fort.*
        if obj.unit != 0 or obj.filetype == "nom":
            dest = "fort." + str(obj.unit)
            if obj.filetype == "nom":
                dest = osp.basename(obj.path)
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


def copy_resultfiles(files, copybase, test=False):
    """Copy result files from the working directory.

    Arguments:
        files (list[File]): List of File objects.
        copybase (bool): Tell if result databases will be copied.
        test (bool, optional): *True* for a testcase, *False* for a study.
    """
    for obj in files:
        if test and obj.unit not in (6, 15):
            continue
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
