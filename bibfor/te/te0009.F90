! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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

subroutine te0009(option, nomte)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/infdis.h"
#include "asterfort/jevech.h"
#include "asterfort/matrot.h"
#include "asterfort/upletr.h"
#include "asterfort/utmess.h"
#include "asterfort/utpalg.h"
#include "asterfort/utpsgl.h"
#include "asterfort/utppgl.h"
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
    integer :: nddlm, nl1, ipoint, lorien
    parameter     (nddlm=6,nl1=(nddlm+1)*nddlm/2)
    integer :: i, nc, nno, jdm, jdc, j, infodi, ibid, irep, indvxx
    real(kind=8) :: vxx, r8bid, pgl(3, 3), klv(nl1), klw(nl1)
    real(kind=8) :: vml(36)
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
!       type de repere
        call infdis('REPM', irep, r8bid, k8bid)
        nno = 1
        nc = 6
    else
        call utmess('F', 'CALCULEL_17')
    endif
!     OPTION DE CALCUL INVALIDE
    if (option .ne. 'MECA_GYRO') then
        ASSERT(.false.)
    endif
!
    call infdis('SYMM', infodi, r8bid, k8bid)
    call jevech('PCADISM', 'L', jdc)
    call jevech('PCAORIE', 'L', lorien)
    call matrot(zr(lorien), pgl)
!
!   passage dans le repère local
    if (irep.eq.1) then
        if (infodi .eq. 1) then
            call utpsgl(nno, nc, pgl, zr(jdc), vml)
            indvxx = 10
        else
            call utppgl(nno, nc, pgl, zr(jdc), vml)
            indvxx = 22
        endif
        vxx = vml(indvxx)
    else
        if (infodi .eq. 1) then
            indvxx = 10
        else if (infodi.eq.2) then
            indvxx = 22
        endif
        vxx = zr(jdc+indvxx-1)
    endif
    call jevech('PMATUNS', 'E', jdm)
!
    do 60 i = 1, nl1
        klv(i)=0.d0
 60 end do
!
!     I : LIGNE ; J : COLONNE
    i = 5
    j = 6
    ipoint = int(j*(j-1)/2)+i
    klv(ipoint) = -vxx
!
    call utpalg(nno, nc, pgl, klv, klw)
    call upletr(nddlm, zr(jdm), klw)
!
end subroutine
