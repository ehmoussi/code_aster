! --------------------------------------------------------------------
! Copyright (C) 1991 - 2017 - EDF R&D - www.code-aster.org
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

module Material_Datastructure_type
!
implicit none
!
#include "asterf_types.h"
!
! person_in_charge: mickael.abbas at edf.fr
!

!
! --------------------------------------------------------------------------------------------------
!
! Material
!
! Define types for datastructures
!
! --------------------------------------------------------------------------------------------------
!

! - Type: components for a state variable
    type Mat_DS_VarcComp
        character(len=8)      :: phys_para_cmp
        character(len=8)      :: varc_cmp
    end type Mat_DS_VarcComp

! - Type: external state variable
    type Mat_DS_VarcAffe
        integer               :: indx_cata
        real(kind=8)          :: vale_refe
        character(len=16)     :: vale_phys_para
        character(len=8)      :: evol
        character(len=8)      :: type_affe
        character(len=16)     :: evol_prol_l
        character(len=16)     :: evol_prol_r
        character(len=8)      :: evol_func
        aster_logical         :: l_affe_tout
        integer, pointer      :: v_elem(:)
        integer               :: nb_elem
    end type Mat_DS_VarcAffe


! - Type: external state variable
    type Mat_DS_VarcCata
        character(len=8)               :: name
        character(len=8)               :: type_phys_para
        integer                        :: nb_cmp
        character(len=16)              :: field_type_def
        type(Mat_DS_VarcComp), pointer :: list_cmp(:)
    end type Mat_DS_VarcCata

! - Type: list of external state variables affected
    type Mat_DS_VarcListAffe
        type(Mat_DS_VarcAffe), pointer :: list_affe_varc(:)
        integer                        :: nb_affe_varc
        integer                        :: nb_varc_acti
        integer                        :: nb_varc_cmp
    end type Mat_DS_VarcListAffe

! - Type: catalog of external state variables
    type Mat_DS_VarcListCata
        type(Mat_DS_VarcCata), pointer :: list_cata_varc(:)
        integer                        :: nb_varc
    end type Mat_DS_VarcListCata
!
end module
