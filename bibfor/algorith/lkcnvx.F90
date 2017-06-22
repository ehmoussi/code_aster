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

subroutine lkcnvx(sigd, sigf, nvi, vind, nmat,&
                  mater, seuil, vinf)
    implicit none
! person_in_charge: alexandre.foucault at edf.fr
! ----------------------------------------------------------------------
! --- BUT : CONVEXE ELASTO-VISCO-PLASTIQUE DE LETK A T+DT --------------
! ---       POUR (SIGF , VINT) DONNES ----------------------------------
! ----------------------------------------------------------------------
! -IN : SIGF   :  CONTRAINTE ELASTIQUE ---------------------------------
! --- : SIGD   :  CONTRAINTE A T ---------------------------------------
! --- : NVI    :  NOMBRE DE VARIABLES INTERNES -------------------------
! --- : VIND   :  VARIABLES INTERNES A T -------------------------------
! --- : NMAT   :  DIMENSION MATER --------------------------------------
! --- : MATER  :  COEFFICIENTS MATERIAU --------------------------------
! OUT : SEUIL  :  SEUIL  PLASTICITE  ET VISCOSITE ----------------------
! ----  SI SEUILV OU SEUILP > 0 -> SEUIL = 1.D0 (NEWTON LOCAL ENCLENCHE)
! ----  VINF(7):  0 OU 1 POUR PRISE EN COMPTE PLASTICITE DANS LCPLAS ---
! ----------------------------------------------------------------------
! ======================================================================
#include "asterc/r8prem.h"
#include "asterfort/lcdevi.h"
#include "asterfort/lkcrip.h"
#include "asterfort/lkcriv.h"
#include "asterfort/utmess.h"
    integer :: nmat, nvi
    real(kind=8) :: mater(nmat, 2), seuil
    real(kind=8) :: sigd(6), sigf(6), vind(nvi), vinf(nvi)
!
    integer :: ndt, ndi, i
    real(kind=8) :: i1, devsig(6), ubid, sigt(6), sigu(6)
    real(kind=8) :: xit, seuilp, seuilv, zero, un, somme
!
    parameter       (zero  =  0.d0 )
    parameter       (un    =  1.d0 )
!       --------------------------------------------------------------
    common /tdim/   ndt  , ndi
!       --------------------------------------------------------------
! --------------------------------------------------------------------
! --- PASSAGE EN CONVENTION MECANIQUE DES SOLS
! --------------------------------------------------------------------
    do 10 i = 1, ndt
        sigt(i) = -sigf(i)
        sigu(i) = -sigd(i)
10  continue
!
! --------------------------------------------------------------------
! --- VERIFICATION D'UN ETAT INITIAL PLASTIQUEMENT ADMISSIBLE -----
! --------------------------------------------------------------------
    somme = zero
    do 20 i = 1, nvi
        somme = somme + vind(i)
20  end do
    if (abs(somme) .lt. r8prem()) then
        i1 = sigu(1)+sigu(2)+sigu(3)
        call lcdevi(sigu, devsig)
        call lkcrip(i1, devsig, vind, nmat, mater,&
                    ubid, seuilp)
        if (seuilp/mater(4,1) .gt. 1.0d-6) then
            call utmess('F', 'ALGORITH2_2')
        endif
    endif
!
! --------------------------------------------------------------------
! --- CONSTRUCTION TENSEUR DEVIATOIRE DES CONTRAINTES ET 1ER INVARIANT
! --------------------------------------------------------------------
    call lcdevi(sigt, devsig)
    i1 = sigt(1)+sigt(2)+sigt(3)
!
! ----------------------------------------------------------------------
! --- CALCUL FONCTION SEUIL PLASTIQUE EN SIGF
! ----------------------------------------------------------------------
    call lkcrip(i1, devsig, vind, nmat, mater,&
                ubid, seuilp)
    if (seuilp .ge. zero) then
        vinf(7) = un
    else
        vinf(7) = zero
    endif
! ----------------------------------------------------------------------
! --- CALCUL FONCTION SEUIL VISQUEUX EN SIGF
! ----------------------------------------------------------------------
    xit = vind(3)
    call lkcriv(xit, i1, devsig, vind, nmat,&
                mater, ubid, seuilv)
!
    if ((seuilv.ge.zero) .or. (seuilp.ge.zero)) then
        seuil = 1.d0
    else
        seuil = -1.d0
    endif
!
end subroutine
