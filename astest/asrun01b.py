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

# person_in_charge: mathieu.courtois at edf.fr

"""
Unittests of run_aster package.
"""

import os
import os.path as osp
import tarfile
import tempfile
import time
import unittest
from glob import glob

from run_aster.command_files import add_import_commands, stop_at_end
from run_aster.config import CFG
from run_aster.ctest2junit import XUnitReport
from run_aster.export import (Export, File, Parameter, ParameterBool,
                              ParameterFloat, ParameterInt, ParameterListStr,
                              ParameterStr)
from run_aster.logger import ERROR, logger
from run_aster.status import StateOptions as SO
from run_aster.status import Status, get_status
from run_aster.timer import Timer
from run_aster.utils import ROOT, copy

# run silently
logger.setLevel(ERROR + 1)


class TestParameter(unittest.TestCase):
    """Check Parameter objects"""

    def test_factory(self):
        para = Parameter.factory("debug")
        self.assertIsInstance(para, ParameterStr)
        para = Parameter.factory("mpi_nbcpu")
        self.assertIsInstance(para, ParameterInt)
        para = Parameter.factory("memory_limit")
        self.assertIsInstance(para, ParameterFloat)
        para = Parameter.factory("testlist")
        self.assertIsInstance(para, ParameterListStr)
        # unknown as list[str]
        para = Parameter.factory("xxxx")
        self.assertIsInstance(para, ParameterListStr)
        # deprecated as None: ignored
        para = Parameter.factory("service")
        self.assertIsNone(para)

    def test_str(self):
        para = ParameterStr("debug")
        self.assertIsNone(para.value)
        para.set("nodebug")
        self.assertEqual(para.value, "nodebug")
        para.set(123)
        self.assertEqual(para.value, "123")
        para.set(["no", "debug"])
        self.assertEqual(para.value, "no debug")
        para.set([2, "debug"])
        self.assertEqual(para.value, "2 debug")

    def test_bool(self):
        para = ParameterBool("interact")
        para.set([])
        self.assertTrue(para.value)
        para.set(False)
        self.assertFalse(para.value)
        para.set(True)
        self.assertTrue(para.value)
        para.set(0)
        self.assertFalse(para.value)
        para.set("ok")
        self.assertTrue(para.value)
        para.set("False")
        self.assertFalse(para.value)
        para.set("True")
        self.assertTrue(para.value)
        para.set([16.0, 32.0])
        self.assertTrue(para.value)

    def test_int(self):
        para = ParameterInt("mpi_nbcpu")
        self.assertIsNone(para.value)
        para.set(2)
        self.assertEqual(para.value, 2)
        para.set(16.0)
        self.assertEqual(para.value, 16)
        para.set("8.1")
        self.assertEqual(para.value, 8)
        para.set([16.0])
        self.assertEqual(para.value, 16)
        with self.assertRaises(ValueError):
            para.set([16.0, 32.0])

    def test_float(self):
        para = ParameterFloat("memory_limit")
        self.assertIsNone(para.value)
        para.set(2048)
        self.assertEqual(para.value, 2048.0)
        para.set(1024.1)
        self.assertEqual(para.value, 1024.1)
        para.set("512")
        self.assertEqual(para.value, 512.0)
        para.set([16.5])
        self.assertEqual(para.value, 16.5)
        with self.assertRaises(ValueError):
            para.set([16.0, 32.0])

    def test_liststr(self):
        para = ParameterListStr("testlist")
        self.assertIsNone(para.value)
        para.set([])
        self.assertSequenceEqual(para.value, [])
        para.set("ci")
        self.assertSequenceEqual(para.value, ["ci"])
        para.set(123.456)
        self.assertSequenceEqual(para.value, ["123.456"])
        para.set(["ci", "verification"])
        self.assertSequenceEqual(para.value, ["ci", "verification"])
        para.set([2, "debug"])
        self.assertSequenceEqual(para.value, ["2", "debug"])


