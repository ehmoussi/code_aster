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
    subroutine deffen(base, nuor, imodi, nbmr, nbm,&
                      iaxe, long, nbnfen, nofe, discfe,&
                      nbp1, nbp2, discff, defm)
        integer :: nbp2
        integer :: nbp1
        integer :: nbnfen
        integer :: nbm
        integer :: nbmr
        character(len=19) :: base
        integer :: nuor(nbm)
        integer :: imodi
        integer :: iaxe
        real(kind=8) :: long
        integer :: nofe(nbnfen)
        real(kind=8) :: discfe(nbnfen)
        real(kind=8) :: discff(nbp1+nbp2)
        real(kind=8) :: defm(nbp1+nbp2, nbmr)
    end subroutine deffen
end interface
