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
import unittest
from glob import glob

from run_aster.export import (Export, File, Parameter, ParameterBool,
                              ParameterFloat, ParameterInt, ParameterListStr,
                              ParameterStr)
from run_aster.logger import ERROR, logger
from run_aster.command_files import add_import_commands, stop_at_end

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


class TestExport(unittest.TestCase):
    """Check Export object"""

    def test(self):
        lfexp = glob("*.export")
        self.assertEqual(len(lfexp), 1)
        fexp = lfexp[0]
        with self.assertRaises(FileNotFoundError):
            export = Export(fexp + "XX")

        export = Export(fexp)
        self.assertIn("/asrun01b.py", repr(export))
        self.assertTrue(export.has_param("time_limit"))
        self.assertFalse(export.has_param("consbtc"))
        self.assertIsInstance(export.get_param("time_limit"), ParameterFloat)
        self.assertIsNone(export.get_param("consbtc"))
        self.assertEqual(export.get("time_limit"), 60.0)
        self.assertIsNone(export.get("consbtc"))
        self.assertEqual(len(export.datafiles), 2)
        self.assertEqual(len(export.resultfiles), 0)
        comm = [i for i in export.datafiles if i.filetype == "comm"][0]
        self.assertEqual(osp.basename(comm.path), "asrun01b.comm")
        self.assertEqual(comm.unit, 1)
        self.assertTrue(comm.data)

    def test_args(self):
        # memory is taken from memjeveux (that is removed) + addmem
        text = "\n".join([
            "A args --continue --memjeveux=512",
            "A max_base 1000",
            "A abort",
        ])
        export = Export(from_string=text)
        memory = export.get_argument_value("memory", float) # with addmem
        self.assertGreaterEqual(memory, 4096.0)
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

    def test_memory(self):
        text = "P memory_limit 4096.0"
        export = Export(from_string=text)
        self.assertGreaterEqual(export.get("memory_limit"), 4096.0)
        self.assertGreaterEqual(export.get_argument_value("memory", float), 4096.0)

    def test_time(self):
        text = "P tpsjob 60"
        export = Export(from_string=text)
        self.assertEqual(export.get("tpsjob"), 60)
        self.assertEqual(export.get("time_limit"), 3600.0)
        self.assertEqual(export.get_argument_value("tpmax", float), 3600.0)

    def test_time2(self):
        text = "\n".join([
            "P tpsjob 60",
            "P time_limit 1800",
        ])
        export = Export(from_string=text)
        self.assertEqual(export.get("tpsjob"), 60)
        self.assertEqual(export.get("time_limit"), 1800.0)
        self.assertEqual(export.get_argument_value("tpmax", float), 1800.0)

    def test_bool(self):
        text = "P hide-command"
        export = Export(from_string=text)
        self.assertTrue(export.has_param("hide-command"))
        param = export.get_param("hide-command")
        self.assertIsInstance(param, ParameterBool)
        self.assertTrue(export.get("hide-command"))
        # how to disable a bool parameter
        param.set(False)
        self.assertFalse(export.get("hide-command"))


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
        self.assertEqual(res, "DEBUT()\nraise EOFError\nFIN(PROC0='OUI')")


if __name__ == "__main__":
    unittest.main()