class TestFile(unittest.TestCase):
    """Check File object"""

    def test_file(self):
        fobj = File("/a/filename", resu=True)
        self.assertEqual(fobj.path, "/a/filename")
        self.assertEqual(fobj.filetype, "libr")
        self.assertFalse(fobj.is_tests_data)
        self.assertEqual(fobj.unit, 0)
        self.assertFalse(fobj.isdir)
        self.assertFalse(fobj.data)
        self.assertTrue(fobj.resu)
        self.assertFalse(fobj.compr)
        self.assertEqual(repr(fobj), "F libr /a/filename R 0")

    def test_directory(self):
        tmpdir = os.getcwd()
        wrk = File(tmpdir)
        self.assertEqual(wrk.path, os.getcwd())
        self.assertEqual(wrk.filetype, "libr")
        self.assertEqual(wrk.unit, 0)
        self.assertTrue(wrk.isdir)
        self.assertTrue(wrk.data)
        self.assertFalse(wrk.resu)
        self.assertFalse(wrk.compr)
        self.assertEqual(repr(wrk), f"R libr {tmpdir} D 0")

    def test_special(self):
        fobj = File("/a/filename", filetype="tests_data", data=True)
        self.assertEqual(fobj.filetype, "nom")
        self.assertTrue(fobj.is_tests_data)


class TestExport(unittest.TestCase):
    """Check Export object"""

    def test(self):
        lfexp = glob("*.export")
        self.assertEqual(len(lfexp), 1)
        fexp = lfexp[0]
        with self.assertRaises(FileNotFoundError):
            export = Export(fexp + "XX")

        export = Export(fexp)
        self.assertIn(".export", export.filename)
        self.assertIn("/asrun01b.py", repr(export))
        self.assertTrue(export.has_param("time_limit"))
        self.assertFalse(export.has_param("consbtc"))
        self.assertIsInstance(export.get_param("time_limit"), ParameterFloat)
        self.assertIsNone(export.get_param("consbtc"))
        # because of facmtps
        self.assertGreaterEqual(export.get("time_limit"), 60.0)
        export.set_time_limit(123.456)
        self.assertEqual(export.get("time_limit"), 123.456)
        self.assertIsNone(export.get("consbtc"))
        self.assertEqual(len(export.commfiles), 1)
        self.assertEqual(len(export.datafiles), 2)
        # 0 in asrun01b.export, but
        # + 'mess' with '--ctest',
        # + 'resu' + 'code' with as_run
        self.assertIn(len(export.resultfiles), (0, 1, 3))
        comm = export.commfiles[0]
        self.assertEqual(osp.basename(comm.path), "asrun01b.comm")
        self.assertEqual(comm.unit, 1)
        self.assertTrue(comm.data)
        tar = [i for i in export.datafiles if i.filetype == "libr"][0]
        self.assertEqual(osp.basename(tar.path), "asrun01b.11")
        self.assertEqual(tar.unit, 11)
        self.assertTrue(tar.data)

    def test_data(self):
        text = "\n".join([
            "F nom filename.py D 0",
            "F tests_data filename.py D 0",
        ])
        export = Export(from_string=text)
        # tests_data type works as nom but with a different path initialization
        file0, file1 = export.datafiles
        self.assertIsNone(export.filename)
        self.assertEqual(file0.filetype, "nom")
        self.assertEqual(file1.filetype, "nom")
        self.assertFalse(file0.is_tests_data)
        self.assertTrue(file1.is_tests_data)
        self.assertEqual(file0.path, "filename.py")
        self.assertEqual(file1.path, osp.join(ROOT, "share", "aster",
                                              "tests_data", "filename.py"))
        self.assertEqual(repr(export), "\n".join([
            "F nom filename.py D 0",
            "F tests_data {} D 0".format(file1.path),
            ""]))

    def test_args(self):
        # memory is taken from memjeveux (that is removed) + addmem
        text = "\n".join([
            "A args --continue --memjeveux=512",
            "A max_base 1000",
            "A abort",
        ])
        addmem = CFG.get("addmem", 0.)
        export = Export(from_string=text)
        memory = export.get_argument_value("memory", float) # with addmem
        self.assertEqual(memory, 4096.0 + addmem)
        self.assertSequenceEqual(export.args,
            ["--continue",
             "--max_base", "1000", "--abort",
             "--memory", str(memory)])
        self.assertIsNone(export.get_argument_value("memjeveux", float))
        self.assertEqual(export.get_argument_value("max_base", float), 1000.0)
        self.assertEqual(export.get_argument_value("continue", bool), True)
        self.assertEqual(export.get_argument_value("abort", bool), True)
        self.assertEqual(export.get_argument_value("tpmax", float), None)
        self.assertEqual(export.get_argument_value("dbgjeveux", bool), False)
        self.assertEqual(repr(export), "\n".join([
            "A args --continue --max_base 1000 --abort --memory {}"
            .format(4096.0 + addmem),
            ""]))

    def test_memory(self):
        text = "P memory_limit 4096.0"
        addmem = CFG.get("addmem", 0.)
        export = Export(from_string=text)
        self.assertGreaterEqual(export.get("memory_limit"), 4096.0)
        self.assertGreaterEqual(export.get_argument_value("memory", float), 4096.0)
        self.assertEqual(repr(export), "\n".join([
            "P memory_limit 4096.0",
            "A args --memory {}".format(4096.0 + addmem),
            ""]))

    def test_time(self):
        text = "P tpsjob 60"
        export = Export(from_string=text)
        self.assertEqual(export.get("tpsjob"), 60)
        self.assertEqual(export.get("time_limit"), 3600.0)
        self.assertEqual(export.get_argument_value("tpmax", float), 3600.0)
        self.assertEqual(repr(export), "\n".join([
            "P tpsjob 60",
            "P time_limit 3600.0",
            "A args --tpmax 3600",
            ""]))

    def test_time2(self):
        text = "\n".join([
            "P tpsjob 60",
            "P time_limit 1800",
        ])
        export = Export(from_string=text)
        self.assertEqual(export.get("tpsjob"), 60)
        self.assertEqual(export.get("time_limit"), 1800.0)
        self.assertEqual(export.get_argument_value("tpmax", float), 1800.0)
        self.assertEqual(repr(export), "\n".join([
            "P tpsjob 60",
            "P time_limit 1800.0",
            "A args --tpmax 1800.0",
            ""]))

    def test_bool(self):
        text = "P hide-command"
        export = Export(from_string=text)
        self.assertTrue(export.has_param("hide-command"))
        param = export.get_param("hide-command")
        self.assertIsInstance(param, ParameterBool)
        self.assertTrue(export.get("hide-command"))
        self.assertEqual(repr(export), "\n".join([
            "P hide-command",
            ""]))
        # how to disable a bool parameter
        param.set(False)
        self.assertFalse(export.get("hide-command"))
        self.assertEqual(repr(export), "\n")


