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

subroutine cfrott(visc, rug, hmoy, umoy, cf0,&
                  mcf0)
    implicit none
! COUPLAGE FLUIDELASTIQUE, CONFIGURATIONS DU TYPE "COQUE_COAX"
! CALCUL DU COEFFICIENT DE FROTTEMENT VISQUEUX
!-----------------------------------------------------------------------
!  IN : VISC : VISCOSITE CINEMATIQUE DU FLUIDE
!  IN : RUG  : RUGOSITE ABSOLUE DE PAROI DES COQUES
!  IN : HMOY : JEU ANNULAIRE MOYEN
!  IN : UMOY : VITESSE DE L'ECOULEMENT MOYEN
! OUT : CF0  : COEFFICIENT DE FROTTEMENT VISQUEUX
! OUT : MCF0 : EXPOSANT VIS-A-VIS DU NOMBRE DE REYNOLDS
!-----------------------------------------------------------------------
    real(kind=8) :: visc, rug
    real(kind=8) :: hmoy, umoy, cf0, mcf0
!-----------------------------------------------------------------------
!
!-----------------------------------------------------------------------
    real(kind=8) :: corr, re, rel
!-----------------------------------------------------------------------
    if (visc .lt. 1.d-10) then
        mcf0 = 0.d0
        cf0 = 0.d0
        goto 100
    endif
!
    re = 2.d0*hmoy*umoy/visc
    rel = (17.85d0/rug*2.d0*hmoy)**1.143d0
!
    corr = 1.5d0
!
    if (re .lt. 2000.d0) then
        mcf0 = -1.d0
        cf0 = 16.d0*(re**mcf0)*corr
    else if (re.lt.4000.d0) then
        mcf0 = 0.55d0
        cf0 = 1.2d-4*(re**mcf0)*corr
    else if (re.lt.100000.d0) then
        if (re .lt. rel) then
            mcf0 = -0.25d0
            cf0 = 0.079d0*(re**mcf0)*corr
        else
            mcf0 = 0.d0
            cf0 = 0.079d0*(rel**(-0.25d0))*corr
        endif
    else if (re.lt.rel) then
        mcf0 = -0.87d0/(dble(log10(re))-0.91d0)
        cf0 = 0.25d0/((1.8d0*dble(log10(re))-1.64d0)**2)*corr
    else
        mcf0 = 0.d0
        cf0 = 0.25d0/((1.8d0*dble(log10(rel))-1.64d0)**2)*corr
    endif
!
100  continue
end subroutine
