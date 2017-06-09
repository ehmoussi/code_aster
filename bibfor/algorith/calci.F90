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

subroutine calci(phib24, phi1j, bj, cij1)
    implicit none
!
! ROUTINE CALCULANT LA MASSE AJOUTEE SUR LE MODELE THERMIQUE
!                    D INTERFACE
! IN: POTENTIELS PHIBARRE ET PHI1
! OUT : CIJ1 :COEFFICIENT D'AMORTISSEMENT CORRESPONDANT AU POTENTIEL
! PHI1
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/mrmult.h"
#include "asterfort/mtdscr.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"
#include "blas/ddot.h"
    integer ::   imade, nphi1
    real(kind=8) :: cij1
    character(len=19) :: phib24, phi1j, bj
!--------------------------------------------------------------------
!
!-----------------------------------------------------------------------

    real(kind=8), pointer :: produit(:) => null()
    real(kind=8), pointer :: barre(:) => null()
    real(kind=8), pointer :: phi1(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    call jeveuo(phi1j//'.VALE', 'L', vr=phi1)
    call jeveuo(phib24//'.VALE', 'L', vr=barre)
    call jelira(phi1j//'.VALE', 'LONMAX', nphi1)
!
    AS_ALLOCATE(vr=produit, size=nphi1)
!
! --- RECUPERATION DES DESCRIPTEURS DE MATRICE ASSEMBLEE MADE
!
    call mtdscr(bj)
    call jeveuo(bj(1:19)//'.&INT', 'E', imade)
!
! ---PRODUIT MATRICE BJ ET LE VECTEUR POTENTIEL PHI1J
!
    call mrmult('ZERO', imade, phi1, produit, 1,&
                .true._1)
!
!
!--PRODUITS SCALAIRES VECTEURS  PHI1J PAR LE VECTEUR RESULTAT PRECEDENT
!
    cij1= ddot(nphi1,barre, 1,produit, 1)
!
!---------------- MENAGE SUR LA VOLATILE ---------------------------
!
    AS_DEALLOCATE(vr=produit)
!
    call jedema()
end subroutine
