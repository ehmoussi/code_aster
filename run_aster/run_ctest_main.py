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
``bin/run_ctest`` --- Script to execute code_aster testcases using ``ctest``
----------------------------------------------------------------------------

``bin/run_ctest`` executes code_aster testcases using ``ctest``.

Usage:

.. code-block:: sh

    bin/run_ctest [options] [ctest-options] [other arguments...]

`ctest-options` and `other arguments` are passed to ``ctest``.

The list of the testcases to be executed is built from ``--testlist`` argument
and a filter on the labels (taken from the ``.export`` files).

The *sequential* label is automatically added for a sequential version.

To show the list of labels, use:

.. code-block:: sh

    bin/run_ctest --resutest=None --print-labels

.. note::

  Difference from ``ctest``: all values passed to ``-L`` option are sorted and
  joined as a unique regular expression.

  Example:

    Using:

    .. code-block:: sh

        bin/run_ctest --resutest=None -L verification -L ci -N

    the ctest command will be:

    .. code-block:: sh

        ctest -N -j 6 -L 'ci.*verification'

See ``bin/run_ctest --help`` for the available options.

"""

import argparse
import os
import os.path as osp
import re
import sys
import tempfile
from glob import glob
from subprocess import PIPE, run

from .config import CFG
from .ctest2junit import XUnitReport
from .run import get_nbcores
from .utils import ROOT

USAGE = """
    run_ctest [options] [ctest-options] [other arguments...]

Execute testcases using 'ctest'.
'ctest-options' and other arguments are passed to 'ctest'.
Use 'ctest --help' for details.

The list of the testcases to be executed is built from '--testlist' argument
and a filter on the labels (taken from the '.export' files).

The label 'sequential' is automatically added for a sequential version.

To show the list of labels, use:

    run_ctest --resutest=None --print-labels

Note:
  Difference from 'ctest': all values passed to '-L' option are sorted and joined
  as a unique regular expression.

  Example:

    Using:
        run_ctest --resutest=None -L verification -L ci -N

    the ctest command will be:

        ctest -N -j 8 -L 'ci.*verification'
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
    parser.add_argument('-j', '--jobs', action='store',
                        type=int, default=max(1, get_nbcores() - 2),
                        help="run the tests in parallel using the given "
                             "number of jobs")
    parser.add_argument('--testlist', action='store',
                        metavar="FILE",
                        help="list of testcases to run")
    parser.add_argument('--resutest', action='store',
                        help="directory to write the results of the testcases "
                             "(relative to the current directory). "
                             "Use 'None' not to keep result files.")
    parser.add_argument('--clean', action='store_true', default='auto',
                        help="remove the content of 'resutest' directory "
                             "before starting (default: auto)")
    parser.add_argument('--no-clean', action='store_false', default='auto',
                        dest="clean",
                        help="do not remove the content of 'resutest' "
                             "directory")
    parser.add_argument('--timefactor', action='store', type=float, default=1.0,
                        help="multiplicative factor applied to the time limit, "
                             "passed through environment to run_aster")
    group = parser.add_argument_group('ctest options')
    group.add_argument('--rerun-failed', action='store_true',
                       help="run only the tests that failed previously")
    group.add_argument('-L', '--label-regex', action='append', metavar="regex",
                       default=[],
                       help="run tests with labels matching regular "
                            "expression.")
    group.add_argument('--print-labels', action='store_true',
                       help="print all available test labels")

    args, others = parser.parse_known_args(argv)
    if not args.resutest:
        parser.error("'--resutest' argument is required")

    # args to be re-injected for ctest
    if args.print_labels:
        others.append("--print-labels")
    if args.rerun_failed:
        others.append("--rerun-failed")
    others.extend(["-j", str(args.jobs)])
    return args, others


def _run(cmd):
    print("execute:", " ".join(cmd))
    return run(cmd)


