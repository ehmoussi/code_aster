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

subroutine bsthpl(nomte, bsigth, indith)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dxbsig.h"
#include "asterfort/dxefgt.h"
#include "asterfort/dxqpgl.h"
#include "asterfort/dxtpgl.h"
#include "asterfort/jevech.h"
#include "asterfort/utmess.h"
#include "asterfort/utpvgl.h"
    real(kind=8) :: bsigth(24)
    aster_logical :: indith
    character(len=16) :: nomte
!
!      CALCUL DU BSIGMA POUR LES CONTRAINTES THERMIQUES
!      (I.E. BT*D*ALPHA(T-TREF)) POUR LES ELEMENTS
!                                DE PLAQUE (DKT,DKQ,DST,DSQ,Q4G)
!     ------------------------------------------------------------------
!     IN  NOMTE  : NOM DU TYPE D'ELEMENT
!     OUT BSIGTH : BT*SIGMA POUR LES CONTRAINTES THERMIQUES
!     OUT INDITH : LOGICAL = .TRUE.  YA DES DEFORMATIONS THERMIQUES
!                          = .FALSE. SINON
!     ------------------------------------------------------------------
    integer :: i, jgeom, nno, iret
    real(kind=8) :: pgl(3, 3), xyzl(3, 4), sigth(32), zero
!     ------------------------------------------------------------------
!
! --- INITIALISATIONS :
!     ---------------
    zero = 0.0d0
    indith = .false.
!
    do 10 i = 1, 24
        bsigth(i) = zero
 10 end do
!
!
! --- RECUPERATION DES COORDONNEES DES NOEUDS DE L'ELEMENT :
!     ----------------------------------------------------
    call jevech('PGEOMER', 'L', jgeom)
!
    if (nomte .eq. 'MEDKTR3' .or. nomte .eq. 'MEDSTR3' .or. nomte .eq. 'MEDKTG3' .or. nomte&
        .eq. 'MET3TR3' .or. nomte .eq. 'MET3GG3') then
        nno = 3
        call dxtpgl(zr(jgeom), pgl)
        else if (nomte.eq.'MEDKQU4' .or.&
     &         nomte.eq.'MEDKQG4' .or.&
     &         nomte.eq.'MEDSQU4' .or.&
     &         nomte.eq.'MEQ4QU4' .or.&
     &         nomte.eq.'MEQ4GG4' ) then
        nno = 4
        call dxqpgl(zr(jgeom), pgl, 'S', iret)
    else
        call utmess('F', 'ELEMENTS_14', sk=nomte)
    endif
!
! --- DETERMINATION DES COORDONNEES LOCALES XYZL DES NOEUDS
! --- DE L'ELEMENT :
!     ------------
    call utpvgl(nno, 3, pgl, zr(jgeom), xyzl)
!
! --- CALCUL DES EFFORTS GENERALISES D'ORIGNIE THERMIQUE AUX POINTS
! --- D'INTEGRATION :
!     -------------
    call dxefgt(pgl, sigth)
!
! --- CALCUL DE BT*SIGTH :
!     ------------------
    call dxbsig(nomte, xyzl, pgl, sigth, bsigth,&
                'FORC_NODA')
!
!
end subroutine
