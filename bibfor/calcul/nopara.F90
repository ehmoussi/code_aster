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

function nopara(opt, te, statut, ipar)

use calcul_module, only : ca_iaopmo_, ca_iaopno_, ca_iaoptt_, ca_ilopmo_, ca_ilopno_, ca_lgco_

implicit none

! person_in_charge: jacques.pellet at edf.fr

#include "jeveux.h"
#include "asterfort/assert.h"

    integer :: opt, te, ipar
    character(len=3) :: statut
    character(len=8) :: nopara
!-----------------------------------------------------------------------
!     entrees:
!        opt    : option
!        te     : type_element
!        statut : in/out
!        ipar   : numero du champ parametre dans l'option
!
!     sorties:
!        nopara : nom du parametre dans l'option
!-----------------------------------------------------------------------
    integer :: nbin, optmod, optnom
    integer ::   jj
!-----------------------------------------------------------------------

!     jj = ioptte(opt,te)
    jj = zi(ca_iaoptt_-1+ (te-1)*ca_lgco_+opt)
    optmod = ca_iaopmo_ + zi(ca_ilopmo_-1+jj) - 1
    optnom = ca_iaopno_ + zi(ca_ilopno_-1+jj) - 1
    if (statut .eq. 'IN ') then
        nopara = zk8(optnom-1+ipar)
    else
        ASSERT(statut.eq.'OUT')
        nbin = zi(optmod-1+2)
        nopara = zk8(optnom-1+nbin+ipar)
    endif
end function
