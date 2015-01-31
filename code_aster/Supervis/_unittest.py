# coding: utf-8

# Copyright (C) 1991 - 2015  EDF R&D                www.code-aster.org
#
# This file is part of Code_Aster.
#
# Code_Aster is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 2 of the License, or
# (at your option) any later version.
#
# Code_Aster is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with Code_Aster.  If not, see <http://www.gnu.org/licenses/>.

import unittest

from code_aster.Supervis.libBaseUtils import to_fstr, to_cstr


class TestBaseUtils( unittest.TestCase ):

    def test01_to_fstr( self ):
        """check to_fstr function"""
        res = to_fstr("hello", 8)
        assert len(res) == 8, repr(res)
        assert res == "hello   ", repr(res)

    def test02_to_cstr( self ):
        """check to_cstr function"""
        res = to_cstr(" hello     not a string", 8)
        assert len(res) == 6, repr(res)
        assert res == " hello", repr(res)


if __name__ == '__main__':
    unittest.main()
