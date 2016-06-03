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

from code_aster.DataStructure.DataStructure cimport DataStructure

#### GenericAction

cdef class GenericAction( DataStructure ):

    """Python wrapper on the C++ GenericAction object"""

    def __cinit__( self ):
        """Initialization: stores the pointer to the C++ object"""
        pass

    def __dealloc__( self ):
        """Destructor"""
        # subclassing, see https://github.com/cython/cython/wiki/WrappingSetOfCppClasses
        cdef GenericActionPtr* tmp
        if self._cptr is not NULL:
            tmp = <GenericActionPtr *>self._cptr
            del tmp
            self._cptr = NULL

    cdef set( self, GenericActionPtr other ):
        """Point to an existing object"""
        # set must be subclassed if it is necessary
        self._cptr = new GenericActionPtr( other )

    cdef GenericActionPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef GenericActionInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()


#### StopOnError

cdef class StopOnError( GenericAction ):
    """Python wrapper on the C++ StopOnError Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericActionPtr *>\
                new StopOnErrorPtr ( new StopOnErrorInstance() )


#### ContinueOnError

cdef class ContinueOnError( GenericAction ):
    """Python wrapper on the C++ ContinueOnError Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericActionPtr *>\
                new ContinueOnErrorPtr ( new ContinueOnErrorInstance() )


#### GenericSubstepingOnError

cdef class GenericSubstepingOnError( GenericAction ):
    """Python wrapper on the C++ SubstepingOnError Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericActionPtr *>\
                new GenericSubstepingOnErrorPtr ( new GenericSubstepingOnErrorInstance() )

    def setAutomatic( self, const bint& isAuto ):
        """Set the management of time step splitting (automatic or not)"""
        (<GenericSubstepingOnErrorInstance* >self.getInstance()).setAutomatic( isAuto )

    def setLevel( self, int level ):
        """Set the level of splitting"""
        (<GenericSubstepingOnErrorInstance* >self.getInstance()).setLevel( level )

    def setMinimumStep( self, double minimum ):
        """Set the minimum time step"""
        (<GenericSubstepingOnErrorInstance* >self.getInstance()).setMinimumStep( minimum )

    def setStep( self, int number ):
        """Set the number of splitting of time step"""
        (<GenericSubstepingOnErrorInstance* >self.getInstance()).setStep( number )


#### SubstepingOnError

cdef class SubstepingOnError( GenericSubstepingOnError ):
    """Python wrapper on the C++ SubstepingOnError Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericActionPtr *>\
                new SubstepingOnErrorPtr ( new SubstepingOnErrorInstance() )


#### AddIterationOnError

cdef class AddIterationOnError( GenericSubstepingOnError ):
    """Python wrapper on the C++ AddIterationOnError Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericActionPtr *>\
                new AddIterationOnErrorPtr ( new AddIterationOnErrorInstance() )

    def setPourcentageOfAddedIteration( self, double pcent ):
        """Set the pourcentage of added iteration"""
        (<AddIterationOnErrorInstance* >self.getInstance()).setPourcentageOfAddedIteration( pcent )


#### SubstepingOnContact

cdef class SubstepingOnContact( GenericAction ):
    """Python wrapper on the C++ SubstepingOnContact Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericActionPtr *>\
                new SubstepingOnContactPtr ( new SubstepingOnContactInstance() )

    def setSubstepDuration( self, double duration ):
        """Set the duration of substeping"""
        (<SubstepingOnContactInstance* >self.getInstance()).setSubstepDuration( duration )

    def setTimeStepSubstep( self, double time ):
        """Set the time of substeping"""
        (<SubstepingOnContactInstance* >self.getInstance()).setTimeStepSubstep( time )


#### PilotageError

