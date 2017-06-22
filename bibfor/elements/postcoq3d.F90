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

subroutine postcoq3d(option, nomte,nbcou)
    implicit none
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/jevete.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "asterfort/vdefro.h"
#include "asterfort/vdrepe.h"
#include "asterfort/vdsiro.h"
#include "asterfort/vdxedg.h"
#include "asterfort/vdxsig.h"

!
    character(len=16) :: option, nomte
!     ----------------------------------------------------------------
!     CALCUL DES OPTIONS DES ELEMENTS DE COQUE 3D
!                EPSI_ELGA
!                SIEF_ELGA
!                DEGE_ELGA
!                DEGE_ELNO
!
    integer :: npgt
!-----------------------------------------------------------------------
    integer ::  icontr, jgeom, lzi
    integer :: nbcou, npgsn, npgsr
!-----------------------------------------------------------------------
    parameter(npgt=10)    
    integer :: nb1, itab(7), iret
    real(kind=8) :: effgt(8, 9), sigpg(162*nbcou)
    real(kind=8) :: edgpg(72), defgt(72)
    real(kind=8) :: matevn(2, 2, npgt), matevg(2, 2, npgt)
    sigpg=0.0d0
! DEB
!
    call jevech('PGEOMER', 'L', jgeom)
    call jevete('&INEL.'//nomte(1:8)//'.DESI', ' ', lzi)
    npgsn=zi(lzi-1+4)


    if (option(1:9) .eq. '         ') then
        call utmess('F', 'CALCULEL7_5', sk=option, si=nbcou)
    endif
!     LE TABLEAU SIGPG A ETE ALLOUE DE FACON STATIQUE POUR OPTIMISER
!     LE CPU CAR LES APPELS A WKVECT DANS LES TE SONT COUTEUX.
!
    if (option(1:9) .eq. 'DEGE_ELGA' .or. option(1:9) .eq. 'DEGE_ELNO') then
        call vdxedg(nomte, option, zr(jgeom), nb1, npgsr,&
                    edgpg, defgt)
    else
        call vdxsig(nomte, option, zr(jgeom), nb1, npgsr,&
                    sigpg, effgt, nbcou)
    endif

!
! --- DETERMINATION DES MATRICES DE PASSAGE DES REPERES INTRINSEQUES
! --- AUX NOEUDS ET AUX POINTS D'INTEGRATION DE L'ELEMENT
! --- AU REPERE UTILISATEUR :
!     ---------------------
    call vdrepe(nomte, matevn, matevg)
    if (option(1:9) .eq. 'EPSI_ELGA') then
        call tecach('OOO', 'PDEFOPG', 'E', iret, nval=7,&
                    itab=itab)
        icontr=itab(1)
!
! ----- STOCKAGE DU VECTEUR DES DEFORMATIONS
! ----- 1 COUCHE - 3 PTS DANS L'EPAISSEUR
!------ 162 = NPGSN*6(6 DEFORMATIONS STOCKEES)*NPGE
!       ------------------------------------------------------
!
!
! ---   PASSAGE DES DEFORMATIONS DANS LE REPERE UTILISATEUR :
        call vdsiro(itab(3), itab(7), matevg, 'IU', 'G',&
                    sigpg, zr( icontr))
!
!
    else if (option(1:9) .eq. 'SIEF_ELGA') then
        call tecach('OOO', 'PCONTRR', 'E', iret, nval=7,&
                    itab=itab)
        icontr=itab(1)
!
! ----- STOCKAGE DU VECTEUR DES CONTRAINTES EN ELASTICITE
! ----- 1 COUCHE - 3 PTS DANS L'EPAISSEUR
!------ 162 = NPGSN*6(6 CONTRAINTES STOCKEES)*NPGE
!       ------------------------------------------------------
!
! ---   PASSAGE DES CONTRAINTES DANS LE REPERE UTILISATEUR :
        call vdsiro(itab(3), itab(7), matevg, 'IU', 'G',&
                    sigpg, zr( icontr))
!
!
    else if (option(1:9) .eq. 'DEGE_ELGA') then
        call tecach('OOO', 'PDEFOPG', 'E', iret, nval=7,&
                    itab=itab)
        icontr=itab(1)
!
! ---   PASSAGE DES DEFORMATIONS DANS LE REPERE UTILISATEUR
!       ET STOCKAGE DES DEFORMATIONS:
!
        call vdefro(npgsn, matevn, edgpg, zr(icontr))
!
    else if (option(1:9) .eq. 'DEGE_ELNO') then
        call tecach('OOO', 'PDEFOGR', 'E', iret, nval=7,&
                    itab=itab)
        icontr=itab(1)
!
! ---   PASSAGE DES DEFORMATIONS DANS LE REPERE UTILISATEUR
!       ET STOCKAGE DES DEFORMATIONS:
!
        call vdefro((nb1+1), matevn, defgt, zr(icontr))
!
    endif
!
end subroutine
