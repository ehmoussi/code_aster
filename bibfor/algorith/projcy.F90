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

subroutine projcy(nomres)
!    P. RICHARD     DATE 11/03/91
!-----------------------------------------------------------------------
!  BUT:  CALCULER LES SOUS-MATRICES OBTENUES A PARTIR DES PROJECTIONS
    implicit none
!     DES MATRICES MASSE ET RAIDEUR SUR LES MODES ET LES DEFORMEES
!    STATIQUECS
!
!-----------------------------------------------------------------------
!
! NOMRES   /I/: NOM UTILISATEUR DU RESULTAT
!
!
!
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/prcycb.h"
#include "asterfort/prcymn.h"
#include "asterfort/utmess.h"
    character(len=8) :: nomres, typint
    character(len=24) :: repmat, soumat
    character(len=24) :: valk
    aster_logical :: nook
!
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: llref
    character(len=8), pointer :: cycl_type(:) => null()
!-----------------------------------------------------------------------
    data nook /.true./
!-----------------------------------------------------------------------
!
!--------------------RECUPERATION DES CONCEPTS AMONT--------------------
!
    call jemarq()
    call jeveuo(nomres//'.CYCL_REFE', 'L', llref)
!
!-------------CAS DE LA DONNEE D'UNE BASE MODALE------------------------
!
    soumat='&&OP0080.CYCLIC.SOUS.MAT'
    repmat='&&OP0080.CYCLIC.REPE.MAT'
!
!--------------RECUPERATION DU TYPE D'INTERFACE-------------------------
!
    call jeveuo(nomres//'.CYCL_TYPE', 'L', vk8=cycl_type)
    typint=cycl_type(1)
!
!----------------CALCUL SOUS-MATRICES DANS LE CAS CRAIG-BAMPTON---------
!                        ET CRAIG-BAMPTON HARMONIQUE
!
    if (typint .eq. 'CRAIGB  ' .or. typint .eq. 'CB_HARMO') then
        call prcycb(nomres, soumat, repmat)
        nook=.false.
    endif
!
!----------------CALCUL SOUS-MATRICES DANS LE CAS MAC NEAL--------------
!
    if (typint .eq. 'MNEAL  ') then
        call prcymn(nomres, soumat, repmat)
        nook=.false.
    endif
!
!----------------CALCUL SOUS-MATRICES DANS LE CAS AUCUN-----------------
!        (=MAC NEAL SANS FLEXIBILITE RESIDUELLE)
!
    if (typint .eq. 'AUCUN   ') then
        call prcymn(nomres, soumat, repmat)
        nook=.false.
    endif
!
!--------------AUTRE CAS -----------------------------------------------
!
    if (nook) then
        valk = typint
        call utmess('F', 'ALGORITH14_3', sk=valk)
    endif
!
    call jedema()
end subroutine
