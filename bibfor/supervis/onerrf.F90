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

subroutine onerrf(set, get, long)
    implicit none
! person_in_charge: mathieu.courtois at edf.fr
!     ----------------------------------------------------------------
!     QUE FAIT-ON EN CAS D'ERREUR <F> ?
!        VEXCF = 0 == ARRET AVEC ABORT
!        VEXCF = 1 == EXCEPTION FATALE (SUPPRESSION DU CONCEPT COURANT)
!        VEXCF = 2 == EXCEPTION SURE (ON VALIDERA LE CONCEPT COURANT)
!
!     POUR DEFINIR LE COMPORTEMENT EN CAS D'ERREUR : SET EN IN
!     POUR RECUPERER LA VALEUR COURANTE : SET=' ', GET, LONG EN OUT
!
! IN  SET : VALEUR DU NOUVEAU COMPORTEMENT (ABORT OU EXCEPTION)
! OUT GET : VALEUR ACTUELLE DU COMPORTEMENT
! OUT LEN : LONGUEUR DE GET EN SORTIE
!
!     VINI CONTIENT LA VALEUR FIXEE PAR DEBUT (INITIALISER AU 1ER APPEL)
!     ----------------------------------------------------------------
#include "asterfort/jefini.h"
#include "asterfort/lxlgut.h"
    character(len=*) :: set
    character(len=16) :: get
    integer :: long
!     ----------------------------------------------------------------
    integer :: vexcf, vini
    save             vexcf, vini
    data vexcf       /  0 /
    data vini        / -1 /
!     ----------------------------------------------------------------
!
!     SI DANS DEBUT, ON A CHOISI ABORT, ON Y RESTE
    if (vini .eq. 0) then
        get='ABORT'
        goto 99
    endif
!
    get = set
! --- L'INITIALISATION EST FAITE PAR UN PREMIER APPEL AVEC SET<>' '
!
! --- ON RECUPERE LA VALEUR ACTUELLE
    if (set(1:1) .eq. ' ') then
!        ON RETOURNE LA VALEUR COURANTE
        if (vexcf .eq. 0) then
            get='ABORT'
        else if (vexcf .eq. 1) then
            get='EXCEPTION'
        else if (vexcf .eq. 2) then
            get='EXCEPTION+VALID'
        else
            write(6,*) 'ERREUR DE PROGRAMMATION : ONERRF NUMERO 1'
            call jefini('ERREUR')
        endif
!
! --- ON POSITIONNE LA VALEUR
    else if (set .eq. 'INIT') then
!        PERMET DE REMETTRE LA VALEUR INITIALE
        vexcf=vini
!
    else if (set .eq. 'EXCEPTION+VALID') then
!        EXCEPTION EN CAS D'ERREUR ET VALIDATION DU CONCEPT COURANT
        vexcf=2
!
    else if (set .eq. 'EXCEPTION') then
!        EXCEPTION EN CAS D'ERREUR ET SUPPRESSION DU CONCEPT COURANT
        vexcf=1
!
    else if (set .eq. 'ABORT') then
!        "CALL ABORT" EN CAS D'ERREUR
        vexcf=0
!
    else
!        PAS D'ASSERT ICI (RECURSIVITE)
        write(6,*) 'ERREUR DE PROGRAMMATION : ONERRF NUMERO 2'
        call jefini('ERREUR')
    endif
!
99  continue
    long = lxlgut(get)
!
    if (vini .lt. 0 .and. set(1:1) .ne. ' ') then
        vini = vexcf
    endif
!
end subroutine
