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

subroutine lcdvin(fami, kpg, ksp, rela_comp, mod,&
                  imat, matcst, nvi, nmat, vini,&
                  coeft, x, dtime, sigi, dvin,&
                  iret)
    implicit none
!     ROUTINE D AIGUILLAGE
!     ----------------------------------------------------------------
!     INTEGRATION DE LOIS DE COMPORTEMENT ELASTO-VISCOPLASTIQUE
!     PAR UNE METHODE DE RUNGE KUTTA. ROUTINE D'AIGUILLAGE
!     ----------------------------------------------------------------
!     IN  FAMI    FAMILLE DE POINT DE GAUSS (RIGI,MASS,...)
!         KPG,KSP NUMERO DU (SOUS)POINT DE GAUSS
!         COMP     :  NOM DU MODELE DE COMPORTEMENT
!         MOD     :  TYPE DE MODELISATION
!         IMAT    :  ADRESSE DU MATERIAU CODE
!         MATCST  :  NATURE DES PARAMETRES INELASTIQUES
!         NVI     :  NOMBRE DE VARIABLES INTERNES
!         NMAT    :  NOMBRE DE PARAMETRES MATERIAU INELASTIQUE
!         VINI    :  VARIABLES INTERNES A T
!         COEFT   :  COEFFICIENTS MATERIAU INELASTIQUE A T
!         X       :  INTERVALE DE TEMPS ADAPTATIF
!         DTIME   :  INTERVALE DE TEMPS
!         SIGI    :  CONTRAINTES A L'INSTANT COURANT
!     OUT DVIN    :  DERIVEES DES VARIABLES INTERNES A T
!         IRET    :  CODE RETOUR
!     ----------------------------------------------------------------
!
#include "asterfort/norton.h"
#include "asterfort/rkdcha.h"
#include "asterfort/rkdhay.h"
#include "asterfort/rkdvec.h"
    integer :: kpg, ksp, imat, nmat, nvi, iret
    character(len=16) :: rela_comp
    character(len=8) :: mod
    character(len=*) :: fami
    character(len=3) :: matcst
    real(kind=8) :: x, dtime, sigi(6), coeft(nmat), vini(nvi), dvin(nvi)
!
    if (rela_comp .eq. 'VISCOCHAB') then
        call rkdcha(nvi, vini, coeft, nmat, sigi,&
                    dvin)
!
    else if (rela_comp.eq.'VENDOCHAB') then
        call rkdvec(fami, kpg, ksp, imat, matcst,&
                    nvi, vini, coeft, x, dtime,&
                    nmat, sigi, dvin)
!
    else if (rela_comp.eq.'HAYHURST') then
        call rkdhay(mod, nvi, vini, coeft, nmat,&
                    sigi, dvin, iret)
!
    else if (rela_comp.eq.'NORTON') then
        call norton(nvi, vini, coeft, nmat, sigi,&
                    dvin, iret)
!
    endif
end subroutine
