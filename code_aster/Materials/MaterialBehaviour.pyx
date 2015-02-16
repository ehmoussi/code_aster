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
                
cdef class Elas_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_foMaterialBehaviourPtr( new Elas_foMaterialBehaviourInstance() )
                
cdef class Elas_fluiMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_fluiMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_fluiMaterialBehaviourPtr( new Elas_fluiMaterialBehaviourInstance() )
                
cdef class Elas_istrMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_istrMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_istrMaterialBehaviourPtr( new Elas_istrMaterialBehaviourInstance() )
                
cdef class Elas_istr_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_istr_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_istr_foMaterialBehaviourPtr( new Elas_istr_foMaterialBehaviourInstance() )
                
cdef class Elas_orthMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_orthMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_orthMaterialBehaviourPtr( new Elas_orthMaterialBehaviourInstance() )
                
cdef class Elas_orth_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_orth_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_orth_foMaterialBehaviourPtr( new Elas_orth_foMaterialBehaviourInstance() )
                
cdef class Elas_hyperMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_hyperMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_hyperMaterialBehaviourPtr( new Elas_hyperMaterialBehaviourInstance() )
                
cdef class Elas_coqueMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_coqueMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_coqueMaterialBehaviourPtr( new Elas_coqueMaterialBehaviourInstance() )
                
cdef class Elas_coque_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_coque_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_coque_foMaterialBehaviourPtr( new Elas_coque_foMaterialBehaviourInstance() )
                
cdef class Elas_membraneMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_membraneMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_membraneMaterialBehaviourPtr( new Elas_membraneMaterialBehaviourInstance() )
                
cdef class Elas_2ndgMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_2ndgMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_2ndgMaterialBehaviourPtr( new Elas_2ndgMaterialBehaviourInstance() )
                
cdef class Elas_glrcMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_glrcMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_glrcMaterialBehaviourPtr( new Elas_glrcMaterialBehaviourInstance() )
                
cdef class Elas_glrc_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_glrc_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_glrc_foMaterialBehaviourPtr( new Elas_glrc_foMaterialBehaviourInstance() )
                
cdef class Elas_dhrcMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_dhrcMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_dhrcMaterialBehaviourPtr( new Elas_dhrcMaterialBehaviourInstance() )
                
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
                
cdef class Veri_borneMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Veri_borneMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Veri_borneMaterialBehaviourPtr( new Veri_borneMaterialBehaviourInstance() )
                
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
                
cdef class Ecro_lineMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Ecro_lineMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Ecro_lineMaterialBehaviourPtr( new Ecro_lineMaterialBehaviourInstance() )
                
cdef class Endo_heterogeneMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Endo_heterogeneMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Endo_heterogeneMaterialBehaviourPtr( new Endo_heterogeneMaterialBehaviourInstance() )
                
cdef class Ecro_line_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Ecro_line_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Ecro_line_foMaterialBehaviourPtr( new Ecro_line_foMaterialBehaviourInstance() )
                
cdef class Ecro_puisMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Ecro_puisMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Ecro_puisMaterialBehaviourPtr( new Ecro_puisMaterialBehaviourInstance() )
                
cdef class Ecro_puis_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Ecro_puis_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Ecro_puis_foMaterialBehaviourPtr( new Ecro_puis_foMaterialBehaviourInstance() )
                
cdef class Ecro_cookMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Ecro_cookMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Ecro_cookMaterialBehaviourPtr( new Ecro_cookMaterialBehaviourInstance() )
                
cdef class Ecro_cook_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Ecro_cook_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Ecro_cook_foMaterialBehaviourPtr( new Ecro_cook_foMaterialBehaviourInstance() )
                
cdef class Beton_ecro_lineMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Beton_ecro_lineMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Beton_ecro_lineMaterialBehaviourPtr( new Beton_ecro_lineMaterialBehaviourInstance() )
                
cdef class Beton_regle_prMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Beton_regle_prMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Beton_regle_prMaterialBehaviourPtr( new Beton_regle_prMaterialBehaviourInstance() )
                
