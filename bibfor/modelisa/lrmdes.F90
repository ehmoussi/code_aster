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

subroutine lrmdes(fid, nbltit, descfi, titre)
! person_in_charge: nicolas.sellenet at edf.fr
!-----------------------------------------------------------------------
!     LECTURE FORMAT MED - LA DESCRIPTION
!     -    -         -        ---
!-----------------------------------------------------------------------
!     LECTURE DU FICHIER MAILLAGE AU FORMAT MED
!               PHASE 0 : LA DESCRIPTION
!     ENTREES :
!       FID    : IDENTIFIANT DU FICHIER MED
!     SORTIES:
!       NBLTIT : NOMBRE DE LIGNES DU TITRE
!       DESCFI : DESCRIPTION DU FICHIER
!       TITRE  : TITRE DU MAILLAGE
!-----------------------------------------------------------------------
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "jeveux.h"
#include "asterfort/as_mficor.h"
#include "asterfort/enlird.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/wkvect.h"
    integer :: fid
    integer :: nbltit
!
    character(len=*) :: descfi, titre
!
! 0.2. ==> COMMUNS
!
!
! 0.3. ==> VARIABLES LOCALES
!
!
    integer :: codret
    integer :: jtitre
!
    character(len=80) :: dat
!
!     ------------------------------------------------------------------
    call jemarq()
!
!====
! 1. LECTURE DE LA DESCRIPTION EVENTUELLE DU FICHIER
!====
!
    descfi=' '
!
    call as_mficor(fid, descfi, codret)
!     POUR CERTAINES ROUTINES MED CODRET = -1 N'EST PAS UN PROBLEME
!      IF ( CODRET.NE.0 ) THEN
!        SAUX08='mficor'
!        CALL UTMESG('F','DVP_97',1,SAUX08,1,CODRET,0,0.D0)
!      ENDIF
!
!====
! 2. OBJET TITRE
!    ON Y MET LA DESCRIPTION SI ELLE EXISTE, LA DATE SINON.
!====
!
    nbltit = 1
    call wkvect(titre, 'G V K80', nbltit, jtitre)
!
    if (descfi .ne. ' ') then
        zk80(jtitre) = descfi
    else
        call enlird(dat)
        zk80(jtitre) = dat
    endif
!
!====
! 3. LA FIN
!====
!
    call jedema()
!
end subroutine
