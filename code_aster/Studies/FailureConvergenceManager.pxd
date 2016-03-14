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

from code_aster.Loads.PhysicalQuantity cimport PhysicalQuantityComponent


cdef extern from "Studies/FailureConvergenceManager.h":

#### GenericAction

    cdef cppclass GenericActionInstance:

        GenericActionInstance( ActionType )
        GenericActionInstance()
        #ActionType& getType()

    cdef cppclass GenericActionPtr:

        GenericActionPtr( GenericActionPtr& )
        GenericActionPtr( GenericActionInstance * )
        GenericActionInstance* get()


#### StopOnError

    cdef cppclass StopOnErrorInstance( GenericActionInstance ):

        StopOnErrorInstance()

    cdef cppclass StopOnErrorPtr:

        StopOnErrorPtr( StopOnErrorPtr& )
        StopOnErrorPtr( StopOnErrorInstance * )
        StopOnErrorInstance* get()


#### ContinueOnError

    cdef cppclass ContinueOnErrorInstance( GenericActionInstance ):

        ContinueOnErrorInstance()

    cdef cppclass ContinueOnErrorPtr:

        ContinueOnErrorPtr( ContinueOnErrorPtr& )
        ContinueOnErrorPtr( ContinueOnErrorInstance * )
        ContinueOnErrorInstance* get()


#### GenericSubstepingOnError

    cdef cppclass GenericSubstepingOnErrorInstance( GenericActionInstance ):

        GenericSubstepingOnErrorInstance()
        void setAutomatic( const bint& isAuto )
        void setLevel( const int& level )
        void setMinimumStep( const double& minimumStep )
        void setStep( const double& step )

    cdef cppclass GenericSubstepingOnErrorPtr:

        GenericSubstepingOnErrorPtr( GenericSubstepingOnErrorPtr& )
        GenericSubstepingOnErrorPtr( GenericSubstepingOnErrorInstance * )
        GenericSubstepingOnErrorInstance* get()


#### SubstepingOnError

    cdef cppclass SubstepingOnErrorInstance( GenericSubstepingOnErrorInstance ):

        SubstepingOnErrorInstance()
        void setAutomatic( const bint& isAuto )
        void setLevel( const int& level )
        void setMinimumStep( const double& minimumStep )
        void setStep( const double& step )

    cdef cppclass SubstepingOnErrorPtr:

        SubstepingOnErrorPtr( SubstepingOnErrorPtr& )
        SubstepingOnErrorPtr( SubstepingOnErrorInstance * )
        SubstepingOnErrorInstance* get()


#### AddIterationOnError

    cdef cppclass AddIterationOnErrorInstance( GenericSubstepingOnErrorInstance ):

        AddIterationOnErrorInstance()
        void setPourcentageOfAddedIteration( const double& pcent )

    cdef cppclass AddIterationOnErrorPtr:

        AddIterationOnErrorPtr( AddIterationOnErrorPtr& )
        AddIterationOnErrorPtr( AddIterationOnErrorInstance * )
        AddIterationOnErrorInstance* get()


#### SubstepingOnContact

    cdef cppclass SubstepingOnContactInstance( GenericActionInstance ):

        SubstepingOnContactInstance()
        void setSubstepDuration( const double& duration )
        void setTimeStepSubstep( const double& time )

    cdef cppclass SubstepingOnContactPtr:

        SubstepingOnContactPtr( SubstepingOnContactPtr& )
        SubstepingOnContactPtr( SubstepingOnContactInstance * )
        SubstepingOnContactInstance* get()


#### PilotageError

    cdef cppclass PilotageErrorInstance( GenericActionInstance ):

        PilotageErrorInstance()

    cdef cppclass PilotageErrorPtr:

        PilotageErrorPtr( PilotageErrorPtr& )
        PilotageErrorPtr( PilotageErrorInstance * )
        PilotageErrorInstance* get()


#### ChangePenalisationOnError

    cdef cppclass ChangePenalisationOnErrorInstance( GenericActionInstance ):

        ChangePenalisationOnErrorInstance()
        void setMaximumPenalisationCoefficient( const double& coef )

    cdef cppclass ChangePenalisationOnErrorPtr:

        ChangePenalisationOnErrorPtr( ChangePenalisationOnErrorPtr& )
        ChangePenalisationOnErrorPtr( ChangePenalisationOnErrorInstance * )
        ChangePenalisationOnErrorInstance* get()



#### GenericConvergenceError

    cdef cppclass GenericConvergenceErrorInstance:

        GenericConvergenceErrorInstance()
        void setAction( const GenericActionPtr& action ) except +

    cdef cppclass GenericConvergenceErrorPtr:

        GenericConvergenceErrorPtr( GenericConvergenceErrorPtr& )
        GenericConvergenceErrorPtr( GenericConvergenceErrorInstance * )
        GenericConvergenceErrorInstance* get()


