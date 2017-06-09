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

subroutine lkdhds(nbmat, mater, invar, s, dhds,&
                  retcom)
!
    implicit none
#include "asterc/r8miem.h"
#include "asterfort/cjst.h"
#include "asterfort/cos3t.h"
#include "asterfort/lcprsc.h"
#include "asterfort/lkhlod.h"
#include "asterfort/utmess.h"
    integer :: nbmat, retcom
    real(kind=8) :: mater(nbmat, 2), invar, s(6), dhds(6)
! --- MODELE LETK : LAIGLE VISCOPLASTIQUE--------------------------
! =================================================================
! --- BUT : CALCUL DES DERICEES dh(THETA)/ds ----------------------
! =================================================================
! IN  :  NBMAT :  NOMBRE DE PARAMETRES MATERIAU -------------------
! --- :  MATER :  COEFFICIENTS MATERIAU A T+DT --------------------
! -----------  :  MATER(*,1) = CARACTERISTIQUES ELASTIQUES --------
! -----------  :  MATER(*,2) = CARACTERISTIQUES PLASTIQUES --------
! --- :  INVAR : INVARINAT DES CONTRAINTES ------------------------
! --- :  S     : DEVIATEUR DES CONTRAINTES ------------------------
! OUT : DHDS: dh(theta)/ds ----------------------------------------
!     : RETCOM : CODE RETOUR POUR REDECOUPAGE ---------------------
! =================================================================
    integer :: ndt, ndi, ii
    real(kind=8) :: gamcjs, pref
    real(kind=8) :: t(6)
    real(kind=8) :: sii, rcos3t, rhlode, h5
    real(kind=8) :: deux, cinq, six, lgleps, ptit
    real(kind=8) :: fact1, fact2
! =================================================================
! --- INITIALISATION DE PARAMETRES --------------------------------
! =================================================================
    parameter       ( deux    =  2.0d0   )
    parameter       ( cinq    =  5.0d0   )
    parameter       ( six     =  6.0d0   )
    parameter       ( lgleps  =  1.0d-8  )
! -----------------------------------------------------------------
    common /tdim/   ndt  , ndi
! -----------------------------------------------------------------
! =================================================================
! --- RECUPERATION DE PARAMETRES DU MODELE ------------------------
! =================================================================
    gamcjs = mater(5,2)
    pref = mater(1,2)
! =================================================================
! --- CALCUL DU DEVIATEUR ET DU PREMIER INVARIANT DES CONTRAINTES -
! =================================================================
    retcom = 0
    ptit = r8miem()
    call lcprsc(s, s, sii)
    sii = sqrt (sii)
    if (sii .lt. ptit) then
        call utmess('A', 'COMPOR1_29')
        retcom = 1
        goto 1000
    endif
! =================================================================
! --- CALCUL DE h(THETA) ------------------------------------------
! =================================================================
    rcos3t = cos3t (s, pref, lgleps)
    rhlode = lkhlod (gamcjs, rcos3t)
    h5 = (rhlode)**cinq
!
    call cjst(s, t)
!
! =================================================================
! --- VARIABLES INTERMEDIAIRES-------------------------------------
! =================================================================
    fact1 = gamcjs*rcos3t/deux/h5/sii**2
    fact2 = gamcjs*sqrt(54.d0)/six/h5/sii**3
! =================================================================
! --- CALCUL FINAL ------------------------------------------------
! =================================================================
    do 10 ii = 1, ndt
        dhds(ii) = fact1*s(ii)-fact2*t(ii)
10  end do
! =================================================================
1000  continue
end subroutine
