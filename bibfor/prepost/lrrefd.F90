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

subroutine lrrefd(resu, prchnd)
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/getvid.h"
#include "asterfort/idensd.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/refdaj.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    character(len=8) :: resu
    character(len=19) :: prchnd
!
!     BUT:
!       * REMPLIR LE .REFD A PARTIR DES DONNEES UTILISATEUR
!       * RETOURNER LE NOM D'UN PROF_CHNO QUI SERVIRA A NUMEROTER
!         LES CHAM_NO DE "DEPL" (DEPL/VITE/ACCE)
!       * PEUT RETOURNER PRCHND=' '
!
!     ARGUMENTS:
!     ----------
!
!      ENTREE :
!-------------
! IN   RESU     : NOM DE LA SD_RESULTAT
!
!      SORTIE :
!-------------
! OUT  PRCHND   : PROFIL DES CHAM_NO DEPL/VITE/ACCE
!
! ......................................................................
!
!
!
!
!
    integer :: iret, iret1, iret2, ibid
!
    character(len=8) :: matrig, matmas
    character(len=14) :: nuddlr, nuddlm
    character(len=19) :: pronur, pronum
    character(len=24) :: matric(3)
!
! ----------------------------------------------------------------------
!
!     SI L'UTILISATEUR NE DONNE PAS DE NUME_DDL ON LE DEDUIT DE LA
!     DE LA MATRICE DE RIGIDITE (MATRIG).
!
    call jemarq()
!
    prchnd = ' '
    matrig = ' '
    matmas = ' '
    nuddlr = ' '
    nuddlm = ' '
!
    ibid = 1
!
    call getvid(' ', 'MATR_RIGI', scal=matrig, nbret=iret1)
    call getvid(' ', 'MATR_MASS', scal=matmas, nbret=iret2)
!
    if (iret1 .eq. 1) then
        call utmess('I', 'PREPOST_14', sk=matrig)
        call dismoi('NOM_NUME_DDL', matrig, 'MATR_ASSE', repk=nuddlr)
        call dismoi('PROF_CHNO', nuddlr, 'NUME_DDL', repk=prchnd)
    endif
!
!     VERIFICATION : LES NUME_DDL DES MATRICES A ET B SONT IDENTIQUES
    if (iret1 .eq. 1 .and. iret2 .eq. 1) then
        call dismoi('NOM_NUME_DDL', matmas, 'MATR_ASSE', repk=nuddlm)
        if (nuddlm .ne. nuddlr) then
            pronur=(nuddlr//'.NUME')
            pronum=(nuddlm//'.NUME')
            if (.not.idensd('PROF_CHNO',pronur,pronum)) then
                call utmess('F', 'ALGELINE2_79')
            endif
        endif
    endif
!
    matric(1) = matrig
    matric(2) = matmas
    matric(3) = ' '
    call refdaj('F', resu, -1, nuddlr, 'DYNAMIQUE',&
                matric, iret)
!
    call jedema()
!
end subroutine
