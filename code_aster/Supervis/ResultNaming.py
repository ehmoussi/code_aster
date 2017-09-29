# coding=utf-8
# --------------------------------------------------------------------
# Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

from ..Utilities import Singleton
from .logger import logger


class ResultNaming(Singleton):
    """This class manages the names of the jeveux objects"""
    _singleton_id = "Supervis.ResultNaming"

    def __init__( self ):
        """Initialize the counter"""
        self._numberOfAsterObjects = 0
        # Maximum 16^8 Aster sd because of the base name of a sd aster (8 characters)
        # and because the hexadecimal system is used to give a name to a given sd
        self._maxNumberOfAsterObjects = 4294967295

    def getNewResultObjectName( self ):
        """Return a new result name
        The first one is "0       ", then "1       ", etc.
        @return String of 8 characters containing the new name
        """
        self._numberOfAsterObjects += 1
        return self.getResultObjectName()

    def getResultObjectName( self ):
        """Return the name of the result created by the current command
        @return String of 8 characters containing the name
        """
        name = "{:<8x}".format( self._numberOfAsterObjects )
        logger.debug("getResultObjectName returns {0!r}".format(name))
        return name

    def initCounter( self, start ):
        """Initialise the counter of objects"""
        self._numberOfAsterObjects = start

    def getLastId( self ):
        """Return the id of the last created objects"""
        return self._numberOfAsterObjects
