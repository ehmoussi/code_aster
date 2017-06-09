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

subroutine mmtypm(noma, numma, nnosd, alias, ndim)
!
implicit none
!
#include "asterfort/mmelty.h"
!
! person_in_charge: mickael.abbas at edf.fr
!
    integer :: numma
    integer :: nnosd, ndim
    character(len=8) :: noma
    character(len=8) :: alias
!
! ----------------------------------------------------------------------
!
! ROUTINE CONTACT (TOUTES METHODES - UTILITAIRE)
!
! TYPE DE LA MAILLE
!
! ----------------------------------------------------------------------
!
! IN  NOMA   : NOM DU MAILLAGE
! IN  NUMMA  : NUMERO ABSOLU DE LA MAILLE
! IN  NNOSD  : NOMBRE DE NOEUDS DE LA MAILLE SUIVANT LA SD
! OUT NDIM   : DIMENSION DE LA MAILLE
! OUT ALIAS  : TYPE GEOMETRIQUE DE LA MAILLE
!
! /!\  NNO EST DIFFERENT DE NNOSD
!        NNOSD : NOMBRE DE NOEUDS SUPPORTANT SUIVANT LA SD
!                REPREND UNIQUEMENT LES NOEUDS SUPPORTANT
!                DES DDLS DE DEPLACEMENTS
!        NNO   : NOMBRE DE NOEUDS TOTAL DE LA MAILLE
!
!
!
!
    integer :: nno
!
! ----------------------------------------------------------------------
!

!
! --- TYPE GEOMETRIQUE DE LA MAILLE
!
    call mmelty(noma, numma, alias, nno, ndim)
!
! --- CAS DES COQUES_3D: PAS DE DX/DY/DZ SUR NOEUD MILIEU
!
    if ((nno .eq.9) .and. (nnosd .eq.8)) then
        alias = 'QU8'
    endif
    if ((nno .eq.7) .and. (nnosd .eq.6)) then
        alias = 'TR6'
    endif
!
! --- CAS DES QUAD8 EN 3D: 4 NOEUDS ET RELATIONS LINEAIRES
!
    if ((nno .eq.8) .and. (nnosd .eq.4)) then
        alias = 'QU4'
    endif
!
end subroutine
