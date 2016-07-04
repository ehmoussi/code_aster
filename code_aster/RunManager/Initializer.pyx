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

import atexit

from code_aster.Supervis.logger import logger
from code_aster.Supervis.libExecutionParameter import executionParameter
from code_aster.Supervis.libCommandSyntax import _F
from code_aster.RunManager.Pickling import Pickler
from code_aster.RunManager.loading import loadObjects


def finalize():
    """Finalize Code_Aster execution"""
    if libaster.get_sh_jeveux_status() != 1:
        return
    syntax = CommandSyntax( "FIN" )
    syntax.define( _F( INFO_RESU="NON" ) )
    cdef INTEGER numOp = 9999
    libaster.execop_( &numOp )
    libaster.register_sh_jeveux_status( 0 )
    syntax.free()


def init( int mode ):
    """Initialize Code_Aster & its memory manager"""
    # TODO: what future for aster modules?
    # At least: aster_mpi_init, exceptions, med module...
    libaster.initAsterModules()
    # Is there any glob.* to reload ?
    pickler = Pickler()
    if mode or not pickler.canRestart():
        # Emulate the syntax of DEBUT (default values should be added)
        make_cata = {}
        if mode == 1:
            make_cata = _F( CATALOGUE=_F(FICHIER='CATAELEM',
                                         UNITE=4) )
        syntax = CommandSyntax( "DEBUT" )
        syntax.define( _F( **make_cata ) )
        libaster.ibmain_()
        libaster.register_sh_jeveux_status( 1 )
        libaster.debut_()
    else:
        logger.info( "restarting from a previous execution..." )
        syntax = CommandSyntax( "POURSUITE" )
        syntax.define( _F( CODE='OUI' ) )
        libaster.ibmain_()
        libaster.register_sh_jeveux_status( 1 )
        libaster.poursu_()
        loadObjects(level=2)

    syntax.free()
    atexit.register( finalize )


def cataBuilder():
    """Build the elements catalog"""
    syntax = CommandSyntax( "MAJ_CATA" )
    syntax.define( _F( ELEMENT=_F() ) )
    cdef INTEGER numOp = 20
    libaster.execop_( &numOp )
    syntax.free()