def main(argv=None):
    """Entry point for testcases runner.

    Arguments:
        argv (list): List of command line arguments.
    """
    args, ctest_args = parse_args(argv or sys.argv[1:])

    use_tmp = args.resutest.lower() == 'none'
    if use_tmp:
        resutest = tempfile.mkdtemp(prefix='resutest_')
    else:
        resutest = osp.join(os.getcwd(), args.resutest)

    if not use_tmp and args.clean and not args.rerun_failed: # clean = True or 'auto'
        if args.clean == "auto" and osp.exists(resutest):
            print(f"{resutest} will be removed.")
            answ = input("do you want to continue (y/n) ?")
            if answ.lower() not in ('y', 'o'):
                print("interrupt by user")
                sys.exit(1)
        _run(["rm", "-rf", resutest])

    if not osp.exists(resutest):
        os.makedirs(resutest, exist_ok=True)

    testlist = osp.abspath(args.testlist) if args.testlist else ""
    if not args.rerun_failed:
        # create CTestTestfile.cmake
        create_ctest_file(testlist,
                          osp.join(resutest, "CTestTestfile.cmake"))
    parallel = CFG.get("parallel", 0)
    labels = set()
    if not parallel:
        labels.add("sequential")
    if labels or args.label_regex:
        labels.update(args.label_regex)
        ctest_args.extend(["-L", ".*".join(sorted(labels))])

    # options passed through environment
    os.environ["FACMTPS"] = str(args.timefactor)
    # execute ctest
    os.chdir(resutest)
    proc = _run(["ctest"] + ctest_args)
    if not use_tmp:
        legend = ""
        if testlist:
            legend += " from "  + osp.join(*testlist.split(osp.sep)[-2:])
        report = XUnitReport(resutest, legend)
        report.read_ctest()
        report.write_xml("run_testcases.xml")
    else:
        _run(["rm", "-rf", resutest])
    return proc.returncode


def create_ctest_file(testlist, filename):
    """Create the CTestTestfile.cmake file.

    Arguments:
        testlist (str): Labels of testlists (comma separated) or a file
            containing a list of testcases.
        filename (str): Destination for the 'ctest' file.
    """
    datadir = osp.normpath(osp.join(ROOT, "share", "aster"))
    bindir = osp.normpath(osp.join(ROOT, "bin"))
    testdir = osp.join(datadir, "tests")
    assert osp.isdir(testdir), f"no such directory {testdir}"
    if osp.isfile(testlist):
        re_comment = re.compile("^ *#.*$", re.M)
        with open(testlist, "r") as fobj:
            text = re_comment.sub("", fobj.read())
            ltests = set(text.split())
            lexport = [osp.join(testdir, tst + ".export") for tst in ltests]
    else:
        lexport = glob(osp.join(testdir, "*.export"))

    tag = CFG.get("version_tag", "")
    text = [f"set(COMPONENT_NAME ASTER_{tag})",
            _build_def(bindir, datadir, lexport)]
    with open(filename, "w") as fobj:
        fobj.write("\n".join(text))


CTEST_DEF = """
set(TEST_NAME ${{COMPONENT_NAME}}_{testname})
add_test(${{TEST_NAME}} {BINDIR}/run_aster --ctest {ASTERDATADIR}/tests/{testname}.export)
set_tests_properties(${{TEST_NAME}} PROPERTIES
                     LABELS "${{COMPONENT_NAME}} {labels}"
                     PROCESSORS {processors})
"""

TEST_FILES_INTEGR = """
forma02a
forma01c
mumps01a
mfron01a
zzzz151a
zzzz200b
zzzz218a
zzzz401a
"""

def _build_def(bindir, datadir, lexport):
    re_list = re.compile("P +testlist +(.*)$", re.M)
    re_nod = re.compile("P +mpi_nbnoeud +([0-9]+)", re.M)
    re_mpi = re.compile("P +mpi_nbcpu +([0-9]+)", re.M)
    re_thr = re.compile("P +ncpus +([0-9]+)", re.M)
    text = []
    for exp in lexport:
        if not osp.isfile(exp):
            print(f"no such file: {exp}")
            continue
        testname = osp.splitext(osp.basename(exp))[0]
        lab = []
        nod = 1
        mpi = 1
        thr = 1
        with open(exp, "r") as fobj:
            export = fobj.read()
        mat = re_list.search(export)
        if mat:
            lab = mat.group(1).split()
        mat = re_nod.search(export)
        if mat:
            nod = int(mat.group(1))
        mat = re_mpi.search(export)
        if mat:
            mpi = int(mat.group(1))
        mat = re_thr.search(export)
        if mat:
            thr = int(mat.group(1))
        lab.append(f"nodes={nod:02d}")
        if testname in TEST_FILES_INTEGR:
            lab.append("SMECA_INTEGR")
        text.append(CTEST_DEF.format(testname=testname,
                                     labels=" ".join(sorted(lab)),
                                     processors=mpi * thr,
                                     ASTERDATADIR=datadir,
                                     BINDIR=bindir))
    return "\n".join(text)


if __name__ == '__main__':
    sys.exit(main())
