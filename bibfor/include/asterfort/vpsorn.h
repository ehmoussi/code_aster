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
interface
    subroutine vpsorn(lmasse, ldynfa, nbeq, nbvect, nfreq,&
                      tolsor, vect, resid, workd, workl,&
                      lonwl, selec, dsor, fshift, vaux,&
                      workv, ddlexc, ddllag, neqact, maxitr,&
                      ifm, niv, priram, alpha, omecor,&
                      nconv, flage, solveu)
        integer :: lonwl
        integer :: nfreq
        integer :: nbvect
        integer :: nbeq
        integer :: lmasse
        integer :: ldynfa
        real(kind=8) :: tolsor
        real(kind=8) :: vect(nbeq, nbvect)
        real(kind=8) :: resid(nbeq)
        real(kind=8) :: workd(3*nbeq)
        real(kind=8) :: workl(lonwl)
        aster_logical :: selec(nbvect)
        real(kind=8) :: dsor(nfreq+1, 2)
        real(kind=8) :: fshift
        real(kind=8) :: vaux(nbeq)
        real(kind=8) :: workv(3*nbvect)
        integer :: ddlexc(nbeq)
        integer :: ddllag(nbeq)
        integer :: neqact
        integer :: maxitr
        integer :: ifm
        integer :: niv
        integer :: priram(8)
        real(kind=8) :: alpha
        real(kind=8) :: omecor
        integer :: nconv
        aster_logical :: flage
        character(len=19) :: solveu
    end subroutine vpsorn
end interface
