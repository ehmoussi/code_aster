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

subroutine lrcmle(idfimd, nochmd, nbcmfi, nbvato, numpt,&
                  numord, typent, typgeo, iprof, ntvale,&
                  nomprf, codret)
!_____________________________________________________________________
! person_in_charge: nicolas.sellenet at edf.fr
! ======================================================================
!     LECTURE D'UN CHAMP - FORMAT MED - LECTURE
!     -    -       -              -     --
!-----------------------------------------------------------------------
!      ENTREES:
!        IDFIMD : IDENTIFIANT DU FICHIER MED
!        NOCHMD : NOM MED DU CHAMP A LIRE
!        NBCMFI : NOMBRE DE COMPOSANTES DANS LE FICHIER      .
!        NBVATO : NOMBRE DE VALEURS TOTAL (VALEUR DE MFNVAL)
!        NUMPT  : NUMERO DE PAS DE TEMPS
!        NUMORD : NUMERO D'ORDRE DU CHAMP
!        TYPENT : TYPE D'ENTITE AU SENS MED
!        TYPGEO : TYPE DE SUPPORT AU SENS MED
!      SORTIES:
!        NOMPRF : NOM DU PROFIL ASSOCIE
!        NTVALE : TABLEAU QUI CONTIENT LES VALEURS LUES
!        CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
!_____________________________________________________________________
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "jeveux.h"
#include "asterfort/as_mfdonp.h"
#include "asterfort/as_mfdonv.h"
#include "asterfort/as_mfdrpr.h"
#include "asterfort/infniv.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
    integer :: idfimd
    integer :: nbcmfi, nbvato, numpt, numord
    integer :: typent, typgeo
    integer :: codret
!
    character(len=*) :: nochmd, nomprf
    character(len=64) :: nomloc
    character(len=*) :: ntvale
!
! 0.2. ==> COMMUNS
!
! 0.3. ==> VARIABLES LOCALES
!
!
    integer :: edfuin
    parameter (edfuin=0)
    integer :: edall
    parameter (edall=0)
    integer :: edcomp
    parameter (edcomp=2)
    integer :: iterma
    parameter (iterma=1)
!
    integer :: ifm, nivinf
!
    integer :: advale, iprof, nbprof, n, taipro, nip
!
    character(len=8) :: saux08
    character(len=64) :: nomamd
!
!====
! 1. PREALABLES
!====
!
! 1.1. ==> RECUPERATION DU NIVEAU D'IMPRESSION
!
    call infniv(ifm, nivinf)
!
    if (nivinf .gt. 1) then
        write(ifm,*) 'NB CMP :',nbcmfi,'  NB TOTAL VALEURS :',nbvato
    endif
!
!====
! 2. LECTURE DU NOM DU PROFIL
!====
!
    call as_mfdonp(idfimd, nochmd, numpt, numord, typent,&
                   typgeo, iterma, nomamd, nomprf, nomloc,&
                   nbprof, codret)
    call as_mfdonv(idfimd, nochmd, typent, typgeo, nomamd,&
                   numpt, numord, iprof, nomprf, edcomp,&
                   taipro, nomloc, nip, n, codret)
!
!====
! 3. LECTURE DU CHAMP DANS UN TABLEAU TEMPORAIRE
!====
!
    call wkvect(ntvale, 'V V R', nbcmfi*nbvato, advale)
!
    call as_mfdrpr(idfimd, nochmd, zr(advale), edfuin, edall,&
                   nomprf, edcomp, typent, typgeo, numpt,&
                   numord, codret)
!
    if (codret .ne. 0) then
        saux08='mfdrpr'
        call utmess('F', 'DVP_97', sk=saux08, si=codret)
    endif
!
end subroutine
