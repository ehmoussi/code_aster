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
    subroutine cccmcr(jcesdd, numma, jrepe, jconx2, jconx1,&
                      jcoord, adcar1, adcar2, ialpha, ibeta,&
                      iepais, jalpha, jbeta, jgamma, ligrmo,&
                      ino, pgl, modeli, codret)
        integer :: jcesdd
        integer :: numma
        integer :: jrepe
        integer :: jconx2
        integer :: jconx1
        integer :: jcoord
        integer :: adcar1(3)
        integer :: adcar2(3)
        integer :: ialpha
        integer :: ibeta
        integer :: iepais
        integer :: jalpha
        integer :: jbeta
        integer :: jgamma
        character(len=19) :: ligrmo
        integer :: ino
        real(kind=8) :: pgl(3, 3)
        character(len=16) :: modeli
        integer :: codret
    end subroutine cccmcr
end interface
