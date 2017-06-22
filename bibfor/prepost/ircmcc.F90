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

subroutine ircmcc(idfimd, nomamd, nochmd, existc, ncmpve,&
                  ntncmp, ntucmp, codret)
! person_in_charge: nicolas.sellenet at edf.fr
!_______________________________________________________________________
!     ECRITURE D'UN CHAMP -  FORMAT MED - CREATION DU CHAMP
!        -  -       -               -     -           -
!_______________________________________________________________________
!     ENTREES :
!        IDFIMD : IDENTIFIANT DU FICHIER MED
!        NOCHMD : NOM MED DU CHAMP A ECRIRE
!        EXISTC : 0 : LE CHAMP EST INCONNU DANS LE FICHIER
!                >0 : LE CHAMP EST CREE AVEC :
!                 1 : LES COMPOSANTES VOULUES NE SONT PAS TOUTES
!                     ENREGISTREES
!                 2 : AUCUNE VALEUR POUR CE TYPE ET CE NUMERO D'ORDRE
!        NCMPVE : NOMBRE DE COMPOSANTES VALIDES EN ECRITURE
!        NTNCMP : SD DES NOMS DES COMPOSANTES A ECRIRE (K16)
!        NTUCMP : SD DES UNITES DES COMPOSANTES A ECRIRE (K16)
!     SORTIES:
!        CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
!_______________________________________________________________________
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "jeveux.h"
#include "asterfort/as_mfdcre.h"
#include "asterfort/infniv.h"
#include "asterfort/jeveuo.h"
#include "asterfort/utmess.h"
    character(len=*) :: nomamd
    character(len=*) :: nochmd
    character(len=*) :: ntncmp, ntucmp
!
    integer :: idfimd
    integer :: existc
    integer :: ncmpve
!
    integer :: codret
!
! 0.2. ==> COMMUNS
!
!
! 0.3. ==> VARIABLES LOCALES
!
!
    integer :: edfl64
    parameter (edfl64=6)
!
    integer :: adncmp, aducmp
    integer :: ifm, nivinf
    integer :: iaux
!
    character(len=8) :: saux08
!
!====
! 1. PREALABLES
!====
!
    call infniv(ifm, nivinf)
!
    if (existc .eq. 1) then
        call utmess('F', 'MED_31', sk=nochmd)
    endif
!
!====
! 2. CREATION DU CHAMP
!====
!
    if (existc .eq. 0) then
!
        if (nivinf .gt. 1) then
            write (ifm,2100) nochmd
        endif
        2100  format(2x,'DEMANDE DE CREATION DU CHAMP MED : ',a)
!
! 2.1. ==> ADRESSES DE LA DESCRIPTION DES COMPOSANTES
!
        call jeveuo(ntncmp, 'L', adncmp)
        call jeveuo(ntucmp, 'L', aducmp)
!
! 2.2. ==> APPEL DE LA ROUTINE MED
!
        call as_mfdcre(idfimd, nochmd, nomamd, edfl64, zk16(adncmp),&
                       zk16(aducmp), ncmpve, codret)
!
        if (codret .ne. 0) then
            saux08='mfdcre'
            call utmess('F', 'DVP_97', sk=saux08, si=codret)
        endif
!
! 2.3. ==> IMPRESSION D'INFORMATION
!
        if (nivinf .gt. 1) then
            if (ncmpve .eq. 1) then
                write (ifm,2301) zk16(adncmp)(1:8)
            else
                write (ifm,2302) ncmpve
                write (ifm,2303) (zk16(adncmp-1+iaux)(1:8),iaux=1,&
                ncmpve)
            endif
        endif
        2301  format(2x,'LE CHAMP MED EST CREE AVEC LA COMPOSANTE : ',a8)
        2302  format(2x,'LE CHAMP MED EST CREE AVEC ',i3,' COMPOSANTES :')
        2303  format(5(a8:,', '),:)
!
    endif
!
end subroutine
