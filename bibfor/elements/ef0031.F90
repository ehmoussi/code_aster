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

subroutine ef0031(nomte)
    implicit none
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterfort/coqrep.h"
#include "asterfort/cosiro.h"
#include "asterfort/dxeffi.h"
#include "asterfort/dxefro.h"
#include "asterfort/dxqpgl.h"
#include "asterfort/dxtpgl.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/ppgan2.h"
#include "asterfort/tecach.h"
#include "asterfort/utpvgl.h"
    character(len=16) :: nomte
!     CALCUL DE EFGE_ELNO
!     ------------------------------------------------------------------
!
    integer :: ndim, nno, nnos, npg, ipoids, ivf, idfdx, jgano, ind
    integer :: icompo, ichn, jgeom, jcara, iret, icontp, ibid
!
    real(kind=8) :: pgl(3, 3), xyzl(3, 4), effgt(32), alpha, beta
    real(kind=8) :: t2iu(4), t2ui(4), c, s
!
!     ---> POUR DKT/DST EFFINT = 24
!     ---> POUR DKQ/DSQ EFFINT = 32
    real(kind=8) :: effint(32)
!
! DEB ------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,npg=npg,jpoids=ipoids,&
                     jvf=ivf,jdfde=idfdx,jgano=jgano)
!
! --- PASSAGE DES CONTRAINTES DANS LE REPERE INTRINSEQUE :
    call cosiro(nomte, 'PCONTRR', 'L', 'UI', 'G', ibid, 'S')
!
    call jevech('PGEOMER', 'L', jgeom)
    if (nno .eq. 3) then
        call dxtpgl(zr(jgeom), pgl)
    else if (nno.eq.4) then
        call dxqpgl(zr(jgeom), pgl, 'S', iret)
    endif
    call utpvgl(nno, 3, pgl, zr(jgeom), xyzl)
!
!
!
    call tecach('NNO', 'PCOMPOR', 'L', iret, iad=icompo)
    call jevech('PCONTRR', 'L', icontp)
    ind=8
    call dxeffi('EFGE_ELNO', nomte, pgl, zr(icontp), ind, effint)
!
    call jevech('PCACOQU', 'L', jcara)
    alpha = zr(jcara+1) * r8dgrd()
    beta  = zr(jcara+2) * r8dgrd()
    call coqrep(pgl, alpha, beta, t2iu, t2ui, c, s)
!
    call dxefro(npg, t2iu, effint, effgt)
    call jevech('PEFFORR', 'E', ichn)
    call ppgan2(jgano, 1, ind, effgt, zr(ichn))
!
end subroutine
