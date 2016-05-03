# coding: utf-8

# Copyright (C) 1991 - 2016  EDF R&D                www.code-aster.org
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

from Tester import TestCase


class TestTester( unittest.TestCase ):

    def setUp(self):
        """create a TestCase object"""
        self.tst = TestCase(silent=False)

    def test01_basic( self ):
        """check basic assertions"""
        self.tst.assertTrue( type(1) is int )
        self.tst.assertEqual( 1 , 1 )
        self.tst.assertEqual( 1 , 0 )

    def test02_exc( self ):
        """check assertRaises*"""
        with self.tst.assertRaises( IOError ):
            raise IOError
        with self.tst.assertRaises( OSError ):
            raise IOError
        with self.tst.assertRaises( OSError ):
            pass


if __name__ == '__main__':
    unittest.main()
