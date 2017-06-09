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

# person_in_charge: mathieu.courtois at edf.fr

"""
Cata package
------------

This package give access to the catalogs of commands.

It works as a switch between the legacy supervisor and the next generation
of the commands language (already used by AsterStudy).

"""

try:
    from common.session import AsterStudySession
    HAVE_ASTERSTUDY = AsterStudySession.use_cata()
except ImportError:
    HAVE_ASTERSTUDY = False


if not HAVE_ASTERSTUDY:
    # use legacy supervisor of commands
    from .Legacy import cata
