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

subroutine lisccm(nomcmd, codarr, lischa)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/lisccc.h"
#include "asterfort/lislch.h"
#include "asterfort/lislcm.h"
#include "asterfort/lislco.h"
#include "asterfort/lisnnb.h"
#include "asterfort/utmess.h"
    character(len=16) :: nomcmd
    character(len=1) :: codarr
    character(len=19) :: lischa
!
! ----------------------------------------------------------------------
!
! ROUTINE UTILITAIRE (LISTE_CHARGES)
!
! VERIFICATION COMPATIBILITE CHARGE/COMMANDE
!
! ----------------------------------------------------------------------
!
!
! IN  NOMCMD : NOM DE LA COMMANDE
! IN  CODARR : TYPE DE MESSAGE INFO/ALARME/ERREUR SI PAS COMPATIBLE
! IN  LISCHA : SD LISTE DES CHARGES
!
! ----------------------------------------------------------------------
!
    integer :: ichar, nbchar
    integer :: nbauth, nbnaut, mclaut(2)
    integer :: motclc(2)
    character(len=24) :: valk(2)
    character(len=8) :: charge
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    if (nomcmd .eq. ' ') goto 999
!
! --- NOMBRE DE CHARGES
!
    call lisnnb(lischa, nbchar)
    if (nbchar .eq. 0) goto 999
!
    do 10 ichar = 1, nbchar
!
! ----- NOM DE LA CHARGE
!
        call lislch(lischa, ichar, charge)
!
! ----- CODE DES MOTS-CLEFS DE LA CHARGE
!
        call lislcm(lischa, ichar, motclc)
!
! ----- AUTORISATION ?
!
        call lisccc(nomcmd, motclc, nbauth, nbnaut, mclaut)
!
        if (nbnaut .ne. 0) then
            valk(1) = charge
            valk(2) = nomcmd
            call utmess(codarr, 'CHARGES5_3', nk=2, valk=valk)
        endif
!
10  continue
!
999  continue
!
    call jedema()
end subroutine
