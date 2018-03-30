! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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

subroutine psvari(compor, nbvari, dimens, ipop1, ipop2)
    implicit none
#include "asterfort/utmess.h"
    character(len=2) :: dimens
    character(len=16) :: compor
    integer :: ipop1, ipop2, nbvari
!
!     FONCTION REALISEE :
!
!     PERMET DE CONNAITRE EN FONCTION DE LA RELATION DE COMPORTEMENT
!     PARMI LES VARIABLES INTERNES LA POSITION DE :
!
!         - LA DEFORMATION PLASTIQUE CUMULEE
!         - L'INDICATEUR DE PLASTICITE
!
! ENTREE  --->  COMPOR : NOM DE LA RELATION DE COMPORTEMENT
!         --->  NBVARI : NOMBRE DE VARIABLES INTERNES
!         --->  DIMENS : DIMENSION DU PROBLEME '2D', '3D'
!
! SORTIE
!         --->  IPOS1  : POSITION DE LA DEFORMATION PLASTIQUE CUMULEE
!         --->  IPOS2  : POSITION DE L'INDICATEUR DE PLASTICITE
!
!     ------------------------------------------------------------------
!
!
    if ((compor.eq.'LEMAITRE' ) .or. (compor.eq.'VMIS_ECMI_TRAC') .or.&
        (compor.eq.'VMIS_ECMI_LINE') .or. (compor.eq.'VMIS_CIN1_CHAB') .or.&
        (compor.eq.'VMIS_CIN2_CHAB') .or. (compor.eq.'VISC_CIN1_CHAB') .or.&
        (compor.eq.'VISC_CIN2_CHAB') .or. (compor.eq.'VMIS_ISOT_TRAC') .or.&
        (compor.eq.'VMIS_ISOT_LINE') .or. (compor.eq.'VMIS2ISOT_TRAC') .or.&
        (compor.eq.'VMIS2ISOT_LINE') .or. (compor.eq.'VISC_ISOT_TRAC') .or.&
        (compor.eq.'VISC_ISOT_LINE')) then
        ipop1=1
        ipop2=2
    else if ((compor.eq.'ROUSSELIER')) then
        ipop1 = 1
        ipop2 = 3
        else if ( (compor.eq.'ROUSS_PR') .or.(compor.eq.'ROUSS_VISC') )&
    then
        ipop1=1
        ipop2=nbvari
    else if (compor.eq.'MONOCRISTAL') then
        ipop1 = nbvari-1
        ipop2 = nbvari
    else if (compor.eq.'POLYCRISTAL') then
        ipop1 = 7
        ipop2 = nbvari
    else
!
        call utmess('F', 'ELEMENTS2_45')
!
    endif
!
end subroutine
