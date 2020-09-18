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
Unittest for Utilities.
"""

import code_aster
from code_aster.Utilities.outputs import command_text

code_aster.init("--test", "--abort", "--debug")

test = code_aster.TestCase()

class FakeDS(object):
    """Fake DataStructure object for unittests."""

    def __init__(self, name):
        self._name = name

    def getName(self):
        """Return the object name."""
        return self._name

    @property
    def userName(self):
        return self._name


obj1 = FakeDS("object1")
obj2 = FakeDS("object2")

keywords = {
    'MATR_MASS': obj1,
    'MATR_RIGI': obj2,
    'PSEUDO_MODE': {'DIRECTION': (0.0, 1.0, 0.0), 'NOM_DIR': 'toto'}
}

text = command_text("MODE_STATIQUE", keywords)
print(text)
test.assertIn("PSEUDO_MODE=_F(", text)
test.assertIn("NOM_DIR='toto'", text)
test.assertEqual(len(text.splitlines()), 4)

keywords['PSEUDO_MODE'] = [keywords['PSEUDO_MODE'], {'TOUT': 'OUI'}]
text = command_text("MODE_STATIQUE", keywords)
print(text)
test.assertIn("PSEUDO_MODE=(_F(", text)
test.assertIn("TOUT='OUI'", text)
test.assertEqual(len(text.splitlines()), 5)

text = command_text("MODE_STATIQUE", keywords, limit=2)
print(text)
test.assertIn("DIRECTION=(0.0, 1.0, ...)", text)
test.assertEqual(len(text.splitlines()), 5)

test.printSummary()

code_aster.close()
