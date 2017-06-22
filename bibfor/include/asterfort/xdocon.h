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
    subroutine xdocon(algocr, algofr, cface, contac, coefcp,&
                      coeffp, coefcr, coeffr, elc, fpg,&
                      ifiss, ivff, jcface, jdonco, jlonch,&
                      mu, nspfis, ncompd, ndim, nface,&
                      ninter, nnof, nomte, npgf, nptf,&
                      rela)
        integer :: algocr
        integer :: algofr
        integer :: cface(30, 6)
        integer :: contac
        real(kind=8) :: coefcp
        real(kind=8) :: coeffp
        real(kind=8) :: coefcr
        real(kind=8) :: coeffr
        character(len=8) :: elc
        character(len=8) :: fpg
        integer :: ifiss
        integer :: ivff
        integer :: jcface
        integer :: jdonco
        integer :: jlonch
        real(kind=8) :: mu
        integer :: nspfis
        integer :: ncompd
        integer :: ndim
        integer :: nface
        integer :: ninter
        integer :: nnof
        character(len=16) :: nomte
        integer :: npgf
        integer :: nptf
        real(kind=8) :: rela
    end subroutine xdocon
end interface
