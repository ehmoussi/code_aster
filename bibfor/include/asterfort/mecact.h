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
    subroutine mecact(base, nomcar, moclez, nomco, nomgdz,&
                      ncmp, nomcmp,  si, sr, sc, sk,&
                            lnomcmp, vi, vr, vc, vk         )
        integer, intent(in) :: ncmp
        character(len=*), intent(in) :: base
        character(len=*), intent(in) :: nomcar
        character(len=*), intent(in) :: moclez
        character(len=*), intent(in) :: nomco
        character(len=*), intent(in) :: nomgdz
        character(len=*), intent(in), optional :: nomcmp, lnomcmp(ncmp)
        integer, intent(in), optional :: si, vi(ncmp)
        real(kind=8), intent(in), optional :: sr, vr(ncmp)
        complex(kind=8), intent(in), optional :: sc, vc(ncmp)
        character(len=*), intent(in), optional :: sk, vk(ncmp)
    end subroutine mecact
end interface
