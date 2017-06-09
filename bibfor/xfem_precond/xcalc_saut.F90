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

function xcalc_saut(id_no, id_escl, id_mait, iflag)
!
!-----------------------------------------------------------------------
! BUT : CALCULER LA FONCTION SAUT : -2 | 0 | 2
!-----------------------------------------------------------------------
!
! ARGUMENTS :
!------------
!   - ID_NO  : IDENTIFIANT <ENTIER> DU DOMAINE DE LA FONCTION HEAVISIDE
!   - ID_ESCL  : IDENTIFIANT DOMAINE ESCLAVE
!   - ID_MAIT  : IDENTIFIANT DOMAINE MAITRE
!   - IFLAG  : FLAG POUR LE MONO HEAVISIDE ==> A NETTOYER
!-----------------------------------------------------------------------
    implicit none
!-----------------------------------------------------------------------
#include "jeveux.h"
#include "asterfort/xcalc_heav.h"
!-----------------------------------------------------------------------
    integer :: id_no, id_escl, id_mait
    integer, optional ::  iflag
    real(kind=8) :: xcalc_saut
!-----------------------------------------------------------------------
    integer :: iflagg
!-----------------------------------------------------------------------
!
    iflagg = -99
    if ( present(iflag) ) iflagg=iflag
!
    xcalc_saut=xcalc_heav(id_no,id_mait,iflagg)-xcalc_heav(id_no,id_escl,iflagg)
!
end function
