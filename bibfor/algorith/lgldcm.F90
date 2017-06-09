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

subroutine lgldcm(nbmat, mater, sig, vin)
!
    implicit    none
#include "jeveux.h"
#include "asterfort/cos3t.h"
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
    real(kind=8) :: sig(6), mater(nbmat, 2), vin(*)
! --- BUT : CALCUL DU DOMAINE DE COMPORTEMENT DU MATERIAU ---------
! =================================================================
! IN  : NBMAT :  NOMBRE DE PARAMETRES MATERIAU --------------------
! --- : MATER :  COEFFICIENTS MATERIAU A T+DT ---------------------
! ----------- :  MATER(*,1) = CARACTERISTIQUES ELASTIQUES ---------
! ----------- :  MATER(*,2) = CARACTERISTIQUES PLASTIQUES ---------
! --- : SIG   :  TENSEUR DES CONTRAINTES (ELASTIQUE) A T+DT -------
! OUT : VIN   :  VARIABLES INTERNES -------------------------------
! =================================================================
! =================================================================
    integer :: ndt, ndi, jpara, posdom
    real(kind=8) :: gamp, mun, zero, un, deux, trois, quatre
    real(kind=8) :: gammae, gamult, sigc, gamcjs, pref, lgleps
    real(kind=8) :: dev(6), invar1, sii, rcos3t
    real(kind=8) :: rhlode, rgdev, rucpla, h0
    real(kind=8) :: agamp, indidc
    character(len=16) :: parecr
! =================================================================
! --- INITIALISATION DE PARAMETRES --------------------------------
! =================================================================
    parameter  ( mun    = -1.0d0  )
    parameter  ( zero   =  0.0d0  )
    parameter  ( un     =  1.0d0  )
    parameter  ( deux   =  2.0d0  )
    parameter  ( trois  =  3.0d0  )
    parameter  ( quatre =  4.0d0  )
    parameter  ( lgleps =  1.0d-8 )
! =================================================================
    common /tdim/   ndt , ndi
! =================================================================
    call jemarq()
! =================================================================
! --- INITIALISATION DE PARAMETRES --------------------------------
! --- POSDOM DESIGNE LA POSITION DU DOMAINE DANS LES VARIABLES ----
! --- INTERNES ----------------------------------------------------
! =================================================================
    gamp = vin(1)
    posdom = 3
    gamult = mater( 1,2)
    gammae = mater( 2,2)
    sigc = mater( 9,2)
    gamcjs = mater(12,2)
    pref = mater(15,2)
    parecr = '&&LGLDCM.PARECR'
    call wkvect(parecr, 'V V R', 5, jpara)
! =================================================================
    if (gamp .eq. zero) then
! =================================================================
! --- DOMAINES PRE-PIC --------------------------------------------
! =================================================================
! --- CALCUL DE H0 = (1-GAMMA_CJS)**(1/6) -------------------------
! =================================================================
        h0 = hlode(gamcjs, mun)
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
        call varecr(gamp, nbmat, mater, zr(jpara))
        agamp = zr(jpara-1+2)
! =================================================================
! --- SI LE CRITERE PLASTIQUE EST NEGATIF ON REDECOUPE ------------
! =================================================================
        rucpla = ucritp(nbmat, mater, zr(jpara), rgdev, invar1)
        indidc = rgdev/(sigc*h0*rucpla**agamp)
        if (indidc .lt. 0.7d0) then
            vin(posdom) = zero
        else
            vin(posdom) = un
        endif
    else if (gamp.lt.gammae) then
        vin(posdom) = deux
    else if (gamp.lt.gamult) then
        vin(posdom) = trois
    else
        vin(posdom) = quatre
    endif
! =================================================================
! --- DESTRUCTION DES VECTEURS INUTILES ---------------------------
! =================================================================
    call jedetr(parecr)
! =================================================================
    call jedema()
! =================================================================
end subroutine
