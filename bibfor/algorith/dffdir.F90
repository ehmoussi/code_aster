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

subroutine dffdir(ndim, baslo, inoff, vdir)
!
    implicit none
!
    real(kind=8) :: baslo(*), vdir(ndim)
    integer :: ndim, inoff
!
!
! FONCTION REALISEE (OPERATEURS DEFI_FOND_FISS, CALC_G) :
!
!      RETOURNE LE VECTEUR DE DIRECTION DE PROPAGATION (1ER VECTEUR DE
!      LA BASE LOCALE EN FOND DE FISSURE) EN UN NOEUD
!
! IN
!   NDIM   : DIMENSION DU MAILLAGE
!   BASLO  : VALEURS DE LA BASE LOCALE EN FOND DE FISSURE
!   INOFF  : INCIDE LOCAL DU NOEUD DE LA BASE DEMANDE
!
! OUT
!   VDIR   : VALEURS DU VECTEUR DE DIRECTION DE PROPAGATION EN CE NOEUD
!
!-----------------------------------------------------------------------
!
    vdir(1) = baslo(2*ndim*(inoff-1)+1)
    vdir(2) = baslo(2*ndim*(inoff-1)+2)
    if (ndim .eq. 3) vdir(3) = baslo(2*ndim*(inoff-1)+3)
!
end subroutine