class TestCommandFiles(unittest.TestCase):
    """Check operations on command files"""

    def test_import(self):
        text = ""
        res = add_import_commands(text)
        self.assertEqual(res, "# coding=utf-8\n")

        text = "DEBUT()"
        res = add_import_commands(text)
        self.assertIn("# coding=utf-8", res)
        self.assertIn("import code_aster", res)
        self.assertIn("from code_aster.Commands import *", res)
        self.assertIn("from math import *", res)
        self.assertIn("DEBUT()", res)

        res2 = add_import_commands(res)
        self.assertEqual(res, res2)

    def test_end(self):
        text = "\n".join([
            "DEBUT()",
            "FIN(PROC0='OUI')"
        ])
        res = stop_at_end(text)
        self.assertIn("DEBUT()", res)
        self.assertIn("raise EOFError", res)
        self.assertIn("FIN(PROC0='OUI')", res)


class TestStatus(unittest.TestCase):
    """Check helper for execution status"""

    def test_state(self):
        state = SO.Ok
        self.assertEqual(SO.name(state), "OK")
        state = SO.Warn
        self.assertEqual(SO.name(state), "<A>_ALARM")
        state = SO.Warn | SO.Nook
        self.assertEqual(SO.name(state), "NOOK_TEST_RESU")
        state = SO.Warn | SO.NoTest
        self.assertEqual(SO.name(state), "NO_TEST_RESU")
        state = SO.CpuLimit
        self.assertEqual(SO.name(state), "<S>_CPU_LIMIT")
        state = SO.NoConvergence
        self.assertEqual(SO.name(state), "<S>_NO_CONVERGENCE")
        state = SO.Warn | SO.Memory
        self.assertEqual(SO.name(state), "<S>_MEMORY_ERROR")
        state = SO.Warn | SO.Nook | SO.Except
        self.assertEqual(SO.name(state), "<S>_ERROR")
        state = SO.Fatal
        self.assertEqual(SO.name(state), "<F>_ERROR")
        state = SO.Syntax | SO.Fatal
        self.assertEqual(SO.name(state), "<F>_SYNTAX_ERROR")
        state = SO.Abort
        self.assertEqual(SO.name(state), "<F>_ABNORMAL_ABORT")
        state = SO.Warn | SO.Nook | SO.Except | SO.Abort
        self.assertEqual(SO.name(state), "<F>_ABNORMAL_ABORT")

    def test_effective(self):
        state = SO.Ok
        self.assertEqual(SO.effective(state), SO.Ok)
        state = SO.Ok | SO.Warn | SO.Nook
        self.assertEqual(SO.effective(state), SO.Warn | SO.Nook)
        state = SO.Ok | SO.NoTest
        self.assertEqual(SO.effective(state), SO.NoTest)
        state = SO.Ok | SO.Warn | SO.Nook | SO.Syntax
        self.assertEqual(SO.effective(state), SO.Syntax)
        state = SO.Warn | SO.Nook | SO.CpuLimit | SO.Syntax
        self.assertEqual(SO.effective(state), SO.CpuLimit | SO.Syntax)
        state = SO.Warn | SO.Nook | SO.CpuLimit | SO.Except
        self.assertEqual(SO.effective(state), SO.CpuLimit | SO.Except)

    def test_status(self):
        status = Status()
        self.assertEqual(status.state, 0)
        self.assertEqual(status.exitcode, -1)
        status.state = SO.NoTest | SO.Warn
        self.assertEqual(SO.name(status.state), "NO_TEST_RESU")
        self.assertTrue(status.state & SO.NoTest)
        self.assertFalse(status.state & SO.Ok)
        self.assertTrue(status.state & SO.Warn)
        self.assertTrue(status.state & SO.Completed)

    def test_status_update(self):
        status = Status()
        st1 = Status(SO.Warn | SO.NoTest, 0)
        st1.times = (3., 1., 5., 10.)
        status.update(st1)
        self.assertEqual(status.state, SO.Warn | SO.NoTest)
        self.assertEqual(status.exitcode, 0)
        self.assertSequenceEqual(status.times, (3., 1., 5., 10.))
        st2 = Status(SO.Except, 1)
        st2.times = (100., 1., 101., 105.)
        status.update(st2)
        self.assertEqual(status.state, SO.Except)
        self.assertEqual(status.exitcode, 1)
        self.assertSequenceEqual(status.times, (103., 2., 106., 115.))

    def test_diag(self):
        status = get_status(0, "")
        self.assertEqual(status.exitcode, 0)
        self.assertEqual(status.state, SO.Ok)
        self.assertEqual(SO.name(status.state), "OK")
        self.assertTrue(status.state & SO.Completed)
        self.assertTrue(status.is_completed())
        self.assertFalse(status.state & SO.Error)
        self.assertSequenceEqual(status.times, [0.] * 4)

        status = get_status(1, "")
        self.assertEqual(status.state, SO.Abort)
        self.assertFalse(status.is_completed())
        self.assertEqual(status.exitcode, 1)
        self.assertEqual(SO.name(status.state), "<F>_ABNORMAL_ABORT")
        self.assertFalse(status.state & SO.Completed)
        self.assertTrue(status.state & SO.Error)

        status = get_status(0, "", test=True)
        self.assertEqual(status.state, SO.NoTest)
        self.assertEqual(SO.name(status.state), "NO_TEST_RESU")
        self.assertFalse(status.state & SO.Ok)
        self.assertTrue(status.state & SO.Completed)
        self.assertFalse(status.state & SO.Error)

        status = get_status(0, "! <A> SUPERVIS_1 !", test=True)
        self.assertEqual(status.state, SO.NoTest | SO.Warn)
        self.assertEqual(SO.name(status.state), "NO_TEST_RESU")
        self.assertFalse(status.state & SO.Ok)
        self.assertTrue(status.state & SO.Completed)
        self.assertFalse(status.state & SO.Error)

        output = "\n".join([
            "! <A> SUPERVIS_1 !",
            "NOOK 1. 0....",
        ])
        status = get_status(0, output)
        self.assertEqual(status.state, SO.Nook | SO.Warn)
        self.assertEqual(SO.name(status.state), "NOOK_TEST_RESU")
        self.assertFalse(status.state & SO.Ok)
        self.assertTrue(status.state & SO.Completed)
        self.assertFalse(status.state & SO.Error)

        status = get_status(1, "TimeLimitError")
        self.assertEqual(status.state, SO.CpuLimit)
        self.assertEqual(SO.name(status.state), "<S>_CPU_LIMIT")
        self.assertFalse(status.state & SO.Ok)
        self.assertFalse(status.state & SO.Completed)
        self.assertTrue(status.state & SO.Error)

        output = "\n".join([
            "! <S> <MECANONLINE_12> ARRET PAR MANQUE DE TEMPS CPU !",
            "SyntaxError: unexpected argument",
        ])
        status = get_status(1, output)
        self.assertEqual(status.state,
                         SO.CpuLimit | SO.Except | SO.Syntax)
        self.assertEqual(SO.name(status.state), "<F>_SYNTAX_ERROR")
        self.assertFalse(status.state & SO.Ok)
        self.assertFalse(status.state & SO.Completed)
        self.assertTrue(status.state & SO.Error)

        output = "\n".join([
            "! <NoConvergenceError> <MECANONLINE_44> bla bla !",
            "TimeLimitError: xxxx",
        ])
        status = get_status(1, output)
        self.assertEqual(status.state,
                         SO.CpuLimit | SO.NoConvergence)
        self.assertEqual(SO.name(status.state), "<S>_NO_CONVERGENCE")
        self.assertFalse(status.state & SO.Ok)
        self.assertFalse(status.state & SO.Completed)
        self.assertTrue(status.state & SO.Error)

        output = "\n".join([
            "-- CODE_ASTER -- VERSION : DÉVELOPPEMENT (unstable) --",
            " OK assert True passed",
        ])
        status = get_status(0, output)
        self.assertEqual(status.state, SO.Abort)
        self.assertEqual(SO.name(status.state), "<F>_ABNORMAL_ABORT")
        self.assertFalse(status.state & SO.Ok)
        self.assertFalse(status.state & SO.Completed)
        self.assertTrue(status.state & SO.Error)


