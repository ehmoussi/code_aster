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

import atexit
import cPickle
import types

from code_aster.Supervis.libExecutionParameter import executionParameter
from code_aster.Supervis.libCommandSyntax import _F


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
    libaster.register_sh_jeveux_status( 1 )
    libaster.debut_()
    syntax.free()
    atexit.register( finalize )

def cataBuilder():
    """Build the elements catalog"""
    syntax = CommandSyntax( "MAJ_CATA" )
    syntax.define( _F( ELEMENT=_F() ) )
    cdef INTEGER numOp = 20
    libaster.execop_( &numOp )
    syntax.free()

# pickling/unpickling functions
def saveObjects(context, filename="code_aster.pick"):
    """Save objects of the context in a file.
    No instruction should be called after this!"""
    ctxt = _filteringContext(context)
    pick = open(filename, "wb")
    # ordered list of objects names
    objList = []
    for name, obj in ctxt.items():
        try:
            cPickle.dump( obj, pick, -1 )
        except TypeError:
            print "object can't be pickled: {0}".format(name)
            continue
        objList.append( name )
    cPickle.dump( objList, pick )
    pick.close()
    return 0

def loadObjects(context, filename="code_aster.pick"):
    """Load objects from a file in the context"""
    pick = open(filename, "rb")
    # load all the objects
    objects = []
    try:
        while True:
            obj = cPickle.load( pick )
            objects.append( obj )
    except EOFError:
        objList = objects.pop()
    pick.close()
    assert len(objects) == len(objList), (objects, objList)
    for name, obj in zip( objList, objects ):
        context[name] = obj
    return 0


def _filteringContext(context):
    """Return a context by filtering the input objects by excluding:
    - modules,
    - code_aster objects,
    - ..."""
    ctxt = {}
    for name, obj in context.items():
        if ( name in ('code_aster', ) or name.startswith('__') or
             type(obj) in (types.ModuleType, types.ClassType, types.FunctionType) or
             issubclass(type(obj), types.TypeType) ):
            continue
        ctxt[name] = obj
    return ctxt
