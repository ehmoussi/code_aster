#coding: utf-8

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


cdef class GeneralMaterialBehaviour:

    """Python wrapper on the C++ GeneralMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = new GeneralMaterialBehaviourPtr( \
                                new GeneralMaterialBehaviourInstance() )

    def __dealloc__( self ):
        """Destructor"""
        # subclassing, see https://github.com/cython/cython/wiki/WrappingSetOfCppClasses
        cdef GeneralMaterialBehaviourPtr* tmp
        if self._cptr is not NULL:
            tmp = <GeneralMaterialBehaviourPtr *>self._cptr
            del tmp
            self._cptr = NULL

    cdef set( self, GeneralMaterialBehaviourPtr other ):
        """Point to an existing object"""
        # set must be subclassed if it is necessary
        self._cptr = new GeneralMaterialBehaviourPtr( other )

    cdef GeneralMaterialBehaviourPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef GeneralMaterialBehaviourInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def getAsterName( self ):
        """Get the aster name of the material behaviour"""
        return self.getInstance().getAsterName()

    def setDoubleValue( self, property, value ):
        """Define the value of a material property"""
        return self.getInstance().setDoubleValue( property, value )

cdef class ElasMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasMaterialBehaviourPtr( new ElasMaterialBehaviourInstance() )

cdef class ElasFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasFoMaterialBehaviourPtr( new ElasFoMaterialBehaviourInstance() )

cdef class ElasFluiMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasFluiMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasFluiMaterialBehaviourPtr( new ElasFluiMaterialBehaviourInstance() )

cdef class ElasIstrMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasIstrMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasIstrMaterialBehaviourPtr( new ElasIstrMaterialBehaviourInstance() )

cdef class ElasIstrFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasIstrFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasIstrFoMaterialBehaviourPtr( new ElasIstrFoMaterialBehaviourInstance() )

cdef class ElasOrthMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasOrthMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasOrthMaterialBehaviourPtr( new ElasOrthMaterialBehaviourInstance() )

cdef class ElasOrthFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasOrthFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasOrthFoMaterialBehaviourPtr( new ElasOrthFoMaterialBehaviourInstance() )

cdef class ElasHyperMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasHyperMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasHyperMaterialBehaviourPtr( new ElasHyperMaterialBehaviourInstance() )

cdef class ElasCoqueMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasCoqueMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasCoqueMaterialBehaviourPtr( new ElasCoqueMaterialBehaviourInstance() )

cdef class ElasCoqueFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasCoqueFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasCoqueFoMaterialBehaviourPtr( new ElasCoqueFoMaterialBehaviourInstance() )

cdef class ElasMembraneMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasMembraneMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasMembraneMaterialBehaviourPtr( new ElasMembraneMaterialBehaviourInstance() )

cdef class Elas2ndgMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas2ndgMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas2ndgMaterialBehaviourPtr( new Elas2ndgMaterialBehaviourInstance() )

cdef class ElasGlrcMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasGlrcMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasGlrcMaterialBehaviourPtr( new ElasGlrcMaterialBehaviourInstance() )

cdef class ElasGlrcFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasGlrcFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasGlrcFoMaterialBehaviourPtr( new ElasGlrcFoMaterialBehaviourInstance() )

cdef class ElasDhrcMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasDhrcMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasDhrcMaterialBehaviourPtr( new ElasDhrcMaterialBehaviourInstance() )

cdef class CableMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ CableMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new CableMaterialBehaviourPtr( new CableMaterialBehaviourInstance() )

cdef class VeriBorneMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ VeriBorneMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new VeriBorneMaterialBehaviourPtr( new VeriBorneMaterialBehaviourInstance() )

cdef class TractionMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ TractionMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new TractionMaterialBehaviourPtr( new TractionMaterialBehaviourInstance() )

cdef class EcroLineMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EcroLineMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EcroLineMaterialBehaviourPtr( new EcroLineMaterialBehaviourInstance() )

cdef class EndoHeterogeneMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EndoHeterogeneMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EndoHeterogeneMaterialBehaviourPtr( new EndoHeterogeneMaterialBehaviourInstance() )

cdef class EcroLineFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EcroLineFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EcroLineFoMaterialBehaviourPtr( new EcroLineFoMaterialBehaviourInstance() )

cdef class EcroPuisMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EcroPuisMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EcroPuisMaterialBehaviourPtr( new EcroPuisMaterialBehaviourInstance() )

cdef class EcroPuisFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EcroPuisFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EcroPuisFoMaterialBehaviourPtr( new EcroPuisFoMaterialBehaviourInstance() )

cdef class EcroCookMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EcroCookMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EcroCookMaterialBehaviourPtr( new EcroCookMaterialBehaviourInstance() )

cdef class EcroCookFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EcroCookFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EcroCookFoMaterialBehaviourPtr( new EcroCookFoMaterialBehaviourInstance() )

cdef class BetonEcroLineMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ BetonEcroLineMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new BetonEcroLineMaterialBehaviourPtr( new BetonEcroLineMaterialBehaviourInstance() )

cdef class BetonReglePrMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ BetonReglePrMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new BetonReglePrMaterialBehaviourPtr( new BetonReglePrMaterialBehaviourInstance() )

cdef class EndoOrthBetonMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EndoOrthBetonMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EndoOrthBetonMaterialBehaviourPtr( new EndoOrthBetonMaterialBehaviourInstance() )

cdef class PragerMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ PragerMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new PragerMaterialBehaviourPtr( new PragerMaterialBehaviourInstance() )

cdef class PragerFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ PragerFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new PragerFoMaterialBehaviourPtr( new PragerFoMaterialBehaviourInstance() )

cdef class TaheriMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ TaheriMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new TaheriMaterialBehaviourPtr( new TaheriMaterialBehaviourInstance() )

cdef class TaheriFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ TaheriFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new TaheriFoMaterialBehaviourPtr( new TaheriFoMaterialBehaviourInstance() )

cdef class RousselierMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ RousselierMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new RousselierMaterialBehaviourPtr( new RousselierMaterialBehaviourInstance() )

cdef class RousselierFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ RousselierFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new RousselierFoMaterialBehaviourPtr( new RousselierFoMaterialBehaviourInstance() )

cdef class ViscSinhMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ViscSinhMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ViscSinhMaterialBehaviourPtr( new ViscSinhMaterialBehaviourInstance() )

cdef class ViscSinhFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ViscSinhFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ViscSinhFoMaterialBehaviourPtr( new ViscSinhFoMaterialBehaviourInstance() )

cdef class Cin1ChabMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Cin1ChabMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Cin1ChabMaterialBehaviourPtr( new Cin1ChabMaterialBehaviourInstance() )

cdef class Cin1ChabFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Cin1ChabFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Cin1ChabFoMaterialBehaviourPtr( new Cin1ChabFoMaterialBehaviourInstance() )

cdef class Cin2ChabMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Cin2ChabMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Cin2ChabMaterialBehaviourPtr( new Cin2ChabMaterialBehaviourInstance() )

cdef class Cin2ChabFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Cin2ChabFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Cin2ChabFoMaterialBehaviourPtr( new Cin2ChabFoMaterialBehaviourInstance() )

cdef class Cin2NradMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Cin2NradMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Cin2NradMaterialBehaviourPtr( new Cin2NradMaterialBehaviourInstance() )

cdef class MemoEcroMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MemoEcroMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MemoEcroMaterialBehaviourPtr( new MemoEcroMaterialBehaviourInstance() )

cdef class MemoEcroFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MemoEcroFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MemoEcroFoMaterialBehaviourPtr( new MemoEcroFoMaterialBehaviourInstance() )

cdef class ViscochabMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ViscochabMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ViscochabMaterialBehaviourPtr( new ViscochabMaterialBehaviourInstance() )

cdef class ViscochabFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ViscochabFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ViscochabFoMaterialBehaviourPtr( new ViscochabFoMaterialBehaviourInstance() )

cdef class LemaitreMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ LemaitreMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new LemaitreMaterialBehaviourPtr( new LemaitreMaterialBehaviourInstance() )

cdef class LemaitreIrraMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ LemaitreIrraMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new LemaitreIrraMaterialBehaviourPtr( new LemaitreIrraMaterialBehaviourInstance() )

cdef class LmarcIrraMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ LmarcIrraMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new LmarcIrraMaterialBehaviourPtr( new LmarcIrraMaterialBehaviourInstance() )

cdef class ViscIrraLogMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ViscIrraLogMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ViscIrraLogMaterialBehaviourPtr( new ViscIrraLogMaterialBehaviourInstance() )

cdef class GranIrraLogMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ GranIrraLogMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new GranIrraLogMaterialBehaviourPtr( new GranIrraLogMaterialBehaviourInstance() )

cdef class LemaSeuilMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ LemaSeuilMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new LemaSeuilMaterialBehaviourPtr( new LemaSeuilMaterialBehaviourInstance() )

cdef class LemaSeuilFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ LemaSeuilFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new LemaSeuilFoMaterialBehaviourPtr( new LemaSeuilFoMaterialBehaviourInstance() )

cdef class Irrad3mMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Irrad3mMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Irrad3mMaterialBehaviourPtr( new Irrad3mMaterialBehaviourInstance() )

cdef class LemaitreFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ LemaitreFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new LemaitreFoMaterialBehaviourPtr( new LemaitreFoMaterialBehaviourInstance() )

cdef class MetaLemaAniMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MetaLemaAniMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MetaLemaAniMaterialBehaviourPtr( new MetaLemaAniMaterialBehaviourInstance() )

cdef class MetaLemaAniFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MetaLemaAniFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MetaLemaAniFoMaterialBehaviourPtr( new MetaLemaAniFoMaterialBehaviourInstance() )

cdef class ArmeMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ArmeMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ArmeMaterialBehaviourPtr( new ArmeMaterialBehaviourInstance() )

cdef class AsseCornMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ AsseCornMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new AsseCornMaterialBehaviourPtr( new AsseCornMaterialBehaviourInstance() )

cdef class DisContactMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ DisContactMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new DisContactMaterialBehaviourPtr( new DisContactMaterialBehaviourInstance() )

cdef class EndoScalaireMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EndoScalaireMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EndoScalaireMaterialBehaviourPtr( new EndoScalaireMaterialBehaviourInstance() )

cdef class EndoScalaireFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EndoScalaireFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EndoScalaireFoMaterialBehaviourPtr( new EndoScalaireFoMaterialBehaviourInstance() )

cdef class EndoFissExpMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EndoFissExpMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EndoFissExpMaterialBehaviourPtr( new EndoFissExpMaterialBehaviourInstance() )

cdef class EndoFissExpFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EndoFissExpFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EndoFissExpFoMaterialBehaviourPtr( new EndoFissExpFoMaterialBehaviourInstance() )

cdef class DisGricraMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ DisGricraMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new DisGricraMaterialBehaviourPtr( new DisGricraMaterialBehaviourInstance() )

cdef class BetonDoubleDpMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ BetonDoubleDpMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new BetonDoubleDpMaterialBehaviourPtr( new BetonDoubleDpMaterialBehaviourInstance() )

cdef class MazarsMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MazarsMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MazarsMaterialBehaviourPtr( new MazarsMaterialBehaviourInstance() )

cdef class MazarsFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MazarsFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MazarsFoMaterialBehaviourPtr( new MazarsFoMaterialBehaviourInstance() )

cdef class JointBaMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ JointBaMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new JointBaMaterialBehaviourPtr( new JointBaMaterialBehaviourInstance() )

cdef class VendochabMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ VendochabMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new VendochabMaterialBehaviourPtr( new VendochabMaterialBehaviourInstance() )

cdef class VendochabFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ VendochabFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new VendochabFoMaterialBehaviourPtr( new VendochabFoMaterialBehaviourInstance() )

cdef class HayhurstMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ HayhurstMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new HayhurstMaterialBehaviourPtr( new HayhurstMaterialBehaviourInstance() )

cdef class ViscEndoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ViscEndoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ViscEndoMaterialBehaviourPtr( new ViscEndoMaterialBehaviourInstance() )

cdef class ViscEndoFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ViscEndoFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ViscEndoFoMaterialBehaviourPtr( new ViscEndoFoMaterialBehaviourInstance() )

cdef class PintoMenegottoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ PintoMenegottoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new PintoMenegottoMaterialBehaviourPtr( new PintoMenegottoMaterialBehaviourInstance() )

cdef class BpelBetonMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ BpelBetonMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new BpelBetonMaterialBehaviourPtr( new BpelBetonMaterialBehaviourInstance() )

cdef class BpelAcierMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ BpelAcierMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new BpelAcierMaterialBehaviourPtr( new BpelAcierMaterialBehaviourInstance() )

cdef class EtccBetonMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EtccBetonMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EtccBetonMaterialBehaviourPtr( new EtccBetonMaterialBehaviourInstance() )

cdef class EtccAcierMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EtccAcierMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EtccAcierMaterialBehaviourPtr( new EtccAcierMaterialBehaviourInstance() )

cdef class MohrCoulombMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MohrCoulombMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MohrCoulombMaterialBehaviourPtr( new MohrCoulombMaterialBehaviourInstance() )

cdef class CamClayMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ CamClayMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new CamClayMaterialBehaviourPtr( new CamClayMaterialBehaviourInstance() )

cdef class BarceloneMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ BarceloneMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new BarceloneMaterialBehaviourPtr( new BarceloneMaterialBehaviourInstance() )

cdef class CjsMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ CjsMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new CjsMaterialBehaviourPtr( new CjsMaterialBehaviourInstance() )

cdef class HujeuxMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ HujeuxMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new HujeuxMaterialBehaviourPtr( new HujeuxMaterialBehaviourInstance() )

cdef class EcroAsymLineMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ EcroAsymLineMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new EcroAsymLineMaterialBehaviourPtr( new EcroAsymLineMaterialBehaviourInstance() )

cdef class GrangerFpMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ GrangerFpMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new GrangerFpMaterialBehaviourPtr( new GrangerFpMaterialBehaviourInstance() )

cdef class GrangerFp_indtMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ GrangerFp_indtMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new GrangerFp_indtMaterialBehaviourPtr( new GrangerFp_indtMaterialBehaviourInstance() )

cdef class VGrangerFpMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ VGrangerFpMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new VGrangerFpMaterialBehaviourPtr( new VGrangerFpMaterialBehaviourInstance() )

cdef class BetonBurgerFpMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ BetonBurgerFpMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new BetonBurgerFpMaterialBehaviourPtr( new BetonBurgerFpMaterialBehaviourInstance() )

cdef class BetonUmlvFpMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ BetonUmlvFpMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new BetonUmlvFpMaterialBehaviourPtr( new BetonUmlvFpMaterialBehaviourInstance() )

cdef class BetonRagMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ BetonRagMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new BetonRagMaterialBehaviourPtr( new BetonRagMaterialBehaviourInstance() )

cdef class PoroBetonMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ PoroBetonMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new PoroBetonMaterialBehaviourPtr( new PoroBetonMaterialBehaviourInstance() )

cdef class GlrcDmMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ GlrcDmMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new GlrcDmMaterialBehaviourPtr( new GlrcDmMaterialBehaviourInstance() )

cdef class DhrcMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ DhrcMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new DhrcMaterialBehaviourPtr( new DhrcMaterialBehaviourInstance() )

cdef class GattMonerieMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ GattMonerieMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new GattMonerieMaterialBehaviourPtr( new GattMonerieMaterialBehaviourInstance() )

cdef class CorrAcierMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ CorrAcierMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new CorrAcierMaterialBehaviourPtr( new CorrAcierMaterialBehaviourInstance() )

cdef class CableGaineFrotMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ CableGaineFrotMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new CableGaineFrotMaterialBehaviourPtr( new CableGaineFrotMaterialBehaviourInstance() )

cdef class DisEcroCineMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ DisEcroCineMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new DisEcroCineMaterialBehaviourPtr( new DisEcroCineMaterialBehaviourInstance() )

cdef class DisViscMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ DisViscMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new DisViscMaterialBehaviourPtr( new DisViscMaterialBehaviourInstance() )

cdef class DisBiliElasMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ DisBiliElasMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new DisBiliElasMaterialBehaviourPtr( new DisBiliElasMaterialBehaviourInstance() )

cdef class TherNlMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ TherNlMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new TherNlMaterialBehaviourPtr( new TherNlMaterialBehaviourInstance() )

cdef class TherHydrMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ TherHydrMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new TherHydrMaterialBehaviourPtr( new TherHydrMaterialBehaviourInstance() )

cdef class TherMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ TherMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new TherMaterialBehaviourPtr( new TherMaterialBehaviourInstance() )

cdef class TherFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ TherFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new TherFoMaterialBehaviourPtr( new TherFoMaterialBehaviourInstance() )

cdef class TherOrthMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ TherOrthMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new TherOrthMaterialBehaviourPtr( new TherOrthMaterialBehaviourInstance() )

cdef class TherCoqueMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ TherCoqueMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new TherCoqueMaterialBehaviourPtr( new TherCoqueMaterialBehaviourInstance() )

cdef class TherCoqueFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ TherCoqueFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new TherCoqueFoMaterialBehaviourPtr( new TherCoqueFoMaterialBehaviourInstance() )

cdef class SechGrangerMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ SechGrangerMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new SechGrangerMaterialBehaviourPtr( new SechGrangerMaterialBehaviourInstance() )

cdef class SechMensiMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ SechMensiMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new SechMensiMaterialBehaviourPtr( new SechMensiMaterialBehaviourInstance() )

cdef class SechBazantMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ SechBazantMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new SechBazantMaterialBehaviourPtr( new SechBazantMaterialBehaviourInstance() )

cdef class SechNappeMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ SechNappeMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new SechNappeMaterialBehaviourPtr( new SechNappeMaterialBehaviourInstance() )

cdef class MetaAcierMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MetaAcierMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MetaAcierMaterialBehaviourPtr( new MetaAcierMaterialBehaviourInstance() )

cdef class MetaZircMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MetaZircMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MetaZircMaterialBehaviourPtr( new MetaZircMaterialBehaviourInstance() )

cdef class DurtMetaMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ DurtMetaMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new DurtMetaMaterialBehaviourPtr( new DurtMetaMaterialBehaviourInstance() )

cdef class ElasMetaMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasMetaMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasMetaMaterialBehaviourPtr( new ElasMetaMaterialBehaviourInstance() )

cdef class ElasMetaFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasMetaFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasMetaFoMaterialBehaviourPtr( new ElasMetaFoMaterialBehaviourInstance() )

cdef class MetaEcroLineMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MetaEcroLineMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MetaEcroLineMaterialBehaviourPtr( new MetaEcroLineMaterialBehaviourInstance() )

cdef class MetaTractionMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MetaTractionMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MetaTractionMaterialBehaviourPtr( new MetaTractionMaterialBehaviourInstance() )

cdef class MetaViscFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MetaViscFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MetaViscFoMaterialBehaviourPtr( new MetaViscFoMaterialBehaviourInstance() )

cdef class MetaPtMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MetaPtMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MetaPtMaterialBehaviourPtr( new MetaPtMaterialBehaviourInstance() )

cdef class MetaReMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MetaReMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MetaReMaterialBehaviourPtr( new MetaReMaterialBehaviourInstance() )

cdef class FluideMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ FluideMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new FluideMaterialBehaviourPtr( new FluideMaterialBehaviourInstance() )

cdef class ThmGazMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ThmGazMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ThmGazMaterialBehaviourPtr( new ThmGazMaterialBehaviourInstance() )

cdef class ThmVapeGazMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ThmVapeGazMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ThmVapeGazMaterialBehaviourPtr( new ThmVapeGazMaterialBehaviourInstance() )

cdef class ThmLiquMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ThmLiquMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ThmLiquMaterialBehaviourPtr( new ThmLiquMaterialBehaviourInstance() )

cdef class FatigueMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ FatigueMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new FatigueMaterialBehaviourPtr( new FatigueMaterialBehaviourInstance() )

cdef class DommaLemaitreMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ DommaLemaitreMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new DommaLemaitreMaterialBehaviourPtr( new DommaLemaitreMaterialBehaviourInstance() )

cdef class CisaPlanCritMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ CisaPlanCritMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new CisaPlanCritMaterialBehaviourPtr( new CisaPlanCritMaterialBehaviourInstance() )

cdef class ThmRuptMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ThmRuptMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ThmRuptMaterialBehaviourPtr( new ThmRuptMaterialBehaviourInstance() )

cdef class WeibullMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ WeibullMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new WeibullMaterialBehaviourPtr( new WeibullMaterialBehaviourInstance() )

cdef class WeibullFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ WeibullFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new WeibullFoMaterialBehaviourPtr( new WeibullFoMaterialBehaviourInstance() )

cdef class NonLocalMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ NonLocalMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new NonLocalMaterialBehaviourPtr( new NonLocalMaterialBehaviourInstance() )

cdef class RuptFragMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ RuptFragMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new RuptFragMaterialBehaviourPtr( new RuptFragMaterialBehaviourInstance() )

cdef class RuptFragFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ RuptFragFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new RuptFragFoMaterialBehaviourPtr( new RuptFragFoMaterialBehaviourInstance() )

cdef class CzmLabMixMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ CzmLabMixMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new CzmLabMixMaterialBehaviourPtr( new CzmLabMixMaterialBehaviourInstance() )

cdef class RuptDuctMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ RuptDuctMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new RuptDuctMaterialBehaviourPtr( new RuptDuctMaterialBehaviourInstance() )

cdef class JointMecaRuptMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ JointMecaRuptMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new JointMecaRuptMaterialBehaviourPtr( new JointMecaRuptMaterialBehaviourInstance() )

cdef class JointMecaFrotMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ JointMecaFrotMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new JointMecaFrotMaterialBehaviourPtr( new JointMecaFrotMaterialBehaviourInstance() )

cdef class RccmMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ RccmMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new RccmMaterialBehaviourPtr( new RccmMaterialBehaviourInstance() )

cdef class RccmFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ RccmFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new RccmFoMaterialBehaviourPtr( new RccmFoMaterialBehaviourInstance() )

cdef class LaigleMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ LaigleMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new LaigleMaterialBehaviourPtr( new LaigleMaterialBehaviourInstance() )

cdef class LetkMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ LetkMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new LetkMaterialBehaviourPtr( new LetkMaterialBehaviourInstance() )

cdef class DruckPragerMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ DruckPragerMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new DruckPragerMaterialBehaviourPtr( new DruckPragerMaterialBehaviourInstance() )

cdef class DruckPragerFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ DruckPragerFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new DruckPragerFoMaterialBehaviourPtr( new DruckPragerFoMaterialBehaviourInstance() )

cdef class ViscDrucPragMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ViscDrucPragMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ViscDrucPragMaterialBehaviourPtr( new ViscDrucPragMaterialBehaviourInstance() )

cdef class HoekBrownMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ HoekBrownMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new HoekBrownMaterialBehaviourPtr( new HoekBrownMaterialBehaviourInstance() )

cdef class ElasGonfMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ ElasGonfMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new ElasGonfMaterialBehaviourPtr( new ElasGonfMaterialBehaviourInstance() )

cdef class JointBandisMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ JointBandisMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new JointBandisMaterialBehaviourPtr( new JointBandisMaterialBehaviourInstance() )

cdef class MonoVisc1MaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MonoVisc1MaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MonoVisc1MaterialBehaviourPtr( new MonoVisc1MaterialBehaviourInstance() )

cdef class MonoVisc2MaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MonoVisc2MaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MonoVisc2MaterialBehaviourPtr( new MonoVisc2MaterialBehaviourInstance() )

cdef class MonoIsot1MaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MonoIsot1MaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MonoIsot1MaterialBehaviourPtr( new MonoIsot1MaterialBehaviourInstance() )

cdef class MonoIsot2MaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MonoIsot2MaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MonoIsot2MaterialBehaviourPtr( new MonoIsot2MaterialBehaviourInstance() )

cdef class MonoCine1MaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MonoCine1MaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MonoCine1MaterialBehaviourPtr( new MonoCine1MaterialBehaviourInstance() )

cdef class MonoCine2MaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MonoCine2MaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MonoCine2MaterialBehaviourPtr( new MonoCine2MaterialBehaviourInstance() )

cdef class MonoDdKrMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MonoDdKrMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MonoDdKrMaterialBehaviourPtr( new MonoDdKrMaterialBehaviourInstance() )

cdef class MonoDdCfcMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MonoDdCfcMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MonoDdCfcMaterialBehaviourPtr( new MonoDdCfcMaterialBehaviourInstance() )

cdef class MonoDdCfcIrraMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MonoDdCfcIrraMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MonoDdCfcIrraMaterialBehaviourPtr( new MonoDdCfcIrraMaterialBehaviourInstance() )

cdef class MonoDdFatMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MonoDdFatMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MonoDdFatMaterialBehaviourPtr( new MonoDdFatMaterialBehaviourInstance() )

cdef class MonoDdCcMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MonoDdCcMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MonoDdCcMaterialBehaviourPtr( new MonoDdCcMaterialBehaviourInstance() )

cdef class MonoDdCcIrraMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ MonoDdCcIrraMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new MonoDdCcIrraMaterialBehaviourPtr( new MonoDdCcIrraMaterialBehaviourInstance() )

cdef class UmatMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ UmatMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new UmatMaterialBehaviourPtr( new UmatMaterialBehaviourInstance() )

cdef class UmatFoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ UmatFoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new UmatFoMaterialBehaviourPtr( new UmatFoMaterialBehaviourInstance() )

cdef class CritRuptMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ CritRuptMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new CritRuptMaterialBehaviourPtr( new CritRuptMaterialBehaviourInstance() )
