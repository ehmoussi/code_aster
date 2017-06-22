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

subroutine ascoma(meelem, numedd, lischa, matass)
!
! person_in_charge: mickael.abbas at edf.fr
!
    implicit none
#include "jeveux.h"
#include "asterfort/asmatr.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jedupo.h"
#include "asterfort/jeexin.h"
#include "asterfort/jelira.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/nmchex.h"
#include "asterfort/reajre.h"
#include "asterfort/wkvect.h"
    character(len=19) :: meelem(*)
    character(len=19) :: matass, lischa
    character(len=24) :: numedd
!
! ----------------------------------------------------------------------
!
! ROUTINE MECA_NON_LINE (CALCUL - UTILITAIRE)
!
! ASSEMBLAGE DE LA MATRICE DE RIGIDITE ASSOCIEE AUX CHARGEMENTS
! SUIVEURS
!
! ----------------------------------------------------------------------
!
!
! IN  MEELEM : LISTE DES MATR_ELEM
! IN  NUMEDD : NOM DE LA NUMEROTATION MECANIQUE
! IN  LISCHA : SD L_CHARGE
! OUT MATASS : MATRICE GLOBALE ASSEMBLEE
!
!
!
!
    integer :: nbchme,  iret
    integer :: k, jcoef, jlicoe
    character(len=24) :: licoef
    character(len=19) :: mesuiv
    character(len=24), pointer :: relr(:) => null()
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
! --- INITIALISATIONS
!
    call nmchex(meelem, 'MEELEM', 'MESUIV', mesuiv)
    licoef = mesuiv(1:15)//'.COEF'
!
! --- NOMBRE DE CHARGEMENTS SUIVEURS
!
    call jeexin(licoef, iret)
    if (iret .eq. 0) then
        goto 999
    else
        call jelira(licoef, 'LONUTI', nbchme)
        call jeveuo(mesuiv(1:19)//'.RELR', 'L', vk24=relr)
        call jeveuo(licoef, 'L', jlicoe)
    endif
!
! --- AJOUT DES MESUIV
!
    call jedupo(mesuiv(1:19)//'.RERR', 'V', '&&ASCOMA           .RERR', .true._1)
    call wkvect('&&ASCOMA.LISTE_COEF', 'V V R', 1, jcoef)
    do 777 k = 1, nbchme
        call jedetr('&&ASCOMA           .RELR')
        call reajre('&&ASCOMA', relr(k), 'V')
        zr(jcoef) = zr(jlicoe+k-1)
        call asmatr(1, '&&ASCOMA           ', '&&ASCOMA.LISTE_COEF', numedd, &
                    lischa, 'CUMU', 'V', 1, matass)
777  end do
!
! --- MENAGE
!
    call jedetr('&&ASCOMA           .RELR')
    call jedetr('&&ASCOMA           .RERR')
    call jedetr('&&ASCOMA.LISTE_COEF')
!
999  continue
!
    call jedema()
end subroutine
