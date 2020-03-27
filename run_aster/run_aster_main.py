#!/usr/bin/env python3
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
``bin/run_aster`` --- Script to execute code_aster from a ``.export`` file
--------------------------------------------------------------------------

``bin/run_aster`` executes a code_aster study from the command line.
The parameters and files used by the study are defined in a ``.export`` file
(see :py:mod:`~run_aster.export` for description of the syntax of the
``.export``).

For parallel executions, these two forms are equivalent:

.. code-block:: sh

    bin/run_aster path/to/file.export

or:

.. code-block:: sh

    mpirun -n 4 bin/run_aster path/to/file.export

Using the first syntax, ``bin/run_aster`` re-runs with ``mpirun`` itself using
the second syntax (``mpirun`` syntax is provided by the configuration, see
:py:mod:`~run_aster.config`).

``bin/run_aster`` only runs each own version, those installed at the level of
the ``bin`` directory; unlike ``as_run`` where the same instance of ``as_run``
executes several versions of code_aster.
This makes ``bin/run_aster`` simpler and allows per version settings
(see :py:mod:`~run_aster.config` for more informations about the configuration
of a version).

More options are available to execute code_aster with an interactive Python
interpreter, to prepare a working directory and to start manually (through
a debugger for example)...
For example, executing ``bin/run_aster`` with no ``.export`` file starts an
interactive Python interpreter.

See ``bin/run_aster --help`` for the available options.

"""

import argparse
import os
import os.path as osp
import sys
import tempfile
from subprocess import PIPE, run

from .command_files import AUTO_IMPORT
from .config import CFG
from .export import Export, File
from .logger import DEBUG, WARNING, logger
from .run import RunAster, get_procid
from .utils import ROOT

try:
    import ptvsd
    HAS_PTVSD = True
except ImportError:
    HAS_PTVSD = False

USAGE = """
    run_aster [options] [EXPORT]

