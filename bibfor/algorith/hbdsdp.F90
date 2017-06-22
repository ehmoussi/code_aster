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

subroutine hbdsdp(se, dg, etap, sigeqe, vp,&
                  parame, derive, nbmat, materf, sig3,&
                  detadg, dgdl, dsdsip)
    implicit      none
#include "asterfort/cadldp.h"
#include "asterfort/lcprsv.h"
    integer :: nbmat
    real(kind=8) :: se(6), dg, etap, dsdsip(6)
    real(kind=8) :: vp(3), sigeqe, parame(4), derive(5), sig3
    real(kind=8) :: detadg, dgdl, materf(nbmat, 2)
! ======================================================================
! -- HOEK BROWN : CALCUL DE LA MATRICE DSIG/DSIP (CONT. TOTALES) -------
! ======================================================================
! IN  : NBMAT  : NOMBRE DE PARAMETRES MATERIAU -------------------------
! --- : MATERF : PARAMETRES MATERIAU -----------------------------------
! --- : SE     : DEVIATEUR DES CONTRAINTES ELASTIQUES ------------------
! --- : VP     : VALEURS PROPRES DU DEVIATEUR ELASTIQUE ----------------
! --- : VECP   : VECTEURS PROPRES DU DEVIATEUR ELASTIQUE ---------------
! --- : PARAME : VALEUR DES PARAMETRES DE LA LOI S*SIG, M*SIG, B -------
! --- : DERIVE : VALEUR DES DERIVEES DES PARAMETRES PAR RAPPORT A GAMMA
! --- : SIG3   : CONTRAINTE PRINCIPALE SIG3 ----------------------------
! --- : DG     : INCREMENT DU PARAMETRE D ECROUISSAGE GAMMA ------------
! --- : DETADG : DERIVEE DE ETA PAR RAPPORT A GAMMA --------------------
! --- : DGDL   : DERIVEE  DE GAMMA PAR RAPPORT A LAMBDA ----------------
! OUT : DSIDEP : DSIG/DEPS ---------------------------------------------
! ======================================================================
    integer :: ndt, ndi, ii
    real(kind=8) :: deux, trois, seb(6), mu, k, param1, dldsip
! ======================================================================
    parameter       ( deux   =  2.0d0  )
    parameter       ( trois  =  3.0d0  )
! ======================================================================
    common /tdim/   ndt, ndi
! ======================================================================
! --- CALCUL DU VECTEUR UNITE -----------------------------------------
! =====================================================================
    do 91 ii = 1, 6
        dsdsip(ii) = 0.0d0
91  end do
    mu = materf(4,1)
    k = materf(5,1)
    do 150 ii = 1, ndi
        seb(ii) = se(ii)
150  end do
    do 140 ii = ndi+1, ndt
        seb(ii) = se(ii) / sqrt(deux)
140  end do
    do 145 ii = ndt+1, 6
        seb(ii) = 0.0d0
145  end do
! ======================================================================
! --- CALCUL DE DDLAMBDA/DSIP ------------------------------------------
! ======================================================================
    call cadldp(vp, sigeqe, nbmat, materf, parame,&
                derive, sig3, etap, dg, detadg,&
                dgdl, dldsip)
! ======================================================================
    param1 = -trois*mu*dldsip/sigeqe
    call lcprsv(param1, seb, dsdsip)
! ======================================================================
    param1 = 1.0d0-trois*k*dldsip*(detadg*dgdl*dg/(etap+1.0d0)+etap)
    do 90 ii = 1, ndi
        dsdsip(ii) = dsdsip(ii)+param1
90  end do
! ======================================================================
end subroutine
