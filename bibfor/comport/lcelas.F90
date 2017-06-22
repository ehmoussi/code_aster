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

subroutine lcelas(fami, kpg, ksp, loi, mod,&
                  imat, nmat, materd, materf, matcst,&
                  nvi, angmas, deps, sigd, vind,&
                  sigf, vinf, theta, etatd, crit,&
                  iret)
    implicit   none
!       INTEGRATION ELASTIQUE SUR DT
!       IN  LOI    :  NOM DU MODELE DE COMPORTEMENT
!           MOD    :  MODELISATION
!           NMAT   :  DIMENSION MATER
!           MATERD :  COEFFICIENTS MATERIAU A T
!           MATERF :  COEFFICIENTS MATERIAU A T+DT
!           ANGMAS :  ANGLES DU MOT_CLEF MASSIF (AFFE_CARA_ELEM)
!           VIND   :  VARIABLES INTERNES A T
!           SIGD   :  CONTRAINTE  A T
!       VAR DEPS   :  INCREMENT DE DEFORMATION
!       OUT SIGF   :  CONTRAINTE A T+DT
!           VINF   :  VARIABLES INTERNES A T+DT
!           IRET   :  CODE RETOUR (O-->OK / 1-->NOOK)
!       ----------------------------------------------------------------
#include "asterfort/hujpel.h"
#include "asterfort/lcelin.h"
#include "asterfort/lksige.h"
#include "asterfort/srsige.h"
#include "asterfort/rsllin.h"
    integer :: nmat, nvi, imat, iret, kpg, ksp
!
    real(kind=8) :: materd(nmat, 2), materf(nmat, 2)
    real(kind=8) :: theta
    real(kind=8) :: sigd(6), sigf(6)
    real(kind=8) :: vind(*), vinf(*)
    real(kind=8) :: deps(6), crit(*)
    real(kind=8) :: angmas(3)
!
    character(len=*) :: fami
    character(len=8) :: mod
    character(len=16) :: loi
    character(len=3) :: matcst
    character(len=7) :: etatd
!
! --- INITIALISATION VARIABLE CODE RETOUR
    iret = 0
!
    if (loi(1:8) .eq. 'ROUSS_PR' .or. loi(1:10) .eq. 'ROUSS_VISC') then
        call rsllin(mod, nmat, materd, materf, matcst,&
                    deps, sigd, vind, sigf, theta)
    else if (loi(1:4).eq.'LETK') then
!        ELASTICITE NON LINEAIRE ISOTROPE POUR LETK
        call lksige(mod, nmat, materd, deps, sigd,&
                    sigf)
    else if (loi(1:3).eq.'LKR') then
!        ELASTICITE NON LINEAIRE ISOTROPE POUR LKR
        call srsige(nmat,materd,deps,sigd,sigf)
    else if (loi(1:6).eq.'HUJEUX') then
!        ELASTICITE NON LINEAIRE ISOTROPE POUR HUJEUX
        call hujpel(fami, kpg, ksp, etatd, mod,&
                    crit, imat, nmat, materf, angmas,&
                    deps, sigd, nvi, vind, sigf,&
                    vinf, iret)
    else
!        ELASTICITE LINEAIRE ISOTROPE OU ANISOTROPE
        call lcelin(mod, nmat, materd, materf, deps,&
                    sigd, sigf)
!
    endif
!
end subroutine
