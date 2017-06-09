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

subroutine xpente(pl, cnse, n, bis)
    implicit none
!
#include "jeveux.h"
    integer :: pl, n(18), cnse(6, 10)
    integer, intent(in), optional :: bis
! person_in_charge: samuel.geniaut at edf.fr
!
!                      DÉCOUPER LE SOUS-PENTA EN SOUS-TETRAS
!
!     ENTREE
!       PL                : PLACE DU 1ER SOUS-TETRA DANS CNSE
!       N1,N2,N3,N4,...N18 : NUMEROS DES NOEUDS DU PENTA
!
!     SORTIE
!       CNSE      : CONNECTIVITE NOMBRE DE SOUS-ÉLÉMENTS (TÉTRAS)
!     ------------------------------------------------------------------
!
! ----------------------------------------------------------------------
!
!
!     ON REMPLIT 3 SOUS TETRAS DE CNSE À PARTIR DE LA PLACE PL
!
    cnse(pl,1)=n(1)
    cnse(pl,2)=n(5)
    cnse(pl,3)=n(2)
    cnse(pl,4)=n(6)
    cnse(pl,5)=n(16)
    cnse(pl,6)=n(11)
    cnse(pl,7)=n(7)
    cnse(pl,8)=n(18)
    cnse(pl,9)=n(14)
    cnse(pl,10)=n(17)
!
    cnse(pl+1,1)=n(4)
    cnse(pl+1,2)=n(5)
    cnse(pl+1,3)=n(1)
    cnse(pl+1,4)=n(6)
    cnse(pl+1,5)=n(13)
    cnse(pl+1,6)=n(16)
    cnse(pl+1,7)=n(10)
    cnse(pl+1,8)=n(15)
    cnse(pl+1,9)=n(14)
    cnse(pl+1,10)=n(18)
!
    cnse(pl+2,1)=n(1)
    cnse(pl+2,2)=n(2)
    cnse(pl+2,3)=n(3)
    cnse(pl+2,4)=n(6)
    cnse(pl+2,5)=n(7)
    cnse(pl+2,6)=n(8)
    cnse(pl+2,7)=n(9)
    cnse(pl+2,8)=n(18)
    cnse(pl+2,9)=n(17)
    cnse(pl+2,10)=n(12)
!
    if (present(bis)) then
       if (bis.eq.1) then
          cnse(pl,1)=n(3)
          cnse(pl,2)=n(1)
          cnse(pl,3)=n(2)
          cnse(pl,4)=n(4)
          cnse(pl,5)=n(9)
          cnse(pl,6)=n(7)
          cnse(pl,7)=n(8)
          cnse(pl,8)=n(18)
          cnse(pl,9)=n(10)
          cnse(pl,10)=n(16)
!
          cnse(pl+1,1)=n(4)
          cnse(pl+1,2)=n(6)
          cnse(pl+1,3)=n(5)
          cnse(pl+1,4)=n(3)
          cnse(pl+1,5)=n(15)
          cnse(pl+1,6)=n(14)
          cnse(pl+1,7)=n(13)
          cnse(pl+1,8)=n(18)
          cnse(pl+1,9)=n(12)
          cnse(pl+1,10)=n(17)
!
          cnse(pl+2,1)=n(2)
          cnse(pl+2,2)=n(5)
          cnse(pl+2,3)=n(3)
          cnse(pl+2,4)=n(4)
          cnse(pl+2,5)=n(11)
          cnse(pl+2,6)=n(17)
          cnse(pl+2,7)=n(8)
          cnse(pl+2,8)=n(16)
          cnse(pl+2,9)=n(13)
          cnse(pl+2,10)=n(18)
       elseif (bis.eq.2) then
          cnse(pl,1)=n(1)
          cnse(pl,2)=n(5)
          cnse(pl,3)=n(2)
          cnse(pl,4)=n(3)
          cnse(pl,5)=n(16)
          cnse(pl,6)=n(11)
          cnse(pl,7)=n(7)
          cnse(pl,8)=n(9)
          cnse(pl,9)=n(17)
          cnse(pl,10)=n(8)
!
          cnse(pl+1,1)=n(4)
          cnse(pl+1,2)=n(5)
          cnse(pl+1,3)=n(1)
          cnse(pl+1,4)=n(6)
          cnse(pl+1,5)=n(13)
          cnse(pl+1,6)=n(16)
          cnse(pl+1,7)=n(10)
          cnse(pl+1,8)=n(15)
          cnse(pl+1,9)=n(14)
          cnse(pl+1,10)=n(18)
