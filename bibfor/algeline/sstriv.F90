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

subroutine sstriv(rdiak, rdiam, lprod, ipos, neq)
    implicit none
#include "jeveux.h"
    real(kind=8) :: rdiak(neq), rdiam(neq)
    integer :: lprod(neq), ipos(neq), neq
!        TRI DES PLUS PETITS K/M
!
!     ------------------------------------------------------------------
!     IN RDIAK : TABLEAU CONTENANT LA DIAGONALE DE LA RAIDEUR
!     IN RDIAM : TABLEAU CONTENANT LA DIAGONALE DE LA MASSE
!     IN LPROD : ADRESSE DANS ZI DES DDL SUR LESQUELS ON TRIE
!     IN NEQ   : NOMBRE D EQUATIONS
!     OUT IPOS : TABLEAU DES INDIRECTIONS APRES LE TRI
!
!
!-----------------------------------------------------------------------
    integer :: i, icont, indic, itemp, ll
!-----------------------------------------------------------------------
    icont = 0
    do 1 i = 1, neq
        ipos(i) = i
        icont = icont + lprod(i)
 1  end do
10  continue
    indic = 0
    do 2 ll = 1, neq-1
        if (lprod(ipos(ll)) .eq. 0 .and. lprod(ipos(ll+1)) .eq. 1) then
            itemp = ipos(ll)
            ipos(ll) = ipos(ll+1)
            ipos(ll+1) = itemp
            indic =1
        endif
 2  end do
    if (indic .eq. 1) goto 10
!
31  continue
    indic = 0
    do 32 ll = 1, icont-1
        if (rdiam(ipos(ll)) .gt. 0.0d0 .and. rdiam(ipos(ll+1)) .gt. 0.0d0) then
            if (rdiak(ipos(ll)) .gt. 0.0d0 .and. rdiak(ipos(ll+1)) .gt. 0.0d0) then
                if (rdiak(ipos(ll))/rdiam(ipos(ll)) .gt.&
                    rdiak(ipos(ll+ 1))/rdiam(ipos(ll+1))) then
                    itemp = ipos(ll)
                    ipos(ll) = ipos(ll+1)
                    ipos(ll+1) = itemp
                    indic =1
                endif
            else if (rdiak(ipos(ll+1)).gt.0.0d0) then
                itemp = ipos(ll)
                ipos(ll) = ipos(ll+1)
                ipos(ll+1) = itemp
                indic =1
            endif
            else if(rdiak(ipos(ll+1)).gt.0.0d0 .and. rdiam(ipos(ll+1))&
        .gt.0.0d0) then
            itemp = ipos(ll)
            ipos(ll) = ipos(ll+1)
            ipos(ll+1) = itemp
            indic =1
        else if (rdiam(ipos(ll)).eq.0.and.rdiam(ipos(ll+1)).ne.0) then
            itemp = ipos(ll)
            ipos(ll) = ipos(ll+1)
            ipos(ll+1) = itemp
            indic =1
        endif
32  end do
    if (indic .eq. 1) goto 31
end subroutine
