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

subroutine mdexcv(nofimd, idfimd, nochmd, numpt, numord,&
                  typent, typgeo, nbval, nbprof, codret)
! person_in_charge: nicolas.sellenet at edf.fr
!_____________________________________________________________________
!        FORMAT MED : EXISTENCE D'UN CHAMP DANS UN FICHIER : VALEURS
!               - -   --             -                       -
! ______________________________________________________________________
! .        .     .        .                                            .
! .  NOM   . E/S . TAILLE .           DESCRIPTION                      .
! .____________________________________________________________________.
! . NOFIMD .  E  .   1    . NOM DU FICHIER MED                         .
! . NOFIMD .  E  .   1    . OU NUMERO DU FICHIER DEJA OUVERT           .
! . NOCHMD .  E  .   1    . NOM DU CHAMP MED VOULU                     .
! . NUMPT  .  E  .   1    . NUMERO DU PAS DE TEMPS DU CHAMP            .
! . NUMORD .  E  .   1    . NUMERO D'ORDRE DU CHAMP                    .
! . TYPENT .  E  .   1    . TYPE D'ENTITE AU SENS MED                  .
! . TYPGEO .  E  .   1    . TYPE DE SUPPORT AU SENS MED                .
! . NBVAL  .  S  .   1    . NOMBRE DE VALEURS DANS LE FICHIER          .
! . NBPROF .  S  .   1    . NOMBRE DE PROFILS MED POUR LE CHAMP        .
! . CODRET .  S  .    1   . CODE DE RETOUR DES MODULES                 .
! ______________________________________________________________________
!
!====
! 0. DECLARATIONS ET DIMENSIONNEMENT
!====
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/as_mfdonp.h"
#include "asterfort/as_mfdonv.h"
#include "asterfort/as_mficlo.h"
#include "asterfort/as_mfiope.h"
#include "asterfort/utmess.h"
    character(len=*) :: nofimd, nochmd
!
    integer :: numpt, numord, typent, typgeo, nbval
!
    integer :: codret
!
! 0.2. ==> COMMUNS
!
!
! 0.3. ==> VARIABLES LOCALES
!
    integer :: edlect
    parameter (edlect=0)
    integer :: edcomp
    parameter (edcomp=2)
    integer :: iterma
    parameter (iterma=1)
!
    integer :: idfimd, nbprof, iprof
    integer :: iaux, npr, nip, ntmp
!
    character(len=8) :: saux08
    character(len=64) :: nompro, nomloc, nomamd
    aster_logical :: ficexi, dejouv
! ______________________________________________________________________
!
!====
! 1. ON OUVRE LE FICHIER EN LECTURE
!    ON PART DU PRINCIPE QUE SI ON N'A PAS PU OUVRIR, C'EST QUE LE
!    FICHIER N'EXISTE PAS, DONC SANS CHAMP A FORTIORI
!====
!
    nbval = 0
    codret = 0
    inquire(file=nofimd,exist=ficexi)
!
    if (.not. ficexi) then
!
        nbval = 0
        codret = 0
!
    else
        if (idfimd .eq. 0) then
            call as_mfiope(idfimd, nofimd, edlect, iaux)
            dejouv = .false.
        else
            dejouv = .true.
            iaux = 0
        endif
        if (iaux .eq. 0) then
!
!====
! 2. COMBIEN DE VALEURS ?
!====
!
            call as_mfdonp(idfimd, nochmd, numpt, numord, typent,&
                           typgeo, iterma, nomamd, nompro, nomloc,&
                           nbprof, codret)
            do iprof = 1, nbprof
                call as_mfdonv(idfimd, nochmd, typent, typgeo, nomamd,&
                               numpt, numord, iprof, nompro, edcomp,&
                               npr, nomloc, nip, ntmp, codret)
                if (codret .eq. 0) then
                    nbval = nbval + nip*ntmp
                endif
            end do
!
!====
! 3. FERMETURE DU FICHIER
!====
!
            if (.not.dejouv) then
                call as_mficlo(idfimd, codret)
                if (codret .ne. 0) then
                    saux08='mficlo'
                    call utmess('F', 'DVP_97', sk=saux08, si=codret)
                endif
                idfimd = 0
            endif
!
        endif
    endif
!
end subroutine
