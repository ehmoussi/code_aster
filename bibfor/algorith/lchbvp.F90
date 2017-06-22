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

subroutine lchbvp(sigd, vp, vecp)
    implicit none
#include "asterfort/codree.h"
#include "asterfort/jacobi.h"
#include "asterfort/lcdevi.h"
#include "asterfort/utmess.h"
    real(kind=8) :: sigd(6), vp(3), vecp(3, 3)
! =====================================================================
! --- HOEK-BROWN : VALEURS ET VECTEURS PROPRES DU DEVIATEUR DE SIGD ---
! --- UTILISE POUR L OPTION RIGI_MECA AFIN DE CALCULER LES VALEURS ----
! --- ET VECTEURS PROPRES DU DEVIATEUR ELASTIQUE ----------------------
! =====================================================================
! IN  : SIGD   :  TENSEUR DES CONTRAINTES (ELASTIQUE) -----------------
! OUT : VP     :  VALEURS PROPRES ORDONNEES DU DEVIATEUR DE SIGD ------
! --- : VECP   :  VECTEURS PROPRES DU DEVIATEUR DE SIGD ---------------
! =====================================================================
    real(kind=8) :: seb(6), deux, se(6), tu(6), tol, toldyn, jacaux(3)
    character(len=10) :: cvp1, cvp2, cvp3
    character(len=24) :: valk(3)
    integer :: ndt, ndi, nperm, ttrij, otrij, nitjac
! ======================================================================
    parameter   (deux = 2.0d0)
! ======================================================================
    common /tdim/   ndt, ndi
! ======================================================================
    data   nperm ,tol,toldyn    /12,1.d-10,1.d-2/
    data   ttrij,otrij  /0,0/
! ======================================================================
    call lcdevi(sigd, se)
    seb(1) = se(1)
    seb(2) = se(4)/sqrt(deux)
    seb(4) = se(2)
    seb(6) = se(3)
    if (ndt .eq. 4) then
        seb(3) = 0.0d0
        seb(5) = 0.0d0
    else
        seb(3) = se(5) / sqrt(deux)
        seb(5) = se(6) / sqrt(deux)
    endif
! -- MATRICE UNITE POUR JACOBI ----------------------------------------
    tu(1) = 1.d0
    tu(2) = 0.d0
    tu(3) = 0.d0
    tu(4) = 1.d0
    tu(5) = 0.d0
    tu(6) = 1.d0
    call jacobi(3, nperm, tol, toldyn, seb,&
                tu, vecp, vp, jacaux, nitjac,&
                ttrij, otrij)
    if ((vp(2).lt.vp(1)) .or. (vp(3).lt.vp(2))) then
        call codree(vp(1), 'E', cvp1)
        call codree(vp(2), 'E', cvp2)
        call codree(vp(3), 'E', cvp3)
        valk(1) = cvp1
        valk(2) = cvp2
        valk(3) = cvp3
        call utmess('F', 'ALGORITH3_89', nk=3, valk=valk)
    endif
! ======================================================================
end subroutine
