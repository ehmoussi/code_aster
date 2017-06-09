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

subroutine utnbnv(typmav, nbsv, nbnv)
! person_in_charge: olivier.boiteau at edf.fr
!-----------------------------------------------------------------------
!    - FONCTION REALISEE:  UTILITAIRE CALCULANT LE TYPE DE FACE VOISINE
!                          ET SON NBRE DE SOMMETS. POUR AERER TE0003
!
! IN TYPMAV  : NOM DE LA MAILLE VOISINE.
! OUT NBSV   : TYPE DE MAILLE VOISINE (POUR 2D, TRAITEMENT MAILLE SYM.).
! OUT NBNV   : NOMBRE DE NOEUDS.
!   -------------------------------------------------------------------
!
!     FONCTIONS INTRINSEQUES:
!       AUCUNE.
!   -------------------------------------------------------------------
!     ASTER INFORMATIONS:
!       25/09/01 (OB): CREATION POUR SIMPLIFIER TE0003.F.
!----------------------------------------------------------------------
! CORPS DU PROGRAMME
    implicit none
!
! DECLARATION PARAMETRES D'APPELS
#include "asterfort/assert.h"
    integer :: nbnv, nbsv
    character(len=8) :: typmav
!
! DECLARATION VARIABLES LOCALES
    character(len=1) :: noeuv
    character(len=2) :: formv
!
! INIT.
    formv = typmav(1:2)
    noeuv = typmav(5:5)
!
! DETERMINATION DE NBNV ET NBSV (EN 2D)
!
! TRIANGLE
    if ((formv.eq.'TR') .or. (formv.eq.'TL')) then
        nbsv = 3
        ASSERT(noeuv.eq.'3'.or.noeuv.eq.'6')
        if (noeuv .eq. '3') then
            nbnv = 3
        else if (noeuv.eq.'6') then
            nbnv = 6
        endif
! QUADRANGLE
    else if ((formv.eq.'QU').or.(formv.eq.'QL')) then
        nbsv = 4
        ASSERT(noeuv.eq.'4'.or.noeuv.eq.'8'.or.noeuv.eq.'9')
        if (noeuv .eq. '4') then
            nbnv = 4
        else if (noeuv.eq.'8') then
            nbnv = 8
        else if (noeuv.eq.'9') then
            nbnv = 9
        endif
! HEXAEDRE
    else if (formv.eq.'HE') then
        ASSERT(typmav(5:5) .eq. '8' .or. typmav(5:6) .eq. '20' .or. typmav(5:6) .eq. '27')
        if (typmav(5:5) .eq. '8') then
            nbnv = 8
        else if (typmav(5:6).eq.'20') then
            nbnv = 20
        else if (typmav(5:6).eq.'27') then
            nbnv = 27
        endif
! PENTAEDRE
    else if (formv.eq.'PE') then
        ASSERT(typmav(6:6).eq.'6'.or.typmav(6:7).eq.'15')
        if (typmav(6:6) .eq. '6') then
            nbnv = 6
        else if (typmav(6:7).eq.'15') then
            nbnv = 15
        endif
! TETRAEDRE
    else if (formv.eq.'TE') then
        ASSERT(typmav(6:6).eq.'4'.or.typmav(6:7).eq.'10')
        if (typmav(6:6) .eq. '4') then
            nbnv = 4
        else if (typmav(6:7).eq.'10') then
            nbnv = 10
        endif
    else
        ASSERT(.false.)
    endif
!
end subroutine