cdef class Endo_orth_betonMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Endo_orth_betonMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Endo_orth_betonMaterialBehaviourPtr( new Endo_orth_betonMaterialBehaviourInstance() )
                
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
                
cdef class Prager_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Prager_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Prager_foMaterialBehaviourPtr( new Prager_foMaterialBehaviourInstance() )
                
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
                
cdef class Taheri_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Taheri_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Taheri_foMaterialBehaviourPtr( new Taheri_foMaterialBehaviourInstance() )
                
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
                
cdef class Rousselier_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Rousselier_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Rousselier_foMaterialBehaviourPtr( new Rousselier_foMaterialBehaviourInstance() )
                
cdef class Visc_sinhMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Visc_sinhMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Visc_sinhMaterialBehaviourPtr( new Visc_sinhMaterialBehaviourInstance() )
                
cdef class Visc_sinh_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Visc_sinh_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Visc_sinh_foMaterialBehaviourPtr( new Visc_sinh_foMaterialBehaviourInstance() )
                
cdef class Cin1_chabMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Cin1_chabMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Cin1_chabMaterialBehaviourPtr( new Cin1_chabMaterialBehaviourInstance() )
                
cdef class Cin1_chab_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Cin1_chab_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Cin1_chab_foMaterialBehaviourPtr( new Cin1_chab_foMaterialBehaviourInstance() )
                
cdef class Cin2_chabMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Cin2_chabMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Cin2_chabMaterialBehaviourPtr( new Cin2_chabMaterialBehaviourInstance() )
                
cdef class Cin2_chab_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Cin2_chab_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Cin2_chab_foMaterialBehaviourPtr( new Cin2_chab_foMaterialBehaviourInstance() )
                
cdef class Cin2_nradMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Cin2_nradMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Cin2_nradMaterialBehaviourPtr( new Cin2_nradMaterialBehaviourInstance() )
                
cdef class Memo_ecroMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Memo_ecroMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Memo_ecroMaterialBehaviourPtr( new Memo_ecroMaterialBehaviourInstance() )
                
cdef class Memo_ecro_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Memo_ecro_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Memo_ecro_foMaterialBehaviourPtr( new Memo_ecro_foMaterialBehaviourInstance() )
                
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
                
cdef class Viscochab_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Viscochab_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Viscochab_foMaterialBehaviourPtr( new Viscochab_foMaterialBehaviourInstance() )
                
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
                
cdef class Lemaitre_irraMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Lemaitre_irraMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Lemaitre_irraMaterialBehaviourPtr( new Lemaitre_irraMaterialBehaviourInstance() )
                
cdef class Lmarc_irraMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Lmarc_irraMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Lmarc_irraMaterialBehaviourPtr( new Lmarc_irraMaterialBehaviourInstance() )
                
cdef class Visc_irra_logMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Visc_irra_logMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Visc_irra_logMaterialBehaviourPtr( new Visc_irra_logMaterialBehaviourInstance() )
                
cdef class Gran_irra_logMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Gran_irra_logMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Gran_irra_logMaterialBehaviourPtr( new Gran_irra_logMaterialBehaviourInstance() )
                
cdef class Lema_seuilMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Lema_seuilMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Lema_seuilMaterialBehaviourPtr( new Lema_seuilMaterialBehaviourInstance() )
                
cdef class Lemaitre_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Lemaitre_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Lemaitre_foMaterialBehaviourPtr( new Lemaitre_foMaterialBehaviourInstance() )
                
cdef class Meta_lema_aniMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Meta_lema_aniMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Meta_lema_aniMaterialBehaviourPtr( new Meta_lema_aniMaterialBehaviourInstance() )
                
cdef class Meta_lema_ani_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Meta_lema_ani_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Meta_lema_ani_foMaterialBehaviourPtr( new Meta_lema_ani_foMaterialBehaviourInstance() )
                
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
                
