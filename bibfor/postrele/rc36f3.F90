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

subroutine rc36f3(nbsigr, nocc, saltij, nupass)
    implicit none
#include "asterf_types.h"
    integer :: nbsigr, nocc(*), nupass
    real(kind=8) :: saltij(*)
!
!     MISE A ZERO DES LIGNES ET COLONNES DANS SALT POUR LA
!       SITUATION DE PASSAGE SI NOCC = 0
!
!     ------------------------------------------------------------------
    integer :: k, l, i1
    aster_logical :: colona, colonb, lignea, ligneb
!     ------------------------------------------------------------------
!
    colona = .false.
    colonb = .false.
    lignea = .false.
    ligneb = .false.
!
    if (nocc(2*(nupass-1)+1) .eq. 0) colona = .true.
    if (nocc(2*(nupass-1)+2) .eq. 0) colonb = .true.
    if (nocc(2*(nupass-1)+1) .eq. 0) lignea = .true.
    if (nocc(2*(nupass-1)+2) .eq. 0) ligneb = .true.
!
    if (colona) then
        do 30 k = 1, nbsigr
            i1 = 4*nbsigr*(k-1)
            saltij(i1+4*(nupass-1)+1) = 0.d0
            saltij(i1+4*(nupass-1)+2) = 0.d0
 30     continue
        i1 = 4*nbsigr*(nupass-1)
        do 32 l = 1, nbsigr
            saltij(i1+4*(l-1)+1) = 0.d0
            saltij(i1+4*(l-1)+3) = 0.d0
 32     continue
    endif
!
    if (colonb) then
        do 40 k = 1, nbsigr
            i1 = 4*nbsigr*(k-1)
            saltij(i1+4*(nupass-1)+3) = 0.d0
            saltij(i1+4*(nupass-1)+4) = 0.d0
 40     continue
        i1 = 4*nbsigr*(nupass-1)
        do 42 l = 1, nbsigr
            saltij(i1+4*(l-1)+2) = 0.d0
            saltij(i1+4*(l-1)+4) = 0.d0
 42     continue
    endif
!
    if (lignea) then
        do 50 k = 1, nbsigr
            i1 = 4*nbsigr*(k-1)
            saltij(i1+4*(nupass-1)+1) = 0.d0
            saltij(i1+4*(nupass-1)+2) = 0.d0
 50     continue
        i1 = 4*nbsigr*(nupass-1)
        do 52 l = 1, nbsigr
            saltij(i1+4*(l-1)+1) = 0.d0
            saltij(i1+4*(l-1)+3) = 0.d0
 52     continue
    endif
!
    if (ligneb) then
        do 60 k = 1, nbsigr
            i1 = 4*nbsigr*(k-1)
            saltij(i1+4*(nupass-1)+3) = 0.d0
            saltij(i1+4*(nupass-1)+4) = 0.d0
 60     continue
        i1 = 4*nbsigr*(nupass-1)
        do 62 l = 1, nbsigr
            saltij(i1+4*(l-1)+2) = 0.d0
            saltij(i1+4*(l-1)+4) = 0.d0
 62     continue
    endif
!
end subroutine
