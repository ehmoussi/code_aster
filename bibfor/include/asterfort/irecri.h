! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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
#include "asterf_types.h"
!
interface
    subroutine irecri(resultName, form, fileUnit, titre, &
                      nbcham, cham,  paraNb, paraName,&
                      storeNb, storeIndx, lresu, motfac, iocc,&
                      tablFormat, lcor, nbnot, numnoe,&
                      nbmat, nummai, nbcmp, nomcmp, lsup,&
                      borsup, linf, borinf, lmax, lmin,&
                      formr, niv)
        character(len=*), intent(in) :: resultName
        integer, intent(in) :: fileUnit
        integer, intent(in) :: storeNb, storeIndx(*)
        integer, intent(in) :: paraNb
        character(len=*), intent(in) :: paraName(*)
        character(len=1), intent(in) :: tablFormat
        character(len=*) :: form, titre, cham(*)
        character(len=*) :: motfac
        character(len=*) :: nomcmp(*), formr
        real(kind=8) :: borsup, borinf
        integer :: nbcham, niv
        integer :: nbcmp, iocc
        integer :: nbnot, numnoe(*), nbmat, nummai(*)
        aster_logical :: lresu, lcor
        aster_logical :: lsup, linf, lmax, lmin
    end subroutine irecri
end interface
