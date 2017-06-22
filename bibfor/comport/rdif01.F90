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

subroutine rdif01(fami, kpg, ksp, rela_comp, mod,&
                  imat, matcst, nbcomm, cpmono, nfs,&
                  nsg, toutms, nvi, nmat, vini,&
                  cothe, coeff, dcothe, dcoeff, pgl,&
                  nbphas, coel, x, dtime, neps,&
                  epsd, detot, dvin, nhsr, numhsr,&
                  hsr, itmax, toler, iret)
! aslint: disable=W1306,W1504
    implicit none
!     ROUTINE D AIGUILLAGE
!     ----------------------------------------------------------------
!     INTEGRATION DE LOIS DE COMPORTEMENT ELASTO-VISCOPLASTIQUE
!     PAR UNE METHODE DE RUNGE KUTTA
!     ----------------------------------------------------------------
!     IN  FAMI    FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
!     IN  KPG,KSP NUMERO DU (SOUS)POINT DE GAUSS
!     IN  COMP     :  NOM DU MODELE DE COMPORTEMENT
!         MOD     :  TYPE DE MODELISATION
!         IMAT    :  ADRESSE DU MATERIAU CODE
!         MATCST  :  NATURE DES PARAMETRES INELASTIQUES
!         NVI     :  NOMBRE DE VARIABLES INTERNES
!         NMAT    :  NOMBRE DE PARAMETRES MATERIAU INELASTIQUE
!         VINI    :  VARIABLES INTERNES A T
!         COTHE   :  COEFFICIENTS MATERIAU ELASTIQUE A T
!         COEFF   :  COEFFICIENTS MATERIAU INELASTIQUE A T
!         DCOTHE  :  DELTA COEFFICIENTS MATERIAU ELASTIQUE A T+DT
!         DCOEFF  :  DELTA COEFFICIENTS MATERIAU INELASTIQUE A T+DT
!         COEL    :  COEFFICIENTS D'ELASTICITE
!         X       :  INTERVALE DE TEMPS ADAPTATIF
!         DTIME   :  INTERVALE DE TEMPS
!         EPSD    :  DEFORMATION TOTALE A T
!         DETOT   :  INCREMENT DE DEFORMATION TOTALE
!         DVIN    :  DERIVEES DES VARIABLES INTERNES A T
!     ----------------------------------------------------------------
#include "asterfort/calsig.h"
#include "asterfort/coefft.h"
#include "asterfort/lcdvin.h"
#include "asterfort/lcmmon.h"
#include "asterfort/lcmmop.h"
    integer :: kpg, ksp, imat, nmat, nvi, nbcomm(nmat, 3), itens
    integer :: nbphas, nfs, iret, itmax, nsg, nhsr, numhsr(*), neps
    character(len=16) :: rela_comp
    character(len=24) :: cpmono(5*nmat+1)
    character(len=8) :: mod
    character(len=*) :: fami
    character(len=3) :: matcst
    real(kind=8) :: pgl(3, 3), toler, x, dtime, coel(nmat)
    real(kind=8) :: cothe(nmat), dcothe(nmat), coeff(nmat), dcoeff(nmat)
    real(kind=8) :: epsd(6), detot(6), coeft(nmat), xm, sigi(6)
    real(kind=8) :: vini(nvi), dvin(nvi), hsr(nsg, nsg, nhsr), evi(6)
!     POUR GAGNER EN TEMPS CPU
    real(kind=8) :: toutms(*)
!
    if (rela_comp(1:8) .eq. 'MONOCRIS') then
!       PAS DE VARIATION DES COEF AVEC LA TEMPERATURE
        xm=0.d0
        call coefft(cothe, coeff, dcothe, dcoeff, xm,&
                    dtime, coeft, nmat, coel)
        call lcmmon(fami, kpg, ksp, rela_comp, nbcomm,&
                    cpmono, nmat, nvi, vini, x,&
                    dtime, pgl, mod, coeft, neps,&
                    epsd, detot, coel, dvin, nfs,&
                    nsg, toutms, hsr(1, 1, 1), itmax, toler,&
                    iret)
!
    else if (rela_comp(1:8).eq.'POLYCRIS') then
!       PAS DE VARIATION DES COEF AVEC LA TEMPERATURE
        xm=0.d0
        call coefft(cothe, coeff, dcothe, dcoeff, xm,&
                    dtime, coeft, nmat, coel)
        call lcmmop(fami, kpg, ksp, rela_comp, nbcomm,&
                    cpmono, nmat, nvi, vini, x,&
                    dtime, mod, coeft, epsd, detot,&
                    coel, nbphas, nfs, nsg, toutms,&
                    dvin, nhsr, numhsr, hsr, itmax,&
                    toler, iret)
!
    else
!
        do itens = 1, 6
            evi(itens) = vini(itens)
        end do
!
        call coefft(cothe, coeff, dcothe, dcoeff, x,&
                    dtime, coeft, nmat, coel)
!
!
        call calsig(fami, kpg, ksp, evi, mod,&
                    rela_comp, vini, x, dtime, epsd,&
                    detot, nmat, coel, sigi)
!
        call lcdvin(fami, kpg, ksp, rela_comp, mod,&
                    imat, matcst, nvi, nmat, vini,&
                    coeft, x, dtime, sigi, dvin,&
                    iret)
!
    endif
end subroutine
