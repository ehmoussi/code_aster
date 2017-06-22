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

subroutine xlenri(noma, fiss, goinop, lismae, lisnoe)
!
!
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvem.h"
#include "asterfort/jedema.h"
#include "asterfort/jedupo.h"
#include "asterfort/jemarq.h"
#include "asterfort/reliem.h"
#include "asterfort/wkvect.h"
    character(len=8) :: fiss, noma
    character(len=24) :: lismae, lisnoe
    aster_logical :: goinop
!
! ----------------------------------------------------------------------
!
! ROUTINE XFEM (CREATION DES SD)
!
! LECTURE DONNEES GROUP_MA_ENRI
!
! ----------------------------------------------------------------------
!
!
! OUT FISS   : NOM DE LA SD FISS_XFEM
!                 FISS//'.GROUP_MA_ENRI'
!                 FISS//'.GROUP_NO_ENRI'
! IN  NOMA   : NOM DU MAILLAGE
! IN  GOINOP : .TRUE.  SI  PASSAGE DANS OPOO10
!              .FALSE. SINON
! OUT LISMAE : NOM DE LA LISTE DES MAILLES ENRICHIES
! OUT LISNOE : NOM DE LA LISTE DES NOEUDS ENRICHIS
!
!
!
!
    integer :: nbmae, nbnoe, n, jmae, jnoe, i
    character(len=8) :: k8b
    integer :: iarg
!
! ----------------------------------------------------------------------
!
    call jemarq()
    k8b=' '
!
!     RECUPERATION DU MOT-CLE FACULTATIF GROUP_MA_ENRI
!     (GOINOP PERMET DE DISTINGUER OP0041 et OP0010)
    if (.not.goinop) then
        call getvem(noma, 'GROUP_MA', ' ', 'GROUP_MA_ENRI', 1,&
                    iarg, 0, k8b, n)
    else
        n=0
    endif
!
    if (n .eq. 0) then
!
!       GROUP_MA_ENRI N'EST PAS RENSEIGNE : ON PREND TOUT LE MAILLAGE
!
        call dismoi('NB_MA_MAILLA', noma, 'MAILLAGE', repi=nbmae)
        call dismoi('NB_NO_MAILLA', noma, 'MAILLAGE', repi=nbnoe)
!
        call wkvect(lismae, 'V V I  ', nbmae, jmae)
        call wkvect(lisnoe, 'V V I  ', nbnoe, jnoe)
!
        do i = 1, nbmae
            zi(jmae-1+i)=i
        end do
!
        do i = 1, nbnoe
            zi(jnoe-1+i)=i
        end do
!
    else
!
!       GROUP_MA_ENRI EST RENSEIGNE
!
        call reliem(' ', noma, 'NU_MAILLE', ' ', 1,&
                    1, 'GROUP_MA_ENRI', 'GROUP_MA', lismae, nbmae)
!
        call reliem(' ', noma, 'NU_NOEUD', ' ', 1,&
                    1, 'GROUP_MA_ENRI', 'GROUP_MA', lisnoe, nbnoe)
!
    endif
!
!     ENREGISTREMENT DANS LA BASE GLOBALE
    call jedupo(lismae, 'G', fiss(1:8)//'.GROUP_MA_ENRI', .false._1)
    call jedupo(lisnoe, 'G', fiss(1:8)//'.GROUP_NO_ENRI', .false._1)
!
    call jedema()
end subroutine
