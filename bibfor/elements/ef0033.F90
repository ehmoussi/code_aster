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

subroutine ef0033(nomte)
    implicit  none
#include "jeveux.h"
#include "asterc/r8dgrd.h"
#include "asterfort/coqrep.h"
#include "asterfort/dxefgv.h"
#include "asterfort/dxefro.h"
#include "asterfort/dxqpgl.h"
#include "asterfort/dxtpgl.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/r8inir.h"
#include "asterfort/utpvgl.h"
    character(len=16) :: nomte
!     CALCUL DE EFGE_ELNO EN LINEAIRE
!     ------------------------------------------------------------------
    integer :: ndim, nno, nnos, npg, ipoids, ivf, idfdx, jgano
    integer :: iret, jcara
    integer :: jdepg, jeffg, jgeom
    integer :: np
!
    real(kind=8) :: alpha, beta
    real(kind=8) :: pgl(3, 3), xyzl(3, 4)
    real(kind=8) :: depl(24)
    real(kind=8) :: effgt(32)
    real(kind=8) :: t2iu(4), t2ui(4), c, s
!
    character(len=4) :: fami
!     ------------------------------------------------------------------
!
!
    fami='NOEU'
    call elrefe_info(fami=fami,ndim=ndim,nno=nno,nnos=nnos,npg=npg,jpoids=ipoids,&
                    jvf=ivf,jdfde=idfdx,jgano=jgano)
!
!
    call r8inir(32, 0.d0, effgt, 1)
!
    call jevech('PGEOMER', 'L', jgeom)
!
    np=nno
!
    if (nno .eq. 3) then
        call dxtpgl(zr(jgeom), pgl)
    else if (nno.eq.4) then
        call dxqpgl(zr(jgeom), pgl, 'S', iret)
    endif
!
    call utpvgl(nno, 3, pgl, zr(jgeom), xyzl)
!
    call jevech('PCACOQU', 'L', jcara)
    alpha = zr(jcara+1) * r8dgrd()
    beta  = zr(jcara+2) * r8dgrd()
    call coqrep(pgl, alpha, beta, t2iu, t2ui, c, s)
!
    call jevech('PDEPLAR', 'L', jdepg)
    call utpvgl(nno, 6, pgl, zr(jdepg), depl)
!
!
! --- CALCUL DES EFFORTS GENERALISES VRAIS AUX POINTS DE CALCUL
    call dxefgv(nomte, 'EFGE_ELNO', xyzl, pgl, depl, effgt)
!
! ---   PASSAGE DES EFFORTS GENERALISES DU REPERE INTRINSEQUE
! ---   A L'ELEMENT AU REPERE LOCAL DE LA COQUE
!       ---------------------------------------
    call jevech('PEFFORR', 'E', jeffg)
    call dxefro(np, t2iu, effgt, zr(jeffg))
!
end subroutine
