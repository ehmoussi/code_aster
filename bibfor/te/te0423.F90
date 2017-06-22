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

subroutine te0423(option, nomte)
    implicit  none
#include "jeveux.h"
#include "asterfort/dxbsig.h"
#include "asterfort/dxefg2.h"
#include "asterfort/dxqpgl.h"
#include "asterfort/dxtpgl.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/jevech.h"
#include "asterfort/utpvgl.h"
    character(len=16) :: option, nomte
! ......................................................................
!    - FONCTION REALISEE:  CALCUL DES VECTEURS ELEMENTAIRES
!                          POUR LES ELEMENTS DE PLAQUE GENERALISEE
!                          DKTG, DKQG, T3GG, Q4GG
!                          OPTIONS : 'CHAR_MECA_TEMP_R'
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ......................................................................
    integer :: ndim, nno, nnos, npg, ipoids, ivf, idfdx, jgano
    integer :: i, jgeom, jcaco, jvecg, iret
    real(kind=8) :: pgl(3, 3), xyzl(3, 4)
    real(kind=8) :: bsigma(24), sigt(32)
    character(len=16) :: optio2
! ----------------------------------------------------------------------
!
    call elrefe_info(fami='RIGI',ndim=ndim,nno=nno,nnos=nnos,npg=npg,jpoids=ipoids,&
                    jvf=ivf,jdfde=idfdx,jgano=jgano)
!
    call jevech('PGEOMER', 'L', jgeom)
    call jevech('PCACOQU', 'L', jcaco)
    call jevech('PVECTUR', 'E', jvecg)
!
! --- DETERMINATION DE LA MATRICE DE PASSAGE DU REPERE GLOBAL
! --- AU REPERE LOCAL A L'ELEMENT
!     ---------------------------
    if (nno .eq. 3) then
        call dxtpgl(zr(jgeom), pgl)
    else if (nno .eq. 4) then
        call dxqpgl(zr(jgeom), pgl, 'S', iret)
    endif
!
! --- DETERMINATION DES COORDONNEES DES CONNECTIVITES DE L'ELEMENT
! --- DANS SON REPERE LOCAL
!     ---------------------
    call utpvgl(nno, 3, pgl, zr(jgeom), xyzl)
!
! --- CALCUL DES EFFORTS GENERALISES D'ORIGINE THERMIQUE
! --- AUX POINTS D'INTEGRATION
!     ------------------------
!
    call dxefg2(pgl, sigt)
!
! --- CALCUL DES EFFORTS INTERNES D'ORIGINE THERMIQUE
! --- (I.E. SOMME_VOL(BT_SIG))
!     ------------------------
    optio2 = 'FORC_NODA'
    call dxbsig(nomte, xyzl, pgl, sigt, bsigma,&
                optio2)
!
! --- AFFECTATION DU VECTEUR DES FORCES ELEMENTAIRES EN SORTIE DU TE
!     --------------------------------------------------------------
    do i = 1, nno*6
        zr(jvecg+i-1) = bsigma(i)
    end do
!
end subroutine
