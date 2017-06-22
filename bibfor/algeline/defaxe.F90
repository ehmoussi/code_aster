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

function defaxe(icoq, imod, z, long, nbm,&
                tcoef)
    implicit none
! COUPLAGE FLUIDELASTIQUE, CONFIGURATIONS DU TYPE "COQUE_COAX"
! CALCUL DE LA DEFORMEE AXIALE AU POINT DE COTE Z SUR LA COQUE ICOQ POUR
! LE MODE IMOD
!-----------------------------------------------------------------------
!  IN : ICOQ  : INDICE CARACTERISTIQUE DE LA COQUE CONSIDEREE
!               ICOQ=1 COQUE INTERNE  ICOQ=2 COQUE EXTERNE
!  IN : IMOD  : INDICE DU MODE
!  IN : Z     : COTE
!  IN : LONG  : LONGUEUR DU DOMAINE DE RECOUVREMENT DES DEUX COQUES
!  IN : NBM   : NOMBRE DE MODES PRIS EN COMPTE POUR LE COUPLAGE
!  IN : TCOEF : TABLEAU CONTENANT LES COEFFICIENTS DES DEFORMEES AXIALES
!-----------------------------------------------------------------------
    real(kind=8) :: defaxe
    integer :: icoq, imod, nbm
    real(kind=8) :: z, long, tcoef(10, nbm)
!-----------------------------------------------------------------------
!-----------------------------------------------------------------------
    integer :: itab
    real(kind=8) :: zz
!-----------------------------------------------------------------------
    itab = 0
    if (icoq .eq. 2) itab = 5
    zz = tcoef(1+itab,imod)*z/long
    defaxe = tcoef(2+itab,imod)*dble(cos(zz)) + tcoef(3+itab,imod)*dble(sin(zz)) + tcoef(4+itab,i&
             &mod)*dble(cosh(zz)) + tcoef(5+itab,imod)*dble(sinh(zz))
!
end function
