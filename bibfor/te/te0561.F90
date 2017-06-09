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

subroutine te0561(option, nomte)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/elrefv.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
#include "asterfort/nmfogn.h"
#include "asterfort/nmforn.h"
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES FORCES NODALES
!                          POUR ELEMENTS NON LOCAUX  GVNO
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
!
    character(len=8) :: typmod(2)
    integer :: nno, nnob, npg
    integer :: iw, ivf, idfde, igeom, imate
    integer :: ivfb, idfdeb, nnos, jgano, jganob
    integer :: icontm
    integer :: idplgm
    integer :: ivectu
    integer :: ndim
!
    character(len=16) :: nomelt
    common /ffauto/ nomelt
!
!
!
!
!
    nomelt = nomte
!
    call elrefv(nomelt, 'RIGI', ndim, nno, nnob,&
                nnos, npg, iw, ivf, ivfb,&
                idfde, idfdeb, jgano, jganob)
!
!
! - TYPE DE MODELISATION
!
    if (lteatt('AXIS','OUI')) then
        typmod(1) = 'AXIS    '
    else if (lteatt('D_PLAN','OUI')) then
        typmod(1) = 'D_PLAN  '
    else if (lteatt('DIM_TOPO_MAILLE','3')) then
        typmod(1) = '3D      '
    else
        ASSERT(.false.)
    endif
!
    typmod(2) = 'GDVARINO'
!
!      CALL JEVECH('PDEPLMR','L',IDPLGM)
!      CALL JEVECH('PDEPLPR','L',IDDPLG)
!
    if (option .eq. 'FORC_NODA') then
!
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PCONTMR', 'L', icontm)
        call jevech('PMATERC', 'L', imate)
        call jevech('PDEPLMR', 'L', idplgm)
        call jevech('PVECTUR', 'E', ivectu)
!
        call nmfogn(ndim, nno, nnob, npg, iw,&
                    zr(ivf), zr(ivfb), idfde, idfdeb, zr(igeom),&
                    typmod, zi(imate), zr(idplgm), zr(icontm), zr( ivectu))
!
    endif
!
!
    if (option .eq. 'REFE_FORC_NODA') then
!
        call jevech('PMATERC', 'L', imate)
        call jevech('PGEOMER', 'L', igeom)
        call jevech('PVECTUR', 'E', ivectu)
!
        call nmforn(ndim, nno, nnob, npg, iw,&
                    zr(ivf), zr(ivfb), idfde, zr( igeom), zr(ivectu))
    endif
!
!
!
end subroutine
