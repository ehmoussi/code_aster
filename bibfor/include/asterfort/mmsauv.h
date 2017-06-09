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
    subroutine mmsauv(ds_contact, izone, iptc, nummam, ksipr1,&
                      ksipr2, tau1, tau2, nummae, numnoe,&
                      ksipc1, ksipc2, wpc)
        use NonLin_Datastructure_type
        type(NL_DS_Contact), intent(in) :: ds_contact
        integer :: izone
        integer :: iptc
        integer :: nummam
        real(kind=8) :: ksipr1
        real(kind=8) :: ksipr2
        real(kind=8) :: tau1(3)
        real(kind=8) :: tau2(3)
        integer :: nummae
        integer :: numnoe
        real(kind=8) :: ksipc1
        real(kind=8) :: ksipc2
        real(kind=8) :: wpc
    end subroutine mmsauv
end interface
