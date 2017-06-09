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

subroutine lcmmj2(taur, materf, cpmono, ifa, nmat,&
                  nbcomm, dt, nsfv, nsfa, ir,&
                  is, nbsys, nfs, nsg, hsr,&
                  vind, dy, dgsdts, dksdts, dgrdbs,&
                  dksdbr, iret)
! aslint: disable=,W1504
    implicit none
! person_in_charge: jean-michel.proix at edf.fr
!       MONOCRISTAL : DERIVEES DES TERMES UTILES POUR LE CALCUL
!                    DU JACOBIEN DU SYSTEME NL A RESOUDRE = DRDY
!                    cf. R5.03.11, COMPO DD_KR
!       IN
!           TAUR   :  SCISSION REDUITE SYSTEME IR
!           MATERF :  COEFFICIENTS MATERIAU A T+DT
!           CPMONO :  NOM DES COMPORTEMENTS
!           IFA    :  NUMERO FAMILLE
!           NMAT   :  DIMENSION MATER
!           NBCOMM :  INCIDES DES COEF MATERIAU
!           DT     :  ACCROISSEMENT INSTANT ACTUEL
!           NSFV   :  DEBUT DES SYST. GLIS. DE LA FAMILLE IFA DANS VIND
!           NSFA   :  DEBUT DES SYST. GLIS. DE LA FAMILLE IFA DANS Y
!           IS     :  NUMERO DU SYST. GLIS. S
!           IR     :  NUMERO DU SYST. GLIS. R
!           NBSYS  :  NOMBRE DE SYSTEMES DE GLISSEMENT FAMILLE IFA
!           HSR    :  MATRICE D'INTERACTION
!           VIND   :  VARIABLES INTERNES A L'INSTANT PRECEDENT
!           DY     :  SOLUTION           =  ( DSIG DX1 DX2 DP (DEPS3) )
!       OUT DGSDTS :  derivee dGammaS/dTauS
!       OUT DKSDTS :  dkS/dTaus
!       OUT DGRDBS :  dGammaR/dBetaS
!       OUT DKRDBS :  dkR/dBetaS
!       OUT IRET   :  CODE RETOUR
!       ----------------------------------------------------------------
#include "asterfort/lcmmfe.h"
#include "asterfort/lcmmjf.h"
    integer :: nmat, nuvr, nbcomm(nmat, 3), nuvi, ifa, nbsys, is, iret, nfs, nsg
    integer :: ir, nsfa, nsfv
    real(kind=8) :: vind(*), dgdtau, hsr(nsg, nsg), dgsdts, dksdts, dgrdbs
    real(kind=8) :: dksdbr
    real(kind=8) :: dhdalr, hs, taur, dp, dy(*), materf(nmat*2), dt, rp, dgdalr
    real(kind=8) :: dfdrr
    real(kind=8) :: alpham, dalpha, alphap, crit, dgamma, sgns, gammap, petith
    real(kind=8) :: sgnr
    character(len=16) :: necoul
    character(len=24) :: cpmono(5*nmat+1)
    integer :: irr, decirr, nbsyst, decal, gdef
    common/polycr/irr,decirr,nbsyst,decal,gdef
!     ----------------------------------------------------------------
!
    iret=0
!
    dgsdts=0.d0
    dksdts=0.d0
    dgrdbs=0.d0
    dksdbr=0.d0
!
    nuvr=nsfa+ir
    nuvi=nsfv+3*(ir-1)
    necoul=cpmono(5*(ifa-1)+3)(1:16)
    alpham=vind(nuvi+1)
    gammap=vind(nuvi+2)
    alphap=alpham+dy(nuvr)
    decal=nsfv
    call lcmmfe(taur, materf(nmat+1), materf(1), ifa, nmat,&
                nbcomm, necoul, ir, nbsys, vind,&
                dy(nsfa+1), rp, alphap, gammap, dt,&
                dalpha, dgamma, dp, crit, sgns,&
                nfs, nsg, hsr, iret)
    if (iret .gt. 0) goto 9999
    if (crit .gt. 0.d0) then
!        CALCUL de dF/dtau
        call lcmmjf(taur, materf(nmat+1), materf(1), ifa, nmat,&
                    nbcomm, dt, necoul, ir, is,&
                    nbsys, vind(nsfv+1), dy(nsfa+1), nfs, nsg,&
                    hsr, rp, alphap, dalpha, gammap,&
                    dgamma, sgnr, dgdtau, dgdalr, dfdrr,&
                    petith, iret)
        if (iret .gt. 0) goto 9999
        dgsdts=dgdtau
        dksdts=abs(dgdtau)*petith
        dgrdbs=dgdalr*sgnr
        dhdalr=dfdrr
        hs=petith
        dksdbr=dgdalr*hs+dp*dhdalr
    endif
!
9999  continue
end subroutine
