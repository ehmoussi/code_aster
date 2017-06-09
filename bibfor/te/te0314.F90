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

subroutine te0314(option, nomte)
    implicit none
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/lteatt.h"
    character(len=16) :: option, nomte
!
!
!     BUT: CALCUL DES VECTEURS ELEMENTAIRES EN MECANIQUE
!          CORRESPONDANT A UN DEBIT HYDRAULIQUE SUR UN ELEMENT DE BORD
!          D'UN JOINT HM
!          OPTION : 'CHAR_MECA_FLUX_R'
!
!    - ARGUMENTS:
!        DONNEES:      OPTION       -->  OPTION DE CALCUL
!                      NOMTE        -->  NOM DU TYPE ELEMENT
! ======================================================================
! NNO      NB DE NOEUDS DE L'ELEMENT DE BORD QUADRATIQUE
! NNO2     NB DE NOEUDS DE L'ELEMENT DE BORD LINEAIRE
! NNOS     NB DE NOEUDS EXTREMITE
! NDLNO    NB DE DDL DES NOEUDS EXTREMITE
! NDLNM    NB DE DDL DES NOEUDS MILIEUX
! NPG      NB DE POINTS DE GAUSS DE L'ELEMENT DE BORD
! ======================================================================
! ======================================================================
    aster_logical :: axi
    integer :: ires, iflux, itemps, igeom
    real(kind=8) :: flu1, deltat, r
!
    axi = .false.
!
    if (lteatt('AXIS','OUI')) then
        axi = .true.
    endif
! ======================================================================
! --- RECUPERATION DES CHAMPS IN ET DES CHAMPS OUT ---------------------
! ======================================================================
    call jevech('PVECTUR', 'E', ires)
!
! ======================================================================
! --- CAS DES FLUX -----------------------------------------------------
! ======================================================================
    if (option .eq. 'CHAR_MECA_FLUX_R') then
        call jevech('PFLUXR', 'L', iflux)
        call jevech('PTEMPSR', 'L', itemps)
        call jevech('PGEOMER', 'L', igeom)
        deltat = zr(itemps+1)
    endif
!
! ======================================================================
! --- OPTION CHAR_MECA_FLUX_R ----------------------
! ======================================================================
!
! ======================================================================
! --- SI MODELISATION = HM ---------------------------------------------
! ======================================================================
!
    flu1 = zr(iflux)
    if (axi) then
        r = zr(igeom)
        zr(ires+6) = zr(ires+6) - deltat*flu1*r
    else
        zr(ires+6) = zr(ires+6) - deltat*flu1
    endif
!
end subroutine
