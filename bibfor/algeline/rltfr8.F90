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

subroutine rltfr8(nommat, neq, xsol, nbsol, typsym)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mlnmin.h"
#include "asterfort/mltdra.h"
#include "asterfort/rlbfr8.h"
#include "asterfort/wkvect.h"
    integer :: neq, nbsol, typsym
!
    character(len=*) :: nommat
    real(kind=8) :: xsol(neq, *)
!     ------------------------------------------------------------------
! person_in_charge: olivier.boiteau at edf.fr
!     RESOLUTION DU SYSTEME A COEFFICIENTS REELS:  A * X = B
!     LA MATRICE EST SYMETRIQUE ET A ETE FACTORISEE SOUS FORME L*D*LT
!     LA RESOLUTION EST EN PLACE
!
!     ON PEUT RESOUDRE SUR UNE SOUS-MATRICE DE A :
!     ON PREND LES NEQ PREMIERES LIGNES ET COLONNES (NEQ PEUT ETRE
!     INFERIEUR A LA DIMENSION DE LA MATRICE).
!
!     ON PEUT RESOUDRE NBSOL SYSTEMES D'UN COUP A CONDITION
!     QUE LES VECETURS SOIENT CONSECUTIFS EN MEMOIRE :
!     XSOL EST UN VECTEUR DE NBSOL*NEQ REELS
!     ------------------------------------------------------------------
!
! IN  NOMMAT  :    : NOM UTILISATEUR DE LA MATRICE A FACTORISER
! IN  NEQ     : IS : NOMBRE D'EQUATIONS PRISES EN COMPTE
!                    C'EST AUSSI LA DIMENSION DES VECTEURS XSOL.
! VAR XSOL    : R8 : EN ENTREE LES SECONDS MEMBRES
!                    EN SORTIE LES SOLUTIONS
! IN  NBSOL   : IS : NOMBRE DE SOLUTIONS / SECONDS MEMBRES
!     ------------------------------------------------------------------
!     ------------------------------------------------------------------
!
!     ------------------------------------------------------------------
    character(len=24) :: factol, factou
    character(len=24) :: nomp01, nomp02, nomp03, nomp04, nomp05, nomp06, nomp07
    character(len=24) :: nomp08, nomp09, nomp10, nomp11, nomp12, nomp13, nomp14
    character(len=24) :: nomp15, nomp16, nomp17, nomp18, nomp19, nomp20
!     -------------------------------------------------- POINTEURS
    integer :: pointr, desc
    integer :: nouv, anc, supnd
    integer :: seq, adress, lgsn
    integer :: decal, global
    integer :: ncbloc, lgbloc, nbloc, nbsn, ad, trav
    integer :: i
    character(len=14) :: nu
!
!     ------------------------------------------------------------------
    data factol/'                   .VALF'/
    data factou/'                   .WALF'/
!     ------------------------------------------------------------------
    call jemarq()
!
!     -- SI NBSOL EST SUFFISAMMENT GRAND, ON GAGNE DU TEMPS A UTILISER
!        LA RESOLUTION PAR BLOCS :
    if (nbsol .gt. 4) then
        call rlbfr8(nommat, neq, xsol, nbsol, typsym)
        goto 999
    endif
!
    call dismoi('NOM_NUME_DDL', nommat, 'MATR_ASSE', repk=nu)
    factol(1:19) = nommat
    factou(1:19) = nommat
    call mlnmin(nu, nomp01, nomp02, nomp03, nomp04,&
                nomp05, nomp06, nomp07, nomp08, nomp09,&
                nomp10, nomp11, nomp12, nomp13, nomp14,&
                nomp15, nomp16, nomp17, nomp18, nomp19,&
                nomp20)
!
!                                ALLOCATION DES POINTEURS ENTIERS
    call jeveuo(nomp01, 'L', desc)
    call jeveuo(nomp03, 'L', adress)
    call jeveuo(nomp04, 'L', supnd)
    call jeveuo(nomp20, 'L', seq)
    call jeveuo(nomp16, 'L', lgbloc)
    call jeveuo(nomp17, 'L', ncbloc)
    call jeveuo(nomp18, 'L', decal)
    call jeveuo(nomp08, 'L', lgsn)
    call jeveuo(nomp14, 'L', anc)
    call jeveuo(nomp19, 'L', nouv)
    call jeveuo(nu//'.MLTF.GLOB', 'L', global)
!
    nbsn = zi(desc+1)
    nbloc= zi(desc+2)
!                               ALLOCATION TABLEAU REEL PROVISOIRE
    call wkvect('&&RLTFR8.POINTER.REELS  ', 'V V R', neq, pointr)
    call wkvect('&&RLTFR8.POINTER.ADRESSE', 'V V I', neq, ad)
    call wkvect('&&RLTFR8.POINTER.TRAVAIL', 'V V R', neq, trav)
!
    do i = 1, nbsol
        call mltdra(nbloc, zi(lgbloc), zi(ncbloc), zi(decal), zi(seq),&
                    nbsn, neq, zi(supnd), zi(adress), zi4(global),&
                    zi(lgsn), factol, factou, xsol(1, i), zr(pointr),&
                    zi(nouv), zi(anc), zi(ad), zr(trav), typsym)
    end do
!
    call jedetr('&&RLTFR8.POINTER.ADRESSE')
    call jedetr('&&RLTFR8.POINTER.TRAVAIL')
    call jedetr('&&RLTFR8.POINTER.REELS  ')
!
999 continue
    call jedema()
!
end subroutine
