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

subroutine jevete(nomobj, code, iad)
! aslint: disable=W0104

use calcul_module, only : ca_iainel_, ca_ininel_, ca_nbobj_

implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/indk24.h"

    character(len=*) :: nomobj
    character(len=1) :: code
    character(len=24) :: nomob2
    integer ::  ii,   iad
!-------------------------------------------------------------------
!  entrees:
!     nomobj  : nombre de l'objet '&INEL.XXXX' dont on veut l'adresse
!     code    : 'l' (pour ressembler a jeveuo mais ne sert a rien !)
!
!  sorties:
!     iad      : adresse de l'objet '&INEL.XXX' voulu.
!                ( = 0 si l'objet n'existe pas).
!-------------------------------------------------------------------
    nomob2 = nomobj
    ii = indk24(zk24(ca_ininel_),nomob2,1,ca_nbobj_)
    ASSERT(ii.ne.0)
    iad = zi(ca_iainel_-1+ii)
end subroutine