#### ConvergenceError

    cdef cppclass ConvergenceErrorInstance( GenericConvergenceErrorInstance ):

        ConvergenceErrorInstance()

    cdef cppclass ConvergenceErrorPtr:

        ConvergenceErrorPtr( ConvergenceErrorPtr& )
        ConvergenceErrorPtr( ConvergenceErrorInstance * )
        ConvergenceErrorInstance* get()


#### ResidualDivergenceError

    cdef cppclass ResidualDivergenceErrorInstance( GenericConvergenceErrorInstance ):

        ResidualDivergenceErrorInstance()

    cdef cppclass ResidualDivergenceErrorPtr:

        ResidualDivergenceErrorPtr( ResidualDivergenceErrorPtr& )
        ResidualDivergenceErrorPtr( ResidualDivergenceErrorInstance * )
        ResidualDivergenceErrorInstance* get()


#### IncrementOverboundError

    cdef cppclass IncrementOverboundErrorInstance( GenericConvergenceErrorInstance ):

        IncrementOverboundErrorInstance()
        void setValueToInspect( const double& value, const string& fieldName,
                                const PhysicalQuantityComponent& component )

    cdef cppclass IncrementOverboundErrorPtr:

        IncrementOverboundErrorPtr( IncrementOverboundErrorPtr& )
        IncrementOverboundErrorPtr( IncrementOverboundErrorInstance * )
        IncrementOverboundErrorInstance* get()


#### ContactDetectionError

    cdef cppclass ContactDetectionErrorInstance( GenericConvergenceErrorInstance ):

        ContactDetectionErrorInstance()

    cdef cppclass ContactDetectionErrorPtr:

        ContactDetectionErrorPtr( ContactDetectionErrorPtr& )
        ContactDetectionErrorPtr( ContactDetectionErrorInstance * )
        ContactDetectionErrorInstance* get()


#### InterpenetrationError

    cdef cppclass InterpenetrationErrorInstance( GenericConvergenceErrorInstance ):

        InterpenetrationErrorInstance()
        void setMaximalPenetration( const double& value )

    cdef cppclass InterpenetrationErrorPtr:

        InterpenetrationErrorPtr( InterpenetrationErrorPtr& )
        InterpenetrationErrorPtr( InterpenetrationErrorInstance * )
        InterpenetrationErrorInstance* get()


#### InstabilityError

    cdef cppclass InstabilityErrorInstance( GenericConvergenceErrorInstance ):

        InstabilityErrorInstance()

    cdef cppclass InstabilityErrorPtr:

        InstabilityErrorPtr( InstabilityErrorPtr& )
        InstabilityErrorPtr( InstabilityErrorInstance * )
        InstabilityErrorInstance* get()


#### GenericAction

cdef class GenericAction:
    cdef GenericActionPtr* _cptr
    cdef set( self, GenericActionPtr other )
    cdef GenericActionPtr* getPtr( self )
    cdef GenericActionInstance* getInstance( self )

#### StopOnError

cdef class StopOnError( GenericAction ):
    pass

#### ContinueOnError

cdef class ContinueOnError( GenericAction ):
    pass

#### GenericSubstepingOnError

cdef class GenericSubstepingOnError( GenericAction ):
    pass

#### SubstepingOnError

cdef class SubstepingOnError( GenericSubstepingOnError ):
    pass

#### AddIterationOnError

cdef class AddIterationOnError( GenericSubstepingOnError ):
    pass

#### SubstepingOnContact

cdef class SubstepingOnContact( GenericAction ):
    pass

#### PilotageError

cdef class PilotageError( GenericSubstepingOnError ):
    pass

#### ChangePenalisationOnError

cdef class ChangePenalisationOnError( GenericAction ):
    pass


#### GenericConvergenceError

cdef class GenericConvergenceError:
    cdef GenericConvergenceErrorPtr* _cptr
    cdef set( self, GenericConvergenceErrorPtr other )
    cdef GenericConvergenceErrorPtr* getPtr( self )
    cdef GenericConvergenceErrorInstance* getInstance( self )

#### ConvergenceError

cdef class ConvergenceError( GenericConvergenceError ):
    pass

#### ResidualDivergenceError

cdef class ResidualDivergenceError( GenericConvergenceError ):
    pass

#### IncrementOverboundError

cdef class IncrementOverboundError( GenericConvergenceError ):
    pass

#### ContactDetectionError

cdef class ContactDetectionError( GenericConvergenceError ):
    pass

#### InterpenetrationError

cdef class InterpenetrationError( GenericConvergenceError ):
    pass

#### InstabilityError

cdef class InstabilityError( GenericConvergenceError ):
    pass
