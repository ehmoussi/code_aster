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

subroutine irrnvi(model, ndt, ndi, nr, nvi)
    implicit none
#include "asterfort/utmess.h"
! person_in_charge: jean-luc.flejou at edf.fr
! ----------------------------------------------------------------
! IRRAD3M  :  NOMBRE DE COMPOSANTES DES CONTRAINTES ET
!             NOMBRE VARIABLES
! ----------------------------------------------------------------
! IN  MODEL :  TYPE DE MODELISATION
! OUT NDT   :  NB TOTAL DE COMPOSANTES TENSEURS
!     NDI   :  NB DE COMPOSANTES DIRECTES TENSEURS
!     NR    :  NB DE COMPOSANTES DANS LE SYSTEME D'EQUATIONS
!              RESOLUTION PAR NEWTON DANS PLASTI : SIG + VINT
!              IL FAUT AJOUTER UN TERME POUR LES C_PLAN
!     NVI   :  NB DE VARIABLES INTERNES
! ----------------------------------------------------------------
    integer :: ndt, ndi, nr, nvi, nvint
    character(len=8) :: model
!
! --- NB DE COMPOSANTES / VARIABLES INTERNES / CATALOGUE MATERIAU
    nvi = 7
! --- NB VARIABLES INTERNES INTEGREES PAR NEWTON
    nvint = 4
! --- 3D
    if (model(1:2) .eq. '3D') then
        ndt = 6
        ndi = 3
        nr = ndt + nvint
! --- D_PLAN AXIS C_PLAN
    else if (model(1:6).eq.'D_PLAN'.or.model(1:4).eq.'AXIS') then
        ndt = 4
        ndi = 3
        nr = ndt + nvint
    else if (model(1:6).eq.'C_PLAN') then
        ndt = 4
        ndi = 3
        nr = ndt + nvint + 1
    else if (model(1:6).eq.'POUTRE') then
        ndt = 0
        ndi = 0
        nr = 0
    else if (model(1:2).eq.'1D') then
! === =================================================================
!        MODELISATION DE TYPE 1D NON AUTORISEE
        call utmess('F', 'ALGORITH4_45')
    else
! === ==============================================================
!        MODELISATION INCONNUE
        call utmess('F', 'ALGORITH2_20')
    endif
!
end subroutine
