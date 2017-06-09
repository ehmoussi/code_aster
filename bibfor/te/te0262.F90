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

subroutine te0262(option, nomte)
! aslint: disable=
    implicit none
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/matrot.h"
#include "asterfort/porigy.h"
#include "asterfort/rcvalb.h"
#include "asterfort/utmess.h"
#include "asterfort/utpplg.h"
!
    character(len=16) :: option, nomte
!     ------------------------------------------------------------------
!     ------------------------------------------------------------------
! IN  OPTION : K16 : NOM DE L'OPTION A CALCULER
!       'MECA_GYRO': CALCUL DE LA MATRICE DE RAIDEUR GYROSCOPIQUE
! IN  NOMTE  : K16 : NOM DU TYPE ELEMENT
!       'MECA_POU_D_E'  : POUTRE DROITE D'EULER       (SECTION VARIABLE)
!       'MECA_POU_D_T'  : POUTRE DROITE DE TIMOSHENKO (SECTION VARIABLE)
!       'MECA_POU_D_EM' : POUTRE DROITE MULTIFIBRE D EULER (SECT. CONST)
!       'MECA_POU_D_TG' : POUTRE DROITE DE TIMOSHENKO (GAUCHISSEMENT)
!       'MECA_POU_D_TGM': POUTRE DROITE DE TIMOSHENKO (GAUCHISSEMENT)
!                         MULTI-FIBRES (SECTION CONSTANTE)
!
!
    integer :: nbres, nl
    parameter (nbres=3,nl=144)
    real(kind=8) :: valres(nbres)
    integer :: codres(nbres)
    character(len=8) :: nompar, fami, poum
    character(len=16) :: nomres(nbres)
    real(kind=8) :: pgl(3, 3), klv(nl)
    real(kind=8) :: e, rho
    real(kind=8) :: valpar, xnu, zero
    integer :: imate, lmat, lorien
    integer :: nbpar, nno, kpg, spt
!     ------------------------------------------------------------------
    data nomres/'E','RHO','NU'/
!     ------------------------------------------------------------------
    zero = 0.d0
!     ------------------------------------------------------------------
!
!     --- CARACTERISTIQUES DES ELEMENTS
!
    if (nomte .eq. 'MECA_POU_D_E' .or. nomte .eq. 'MECA_POU_D_T' .or. nomte .eq.&
        'MECA_POU_D_EM') then
        nno = 2
    else
        call utmess('F', 'ELEMENTS2_42', sk=nomte)
    endif
!
!     --- RECUPERATION DES CARACTERISTIQUES MATERIAUX ---
!
    call jevech('PMATERC', 'L', imate)
!
    nbpar = 0
    nompar = ' '
    valpar = zero
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
    call rcvalb(fami, kpg, spt, poum, zi(imate),&
                ' ', 'ELAS', nbpar, nompar, [valpar],&
                nbres, nomres, valres, codres, 1)
    e = valres(1)
    rho = valres(2)
    xnu = valres(3)
!
    call jevech('PMATUNS', 'E', lmat)
!
!     --- RECUPERATION DES ORIENTATIONS ---
!
    call jevech('PCAORIE', 'L', lorien)
!
!     --- CALCUL DE LA MATRICE GYROSCOPIQUE LOCALE ---
    call porigy(nomte, rho, xnu, zi(imate), klv, nl)
!
    call matrot(zr(lorien), pgl)
!  CHANGEMENT DE BASE : LOCAL -> GLOBAL
    call utpplg(nno, 6, pgl, klv, zr(lmat))
!
end subroutine
