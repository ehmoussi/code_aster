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

subroutine te0464(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/infdis.h"
#include "asterfort/jevech.h"
#include "asterfort/matrot.h"
#include "asterfort/utmess.h"
#include "asterfort/utpplg.h"
!
    character(len=16) :: option, nomte
!     CALCUL DES MATRICES D'AMORTISSEMENT GYROSCOPIQUE
!     DES ELEMENTS DISCRETS :
!                             MECA_DIS_TR_N
!     ------------------------------------------------------------------
! IN  : OPTION : NOM DE L'OPTION A CALCULER
! IN  : NOMTE  : NOM DU TYPE_ELEMENT
!     ------------------------------------------------------------------
!     ------------------------------------------------------------------
!
    integer :: nddlm, nl, ipoint, lorien
    parameter     (nddlm=6,nl=nddlm*nddlm)
    integer :: i, nc, nno, jdm, jdc, j, infodi, ibid
    real(kind=8) :: vxx, r8bid, pgl(3, 3), klv(nl)
    character(len=8) :: k8bid
!
!     ------------------------------------------------------------------
!
    if (nomte .eq. 'MECA_DIS_TR_N') then
!        ON VERIFIE QUE LES CARACTERISTIQUES ONT ETE AFFECTEES
!        LE CODE DU DISCRET
        call infdis('CODE', ibid, r8bid, nomte)
!        LE CODE STOKE DANS LA CARTE
        call infdis('TYDI', infodi, r8bid, k8bid)
        if (infodi .ne. ibid) then
            call utmess('F+', 'DISCRETS_25', sk=nomte)
            call infdis('DUMP', ibid, r8bid, 'F+')
        endif
!        DISCRET DE TYPE MASSE
        call infdis('DISM', infodi, r8bid, k8bid)
        if (infodi .eq. 0) then
            call utmess('A+', 'DISCRETS_26', sk=nomte)
            call infdis('DUMP', ibid, r8bid, 'A+')
        endif
        nc = 6
    else
        call utmess('F', 'CALCULEL_17')
    endif
!     OPTION DE CALCUL INVALIDE
    if (option .ne. 'RIGI_GYRO') then
        ASSERT(.false.)
    endif
!
    call infdis('SYMM', infodi, r8bid, k8bid)
    call jevech('PCADISM', 'L', jdc)
    if (infodi .eq. 1) then
        vxx = zr(jdc+10-1)
    else if (infodi.eq.2) then
        vxx = zr(jdc+22-1)
    endif
    call jevech('PMATUNS', 'E', jdm)
!
    do 60 i = 1, nl
        klv(i)=0.d0
 60 end do
!
!     I : LIGNE ; J : COLONNE
    i = 5
    j = 6
    ipoint = nc*(j-1) + i
    klv(ipoint) = vxx
!
    call jevech('PCAORIE', 'L', lorien)
    call matrot(zr(lorien), pgl)
    nno = 1
    call utpplg(nno, nc, pgl, klv, zr(jdm))
!
end subroutine