class TestUtils(unittest.TestCase):
    """Check utilities functions"""

    def test_copy(self):
        previous = os.getcwd()
        with tempfile.TemporaryDirectory() as tmpdir:
            os.chdir(tmpdir)
            os.system("echo data1 > data1")
            os.system("mkdir datadir")
            os.system("echo data2 > datadir/data2")
            os.system("echo data3 > datadir/data3")
            copy("data1", "resudir1/resu1", verbose=True)
            self.assertTrue(osp.isfile(osp.join(tmpdir, "resudir1", "resu1")))
            copy("data1", "resudir1/resu1.1", verbose=True)
            self.assertTrue(osp.isfile(osp.join(tmpdir, "resudir1", "resu1.1")))
            copy("data1", "resudir1", verbose=True)
            self.assertTrue(osp.isfile(osp.join(tmpdir, "resudir1", "data1")))

            copy("datadir", "resudir2")
            self.assertTrue(osp.isdir(osp.join(tmpdir, "resudir2")))
            self.assertTrue(osp.isfile(osp.join(tmpdir, "resudir2", "data2")))
            self.assertTrue(osp.isfile(osp.join(tmpdir, "resudir2", "data3")))
            with open(osp.join(tmpdir, "resudir2", "data3")) as fobj:
                self.assertTrue("data3" in fobj.read())
            os.system("echo change3 > datadir/data3")
            copy("datadir", "resudir2")
            self.assertTrue(osp.isdir(osp.join(tmpdir, "resudir2")))
            self.assertTrue(osp.isfile(osp.join(tmpdir, "resudir2", "data2")))
            self.assertTrue(osp.isfile(osp.join(tmpdir, "resudir2", "data3")))
            self.assertFalse(osp.isdir(osp.join(tmpdir, "resudir2", "datadir")))
            with open(osp.join(tmpdir, "resudir2", "data3")) as fobj:
                self.assertTrue("change3" in fobj.read())
            # os.system("find")
        os.chdir(previous)

    def test_timer(self):
        timer = Timer("Global")
        timer.start("key1")
        timer.start("key2")
        time.sleep(0.1)
        timer.stop()
        time.sleep(0.1)
        report = timer.report()
        self.assertEqual(len(timer._started), 3)
        self.assertEqual(len(timer._measures), 3)
        self.assertGreaterEqual(timer._measures["key1"].elapsed, 0.19)
        self.assertGreaterEqual(timer._measures["key2"].elapsed, 0.09)
        self.assertIn("Global", report)


class TestCTest2Junit(unittest.TestCase):
    """Check ctest2junit module"""

    def test_convert(self):
        previous = os.getcwd()
        with tempfile.TemporaryDirectory() as tmpdir:
            os.chdir(tmpdir)
            with tarfile.open(osp.join(previous, "fort.11")) as tar:
                tar.extractall()
            report = XUnitReport(tmpdir)
            report.read_ctest()
            report.write_xml("run_testcases.xml")
        os.chdir(previous)


if __name__ == "__main__":
    unittest.main()
