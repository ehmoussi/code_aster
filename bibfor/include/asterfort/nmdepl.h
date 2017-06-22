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
#include "asterf_types.h"
!
! aslint: disable=W1504
!
interface
    subroutine nmdepl(modele         , numedd , mate  , carele    , comref     ,&
                      ds_constitutive, lischa , fonact, ds_measure, ds_algopara,&
                      noma           , numins , iterat, solveu    , matass     ,&
                      sddisc         , sddyna , sdnume, sdpilo    , sderro     ,&
                      ds_contact     , valinc , solalg, veelem    , veasse     ,&
                      eta            , ds_conv, lerrit)
        use NonLin_Datastructure_type
        character(len=24) :: modele
        character(len=24) :: numedd
        character(len=24) :: mate
        character(len=24) :: carele
        character(len=24) :: comref
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        character(len=19) :: lischa
        integer :: fonact(*)
        type(NL_DS_Measure), intent(inout) :: ds_measure
        type(NL_DS_AlgoPara), intent(in) :: ds_algopara
        character(len=8) :: noma
        integer :: numins
        integer :: iterat
        character(len=19) :: solveu
        character(len=19) :: matass
        character(len=19) :: sddisc
        character(len=19) :: sddyna
        character(len=19) :: sdnume
        character(len=19) :: sdpilo
        character(len=24) :: sderro
        type(NL_DS_Contact), intent(inout) :: ds_contact
        character(len=19) :: valinc(*)
        character(len=19) :: solalg(*)
        character(len=19) :: veelem(*)
        character(len=19) :: veasse(*)
        real(kind=8) :: eta
        type(NL_DS_Conv), intent(inout) :: ds_conv
        aster_logical :: lerrit
    end subroutine nmdepl
end interface
