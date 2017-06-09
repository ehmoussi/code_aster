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

subroutine xvermo(nfiss, fiss, mai)
!
!
    implicit none
#include "jeveux.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jemarq.h"
#include "asterfort/utmess.h"
    integer :: nfiss
    character(len=8) :: fiss(nfiss), mai
!
! ----------------------------------------------------------------------
!
! ROUTINE XFEM (VERIFICATION DES SD)
!
! VERIFICATION QUE LES FISSURES SONT TOUTES DEFINIES A PARTIR DU
! MAILLAGE UTILISE POUR CONSTRUIRE LE MODELE SAIN EN ENTREE DE
! MODI_MODELE_XFEM  (MC MODELE_IN)
! ----------------------------------------------------------------------
!
! IN  NFISS  : NOMBRE DE FISSURES
! IN  FISS   : LISTE DES NOMS DES FISSURES
! IN  MAI    : NOM DU MAILLAGE UTILISE POUR CONSTRUIRE LE MODELE SAIN
!              EN ENTREE DE MODI_MODELE_XFEM  (MC MODELE_IN)
!
!
!
!
    integer :: ifiss
    character(len=8) :: maif, valk(3)
!
! ----------------------------------------------------------------------
!
    call jemarq()
!
    do ifiss = 1, nfiss
!
!       RECUPERATION DU MAILLAGE ASSOCIE A LA FISSURE COURANTE
        call dismoi('NOM_MAILLA', fiss(ifiss), 'FISS_XFEM', repk=maif)
!
!       VERIFICATION DE LA COHERENCE
        if (mai .ne. maif) then
            valk(1)=fiss(ifiss)
            valk(2)=maif
            valk(3)=mai
            call utmess('F', 'XFEM_39', nk=3, valk=valk)
        endif
!
    end do
!
    call jedema()
end subroutine
