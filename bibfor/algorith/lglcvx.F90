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

subroutine lglcvx(sig, vin, nbmat, mater, seuil)
!
    implicit    none
#include "jeveux.h"
#include "asterfort/cos3t.h"
#include "asterfort/domrev.h"
#include "asterfort/gdev.h"
#include "asterfort/hlode.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/lcdevi.h"
#include "asterfort/lcprsc.h"
#include "asterfort/trace.h"
#include "asterfort/ucritp.h"
#include "asterfort/varecr.h"
#include "asterfort/wkvect.h"
    integer :: nbmat
    real(kind=8) :: sig(6), mater(nbmat, 2), vin(*), seuil
! --- BUT : VALEUR SEUIL POUR LE CONVEXE ELASTO-PLASTIQUE ---------
! =================================================================
! IN  : SIG   :  TENSEUR DES CONTRAINTES (ELASTIQUE) A T+DT -------
! --- : VIN   :  VARIABLES INTERNES -------------------------------
! --- : NBMAT :  NOMBRE DE PARAMETRES MATERIAU --------------------
! --- : MATER :  COEFFICIENTS MATERIAU A T+DT ---------------------
! ----------- :  MATER(*,1) = CARACTERISTIQUES ELASTIQUES ---------
! ----------- :  MATER(*,2) = CARACTERISTIQUES PLASTIQUES ---------
! OUT : SEUIL :  VALEUR DE F(S) -----------------------------------
! =================================================================
! =================================================================
    integer :: ndt, ndi, jpara
    real(kind=8) :: dev(6), invar1, sii, pref, lgleps, gamcjs, sigc
    real(kind=8) :: gamp, rcos3t, rhlode, rgdev, rucpla
    character(len=16) :: parecr
! =================================================================
! --- INITIALISATION DE PARAMETRES --------------------------------
! =================================================================
    parameter       ( lgleps  = 1.0d-8 )
! =================================================================
    common /tdim/   ndt , ndi
! =================================================================
    call jemarq()
! =================================================================
! --- DEFINITIONS -------------------------------------------------
! =================================================================
    parecr = '&&LGLCVX.PARECR'
    call wkvect(parecr, 'V V R', 5, jpara)
! =================================================================
! --- RECUPERATION DES DONNEES MATERIAU ---------------------------
! =================================================================
    sigc = mater( 9,2)
    gamcjs = mater(12,2)
    pref = mater(15,2)
! =================================================================
! --- CALCUL DU DEVIATEUR ET DU PREMIER INVARIANT DES CONTRAINTES -
! =================================================================
    call lcdevi(sig, dev)
    invar1 = trace (ndi, sig)
! =================================================================
! --- CALCUL DE G(S) ----------------------------------------------
! =================================================================
    call lcprsc(dev, dev, sii)
    sii = sqrt (sii)
    rcos3t = cos3t (dev, pref, lgleps)
    rhlode = hlode (gamcjs, rcos3t)
    rgdev = gdev (sii , rhlode)
! =================================================================
! --- CALCUL DE U(SIG, GAMP) --------------------------------------
! =================================================================
    gamp = vin(1)
    call varecr(gamp, nbmat, mater, zr(jpara))
! =================================================================
! --- SI LE CRITERE PLASTIQUE EST NEGATIF ON REDECOUPE ------------
! =================================================================
    rucpla = ucritp(nbmat, mater, zr(jpara), rgdev, invar1)
    seuil = domrev(gamcjs, sigc, zr(jpara), rgdev, rucpla)
! =================================================================
! --- DESTRUCTION DES VECTEURS INUTILES ---------------------------
! =================================================================
    call jedetr(parecr)
! =================================================================
    call jedema()
! =================================================================
end subroutine
