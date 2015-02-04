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

from code_aster.Supervis.libExecutionParameter import executionParameter
from code_aster.Supervis.libCommandSyntax import _F


def init( int mode ):
    """Initialize Code_Aster & its memory manager"""
    # TODO: what future for aster modules?
    # At least: aster_mpi_init, exceptions, med module...
    libaster.initAsterModules()
    # Emulate the syntax of DEBUT (default values should be added)
    make_cata = {}
    if mode == 1:
        make_cata = _F( CATALOGUE=_F(FICHIER='CATAELEM',
                                     UNITE=4) )

    syntax = CommandSyntax( "DEBUT" )
    syntax.define( _F( CODE=_F( NIV_PUB_WEB='NON' ),
                       MEMOIRE=_F( TAILLE_BLOC=800.,
                                   TAILLE_GROUP_ELEM=1000 ),
                       **make_cata )
                 )

    libaster.ibmain_()
    libaster.debut_()
    libaster.register_sh_jeveux_status( 1 );
    syntax.free()

def finalize():
    """Finalize Code_Aster execution"""
    # cInitializer.asterFinalization()
    syntax = CommandSyntax( "FIN" )
    syntax.define( _F( STATUT=0 ) )
    cdef INTEGER numOp = 9999
    libaster.execop_( &numOp )
    libaster.register_sh_jeveux_status(0);
    syntax.free()

def cataBuilder():
    """Build the elements catalog"""
    syntax = CommandSyntax( "MAJ_CATA" )
    syntax.define( _F( ELEMENT=_F() ) )
    cdef INTEGER numOp = 20
    libaster.execop_( &numOp )
    syntax.free()