cdef class Asse_cornMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Asse_cornMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Asse_cornMaterialBehaviourPtr( new Asse_cornMaterialBehaviourInstance() )
                
cdef class Dis_contactMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Dis_contactMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Dis_contactMaterialBehaviourPtr( new Dis_contactMaterialBehaviourInstance() )
                
cdef class Endo_scalaireMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Endo_scalaireMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Endo_scalaireMaterialBehaviourPtr( new Endo_scalaireMaterialBehaviourInstance() )
                
cdef class Endo_scalaire_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Endo_scalaire_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Endo_scalaire_foMaterialBehaviourPtr( new Endo_scalaire_foMaterialBehaviourInstance() )
                
cdef class Endo_fiss_expMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Endo_fiss_expMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Endo_fiss_expMaterialBehaviourPtr( new Endo_fiss_expMaterialBehaviourInstance() )
                
cdef class Endo_fiss_exp_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Endo_fiss_exp_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Endo_fiss_exp_foMaterialBehaviourPtr( new Endo_fiss_exp_foMaterialBehaviourInstance() )
                
cdef class Dis_gricraMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Dis_gricraMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Dis_gricraMaterialBehaviourPtr( new Dis_gricraMaterialBehaviourInstance() )
                
cdef class Beton_double_dpMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Beton_double_dpMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Beton_double_dpMaterialBehaviourPtr( new Beton_double_dpMaterialBehaviourInstance() )
                
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
                
cdef class Vendochab_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Vendochab_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Vendochab_foMaterialBehaviourPtr( new Vendochab_foMaterialBehaviourInstance() )
                
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
                
cdef class Visc_endoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Visc_endoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Visc_endoMaterialBehaviourPtr( new Visc_endoMaterialBehaviourInstance() )
                
cdef class Visc_endo_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Visc_endo_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Visc_endo_foMaterialBehaviourPtr( new Visc_endo_foMaterialBehaviourInstance() )
                
cdef class Pinto_menegottoMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Pinto_menegottoMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Pinto_menegottoMaterialBehaviourPtr( new Pinto_menegottoMaterialBehaviourInstance() )
                
cdef class Bpel_betonMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Bpel_betonMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Bpel_betonMaterialBehaviourPtr( new Bpel_betonMaterialBehaviourInstance() )
                
cdef class Bpel_acierMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Bpel_acierMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Bpel_acierMaterialBehaviourPtr( new Bpel_acierMaterialBehaviourInstance() )
                
cdef class Etcc_betonMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Etcc_betonMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Etcc_betonMaterialBehaviourPtr( new Etcc_betonMaterialBehaviourInstance() )
                
cdef class Etcc_acierMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Etcc_acierMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Etcc_acierMaterialBehaviourPtr( new Etcc_acierMaterialBehaviourInstance() )
                
cdef class Mohr_coulombMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Mohr_coulombMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Mohr_coulombMaterialBehaviourPtr( new Mohr_coulombMaterialBehaviourInstance() )
                
cdef class Cam_clayMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Cam_clayMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Cam_clayMaterialBehaviourPtr( new Cam_clayMaterialBehaviourInstance() )
                
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
                
cdef class Ecro_asym_lineMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Ecro_asym_lineMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Ecro_asym_lineMaterialBehaviourPtr( new Ecro_asym_lineMaterialBehaviourInstance() )
                
cdef class Granger_fpMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Granger_fpMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Granger_fpMaterialBehaviourPtr( new Granger_fpMaterialBehaviourInstance() )
                
cdef class Granger_fp_indtMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Granger_fp_indtMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Granger_fp_indtMaterialBehaviourPtr( new Granger_fp_indtMaterialBehaviourInstance() )
                
cdef class V_granger_fpMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ V_granger_fpMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new V_granger_fpMaterialBehaviourPtr( new V_granger_fpMaterialBehaviourInstance() )
                
cdef class Beton_burger_fpMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Beton_burger_fpMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Beton_burger_fpMaterialBehaviourPtr( new Beton_burger_fpMaterialBehaviourInstance() )
                
