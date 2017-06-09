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

subroutine rccome(nommat, pheno, icodre, iarret, k11_ind_nomrc)
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/codent.h"
#include "asterfort/jelira.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    character(len=*), intent(in) :: nommat, pheno
    integer, intent(out) :: icodre
    integer, intent(in), optional :: iarret
    character(len=11), intent(out), optional :: k11_ind_nomrc
! ----------------------------------------------------------------------
!     OBTENTION DU COMPORTEMENT COMPLET D'UN MATERIAU DONNE A PARTIR
!     D'UN PREMISSE (C'EST L'INDICE DU PREMIER NOM QUI CONTIENT LA CHAINE 
!     CHERCHEE EST RETOURNE) 
!
!     ARGUMENTS D'ENTREE:
!        NOMMAT : NOM DU MATERIAU
!        PHENO  : NOM DU PHENOMENE EVENTUELLEMENT INCOMPLET 
!     ARGUMENTS DE SORTIE:
!        ICODRE : 0 SI ON A TROUVE, 1 SINON
!        IARRET : 0 RETOURNE LE CODE RETOUR ICODRE SANS EMISSION DE MESSAGE (PAR DEFAUT)
!                 1 EMISSION D'UNE ERREUR FATALE
!        INDI   : INDICE DE PHENO DANS nommat//'.MATERIAU.NOMRC
!  
! DEB ------------------------------------------------------------------
    character(len=32) :: ncomp
    character(len=6) :: k6
    integer :: i, icomp, nbcomp, iarret_in
!-----------------------------------------------------------------------
!
    if (present(iarret)) then
        iarret_in = iarret
    else
        iarret_in = 0
    endif
!
    ASSERT((iarret_in.eq.0) .or. (iarret_in.eq.1))
!
    icodre = 1
    ncomp = nommat//'.MATERIAU.NOMRC         '
    call jelira(ncomp, 'LONUTI', nbcomp)
    call jeveuo(ncomp, 'L', icomp)
    do i = 1, nbcomp 
        if (pheno .eq. zk32(icomp+i-1)(1:len(pheno))) then
            if (present(k11_ind_nomrc)) then
               call codent(i,'D0',k6)  
               k11_ind_nomrc='.CPT.'//k6
            endif   
            icodre = 0
        endif
    end do
    if (( icodre .eq. 1 ) .and. ( iarret_in .eq. 1 )) then
        call utmess('F', 'ELEMENTS2_63', sk=pheno)
    endif
! FIN ------------------------------------------------------------------
end subroutine
