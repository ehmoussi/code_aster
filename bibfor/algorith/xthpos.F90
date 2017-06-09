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

subroutine xthpos(result, modele)
!
implicit none
!
#include "jeveux.h"
#include "asterfort/alchml.h"
#include "asterfort/assert.h"
#include "asterfort/copisd.h"
#include "asterfort/detrsd.h"
#include "asterfort/jedema.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/rsexch.h"
#include "asterfort/rsnoch.h"
#include "asterfort/xthpoc.h"
!
!
    character(len=8), intent(in) :: result
    character(len=24), intent(in) ::  modele
!
! ----------------------------------------------------------------------
!
! THER_LINEAIRE + XFEM : CALCUL ET STOCKAGE DE L'OPTION 'TEMP_ELGA'
!
! IN  RESULZ  : NOM DU RESULTAT
! IN  MODELE  : NOM DU MODELE
!
! ----------------------------------------------------------------------
    integer :: jord, nbordr, ior, iord, iret
    character(len=19) :: ligrmo, chtn, chtpg, celtmp
    character(len=24) :: ordr
! ----------------------------------------------------------------------
!
    call jemarq()
!
    ligrmo=modele(1:8)//'.MODELE'
    celtmp='&&XTELGA.CELTMP'
!
    ordr=result//'           .ORDR'
    call jeveuo(ordr, 'L', jord)
    call jelira(ordr, 'LONUTI', nbordr)
!
!     ------------------------------------------------------------------
!     - BOUCLE SUR LES NBORDR NUMEROS D'ORDRE
!     ------------------------------------------------------------------
!
    do ior = 1, nbordr
!
        iord=zi(jord-1+ior)
!
!       SI LE CHAMP 'TEMP' N'EXISTE PAS DANS RESULT, ON PASSE...
        call rsexch(' ', result, 'TEMP', iord, chtn,&
                    iret)
        if (iret .gt. 0) cycle
!
!       ALLOCATION DU CHAM_ELEM TEMPORAIRE : CELTMP
!       RQ : LIGRMO CONTIENT TOUS LES EF DU MODELE, MAIS SEULS LES EF
!       ---  X-FEM SAVENT CALCULER L'OPTION 'TEMP_ELGA' -> CELTMP N'EST
!            DONC DEFINI QUE SUR L'ENSEMBLE DES EF X-FEM
        call alchml(ligrmo, 'TEMP_ELGA', 'PTEMP_R', 'V', celtmp,&
                    iret, ' ')
        ASSERT(iret.eq.0)
!
!       CALCUL DE L'OPTION 'TEMP_ELGA' ET ECRITURE DANS CELTMP
        call xthpoc(modele, chtn, celtmp)
!
!       RECUPERATION DU NOM DU CHAMP A ECRIRE : CHTPG
        call rsexch(' ', result, 'TEMP_ELGA', iord, chtpg,&
                    iret)
        ASSERT(iret.eq.100)
!       COPIE : CELTMP (BASE 'V') -> CHTPG (BASE 'G')
        call copisd('CHAMP', 'G', celtmp, chtpg)
!       STOCKAGE DANS LA SD RESULTAT
        call rsnoch(result, 'TEMP_ELGA', iord)
!
!       DESTRUCTION DE CELTMP
        call detrsd('CHAM_ELEM', celtmp)
!
    end do
!
    call jedema()
!
end subroutine
