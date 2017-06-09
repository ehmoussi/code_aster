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

subroutine te0351(option, nomte)
!
!    CALCUL DES FORCES NODALES POUR LES ELEMENTS QUAS4
!    => 1 POINT DE GAUSS + STABILISATION ASSUMED STRAIN
! ======================================================================
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/nmasf2.h"
    character(len=16) :: option, nomte
!
    character(len=8) :: typmod(2)
    integer :: nno, npg1, ipoids, ivf, idfde, igeom
    integer :: icontm, ivectu, ndim, nnos, jgano
    real(kind=8) :: work(18)
!
!
!
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg1,jpoids=ipoids,jvf=ivf,jdfde=idfde,jgano=jgano)
!
! - TYPE DE MODELISATION
!
    if (lteatt('AXIS','OUI')) then
        typmod(1) = 'AXIS'
    else if (lteatt('C_PLAN','OUI')) then
        typmod(1) = 'C_PLAN'
    else if (lteatt('D_PLAN','OUI')) then
        typmod(1) = 'D_PLAN'
    else
        ASSERT(.false.)
    endif
!
    typmod(2) = 'ASSU    '
!
! - PARAMETRES
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCONTMR', 'L', icontm)
    call jevech('PVECTUR', 'E', ivectu)
!
    call nmasf2(nno, npg1, ipoids, ivf, idfde,&
                zr(igeom), typmod, zr(icontm), work, zr(ivectu))
!
end subroutine
