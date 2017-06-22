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

subroutine ddlphy(depplu, neq, vect, desc)
!
! person_in_charge: ludovic.idoux at edf.fr
! ----------------------------------------------------------------------
!     CALCUL DES ENERGIES
! ----------------------------------------------------------------------
!  IN      : DEPPLU   : VECTEUR DES INCONNUS
!  IN      : NEQ      : DIMENSION DU VECTEUR
!  IN/OUT  : VECT     : EN ENTREE : VECTEUR COMPLET
!                       EN SORTIE : LES DDL NON PHYSIQUES SONT A ZERO
!  OUT     : DESC     : DESCRIPTEUR DES COMPOSANTES
!
! CORPS DU PROGRAMME
    implicit none
! DECLARATION PARAMETRES D'APPELS
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/iposdg.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jexnom.h"
#include "asterfort/jexnum.h"
#include "asterfort/wkvect.h"
!
    real(kind=8) :: vect(*)
    character(len=19) :: depplu
    character(len=8) :: desc(*)
    integer :: neq
!
!
! DECLARATION VARIABLES LOCALES
!
    character(len=8) :: nomgd, noma, exclus(200)
    character(len=19) :: prno
    integer :: iaux, jnocmp, ncmpmx, jprno, nec
    integer :: jdg, inueq, jaux, kaux
    integer :: nbnot
    integer :: nbexcl, ival, pos, ivect2
    aster_logical :: garder
    integer, pointer :: nueq(:) => null()
!
    call jemarq()
!
    do iaux = 1, 200
        exclus(iaux)=' '
    end do
    call wkvect('VECTMP', 'V V R', neq, ivect2)
    do iaux = 1, neq
        zr(ivect2-1+iaux)=vect(iaux)
        vect(iaux)=0.d0
        desc(iaux)=' '
    end do
    call dismoi('NOM_GD', depplu, 'CHAM_NO', repk=nomgd)
    call jeveuo(jexnom('&CATA.GD.NOMCMP', nomgd), 'L', jnocmp)
    call dismoi('NB_CMP_MAX', nomgd, 'GRANDEUR', repi=ncmpmx)
    call dismoi('PROF_CHNO', depplu, 'CHAM_NO', repk=prno)
    call jeveuo(jexnum(prno//'.PRNO', 1), 'L', jprno)
    call jeveuo(prno//'.NUEQ', 'L', vi=nueq)
    call dismoi('NB_EC', nomgd, 'GRANDEUR', repi=nec)
    call dismoi('NOM_MAILLA', depplu, 'CHAM_NO', repk=noma)
    call dismoi('NB_NO_MAILLA', noma, 'MAILLAGE', repi=nbnot)
    nbexcl=0
!
    do iaux = 1, nbnot
!       DEBUT DU DESCRIPTEUR GRANDEUR DU NOEUD
        jdg = jprno - 1 + (iaux-1)*(2+nec) + 1 + 2
!       INDIRECTION VERS LE .NUEQ
        inueq = zi(jprno - 1 + (iaux-1)*(2+nec) + 1)
!       POSITIONS DES DDL PHYSIQUES DANS LE DG
        do jaux = 1, ncmpmx
            pos = iposdg(zi(jdg),jaux)
            if (pos .ne. 0) then
!           A EXCLURE OU CONSERVER
                garder=.true.
                do kaux = 1, nbexcl
                    if (exclus(kaux) .eq. zk8(jnocmp-1+jaux)) then
                        garder=.false.
                    endif
                end do
!           ADRESSE DU DDL DANS LE .VALE
                ival = nueq(inueq - 1 + pos)
                desc(ival) = zk8(jnocmp-1+jaux)
                if (garder) then
                    vect(ival) = zr(ivect2-1+ival)
                endif
            endif
        end do
    end do
!
    call jedetr('VECTMP')
!
    call jedema()
!
end subroutine
