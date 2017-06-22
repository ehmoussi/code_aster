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

!
!
! aslint: disable=W1504
!
#include "asterf_types.h"
!
interface
    subroutine calcCalcMeca(nb_option   , list_option    , &
                            list_load   , model          , mate       , cara_elem,& 
                            l_elem_nonl , ds_constitutive, varc_refe  ,&
                            hval_incr   , hval_algo      ,&
                            merigi      , vediri         , vefint     , veforc,&
                            vevarc_prev , vevarc_curr    , nume_harm  ,&
                            nb_obje_maxi, obje_name      , obje_sdname, nb_obje)
        use NonLin_Datastructure_type
        integer, intent(in) :: nb_option
        character(len=16), intent(in) :: list_option(:)
        character(len=19), intent(in) :: list_load
        character(len=24), intent(in) :: model
        character(len=24), intent(in) :: mate
        character(len=24), intent(in) :: cara_elem
        aster_logical, intent(in) :: l_elem_nonl
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=24), intent(in) :: varc_refe
        character(len=19), intent(in) :: hval_incr(:)
        character(len=19), intent(in) :: hval_algo(:)
        character(len=19), intent(in) :: merigi
        character(len=19), intent(in) :: vediri
        character(len=19), intent(in) :: vefint
        character(len=19), intent(in) :: veforc
        character(len=19), intent(in) :: vevarc_prev
        character(len=19), intent(in) :: vevarc_curr
        integer, intent(in) :: nume_harm
        integer, intent(in) :: nb_obje_maxi
        character(len=16), intent(inout) :: obje_name(nb_obje_maxi)
        character(len=24), intent(inout) :: obje_sdname(nb_obje_maxi)
        integer, intent(out) ::  nb_obje
    end subroutine calcCalcMeca
end interface
