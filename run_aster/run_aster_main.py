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

# Imports are differed to show debug informations as soon as possible
# aslint: disable=C4008

"""
    run_aster [options] EXPORT

"""

import argparse
import os
import os.path as osp
import sys
from subprocess import PIPE, run

from .logger import DEBUG, WARNING, logger

try:
    import ptvsd
    HAS_PTVSD = True
except ImportError:
    HAS_PTVSD = False

__DOC__ = __doc__


def parse_args(argv):
    """Parse command line arguments.

    Arguments:
        argv (list): List of command line arguments.
    """
    # command arguments parser
    parser = argparse.ArgumentParser(
        usage=__DOC__,
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
                        help="use this existing directory as working directory")
    parser.add_argument('--only-proc0', dest='proc0',
                        action='store_true',
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
                        help='override the time limit')
    parser.add_argument('--memory_limit', dest='memory_limit', type=float,
                        action='store',
                        help="override the memory limit in MB")
    parser.add_argument('--ptvsd', action='store', type=int,
                        help="ptvsd port number")
    parser.add_argument('export', metavar='EXPORT',
                        help="Export file defining the calculation.")

    args = parser.parse_args(argv)
    if args.ctest:
        logger.setLevel(WARNING)
    if args.debug:
        logger.setLevel(DEBUG)
    if args.env and not args.wrkdir:
        parser.error("Argument '--wrkdir' is required if '--env' is enabled")
    if args.ptvsd and not HAS_PTVSD:
        parser.error("can not import 'ptvsd'")
    return args


def main(argv=None):
    """Entry point for code_aster runner.

    Arguments:
        argv (list): List of command line arguments.
    """
    argv = argv or sys.argv[1:]
    args = parse_args(argv)

    from run_aster.export import Export, File
    from run_aster.run import RunAster, get_procid
    from run_aster.config import CFG
    from run_aster.utils import ROOT

    if args.ptvsd:
        print('Waiting for debugger attach...'),
        ptvsd.enable_attach(address=('127.0.0.1', args.ptvsd))
        ptvsd.wait_for_attach()
        ptvsd.break_into_debugger()

    export = Export(args.export, check=False)
    # args to parameters
    if args.ctest:
        args.test = True
        basename = osp.splitext(osp.basename(args.export))[0]
        mess = File(osp.abspath(basename + ".mess"),
                    filetype="mess", unit=6, resu=True)
        export.add_file(mess)
    if args.interactive:
        export.set("interact", True)
        export.set_time_limit(86400.)
    if args.time_limit:
        export.set_time_limit(args.time_limit)
    if args.memory_limit:
        export.set_memory_limit(args.memory_limit)
    export.check()

    procid = 0
    if CFG.get("parallel", 0):
        procid = get_procid()
        if args.proc0 and procid > 0:
            logger.setLevel(WARNING)
        if procid < 0 and args.auto_mpirun:
            run_aster = osp.join(ROOT, "bin", "run_aster")
            args_cmd = dict(mpi_nbcpu=export.get("mpi_nbcpu", 1),
                            program=f"{run_aster} {' '.join(argv)}")
            cmd = CFG.get("mpirun").format(**args_cmd)
            proc = run(cmd, shell=True)
            return proc.returncode

    opts = {}
    opts["test"] = args.test
    opts["env"] = args.env
    opts["tee"] = not args.ctest and (not args.proc0 or procid == 0)
    opts["interactive"] = args.interactive
    calc = RunAster.factory(export, **opts)
    status = calc.execute(args.wrkdir)
    return status.exitcode


if __name__ == '__main__':
    sys.exit(main())