!
          cnse(pl+2,1)=n(6)
          cnse(pl+2,2)=n(3)
          cnse(pl+2,3)=n(5)
          cnse(pl+2,4)=n(1)
          cnse(pl+2,5)=n(12)
          cnse(pl+2,6)=n(17)
          cnse(pl+2,7)=n(14)
          cnse(pl+2,8)=n(18)
          cnse(pl+2,9)=n(9)
          cnse(pl+2,10)=n(16)
       elseif (bis.eq.3) then
          cnse(pl,1)=n(3)
          cnse(pl,2)=n(1)
          cnse(pl,3)=n(2)
          cnse(pl,4)=n(4)
          cnse(pl,5)=n(9)
          cnse(pl,6)=n(7)
          cnse(pl,7)=n(8)
          cnse(pl,8)=n(18)
          cnse(pl,9)=n(10)
          cnse(pl,10)=n(16)
!
          cnse(pl+1,1)=n(4)
          cnse(pl+1,2)=n(6)
          cnse(pl+1,3)=n(5)
          cnse(pl+1,4)=n(2)
          cnse(pl+1,5)=n(15)
          cnse(pl+1,6)=n(14)
          cnse(pl+1,7)=n(13)
          cnse(pl+1,8)=n(16)
          cnse(pl+1,9)=n(17)
          cnse(pl+1,10)=n(11)
!
          cnse(pl+2,1)=n(2)
          cnse(pl+2,2)=n(6)
          cnse(pl+2,3)=n(3)
          cnse(pl+2,4)=n(4)
          cnse(pl+2,5)=n(17)
          cnse(pl+2,6)=n(12)
          cnse(pl+2,7)=n(8)
          cnse(pl+2,8)=n(16)
          cnse(pl+2,9)=n(15)
          cnse(pl+2,10)=n(18)
       elseif (bis.eq.4) then
          cnse(pl,1)=n(1)
          cnse(pl,2)=n(5)
          cnse(pl,3)=n(2)
          cnse(pl,4)=n(3)
          cnse(pl,5)=n(16)
          cnse(pl,6)=n(11)
          cnse(pl,7)=n(7)
          cnse(pl,8)=n(9)
          cnse(pl,9)=n(17)
          cnse(pl,10)=n(8)
!
          cnse(pl+1,1)=n(4)
          cnse(pl+1,2)=n(5)
          cnse(pl+1,3)=n(3)
          cnse(pl+1,4)=n(6)
          cnse(pl+1,5)=n(13)
          cnse(pl+1,6)=n(17)
          cnse(pl+1,7)=n(18)
          cnse(pl+1,8)=n(15)
          cnse(pl+1,9)=n(14)
          cnse(pl+1,10)=n(12)
!
          cnse(pl+2,1)=n(4)
          cnse(pl+2,2)=n(5)
          cnse(pl+2,3)=n(1)
          cnse(pl+2,4)=n(3)
          cnse(pl+2,5)=n(13)
          cnse(pl+2,6)=n(16)
          cnse(pl+2,7)=n(10)
          cnse(pl+2,8)=n(18)
          cnse(pl+2,9)=n(17)
          cnse(pl+2,10)=n(9)
       elseif (bis.eq.5) then
          cnse(pl,1)=n(3)
          cnse(pl,2)=n(1)
          cnse(pl,3)=n(2)
          cnse(pl,4)=n(6)
          cnse(pl,5)=n(9)
          cnse(pl,6)=n(7)
          cnse(pl,7)=n(8)
          cnse(pl,8)=n(12)
          cnse(pl,9)=n(18)
          cnse(pl,10)=n(17)
!
          cnse(pl+1,1)=n(4)
          cnse(pl+1,2)=n(6)
          cnse(pl+1,3)=n(5)
          cnse(pl+1,4)=n(2)
          cnse(pl+1,5)=n(15)
          cnse(pl+1,6)=n(14)
          cnse(pl+1,7)=n(13)
          cnse(pl+1,8)=n(16)
          cnse(pl+1,9)=n(17)
          cnse(pl+1,10)=n(11)
!
          cnse(pl+2,1)=n(4)
          cnse(pl+2,2)=n(1)
          cnse(pl+2,3)=n(6)
          cnse(pl+2,4)=n(2)
          cnse(pl+2,5)=n(10)
          cnse(pl+2,6)=n(18)
          cnse(pl+2,7)=n(15)
          cnse(pl+2,8)=n(16)
          cnse(pl+2,9)=n(7)
          cnse(pl+2,10)=n(17)
       endif
    endif
!
end subroutine