cdef class Beton_umlv_fpMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Beton_umlv_fpMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Beton_umlv_fpMaterialBehaviourPtr( new Beton_umlv_fpMaterialBehaviourInstance() )
                
cdef class Beton_ragMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Beton_ragMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Beton_ragMaterialBehaviourPtr( new Beton_ragMaterialBehaviourInstance() )
                
cdef class Poro_betonMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Poro_betonMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Poro_betonMaterialBehaviourPtr( new Poro_betonMaterialBehaviourInstance() )
                
cdef class Glrc_dmMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Glrc_dmMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Glrc_dmMaterialBehaviourPtr( new Glrc_dmMaterialBehaviourInstance() )
                
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
                
cdef class Gatt_monerieMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Gatt_monerieMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Gatt_monerieMaterialBehaviourPtr( new Gatt_monerieMaterialBehaviourInstance() )
                
cdef class Corr_acierMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Corr_acierMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Corr_acierMaterialBehaviourPtr( new Corr_acierMaterialBehaviourInstance() )
                
cdef class Dis_ecro_cineMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Dis_ecro_cineMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Dis_ecro_cineMaterialBehaviourPtr( new Dis_ecro_cineMaterialBehaviourInstance() )
                
cdef class Dis_viscMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Dis_viscMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Dis_viscMaterialBehaviourPtr( new Dis_viscMaterialBehaviourInstance() )
                
cdef class Dis_bili_elasMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Dis_bili_elasMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Dis_bili_elasMaterialBehaviourPtr( new Dis_bili_elasMaterialBehaviourInstance() )
                
cdef class Ther_nlMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Ther_nlMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Ther_nlMaterialBehaviourPtr( new Ther_nlMaterialBehaviourInstance() )
                
cdef class Ther_hydrMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Ther_hydrMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Ther_hydrMaterialBehaviourPtr( new Ther_hydrMaterialBehaviourInstance() )
                
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
                
cdef class Ther_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Ther_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Ther_foMaterialBehaviourPtr( new Ther_foMaterialBehaviourInstance() )
                
cdef class Ther_orthMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Ther_orthMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Ther_orthMaterialBehaviourPtr( new Ther_orthMaterialBehaviourInstance() )
                
cdef class Ther_coqueMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Ther_coqueMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Ther_coqueMaterialBehaviourPtr( new Ther_coqueMaterialBehaviourInstance() )
                
cdef class Ther_coque_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Ther_coque_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Ther_coque_foMaterialBehaviourPtr( new Ther_coque_foMaterialBehaviourInstance() )
                
cdef class Sech_grangerMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Sech_grangerMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Sech_grangerMaterialBehaviourPtr( new Sech_grangerMaterialBehaviourInstance() )
                
cdef class Sech_mensiMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Sech_mensiMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Sech_mensiMaterialBehaviourPtr( new Sech_mensiMaterialBehaviourInstance() )
                
cdef class Sech_bazantMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Sech_bazantMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Sech_bazantMaterialBehaviourPtr( new Sech_bazantMaterialBehaviourInstance() )
                
cdef class Sech_nappeMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Sech_nappeMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Sech_nappeMaterialBehaviourPtr( new Sech_nappeMaterialBehaviourInstance() )
                
cdef class Meta_acierMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Meta_acierMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Meta_acierMaterialBehaviourPtr( new Meta_acierMaterialBehaviourInstance() )
                
cdef class Meta_zircMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Meta_zircMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Meta_zircMaterialBehaviourPtr( new Meta_zircMaterialBehaviourInstance() )
                
cdef class Durt_metaMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Durt_metaMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Durt_metaMaterialBehaviourPtr( new Durt_metaMaterialBehaviourInstance() )
                
cdef class Elas_metaMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_metaMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_metaMaterialBehaviourPtr( new Elas_metaMaterialBehaviourInstance() )
                
cdef class Elas_meta_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_meta_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_meta_foMaterialBehaviourPtr( new Elas_meta_foMaterialBehaviourInstance() )
                
