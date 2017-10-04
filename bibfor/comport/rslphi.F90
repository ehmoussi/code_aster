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

subroutine rslphi(fami, kpg, ksp, loi, imat,&
                  troisk, troimu, depsmo, rigdmo, rieleq,&
                  pi, d, s1, ann, theta,&
                  acc, f, df, sig0, eps0,&
                  mexpo, dt, phi, phip, rigeq,&
                  rigm, p, overfl)
! aslint: disable=W1504
    implicit none
!       CALCUL DE LA FONCTION A ANNULER ET SA DERIVE POUR
!          CALCULER L'INCREMENT DF POUR LA LOI DE ROUSSELIER
!          PHI(DF)=RIGEQ(DF)-R(P(DF))+D*S1*F(DF)*EXP(RIGM(DF)/S1)=0
!
!       IN  IMAT   :  ADRESSE DU MATERIAU CODE
!           FAMI   :  FAMILLE DU POINT DE GAUSS
!           KPG    :  POINT DE GAUSS
!           KSG    :  SOUS-POINT DE GAUSS
!           TROISK :  ELASTICITE : PARTIE MOYENNE
!           TROIMU :  ELASTICITE : 2/3*PARTIE DEVIATORIQUE
!           DEPSMO :  INCREMENT DEFORMATION : PARTIE MOYENNE
!           RIGDMO :  CONTRAINTE REDUITE INITIALE : PARTIE MOYENNE
!           RIELEQ :  (SIGFDV/RHO+2MU*DEPSDV)     : PARTIE EQUIVALENTE
!           PI     :  PLASTICITE CUMULE INITIALE
!           F      :  INCONNU (POROSITE)
!           DF     :  INCREMENT D INCONNU
!           DT     :  INTERVALLE DE TEMPS DT
!       OUT PHI    :  FONCTION A ANNULE
!           PHIP   :  DERIVE DE PHI / INCONNU
!           RIGEQ  :  CONTRAINTE EQUIVALENTE
!           RIGM   :  CONTRAINTE MOYENNE
!           P      :  PLASTICITE CUMULE
!       -------------------------------------------------------------
#include "asterf_types.h"
#include "asterc/r8miem.h"
#include "asterfort/rsliso.h"
    integer :: imat, kpg, ksp
!
    character(len=16) :: loi
    character(len=*) :: fami
!
    real(kind=8) :: troisk, troimu, deux, coeffa, dt
    real(kind=8) :: rieleq, rigeq, rigm, depsmo, rigdmo, coeffb
    real(kind=8) :: pi, p, dp, f, df, phi, phip, d, s1, discri
    real(kind=8) :: rp, drdp, d13, un, unmf, unex, dunex
    real(kind=8) :: drigm, ddp, acc, expo, dexpo, ptheta
    real(kind=8) :: coeffc, theta, ftheta, ftot, ann, zero
    real(kind=8) :: sig0, eps0, mexpo, puiss
    real(kind=8) :: seuil, dseuil, dpuiss, asinh, lv1, lv2, lv3
!
    aster_logical :: overfl
!
    parameter       ( un     = 1.d0  )
    parameter       ( zero   = 0.d0  )
    parameter       ( deux   = 2.d0  )
    parameter       ( d13    = .33333333333333d0 )
!
!      -------------------------------------------------------------
!
    overfl = .false.
    ftheta = f - (un - theta)*df
    unmf = (un-ftheta)
!
! ----- CALCUL DE RIGM ET DRIGM/DDF---------------
    rigm = rigdmo + troisk*theta*(depsmo - d13*df/unmf/acc)
    drigm = -troisk*d13*theta*(unmf+theta*df)/(unmf**2)/acc
    ! limit some quantities to avoid FPE in exponentials
    if ((rigm/s1) > 1.d1) then
        overfl = .true.
        goto 9999
    endif
    expo = d*exp(rigm/s1)
    dexpo = expo*(drigm/s1)
    unex = unmf*expo*acc
    dunex = (-theta*expo + unmf*dexpo)*acc
!
! ----- CALCUL DE DP ET DDP/DDF-----------
! ----- ABSENCE DE GERMINATION---------------
    if (ann .eq. zero) then
        dp = df/(ftheta*unex)
        ddp = (un - df*dunex/unex -df*theta/ftheta)/(ftheta*unex)
! ----- AN NON NUL---------------
    else
        coeffa = deux*ann*theta
        coeffb = ftheta + ann*pi
        coeffc = df/unex
        discri = coeffb**2 + deux*coeffa*coeffc
        if (coeffc .le. r8miem()) then
            dp=0.d0
        else
            dp=(-coeffb+sqrt(discri))/coeffa
        endif
        ddp=((un-df*dunex/unex )/unex -theta*dp)/(coeffa*dp+coeffb)
    endif
    p = pi+dp
    ptheta= pi +theta*dp
    ! limit plastic strain to avoid subsequent FPE
    if (p > 1.d30) then
        overfl = .true.
        goto 9999
    endif
!
! ----- CALCUL DE RIGEQ ---------------
    rigeq = rieleq - troimu*theta*dp
!
! ----- CALCUL DE R(P) ET DR/DP(P) ----
    call rsliso(fami, kpg, ksp, '+', imat,&
                ptheta, rp, drdp)
!
    ftot = ftheta + ann*ptheta
!
! ----- CALCUL DE PHI -----------------
!
    phi = rigeq - rp + s1*ftot*expo
!
!
! ----- CALCUL DE DPHI/DDF -------------
!
    phip = s1*(ftot*dexpo + (theta + ann*theta*ddp)*expo) -(troimu+drdp )*theta*ddp
!
!
    if (loi(1:10) .eq. 'ROUSS_VISC') then
        seuil = phi
        dseuil = phip
!          PUISS = (DP/(DT*EPS0))**(UN/MEXPO)
!          DPUISS = ( (DP/(DT*EPS0))**(UN/MEXPO-UN) )/( MEXPO*DT*EPS0 )
        if (dp .eq. 0.d0) then
            puiss = 0.d0
            dpuiss = 0.d0
        else
            lv1 = dp / (dt*eps0)
            lv2 = un / mexpo - un
            lv3 = mexpo * dt * eps0
            puiss = ( lv1 )**(un/mexpo)
            dpuiss = ( lv1**lv2 ) / lv3
        endif
!
        asinh = log(puiss + sqrt(un + puiss**2))
        phi = seuil - sig0*asinh
        phip = dseuil - sig0*ddp*dpuiss/sqrt(un+puiss**2)
    endif
!
! ----- ET C EST FINI -------------
9999 continue
end subroutine
