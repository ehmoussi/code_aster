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

subroutine ef0410(nomte)
!     CALCUL DE EFGE_ELNO
!     ------------------------------------------------------------------
    implicit none
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/jevete.h"
#include "asterfort/utmess.h"
#include "asterfort/vdefro.h"
#include "asterfort/vdrepe.h"
#include "asterfort/vdxsig.h"
!
    character(len=16) :: nomte
!
    integer :: npgt, ncoumx
!-----------------------------------------------------------------------
    integer :: jcou, jeffg, jgeom, lzi, nb2
    integer :: nbcou, np, npgsr
!-----------------------------------------------------------------------
    parameter(npgt=10,ncoumx=50)
    integer :: nb1
    real(kind=8) :: effgt(8, 9), sigpg(162*ncoumx)
    real(kind=8) :: matevn(2, 2, npgt), matevg(2, 2, npgt)
! DEB
!
!
    call jevech('PGEOMER', 'L', jgeom)
    call jevete('&INEL.'//nomte(1:8)//'.DESI', ' ', lzi)
    nb2=zi(lzi-1+2)
!
    call jevech('PNBSP_I', 'L', jcou)
    nbcou=zi(jcou)
!
!     LE TABLEAU SIGPG A ETE ALLOUE DE FACON STATIQUE POUR OPTIMISER
!     LE CPU CAR LES APPELS A WKVECT DANS LES TE SONT COUTEUX.
    call vdxsig(nomte, 'EFGE_ELNO', zr(jgeom), nb1, npgsr,&
                sigpg, effgt,nbcou)
!
! --- DETERMINATION DES MATRICES DE PASSAGE DES REPERES INTRINSEQUES
! --- AUX NOEUDS ET AUX POINTS D'INTEGRATION DE L'ELEMENT
! --- AU REPERE UTILISATEUR :
!     ---------------------
    call vdrepe(nomte, matevn, matevg)
    call jevech('PEFFORR', 'E', jeffg)
!
!     CES CHAMPS SONT CALCULES AUX NB2 NOEUDS
!
    np=nb2
!
! --- PASSAGE DU VECTEUR DES EFFORTS GENERALISES OU DU VECTEUR
! --- DES DEFORMATIONS-COURBURES DEFINI AUX NOEUDS
! --- DE L'ELEMENT DU REPERE INTRINSEQUE AU REPERE UTILISATEUR :
!     --------------------------------------------------------
    call vdefro(np, matevn, effgt, zr(jeffg))
!
!
end subroutine
