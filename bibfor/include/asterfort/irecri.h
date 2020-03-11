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
    subroutine irecri(nomcon, form, ifi, titre,&
                      nbcham, cham, nbpara, para,&
                      nbordr, ordr, lresu, motfac, iocc,&
                      cecr, lcor, nbnot, numnoe,&
                      nbmat, nummai, nbcmp, nomcmp, lsup,&
                      borsup, linf, borinf, lmax, lmin,&
                      formr,  niv)
        character(len=*) :: nomcon
        character(len=*) :: form
        integer :: ifi
        character(len=*) :: titre
        integer :: nbcham
        character(len=*) :: cham(*)
        integer :: nbpara
        character(len=*) :: para(*)
        integer :: nbordr
        integer :: ordr(*)
        aster_logical :: lresu
        character(len=*) :: motfac
        integer :: iocc
        character(len=*) :: cecr
        aster_logical :: lcor
        integer :: nbnot
        integer :: numnoe(*)
        integer :: nbmat
        integer :: nummai(*)
        integer :: nbcmp
        character(len=*) :: nomcmp(*)
        aster_logical :: lsup
        real(kind=8) :: borsup
        aster_logical :: linf
        real(kind=8) :: borinf
        aster_logical :: lmax
        aster_logical :: lmin
        character(len=*) :: formr
        integer :: niv
    end subroutine irecri
end interface
