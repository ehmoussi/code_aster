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

subroutine lglite(yf, nbmat, mater, f0, devg,&
                  devgii, traceg, dy, codret)
!
    implicit      none
#include "jeveux.h"
#include "asterfort/calcdr.h"
#include "asterfort/calcdy.h"
#include "asterfort/cos3t.h"
#include "asterfort/dervar.h"
#include "asterfort/gdev.h"
#include "asterfort/hlode.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jemarq.h"
#include "asterfort/lceqvn.h"
#include "asterfort/solren.h"
#include "asterfort/varecr.h"
#include "asterfort/wkvect.h"
#include "blas/ddot.h"
    integer :: nbmat, codret
    real(kind=8) :: yf(10), mater(nbmat, 2), f0
    real(kind=8) :: devg(6), devgii, traceg, dy(10)
! --- BUT : CALCUL DES DIFFERENTS INCREMENTS ---------------------------
! ======================================================================
! IN  : YF     : (SIG, I1, GAMP, EVP, DELTA) A L'INSTANT COURANT -------
! --- : NR     : DIMENSION DE YD ---------------------------------------
! --- : NBMAT  : NOMBRE DE PARAMETRES MATERIAU -------------------------
! --- : MATER  : PARAMETRES MATERIAU -----------------------------------
! --- : F0     : VALEUR SEUIL A L'INSTANT 0 ----------------------------
! --- : DEVG   : DEVIATEUR DU TENSEUR G --------------------------------
! --- : DEVGII : NORME DU DEVIATEUR DU TENSEUR G -----------------------
! --- : TRACEG : TRACE DU TENSEUR G ------------------------------------
! OUT : DY     : INCREMENTS (DSIG, DI1, DGAMP, DEVP, DDELTA) -----------
! ======================================================================
! ======================================================================
    integer :: jpara, jderiv, ndt, ndi
    real(kind=8) :: pref, epssig, gamcjs, mu, k, snii, rn, gn
    real(kind=8) :: rcos3t
    real(kind=8) :: dfdl, sn(6), invn, gampn, evpn, deltan, q(6)
    character(len=16) :: parecr, derive
! ======================================================================
! --- INITIALISATION DE PARAMETRES -------------------------------------
! ======================================================================
    parameter       ( epssig  = 1.0d-8 )
! ======================================================================
    common /tdim/   ndt , ndi
! ======================================================================
    call jemarq()
! ======================================================================
! --- DEFINITIONS ------------------------------------------------------
! ======================================================================
    parecr = '&&LGLITE.PARECR'
    derive = '&&LGLITE.DERIVE'
    call wkvect(parecr, 'V V R', 5, jpara)
    call wkvect(derive, 'V V R', 4, jderiv)
! ======================================================================
! --- RECUPERATION DE DONNEES ------------------------------------------
! ======================================================================
    mu = mater ( 4,1)
    k = mater ( 5,1)
    gamcjs = mater (12,2)
    pref = mater (15,2)
    call lceqvn(ndt, yf(1), sn(1))
    invn  =yf(ndt+1)
    gampn =yf(ndt+2)
    evpn  =yf(ndt+3)
    deltan=yf(ndt+4)
! ======================================================================
! --- CALCUL DES VARIABLES D'ECROUISSAGES ET DE SES DERIVEES -----------
! ======================================================================
    call varecr(gampn, nbmat, mater, zr(jpara))
    call dervar(gampn, nbmat, mater, zr(jpara), zr(jderiv))
! ======================================================================
! --- CALCUL DES VARIABLES ELASTIQUES INITIALES ------------------------
! ======================================================================
    snii=ddot(ndt,sn,1,sn,1)
    snii = sqrt (snii)
    rcos3t = cos3t (sn, pref, epssig)
    rn = hlode (gamcjs, rcos3t)
    gn = gdev (snii, rn)
! ======================================================================
! --- CALCUL DE Q ------------------------------------------------------
! ======================================================================
    call solren(sn, nbmat, mater, q, codret)
    if (codret .ne. 0) goto 100
! ======================================================================
! --- CALCUL DES DIFFERENTES DERIVEES ----------------------------------
! ======================================================================
    call calcdr(nbmat, mater, zr(jpara), zr(jderiv), gn,&
                invn, q, devg, devgii, traceg,&
                dfdl)
! ======================================================================
! --- CALCUL DES DIFFERENTS INCREMENTS ---------------------------------
! ======================================================================
    call calcdy(mu, k, f0, devg, devgii,&
                traceg, dfdl, deltan, dy)
! ======================================================================
! --- DESTRUCTION DES VECTEURS INUTILES --------------------------------
! ======================================================================
100  continue
    call jedetr(parecr)
    call jedetr(derive)
! ======================================================================
    call jedema()
! ======================================================================
end subroutine
