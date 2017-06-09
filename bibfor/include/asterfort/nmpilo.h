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
interface
    subroutine nmpilo(sdpilo, deltat, rho            , solalg    , veasse,&
                      modele, mate  , ds_constitutive, ds_contact, valinc,&
                      nbatte, numedd, nbeffe         , eta       , pilcvg,&
                      carele)
        use NonLin_Datastructure_type
        integer :: nbatte
        character(len=19) :: sdpilo
        real(kind=8) :: deltat
        real(kind=8) :: rho
        character(len=19) :: solalg(*)
        character(len=19) :: veasse(*)
        character(len=24) :: modele
        character(len=24) :: mate
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_Contact), intent(in) :: ds_contact
        character(len=19) :: valinc(*)
        character(len=24) :: numedd
        integer :: nbeffe
        real(kind=8) :: eta(nbatte)
        integer :: pilcvg
        character(len=24) :: carele
    end subroutine nmpilo
end interface
