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

subroutine te0063(nomopt, nomte)
!
!
implicit none
    character(len=16) :: nomte, nomopt
!
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/tpsivp.h"
#include "asterfort/tecach.h"
!
! --------------------------------------------------------------------------------------------------
!
!                           Passage des PSIEFR d'un repère vers un autre
!
!       Matrice de passage donnée par PMATPASS
!           PMATPASS(0)     Type de passage
!                                   0.5 : matrice constante par éléments
!           PMATPASS(1..9)  Matrice de passage
!
! --------------------------------------------------------------------------------------------------
!
    integer :: nbsig
    parameter (nbsig=6)
!
    integer :: jsiefr, jmatpas, jcontpr, iret, kpg, ksp, iposin, iposout
    integer :: nbpg, nbspoint,  itabp(7), nbcmp
    real(kind=8) :: pglul(3,3), sigma(nbsig)
!
! --------------------------------------------------------------------------------------------------
!
!   Champs en entrée
    call jevech('PSIEFR',   'L', jsiefr)
    call jevech('PMATPASS', 'L', jmatpas)
!   Champ en sortie
    call tecach('ONO', 'PCONTPR', 'E', iret, nval=7,itab=itabp)
    jcontpr  = itabp(1)
    nbspoint = itabp(7)
!   Vérification du nombre de composante dans le champ
    nbcmp = itabp(2)/itabp(3)
    ASSERT( nbcmp .eq. nbsig )
!
!   Nombre de point de gauss
    call elrefe_info(fami='RIGI',npg=nbpg)
!   Vérification que la matrice est la bonne
    ASSERT( (0.0d0.lt.zr(jmatpas)) .and. (zr(jmatpas).lt.1.0d0) )
!   Décompactage de la matrice de passage : option REPERE_LOCAL
    pglul(1,1) = zr(jmatpas+1)
    pglul(2,1) = zr(jmatpas+2)
    pglul(3,1) = zr(jmatpas+3)
    pglul(1,2) = zr(jmatpas+4)
    pglul(2,2) = zr(jmatpas+5)
    pglul(3,2) = zr(jmatpas+6)
    pglul(1,3) = zr(jmatpas+7)
    pglul(2,3) = zr(jmatpas+8)
    pglul(3,3) = zr(jmatpas+9)
!   Boucle sur les sous-points des points de gauss
    do kpg = 1 , nbpg
        do ksp = 1, nbspoint
            iposin = jsiefr + (kpg-1)*nbspoint*nbsig + (ksp-1)*nbsig
            sigma(:) = zr(iposin:iposin+nbsig-1)
!           Calcul de P^t.Sigma.P
            call tpsivp(pglul, sigma)
            iposout = jcontpr + (kpg-1)*nbspoint*nbsig + (ksp-1)*nbsig
            zr(iposout:iposout+nbsig-1) = sigma(:)
        enddo
    enddo
end subroutine
