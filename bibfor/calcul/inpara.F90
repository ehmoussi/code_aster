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

function inpara(opt, te, statut, nopara)

use calcul_module, only : ca_iaopmo_, ca_iaopno_, ca_iaoptt_, ca_ilopmo_, ca_ilopno_, ca_lgco_

implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "jeveux.h"
    character(len=8) :: nopara
    character(len=3) :: statut
    integer :: opt, te
    integer :: inpara
!-----------------------------------------------------------------------
!     entrees:
!        opt    : option
!        te     : type_element
!        statut : in/out
!        nompara : nom d'1 parametre de l'option
!
!     sorties:
!        inpara : numero du parametre nompara pour(opt,te)
!                --> rend : 0 si le nompara n'est pas trouve
!
!-----------------------------------------------------------------------
    integer :: i, deb, fin, trouve, jj, optmod, optnom
    integer ::    nucalc
!-------------------------------------------------------------------

    jj = zi(ca_iaoptt_-1+ (te-1)*ca_lgco_+opt)
    if (jj .eq. 0) then
        inpara = 0
    else
        optmod = ca_iaopmo_ + zi(ca_ilopmo_-1+jj) - 1
        nucalc = zi(optmod-1+1)
        if (nucalc .le. 0) then
            inpara = 0
            goto 999
        endif
        optnom = ca_iaopno_ + zi(ca_ilopno_-1+jj) - 1
        if (statut .eq. 'IN ') then
            deb = 1
            fin = zi(optmod-1+2)

        else
            deb = zi(optmod-1+2) + 1
            fin = zi(optmod-1+2) + zi(optmod-1+3)
        endif

        trouve = 0
        do i = deb, fin
            if (nopara .eq. zk8(optnom-1+i)) then
                trouve = 1
                exit
            endif
        enddo

        if (trouve .eq. 0) then
            inpara = 0
            goto 999
        else
            inpara = i - deb + 1
            goto 999
        endif

    endif

999 continue
end function