"""


def parse_args(argv):
    """Parse command line arguments.

    Arguments:
        argv (list): List of command line arguments.
    """
    # command arguments parser
    parser = argparse.ArgumentParser(
        usage=USAGE,
        formatter_class=argparse.ArgumentDefaultsHelpFormatter)
    parser.add_argument('-g', '--debug', action='store_true',
                        help="print debugging information (same as "
                             "DEBUG=1 in environment)")
    parser.add_argument('-i', '--interactive', action='store_true',
                        help="inspect interactively after running script"
                             "instead of calling FIN command, time limit is "
                             "increased to 24 hours")
    parser.add_argument('--env', action='store_true',
                        help="do not execute, only prepare the working "
                             "directory ('--wrkdir' is required)")
    parser.add_argument('-w', '--wrkdir', action='store',
                        help="use this directory as working directory")
    parser.add_argument('--all-procs', dest='only_proc0',
                        action='store_false', default=None,
                        help="show all processors output")
    parser.add_argument('--only-proc0', dest='only_proc0',
                        action='store_true', default=None,
                        help="only processor #0 is writing on stdout")
    parser.add_argument('--no-mpi', dest='auto_mpirun',
                        action='store_false',
                        help="if '%(prog)s' is executed with a parallel "
                             "version but not under 'mpirun', it is "
                             "automatically restart with "
                             "'mpirun -n N %(prog)s ...'; use '--no-mpi' "
                             "to not do it")
    parser.add_argument('-t', '--test', action='store_true',
                        help="execution of a testcase")
    parser.add_argument('--ctest', action='store_true',
                        help="testcase execution inside ctest (implies "
                             "'--test'), the 'mess' file is saved into "
                             "the current directory (which is '--resutest' "
                             "directory for 'run_ctest') and is not duplicated "
                             "on stdout.")
    parser.add_argument('--time_limit', dest='time_limit', type=float,
                        action='store', default=None,
                        help='override the time limit (may also be changed by '
                             'FACMTPS environment variable)')
    parser.add_argument('--memory_limit', dest='memory_limit', type=float,
                        action='store',
                        help="override the memory limit in MB")
    parser.add_argument('--ptvsd-runner', action='store', type=int,
                        help=argparse.SUPPRESS)
    parser.add_argument('--no-comm', action='store_true',
                        help="do not executes the `.comm` files but starts an "
                             "interactive Python session. Execute "
                             "`code_aster.init()` to copy data files.")
    parser.add_argument('export', metavar='EXPORT', nargs="?",
                        help="Export file defining the calculation. "
                             "Without file, it starts an interactive Python "
                             "session.")

    args = parser.parse_args(argv)
    if args.ctest:
        logger.setLevel(WARNING)
    if args.debug:
        logger.setLevel(DEBUG)
    if args.env and not args.wrkdir:
        parser.error("Argument '--wrkdir' is required if '--env' is enabled")
    if args.ptvsd_runner and not HAS_PTVSD:
        parser.error("can not import 'ptvsd'")
    return args


def main(argv=None):
    """Entry point for code_aster runner.

    Arguments:
        argv (list): List of command line arguments.
    """
    argv = argv or sys.argv[1:]
    args = parse_args(argv)

    if args.ptvsd_runner:
        print('Waiting for debugger attach...'),
        ptvsd.enable_attach(address=('127.0.0.1', args.ptvsd_runner))
        ptvsd.wait_for_attach()
        ptvsd.break_into_debugger()

    export = Export(args.export, " ", test=args.test or args.ctest, check=False)
    # args to parameters
    tmpf = None
    if args.no_comm:
        for comm in export.commfiles:
            export.remove_file(comm)
    if not args.export or args.no_comm:
        args.interactive = True
        with tempfile.NamedTemporaryFile(mode="w", delete=False) as fobj:
            fobj.write(AUTO_IMPORT.format(starter=""))
            export.add_file(File(fobj.name, filetype="comm", unit=1))
            tmpf = fobj.name
    if args.ctest:
        args.test = True
        basename = osp.splitext(osp.basename(args.export))[0]
        mess = File(osp.abspath(basename + ".mess"),
                    filetype="mess", unit=6, resu=True)
        export.add_file(mess)
    if args.time_limit:
        export.set_time_limit(args.time_limit)
    # use FACMTPS from environment
    try:
        mult = float(os.environ.get("FACMTPS", 1))
        limit = export.get("time_limit", 0) * mult
        export.set_time_limit(limit)
    except ValueError:
        pass
    if args.interactive:
        export.set("interact", True)
        export.set_time_limit(86400.)
    if args.memory_limit:
        export.set_memory_limit(args.memory_limit)
    if export.get("no-mpi"):
        args.auto_mpirun = False
    export.check()

    if args.only_proc0 is None:
        args.only_proc0 = CFG.get("only-proc0", False)
    procid = 0
    if CFG.get("parallel", 0):
        procid = get_procid()
        if args.only_proc0 and procid > 0:
            logger.setLevel(WARNING)
        if procid < 0 and args.auto_mpirun:
            if tmpf:
                os.remove(tmpf)
            run_aster = osp.join(ROOT, "bin", "run_aster")
            args_cmd = dict(mpi_nbcpu=export.get("mpi_nbcpu", 1),
                            program=f"{run_aster} {' '.join(argv)}")
            cmd = CFG.get("mpirun").format(**args_cmd)
            proc = run(cmd, shell=True)
            return proc.returncode

    opts = {}
    opts["test"] = args.test
    opts["env"] = args.env or "make_env" in export.get("actions", [])
    opts["tee"] = not args.ctest and (not args.only_proc0 or procid == 0)
    opts["interactive"] = args.interactive
    calc = RunAster.factory(export, **opts)
    status = calc.execute(args.wrkdir)
    if tmpf and not opts["env"]:
        os.remove(tmpf)
    return status.exitcode


if __name__ == '__main__':
    sys.exit(main())
