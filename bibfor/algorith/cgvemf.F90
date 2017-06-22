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

subroutine cgvemf(modele, typfis, nomfis, typdis)
    implicit none
!
#include "asterf_types.h"
#include "asterfort/exixfe.h"
#include "asterfort/utmess.h"
#include "asterfort/xvfimo.h"
    character(len=8) :: modele, typfis, nomfis
    character(len=16) :: typdis
!
! person_in_charge: samuel.geniaut at edf.fr
!
!     SOUS-ROUTINE DE L'OPERATEUR CALC_G
!
!     BUT : VERIFICATION DE LA COMPATIBILITE ENTRE LA SD ASSOCIEE AU
!           FOND DE FISSURE ET LE MODELE
!
!  IN :
!    MODELE : NOM DE LA SD_MODELE
!    TYPFIS : TYPE DE LA SD DECRIVANT LE FOND DE FISSURE
!            ('THETA' OU 'FONDIFSS' OU 'FISSURE')
!    NOMFIS : NOM DE LA SD DECRIVANT LE FOND DE FISSURE
!    TYPDIS : TYPE DE DISCONTINUITE SI FISSURE XFEM 
!             'FISSURE' OU 'COHESIF'
! ======================================================================
!
    integer :: ixfem
    aster_logical :: fiinmo
    character(len=8) :: valk(2)
!
!     LE MODELE EST-IL X-FEM : SI OUI IXFEM=1
    call exixfe(modele, ixfem)
!
!     ERREUR SI FOND_FISS EST DONNE AVEC UN MODELE X-FEM
    if (typfis .eq. 'FONDFISS' .and. ixfem .eq. 1) then
        call utmess('F', 'RUPTURE0_95', sk=modele)
    endif
!
!     ERREUR SI FISSURE EST DONNE AVEC UN MODELE NON X-FEM
    if (typfis .eq. 'FISSURE' .and. ixfem .eq. 0) then
        call utmess('F', 'RUPTURE0_96', sk=modele)
    endif
!
!     ERREUR SI FISSURE N'EST PAS ASSOCIEE AU MODELE X-FEM
!     SAUF SI MODELE COHESIF
    if (typfis .eq. 'FISSURE'.and.typdis.eq.'FISSURE') then
        fiinmo = xvfimo(modele,nomfis)
        if (.not.fiinmo) then
            valk(1)=nomfis
            valk(2)=modele
            call utmess('F', 'RUPTURE0_97', nk=2, valk=valk)
        endif
    endif
!
end subroutine
