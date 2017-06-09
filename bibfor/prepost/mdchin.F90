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

subroutine mdchin(nofimd, idfimd, nochmd, typent, typgeo,&
                  prefix, nbtv, codret)
!_____________________________________________________________________
! person_in_charge: nicolas.sellenet at edf.fr
! ======================================================================
!     FORMAT MED - CHAMP - INFORMATIONS - FICHIER CONNU PAR NOM
!            --    --      -                                -
! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
! !!! ATTENTION, CETTE ROUTINE NE DOIT PAS ETRE UTILISEE DANS LE  !!!
! !!! CAS D'UN ENRICHISSEMENT D'UN FICHIER MED CAR MDCHII SUPPOSE !!!
! !!! QUE LE FICHIER MED NE CHANGE PAS AU COURS DE LA COMMANDE    !!!
! !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
!     DONNE LE NOMBRE DE TABLEAUX DE VALEURS ET LEURS CARACTERISTIQUES
!     TEMPORELLES POUR UN CHAMP ET UN SUPPORT GEOMETRIQUE
!-----------------------------------------------------------------------
!      ENTREES:
!        NOFIMD : NOM DU FICHIER MED
!        IDFIMD : OU NUMERO DU FCHIER MED DEJA OUVERT
!        NOCHMD : NOM MED DU CHAMP A LIRE
!        TYPENT : TYPE D'ENTITE AU SENS MED
!        TYPGEO : TYPE DE SUPPORT AU SENS MED
!      ENTREES/SORTIES:
!        PREFIX : BASE DU NOM DES STRUCTURES
!                 POUR LE TABLEAU NUMERO I
!                 PREFIX//'.NUME' : T(2I-1) = NUMERO DE PAS DE TEMPS
!                                   T(2I)   = NUMERO D'ORDRE
!                 PREFIX//'.INST' : T(I) = INSTANT S'IL EXISTE
!      SORTIES:
!        NBTV   : NOMBRE DE TABLEAUX DE VALEURS DU CHAMP
!        CODRET : CODE DE RETOUR (0 : PAS DE PB, NON NUL SI PB)
!_____________________________________________________________________
!
    implicit none
!
! 0.1. ==> ARGUMENTS
!
#include "asterf_types.h"
#include "asterfort/as_mficlo.h"
#include "asterfort/as_mfiope.h"
#include "asterfort/mdchii.h"
#include "asterfort/utmess.h"
    integer :: nbtv
    integer :: typent, typgeo
    integer :: codret
!
    character(len=19) :: prefix
    character(len=*) :: nochmd
    character(len=*) :: nofimd
!
! 0.2. ==> VARIABLES LOCALES
!
    character(len=8) :: saux08
!
    integer :: edlect
    parameter (edlect=0)
!
    integer :: idfimd
    aster_logical :: dejouv
!====
! 1. ON OUVRE LE FICHIER EN LECTURE
!====
!
    if (idfimd .eq. 0) then
        call as_mfiope(idfimd, nofimd, edlect, codret)
        dejouv = .false.
    else
        dejouv = .true.
        codret = 0
    endif
    if (codret .ne. 0) then
        saux08='mfiope'
        call utmess('F', 'DVP_97', sk=saux08, si=codret)
    endif
!
!====
! 2. APPEL DU PROGRAMME GENERIQUE
!====
!
    call mdchii(idfimd, nochmd, typent, typgeo, prefix,&
                nbtv, codret)
!
!====
! 3. FERMETURE DU FICHIER MED
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
end subroutine
