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
interface
    subroutine nmflal(option, ds_constitutive, ds_posttimestep, mod45 , defo  ,&
                      nfreq , cdsp           , typmat         , optmod, bande ,&
                      nddle , nsta           , modrig)
        use NonLin_Datastructure_type
        character(len=16) :: option
        type(NL_DS_Constitutive), intent(in) :: ds_constitutive
        type(NL_DS_PostTimeStep), intent(in) :: ds_posttimestep
        character(len=4) :: mod45
        integer :: defo
        integer :: nfreq
        integer :: cdsp
        character(len=16) :: typmat
        character(len=16) :: optmod
        real(kind=8) :: bande(2)
        integer :: nddle
        integer :: nsta
        character(len=16) :: modrig
    end subroutine nmflal
end interface
