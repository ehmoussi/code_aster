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

subroutine recyec(nmresz, mdcycz, numsec, typsdz)
!    P. RICHARD     DATE 16/04/91
!-----------------------------------------------------------------------
!  BUT:      < RESTITUTION CYCLIQUE ECLATEE >
    implicit none
!
!      RESTITUER EN BASE PHYSIQUE SUR UN SECTEUR LES RESULTATS
!                ISSU DE LA SOUS-STRUCTURATION CYCLIQUE
!  LE CONCEPT RESULTAT EST UN RESULTAT COMPOSE "MODE_MECA"
!
!-----------------------------------------------------------------------
!
! NMRESZ   /I/: NOM K8 DU CONCEPT MODE MECA RESULTAT
! MDCYCZ   /I/: NOM K8 MODE_CYCL AMONT
! NUMSEC   /I/: NUMERO DU SECTEUR SUR LEQUEL RESTITUER
! TYPSDZ   /I/: TYPE STRUCTURE DONNEE RESULTAT (MODE_MECA,BASE_MODALE)
!
!
!
!
#include "jeveux.h"
!
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/recbec.h"
#include "asterfort/remnec.h"
#include "asterfort/titre.h"
    character(len=8) :: nomres, modcyc, basmod, typint
    character(len=*) :: nmresz, mdcycz, typsdz
    character(len=16) :: typsd
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
!
!-----------------ECRITURE DU TITRE-------------------------------------
!
!-----------------------------------------------------------------------
    integer ::   numsec
    character(len=24), pointer :: cycl_refe(:) => null()
    character(len=8), pointer :: cycl_type(:) => null()
!-----------------------------------------------------------------------
    call jemarq()
    nomres = nmresz
    modcyc = mdcycz
    typsd = typsdz
!
    call titre()
!
!-------------------RECUPERATION DE LA BASE MODALE----------------------
!
    call jeveuo(modcyc//'.CYCL_REFE', 'L', vk24=cycl_refe)
    basmod=cycl_refe(3)
!
!-----------------------RECUPERATION DU TYPE INTERFACE------------------
!
!
    call jeveuo(modcyc//'.CYCL_TYPE', 'L', vk8=cycl_type)
    typint=cycl_type(1)
!
!
!------------------------------RESTITUTION -----------------------------
!
!    CAS CRAIG-BAMPTON ET CRAIG-BAMPTON HARMONIQUE
!
    if (typint .eq. 'CRAIGB  ' .or. typint .eq. 'CB_HARMO') then
        call recbec(nomres, typsd, basmod, modcyc, numsec)
    endif
!
!
!    CAS MAC NEAL AVEC ET SANS CORRECTION
!
    if (typint .eq. 'MNEAL   ' .or. typint .eq. 'AUCUN   ') then
        call remnec(nomres, typsd, basmod, modcyc, numsec)
    endif
!
!
    call jedema()
end subroutine
