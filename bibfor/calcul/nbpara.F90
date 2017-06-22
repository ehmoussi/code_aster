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

function nbpara(opt, te, statut)

use calcul_module, only : ca_iaopmo_, ca_iaoptt_, ca_ilopmo_, ca_lgco_

implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "jeveux.h"
#include "asterfort/assert.h"

    integer :: opt, te
    character(len=3) :: statut
    integer :: nbpara
!-----------------------------------------------------------------------
!     entrees:
!        opt     : option_simple
!        te      : type_element
!        statut  : IN / OUT
!
!     sorties:
!        nbpara: nombre de champ parametre de statut: statut
!                pour le calcul(opt,te)
!-----------------------------------------------------------------------
    integer :: optmod, jj
    integer ::  nucalc
!-----------------------------------------------------------------------

    jj = zi(ca_iaoptt_-1+ (te-1)*ca_lgco_+opt)
    if (jj .eq. 0) then
        nbpara = 0
    else
        optmod = ca_iaopmo_ + zi(ca_ilopmo_-1+jj) - 1
        nucalc = zi(optmod-1+1)
        if (nucalc .le. 0) then
            nbpara = 0
        else
            if (statut .eq. 'IN ') then
                nbpara = zi(optmod-1+2)
            else
                ASSERT(statut.eq.'OUT')
                nbpara = zi(optmod-1+3)
            endif
        endif
    endif
end function