cdef class Meta_ecro_lineMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Meta_ecro_lineMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Meta_ecro_lineMaterialBehaviourPtr( new Meta_ecro_lineMaterialBehaviourInstance() )
                
cdef class Meta_tractionMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Meta_tractionMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Meta_tractionMaterialBehaviourPtr( new Meta_tractionMaterialBehaviourInstance() )
                
cdef class Meta_visc_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Meta_visc_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Meta_visc_foMaterialBehaviourPtr( new Meta_visc_foMaterialBehaviourInstance() )
                
cdef class Meta_ptMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Meta_ptMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Meta_ptMaterialBehaviourPtr( new Meta_ptMaterialBehaviourInstance() )
                
cdef class Meta_reMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Meta_reMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Meta_reMaterialBehaviourPtr( new Meta_reMaterialBehaviourInstance() )
                
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
                
cdef class Thm_initMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Thm_initMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Thm_initMaterialBehaviourPtr( new Thm_initMaterialBehaviourInstance() )
                
cdef class Thm_diffuMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Thm_diffuMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Thm_diffuMaterialBehaviourPtr( new Thm_diffuMaterialBehaviourInstance() )
                
cdef class Thm_liquMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Thm_liquMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Thm_liquMaterialBehaviourPtr( new Thm_liquMaterialBehaviourInstance() )
                
cdef class Thm_gazMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Thm_gazMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Thm_gazMaterialBehaviourPtr( new Thm_gazMaterialBehaviourInstance() )
                
cdef class Thm_vape_gazMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Thm_vape_gazMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Thm_vape_gazMaterialBehaviourPtr( new Thm_vape_gazMaterialBehaviourInstance() )
                                                              
cdef class Thm_air_dissMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Thm_air_dissMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Thm_air_dissMaterialBehaviourPtr( new Thm_air_dissMaterialBehaviourInstance() )
                                                       
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
                
cdef class Domma_lemaitreMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Domma_lemaitreMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Domma_lemaitreMaterialBehaviourPtr( new Domma_lemaitreMaterialBehaviourInstance() )
                
cdef class Cisa_plan_critMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Cisa_plan_critMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Cisa_plan_critMaterialBehaviourPtr( new Cisa_plan_critMaterialBehaviourInstance() )
                
cdef class Thm_ruptMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Thm_ruptMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Thm_ruptMaterialBehaviourPtr( new Thm_ruptMaterialBehaviourInstance() )
                
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
                
cdef class Weibull_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Weibull_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Weibull_foMaterialBehaviourPtr( new Weibull_foMaterialBehaviourInstance() )
                
cdef class Non_localMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Non_localMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Non_localMaterialBehaviourPtr( new Non_localMaterialBehaviourInstance() )
                
cdef class Rupt_fragMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Rupt_fragMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Rupt_fragMaterialBehaviourPtr( new Rupt_fragMaterialBehaviourInstance() )
                
cdef class Rupt_frag_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Rupt_frag_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Rupt_frag_foMaterialBehaviourPtr( new Rupt_frag_foMaterialBehaviourInstance() )
                
cdef class Czm_lab_mixMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Czm_lab_mixMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Czm_lab_mixMaterialBehaviourPtr( new Czm_lab_mixMaterialBehaviourInstance() )
                
cdef class Rupt_ductMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Rupt_ductMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Rupt_ductMaterialBehaviourPtr( new Rupt_ductMaterialBehaviourInstance() )
                
cdef class Joint_meca_ruptMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Joint_meca_ruptMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Joint_meca_ruptMaterialBehaviourPtr( new Joint_meca_ruptMaterialBehaviourInstance() )
                
cdef class Joint_meca_frotMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Joint_meca_frotMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Joint_meca_frotMaterialBehaviourPtr( new Joint_meca_frotMaterialBehaviourInstance() )
                
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
                
cdef class Rccm_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Rccm_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Rccm_foMaterialBehaviourPtr( new Rccm_foMaterialBehaviourInstance() )
                
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
                
