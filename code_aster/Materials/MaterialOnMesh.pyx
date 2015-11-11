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

from libcpp.string cimport string
from cython.operator cimport dereference as deref

from code_aster.Mesh.Mesh cimport Mesh
from code_aster.Materials.Material cimport Material
from code_aster.Supervis.libCommandSyntax cimport CommandSyntax, resultNaming

from code_aster.Supervis.logger import logger
from code_aster.Supervis.libCommandSyntax import _F


cdef class MaterialOnMesh:

    """Python wrapper on the C++ MaterialOnMesh object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new MaterialOnMeshPtr( new MaterialOnMeshInstance() )

    def __dealloc__( self ):
        """Destructor"""
        if self._cptr is not NULL:
            del self._cptr

    cdef set( self, MaterialOnMeshPtr other ):
        """Point to an existing object"""
        self._cptr = new MaterialOnMeshPtr( other )

    cdef MaterialOnMeshPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef MaterialOnMeshInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def addMaterialOnAllMesh( self, Material mater ):
        """Add the same material on all the mesh"""
        self.getInstance().addMaterialOnAllMesh( deref( mater.getPtr() ) )

    def addMaterialOnGroupOfElements( self, Material mater, string nameOfGroup ):
        """Add a material of a mesh entity"""
        # TODO: use 'Entity or MeshEntity' instead of 'GroupOfElements' ?
        self.getInstance().addMaterialOnGroupOfElements( deref( mater.getPtr() ), nameOfGroup)

    def setSupportMesh( self, Mesh mesh ):
        """Set the support mesh"""
        return self.getInstance().setSupportMesh( deref( mesh.getPtr() ) )

    def getSupportMesh( self ):
        """Return the support mesh"""
        mesh = Mesh()
        mesh.set( self.getInstance().getSupportMesh() )
        return mesh

    def build( self ):
        """Build the object"""
        instance = self.getInstance()
        syntax = CommandSyntax( "AFFE_MATERIAU" )
        syntax.setResult( resultNaming.getResultObjectName(), instance.getType() )
        dictSyntax = instance.getCommandKeywords()
        # add default values
        dictSyntax["LIST_NOM_VARC"] = ( "TEMP", "GEOM", "CORR", "IRRA", "HYDR",
                                        "SECH", "EPSA", "M_ACIER", "M_ZIRC", "NEUT1",
                                        "NEUT2", "PTOT", "DIVU" )
        dictSyntax.update( _hiddenKeywords() )

        logger.debug( "AFFE_MATERIAU: %r", dictSyntax )
        syntax.define( dictSyntax )
        iret = instance.build()
        syntax.free()
        return iret

    def debugPrint( self, logicalUnit=6 ):
        """Print debug information of the content"""
        self.getInstance().debugPrint( logicalUnit )


def _hiddenKeywords():
    """Return the list of hidden keywords for AFFE_MATERIAU"""
    return _F(
        #  mots clés cachés pour les variables de commande NEUT1/NEUT2 :
        #  --------------------------------------------------------------
        VARC_NEUT1 = _F(
          NOM_VARC        = "NEUT1",
          GRANDEUR        = "NEUT_R",
          CMP_GD          = ("X1"),
          CMP_VARC        = ("NEUT1"),
        ),
        VARC_NEUT2 = _F(
          NOM_VARC        = "NEUT2",
          GRANDEUR        = "NEUT_R",
          CMP_GD          = ("X1"),
          CMP_VARC        = ("NEUT2"),
        ),
        #  mots clés cachés pour variable de commande TEMP :
        #  --------------------------------------------------
        VARC_TEMP = _F(
          NOM_VARC        = "TEMP",
          GRANDEUR        = "TEMP_R",
          CMP_GD          = ("TEMP","TEMP_MIL","TEMP_INF","TEMP_SUP",),
          CMP_VARC        = ("TEMP","TEMP_MIL","TEMP_INF","TEMP_SUP",),
        ),
        #  mots clés cachés pour variable de commande GEOM :
        #  --------------------------------------------------
        VARC_GEOM = _F(
          NOM_VARC        = "GEOM",
          GRANDEUR        = "GEOM_R",
          CMP_GD          = ("X","Y","Z",),
          CMP_VARC        = ("X","Y","Z",),
        ),
        #  mots clés cachés pour variable de commande PTOT :
        #  -------------------------------------------------
        VARC_PTOT = _F(
          NOM_VARC         = "PTOT",
          GRANDEUR         = "DEPL_R",
          CMP_GD           = ("PTOT",),
          CMP_VARC         = ("PTOT",),
        ),
        #  mots clés cachés pour variable de commande SECH :
        #  --------------------------------------------------
        VARC_SECH = _F(
          NOM_VARC        = "SECH",
          GRANDEUR        = "TEMP_R",
          CMP_GD          = ("TEMP",),
          CMP_VARC        = ("SECH",),
        ),
        #  mots clés cachés pour variable de commande HYDR :
        #  --------------------------------------------------
        VARC_HYDR = _F(
          NOM_VARC        = "HYDR",
          GRANDEUR        = "HYDR_R",
          CMP_GD          = ("HYDR",),
          CMP_VARC        = ("HYDR",),
        ),
        #  mots clés cachés pour variable de commande CORR :
        #  --------------------------------------------------
        VARC_CORR = _F(
          NOM_VARC        = "CORR",
          GRANDEUR        = "CORR_R",
          CMP_GD          = ("CORR",),
          CMP_VARC        = ("CORR",),
        ),
        #  mots clés cachés pour variable de commande IRRA :
        #  --------------------------------------------------
        VARC_IRRA = _F(
          NOM_VARC        = "IRRA",
          GRANDEUR        = "IRRA_R",
          CMP_GD          = ("IRRA",),
          CMP_VARC        = ("IRRA",),
        ),
        #  mots clés cachés pour variable de commande DIVU :
        #  --------------------------------------------------
        VARC_DIVU = _F(
          NOM_VARC        = "DIVU",
          GRANDEUR        = "EPSI_R",
          CMP_GD          = ("DIVU",),
          CMP_VARC        = ("DIVU",),
        ),
        #  mots clés cachés pour variable de commande EPSA :
        #  --------------------------------------------------
        VARC_EPSA = _F(
          NOM_VARC        = "EPSA",
          GRANDEUR        = "EPSI_R",
          CMP_GD          = ("EPXX","EPYY","EPZZ","EPXY","EPXZ","EPYZ",),
          CMP_VARC        = ("EPSAXX","EPSAYY","EPSAZZ","EPSAXY","EPSAXZ","EPSAYZ",),
        ),
        #  mots clés cachés pour variable de commande metallurgique ACIER :
        #  -----------------------------------------------------------------
        VARC_M_ACIER = _F(
          NOM_VARC        = "M_ACIER",
          GRANDEUR        = "VARI_R",
          CMP_GD          = ("V1","V2","V3","V4","V5","V6","V7"),
          CMP_VARC        = ("PFERRITE","PPERLITE","PBAINITE", "PMARTENS","TAUSTE","TRANSF","TACIER",),
        ),
        #  mots clés cachés pour variable de commande metallurgique ZIRCALOY :
        #  --------------------------------------------------------------------
        VARC_M_ZIRC = _F(
          NOM_VARC        = "M_ZIRC",
          GRANDEUR        = "VARI_R",
          CMP_GD          = ("V1","V2","V3","V4"),
          CMP_VARC        = ("ALPHPUR","ALPHBETA","TZIRC","TEMPS"),
        ),
    )
