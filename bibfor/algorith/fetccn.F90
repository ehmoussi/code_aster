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

subroutine fetccn(chamn1, chamn2, chamn3, chamn4, typcum,&
                  chamnr)
!    - FONCTION REALISEE:  CONCATENATION DE CHAM_NOS EN UN SEUL.
!      POUR GAGNER DU TEMPS AUCUN TEST D'HOMOGENEITE N'EST EFFECTUE. ILS
!      SONT NORMALEMENT FAITS (ET REFAITS !) EN AMONT.
!
! IN CHAMN1/4 : CHAM_NOS A CONCATENER
! IN TYPCUM   : TYPE DE CUMUL
! OUT CHAMNR  : CHAM_NO RESULTAT
!----------------------------------------------------------------------
! person_in_charge: olivier.boiteau at edf.fr
! CORPS DU PROGRAMME
    implicit none
!
! DECLARATION PARAMETRES D'APPELS
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/infniv.h"
#include "asterfort/jedema.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utimsd.h"
!
    integer :: typcum
    character(len=19) :: chamn1, chamn2, chamn3, chamn4, chamnr
!
!
! DECLARATION VARIABLES LOCALES
    integer :: nbval, k, j1, j2, j3, j4, jr
    integer :: ifm, niv
    character(len=5) :: vale
    character(len=19) :: cham1b, cham2b, cham3b, cham4b, chamrb
!
! CORPS DU PROGRAMME
    call jemarq()
! RECUPERATION ET MAJ DU NIVEAU D'IMPRESSION
    call infniv(ifm, niv)
!
! INIT.
    vale='.VALE'
!
!
!
! DOMAINE GLOBAL
    cham1b=chamn1
    cham2b=chamn2
    cham3b=chamn3
    cham4b=chamn4
    chamrb=chamnr
    if (typcum .gt. 0) call jeveuo(cham1b//vale, 'L', j1)
    if (typcum .gt. 1) call jeveuo(cham2b//vale, 'L', j2)
    if (typcum .gt. 2) call jeveuo(cham3b//vale, 'L', j3)
    if (typcum .gt. 3) call jeveuo(cham4b//vale, 'L', j4)
    call jeveuo(chamrb//vale, 'E', jr)
    call jelira(chamrb//vale, 'LONMAX', nbval)
    nbval=nbval-1
!
!----------------------------------------------------------------------
! ----- BOUCLE SUR LES .VALE SELON LES TYPES DE CUMUL
!----------------------------------------------------------------------
!
    if (typcum .eq. 0) then
        do k = 0, nbval
            zr(jr+k) = 0.d0
        end do
    else if (typcum.eq.1) then
        do k = 0, nbval
            zr(jr+k) = zr(j1+k)
        end do
    else if (typcum.eq.2) then
        do k = 0, nbval
            zr(jr+k) = zr(j1+k) + zr(j2+k)
        end do
    else if (typcum.eq.3) then
        do k = 0, nbval
            zr(jr+k) = zr(j1+k) + zr(j2+k) + zr(j3+k)
        end do
    else if (typcum.eq.4) then
        do k = 0, nbval
            zr(jr+k) = zr(j1+k) + zr(j2+k) + zr(j3+k) + zr(j4+ k)
        end do
    else
        ASSERT(.false.)
    endif
!
    call jedema()
end subroutine