cdef class Druck_pragerMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Druck_pragerMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Druck_pragerMaterialBehaviourPtr( new Druck_pragerMaterialBehaviourInstance() )
                
cdef class Druck_prager_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Druck_prager_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Druck_prager_foMaterialBehaviourPtr( new Druck_prager_foMaterialBehaviourInstance() )
                
cdef class Visc_druc_pragMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Visc_druc_pragMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Visc_druc_pragMaterialBehaviourPtr( new Visc_druc_pragMaterialBehaviourInstance() )
                
cdef class Hoek_brownMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Hoek_brownMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Hoek_brownMaterialBehaviourPtr( new Hoek_brownMaterialBehaviourInstance() )
                
cdef class Elas_gonfMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Elas_gonfMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Elas_gonfMaterialBehaviourPtr( new Elas_gonfMaterialBehaviourInstance() )
                
cdef class Joint_bandisMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Joint_bandisMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Joint_bandisMaterialBehaviourPtr( new Joint_bandisMaterialBehaviourInstance() )
                
cdef class Mono_visc1MaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Mono_visc1MaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Mono_visc1MaterialBehaviourPtr( new Mono_visc1MaterialBehaviourInstance() )
                
cdef class Mono_visc2MaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Mono_visc2MaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Mono_visc2MaterialBehaviourPtr( new Mono_visc2MaterialBehaviourInstance() )
                
cdef class Mono_isot1MaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Mono_isot1MaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Mono_isot1MaterialBehaviourPtr( new Mono_isot1MaterialBehaviourInstance() )
                
cdef class Mono_isot2MaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Mono_isot2MaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Mono_isot2MaterialBehaviourPtr( new Mono_isot2MaterialBehaviourInstance() )
                
cdef class Mono_cine1MaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Mono_cine1MaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Mono_cine1MaterialBehaviourPtr( new Mono_cine1MaterialBehaviourInstance() )
                
cdef class Mono_cine2MaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Mono_cine2MaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Mono_cine2MaterialBehaviourPtr( new Mono_cine2MaterialBehaviourInstance() )
                
cdef class Mono_dd_krMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Mono_dd_krMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Mono_dd_krMaterialBehaviourPtr( new Mono_dd_krMaterialBehaviourInstance() )
                
cdef class Mono_dd_cfcMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Mono_dd_cfcMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Mono_dd_cfcMaterialBehaviourPtr( new Mono_dd_cfcMaterialBehaviourInstance() )
                
cdef class Mono_dd_cfc_irraMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Mono_dd_cfc_irraMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Mono_dd_cfc_irraMaterialBehaviourPtr( new Mono_dd_cfc_irraMaterialBehaviourInstance() )
                
cdef class Mono_dd_fatMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Mono_dd_fatMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Mono_dd_fatMaterialBehaviourPtr( new Mono_dd_fatMaterialBehaviourInstance() )
                
cdef class Mono_dd_ccMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Mono_dd_ccMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Mono_dd_ccMaterialBehaviourPtr( new Mono_dd_ccMaterialBehaviourInstance() )
                
cdef class Mono_dd_cc_irraMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Mono_dd_cc_irraMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Mono_dd_cc_irraMaterialBehaviourPtr( new Mono_dd_cc_irraMaterialBehaviourInstance() )
                
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
                
cdef class Umat_foMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Umat_foMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Umat_foMaterialBehaviourPtr( new Umat_foMaterialBehaviourInstance() )
                
cdef class Crit_ruptMaterialBehaviour( GeneralMaterialBehaviour ):

    """Python wrapper on the C++ Crit_ruptMaterialBehaviour object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        # allow subclassing
        if self._cptr is not NULL:
            del self._cptr
        if init:
            self._cptr = <GeneralMaterialBehaviourPtr *>\
                new Crit_ruptMaterialBehaviourPtr( new Crit_ruptMaterialBehaviourInstance() )
                
