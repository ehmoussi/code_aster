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

subroutine hbrjpl(mod, nbmat, materf, sigp, vip,&
                  vim, vp, vecp, dsidep)
    implicit      none
#include "asterc/r8pi.h"
#include "asterfort/hbderi.h"
#include "asterfort/hbmata.h"
#include "asterfort/hbvaec.h"
#include "asterfort/lcdevi.h"
#include "asterfort/lcinma.h"
#include "asterfort/trace.h"
#include "blas/ddot.h"
    integer :: nbmat
    real(kind=8) :: vim(*), vip(*), sigp(6), dsidep(6, 6), materf(nbmat, 2)
    real(kind=8) :: vp(3), vecp(3, 3)
    character(len=8) :: mod(*)
! ======================================================================
! -- HOEK BROWN : CALCUL DE LA MATRICE TANGENTE COHERENTE DSIG/DEPS ----
! ======================================================================
! IN  : MOD    : TYPE DE MODELISATION ----------------------------------
! --- : NBMAT  : NOMBRE DE PARAMETRES MATERIAU -------------------------
! --- : MATERF : PARAMETRES MATERIAU -----------------------------------
! --- : SIGP   : TENSEUR DES CONTRAINTES A T+ --------------------------
! --- : VIM    : VARIABLES INTERNES A T- -------------------------------
! --- : VIP    : VARIABLES INTERNES A T+ -------------------------------
! --- : VP     : VALEURS PROPRES DU DEVIATEUR ELASTIQUE ----------------
! --- : VECP   : VECTEURS PROPRES DU DEVIATEUR ELASTIQUE ---------------
! OUT : DSIDEP : DSIG/DEPS ---------------------------------------------
! ======================================================================
    integer :: ndt, ndi, ii
    real(kind=8) :: gp, etap, sig3, mu, k, neuf
    real(kind=8) :: i1e, dg, sigeqe, se(6), un, zero
    real(kind=8) :: deux, trois, sf(6), seqf
    real(kind=8) :: parame(4), derive(5), gres, grup, detadg, dgdl
    real(kind=8) :: pi, pphi1, pphi2, pphi0
! ======================================================================
    parameter       ( deux   =  2.0d0  )
    parameter       ( un     =  1.0d0  )
    parameter       ( zero   =  0.0d0  )
    parameter       ( trois  =  3.0d0  )
    parameter       ( neuf   =  9.0d0  )
! ======================================================================
    common /tdim/   ndt, ndi
! ======================================================================
! --- INITIALISATIONS --------------------------------------------------
! ======================================================================
    k = materf(5,1)
    mu = materf(4,1)
    pi = r8pi()
    pi = pi/180.d0
    grup = materf(1,2)
    gres = materf(2,2)
    pphi1 = materf(9,2)
    pphi2 = materf(15,2)
    pphi0 = materf(16,2)
    call lcinma(0.0d0, dsidep)
    pi = r8pi()/180.0d0
! =====================================================================
! --- CALCUL DES PARAMETRES D ECROUISSAGE -----------------------------
! =====================================================================
    gp = vip(1)
    dg = vip(1)-vim(1)
    call hbvaec(gp, nbmat, materf, parame)
    etap = deux*sin(parame(4)*pi)/(trois+sin(parame(4)*pi))
! =====================================================================
! --- CALCUL DES VALEURS PROPRES --------------------------------------
! =====================================================================
    call lcdevi(sigp, sf)
    seqf=ddot(ndt,sf,1,sf,1)
    sigeqe = sqrt(trois*seqf/deux)+trois*mu*dg/(etap+un)
    i1e = trace(ndi,sigp)+9.0d0*k*etap*dg/(etap+un)
    do 10 ii = 1, ndt
        se(ii) = sf(ii)/(1.0d0-3.0d0*mu*dg/((etap+un)*sigeqe))
10  end do
! ======================================================================
! --- CALCUL DE LA MATRICE TANGENTE ------------------------------------
! ======================================================================
    sig3 = vp(3)*(un - trois*mu*dg/(sigeqe*(etap+un))) + (i1e - neuf*k*etap*dg/(etap+un))/trois
    call hbderi(gp, nbmat, materf, zero, etap,&
                parame, derive)
! ======================================================================
    if (gp .lt. materf(1,2)) then
        detadg = 6.0d0*(pphi1-pphi0)*pi*cos(parame(4)*pi) / (grup*( trois+sin(parame(4)*pi))**2)
    else if (gp.lt.materf(2,2)) then
        detadg = 6.0d0*(pphi2-pphi1)*pi*cos(parame(4)*pi) / ((gres- grup)*(trois+sin(parame(4)*pi&
                 &))**2)
    else
        detadg = 0.d0
    endif
    dgdl = etap+un
! ======================================================================
    call hbmata(se, dg, etap, i1e, sigeqe,&
                vp, vecp, parame, derive, sig3,&
                detadg, dgdl, nbmat, materf, dsidep)
! ======================================================================
end subroutine
