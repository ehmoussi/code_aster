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

subroutine te0428(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/dkqrge.h"
#include "asterfort/dktrge.h"
#include "asterfort/dxqpgl.h"
#include "asterfort/dxtpgl.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/utpslg.h"
#include "asterfort/utpvgl.h"
    character(len=16) :: option, nomte

!
! ajout elements
!
!    calcul de la matrice de rigidite geometrique des elements de plaque
!       => option rigi_meca_ge
!
    integer :: ndim, nno, nnos, npg, ipoids, ivf, idfdx, jgano
    integer :: jgeom, jmatr, iret
    real(kind=8) :: pgl(3, 3), xyzl(3, 4)
!
!     ---> pour dkt/dktg  matelem = 3 * 6 ddl = 171 termes stockage syme
!     ---> pour dkq/dkqg  matelem = 4 * 6 ddl = 300 termes stockage syme
!
    real(kind=8) :: matloc(300)
!
! deb ------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,&
  npg=npg,jpoids=ipoids,jvf=ivf,jdfde=idfdx,jgano=jgano)
!
    call jevech('PGEOMER', 'L', jgeom)
!
! --- calcul de la matrice de passage du repere global --> intrinseque
!
    if (nno .eq. 3) then
        call dxtpgl(zr(jgeom), pgl)
    else if (nno.eq.4) then
        call dxqpgl(zr(jgeom), pgl, 'S', iret)
    endif
!
    call utpvgl(nno, 3, pgl, zr(jgeom), xyzl)
!
    if (option .eq. 'RIGI_MECA_GE') then
!     --------------------------------------
!
        if ((nomte.eq.'MEDKTR3') .or. (nomte.eq.'MEDKTG3')) then
            call dktrge(nomte, xyzl, pgl, matloc)
        else if ((nomte.eq.'MEDKQU4').or.(nomte.eq.'MEDKQG4')) then
            call dkqrge(nomte, xyzl, pgl, matloc)
        else
! type d element invalide
            ASSERT(.false.)
        endif
!
! - stockage
!
        call jevech('PMATUUR', 'E', jmatr)
        call utpslg(nno, 6, pgl, matloc, zr(jmatr))
    else
!
! option de calcul invalide
!
        ASSERT(.false.)
    endif
!
end