cdef class PilotageError( GenericSubstepingOnError ):
    """Python wrapper on the C++ PilotageError Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericActionPtr *>\
                new PilotageErrorPtr ( new PilotageErrorInstance() )


#### ChangePenalisationOnError

cdef class ChangePenalisationOnError( GenericAction ):
    """Python wrapper on the C++ ChangePenalisationOnError Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericActionPtr *>\
                new ChangePenalisationOnErrorPtr ( new ChangePenalisationOnErrorInstance() )

    def setMaximumPenalisationCoefficient( self, double coefMax ):
        """Set the maximum penalisation coefficient"""
        (<ChangePenalisationOnErrorInstance* >self.getInstance()).setMaximumPenalisationCoefficient( coefMax )


#### GenericConvergenceError

cdef class GenericConvergenceError:
    """Python wrapper on the C++ GenericConvergenceError object"""

    def __cinit__( self ):
        """Initialization: stores the pointer to the C++ object"""
        pass

    def __dealloc__( self ):
        """Destructor"""
        # subclassing, see https://github.com/cython/cython/wiki/WrappingSetOfCppClasses
        cdef GenericConvergenceErrorPtr* tmp
        if self._cptr is not NULL:
            tmp = <GenericConvergenceErrorPtr *>self._cptr
            del tmp
            self._cptr = NULL

    cdef set( self, GenericConvergenceErrorPtr other ):
        """Point to an existing object"""
        # set must be subclassed if it is necessary
        self._cptr = new GenericConvergenceErrorPtr( other )

    cdef GenericConvergenceErrorPtr* getPtr( self ):
        """Return the pointer on the c++ shared-pointer object"""
        return self._cptr

    cdef GenericConvergenceErrorInstance* getInstance( self ):
        """Return the pointer on the c++ instance object"""
        return self._cptr.get()

    def setAction( self, GenericAction action ):
        """Set action on error"""
        self.getInstance().setAction( deref( action.getPtr() ) )

#### ConvergenceError

cdef class ConvergenceError( GenericConvergenceError ):
    """Python wrapper on the C++ ConvergenceError Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericConvergenceErrorPtr *>\
                new ConvergenceErrorPtr ( new ConvergenceErrorInstance() )

#### ResidualDivergenceError

cdef class ResidualDivergenceError( GenericConvergenceError ):
    """Python wrapper on the C++ ResidualDivergenceError Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericConvergenceErrorPtr *>\
                new ResidualDivergenceErrorPtr ( new ResidualDivergenceErrorInstance() )

#### IncrementOverboundError

cdef class IncrementOverboundError( GenericConvergenceError ):
    """Python wrapper on the C++ IncrementOverboundError Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericConvergenceErrorPtr *>\
                new IncrementOverboundErrorPtr ( new IncrementOverboundErrorInstance() )

    def setValueToInspect( self, value, fieldName, component ):
        """Set value increment to inspect"""
        (<IncrementOverboundErrorInstance* >self.getInstance()).setValueToInspect( value,
                                                                                   fieldName,
                                                                                   component )

#### ContactDetectionError

cdef class ContactDetectionError( GenericConvergenceError ):
    """Python wrapper on the C++ ContactDetectionError Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericConvergenceErrorPtr *>\
                new ContactDetectionErrorPtr ( new ContactDetectionErrorInstance() )

#### InterpenetrationError

cdef class InterpenetrationError( GenericConvergenceError ):
    """Python wrapper on the C++ InterpenetrationError Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericConvergenceErrorPtr *>\
                new InterpenetrationErrorPtr ( new InterpenetrationErrorInstance() )

    def setMaximalPenetration( self, value ):
        """Set the value of maximal interpenetration"""
        (<InterpenetrationErrorInstance* >self.getInstance()).setMaximalPenetration( value )

#### InstabilityError

cdef class InstabilityError( GenericConvergenceError ):
    """Python wrapper on the C++ InstabilityError Object"""

    def __cinit__( self, bint init=True ):
        """Initialization: stores the pointer to the C++ object"""
        if init:
            self._cptr = <GenericConvergenceErrorPtr *>\
                new InstabilityErrorPtr ( new InstabilityErrorInstance() )
