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

function nucalc(opt, te, memoir)
use calcul_module, only : ca_iaopmo_, ca_iaoptt_, ca_ilopmo_, ca_lgco_
implicit none
    integer :: nucalc

! person_in_charge: jacques.pellet at edf.fr

#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexatr.h"

    integer :: opt, te, memoir
!-----------------------------------------------------------------------
!     entrees:
!        opt    : option
!        te     : type_element
!        memoir : 1 : on met en memoire les objets catalogue necessaires
!                 0 : on ne fait pas de jeveux car les objets sont deja la
!                     (pour etre plus rapide dans calcul).
!
!     sorties:
!        nucalc : numero du calcul elementaire (te00ij)
!
!-----------------------------------------------------------------------
    integer :: optmod, jj
    integer, pointer :: nbligcol(:) => null()
!-------------------------------------------------------------------
    ASSERT(memoir.eq.0 .or. memoir.eq.1)
    if (memoir .eq. 1) then
        call jeveuo('&CATA.TE.OPTTE', 'L', ca_iaoptt_)
        call jeveuo('&CATA.TE.OPTMOD', 'L', ca_iaopmo_)
        call jeveuo(jexatr('&CATA.TE.OPTMOD', 'LONCUM'), 'L', ca_ilopmo_)
        call jeveuo('&CATA.TE.NBLIGCOL', 'L', vi=nbligcol)
        ca_lgco_ = nbligcol(1)
    endif

    jj = zi(ca_iaoptt_-1+ (te-1)*ca_lgco_+opt)
    if (jj .eq. 0) then
!        -- le type_element te n'est pas concerne par l'option opt:
        nucalc = 0
    else
        optmod = ca_iaopmo_ + zi(ca_ilopmo_-1+jj) - 1
        nucalc = zi(optmod-1+1)
    endif
end function
