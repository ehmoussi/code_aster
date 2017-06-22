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

subroutine te0328(option, nomte)
!.......................................................................
    implicit none
!          ELEMENTS ISOPARAMETRIQUES 3D ET 2D
!    FONCTION REALISEE:
!            OPTION : 'VERIF_JACOBIEN'
!     ENTREES  ---> OPTION : OPTION DE CALCUL
!              ---> NOMTE  : NOM DU TYPE ELEMENT
!.......................................................................
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dfdm2j.h"
#include "asterfort/dfdm3j.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
!
    character(len=16) :: nomte, option
!
    aster_logical :: posi, nega
    character(len=24) :: valk(2)
    real(kind=8) :: poids
    integer :: igeom, ipoids, ivf, idfde, ndim, npg, nno, jgano, nnos
    integer :: kp, icodr
    integer :: iadzi, iazk24, codret
!
    codret=0
    call jevech('PGEOMER', 'L', igeom)
    call jevech('PCODRET', 'E', icodr)
!
    call elrefe_info(fami='RIGI', ndim=ndim, nno=nno, nnos=nnos, npg=npg,&
                     jpoids=ipoids, jvf=ivf, jdfde=idfde, jgano=jgano)
!
    posi=.false.
    nega=.false.
    do 1 kp = 1, npg
        if (ndim .eq. 3) then
            call dfdm3j(nno, kp, idfde, zr(igeom), poids)
        else if (ndim.eq.2) then
            call dfdm2j(nno, kp, idfde, zr(igeom), poids)
        else
            goto 9999
        endif
        if (poids .lt. 0.d0) nega=.true.
        if (poids .gt. 0.d0) posi=.true.
  1 end do
!
!
    if (posi .and. nega) then
        call tecael(iadzi, iazk24)
        nno=zi(iadzi-1+2)
        valk(1)=zk24(iazk24-1+3)
        valk(2)=zk24(iazk24-1+3+nno+1)
        call utmess('A', 'MAILLAGE1_1', nk=2, valk=valk)
        codret=1
    endif
!
9999 continue
    zi(icodr-1+1)=codret
!
end subroutine
