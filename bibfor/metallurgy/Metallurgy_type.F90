! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
! This file is part of code_aster.
!
! code_aster is free software: you can redistribute it and/or modify
! it under the terms of the GNU General Public License as published by
! the Free Software Foundation, either version 3 of the License, or
! (at your option) any later version.
!
! code_aster is distributed in the hope that it will be useful,
! but WITHOUT ANY WARRANTY; without even the implied warranty of
! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
! GNU General Public License for more details.
!
! You should have received a copy of the GNU General Public License
! along with code_aster.  If not, see <http://www.gnu.org/licenses/>.
! --------------------------------------------------------------------
! person_in_charge: mickael.abbas at edf.fr
!
module Metallurgy_type
!
implicit none
!
#include "asterf_types.h"
!
! --------------------------------------------------------------------------------------------------
!
! Metallurgy
!
! Define types for datastructures
!
! --------------------------------------------------------------------------------------------------
!
!
! - Type: parameters for behaviour
! 
    type META_Parameters
! ----- Keyword RELATION
        character(len=16) :: phase_type
! ----- Keyword LOI_META
        character(len=16) :: loi_meta
! ----- Total number of internal state variables
        integer           :: nb_vari
! ----- Index of behaviour
        integer           :: nume_comp
    end type META_Parameters
!
! - Type: for preparation of comportment
! 
    type META_PrepPara
! ----- Number of factor keywords
        integer                        :: nb_comp
! ----- List of parameters
        type(META_Parameters), pointer :: v_comp(:)
    end type META_PrepPara
!
    type META_AusteniteParameters
        real(kind=8) :: lambda0
        real(kind=8) :: qsr_k
        real(kind=8) :: d10
        real(kind=8) :: wsr_k
    end type META_AusteniteParameters
!
    type META_TRCParameters
        integer :: jv_ftrc, jv_trc
        integer :: iadexp, iadckm, iadtrc
        integer :: nb_trc
        integer :: nb_hist
    end type META_TRCParameters
!
    type META_SteelParameters
        real(kind=8) :: ar3
        real(kind=8) :: alpha
        real(kind=8) :: ms0
        real(kind=8) :: ac1
        real(kind=8) :: ac3
        real(kind=8) :: taux_1
        real(kind=8) :: taux_3
        aster_logical :: l_grain_size
        type(META_AusteniteParameters) :: austenite
        type(META_TRCParameters)       :: trc
    end type META_SteelParameters
!
    type META_ZircParameters
        real(kind=8) :: tdeq
        real(kind=8) :: k
        real(kind=8) :: n
        real(kind=8) :: t1c
        real(kind=8) :: t2c
        real(kind=8) :: ac
        real(kind=8) :: m
        real(kind=8) :: qsrk
        real(kind=8) :: t1r
        real(kind=8) :: t2r
        real(kind=8) :: ar
        real(kind=8) :: br
    end type META_ZircParameters
!
    type META_MaterialParameters
        type(META_SteelParameters)      :: steel
        type(META_ZircParameters)       :: zirc
    end type META_MaterialParameters
!
end module
