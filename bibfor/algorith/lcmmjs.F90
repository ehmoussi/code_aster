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

subroutine lcmmjs(nomfam, nbsys, tbsys)
    implicit none
! person_in_charge: jean-michel.proix at edf.fr
!      ----------------------------------------------------------------
!     MONOCRISTAL : RECUPERATION DES SYSTEMES DE GLISSEMENT UTILISATEUR
!       ----------------------------------------------------------------
    integer :: i, j, nbsys, numfam, decal
    character(len=16) :: nomfam
    real(kind=8) :: tbsys(30, 6), tbsysg
    common/tbsysg/tbsysg(900)
!     ----------------------------------------------------------------
!
! -   NB DE COMPOSANTES / VARIABLES INTERNES -------------------------
!
    read (nomfam(5:5),'(I1)') numfam
    nbsys=nint(tbsysg(2*numfam+1))
    decal=nint(tbsysg(2*numfam+2))
    do 2 i = 1, nbsys
        do 2 j = 1, 6
            tbsys(i,j)=tbsysg(decal-1+6*(i-1)+j)
 2      continue
!
end subroutine
