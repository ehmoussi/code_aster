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

subroutine lcmmjb(taur, materf, cpmono, ifa, nmat,&
                  nbcomm, dt, nuecou, nsfv, nsfa,&
                  ir, is, nbsys, nfs, nsg,&
                  hsr, vind, dy, iexp, expbp,&
                  itmax, toler, dgsdts, dksdts, dgrdbs,&
                  dkrdbs, iret)
! aslint: disable=W1504
    implicit none
! person_in_charge: jean-michel.proix at edf.fr
!       ----------------------------------------------------------------
!       MONOCRISTAL : DERIVEES DES TERMES UTILES POUR LE CALCUL
!                    DU JACOBIEN DU SYSTEME NL A RESOUDRE = DRDY
!                    cf. R5.03.11
!       IN
!           TAUR   :  SCISSION REDUITE SYSTEME IR
!           MATERF :  COEFFICIENTS MATERIAU A T+DT
!           CPMONO :  NOM DES COMPORTEMENTS
!           IFA    :  NUMERO FAMILLE
!           NMAT   :  DIMENSION MATER
!           NBCOMM :  INCIDES DES COEF MATERIAU
!           DT     :  ACCROISSEMENT INSTANT ACTUEL
!           NUECOU : NUMERO DE LA LOI D'ECOULEMENT
!           NSFV   :  DEBUT DES SYST. GLIS. DE LA FAMILLE IFA DANS VIND
!           NSFA   :  DEBUT DES SYST. GLIS. DE LA FAMILLE IFA DANS Y
!           IS     :  NUMERO DU SYST. GLIS. S
!           IR     :  NUMERO DU SYST. GLIS. R
!           NBSYS  :  NOMBRE DE SYSTEMES DE GLISSEMENT FAMILLE IFA
!           HSR    :  MATRICE D'INTERACTION
!           VIND   :  VARIABLES INTERNES A L'INSTANT PRECEDENT
!           DY     :  SOLUTION           =  ( DSIG DX1 DX2 DP (DEPS3) )
!           ITMAX  :  ITER_INTE_MAXI
!           TOLER  :  RESI_INTE_RELA
!       OUT DGSDTS :  derivee dGammaS/dTauS
!       OUT DKSDTS :  dkS/dTaus
!       OUT DGRDBS :  dGammaR/dBetaS
!       OUT DKRDBS :  dkR/dBetaS
!       OUT IRET   :  CODE RETOUR
!       ----------------------------------------------------------------
#include "asterfort/lcmmj1.h"
#include "asterfort/lcmmj2.h"
#include "asterfort/lcmmjd.h"
#include "asterfort/utmess.h"
    integer :: nmat, nbcomm(nmat, 3), ifa, nbsys, is, iret, nfs, nsg
    integer :: ir, nsfa, nsfv, nuecou, itmax, iexp
    real(kind=8) :: dgsdts, dksdts, dgrdbs, dkrdbs, vind(*), hsr(nsg, nsg)
    real(kind=8) :: materf(nmat*2), dt, sgnr, hr, dpr, dpdtau, dprdas, dhrdas
    real(kind=8) :: toler
    real(kind=8) :: taur, dy(*), expbp(nsg)
    character(len=24) :: cpmono(5*nmat+1)
    integer :: irr, decirr, nbsyst, decal, gdef
    common/polycr/irr,decirr,nbsyst,decal,gdef
!     ----------------------------------------------------------------
!
    iret=0
!
    if (nuecou .eq. 4) then
!        KOCKS-RAUCH
        call lcmmj2(taur, materf, cpmono, ifa, nmat,&
                    nbcomm, dt, nsfv, nsfa, ir,&
                    is, nbsys, nfs, nsg, hsr,&
                    vind, dy, dgsdts, dksdts, dgrdbs,&
                    dkrdbs, iret)
                    
    else if ((nuecou.eq.5).or.(nuecou.eq.8)) then
!        DD-CFC et DD_CFC_IRRA
        decal=nsfv
        call lcmmjd(taur, materf, ifa, nmat, nbcomm,&
                    dt, ir, is, nbsys, nfs,&
                    nsg, hsr, vind, dy(nsfa+1), dpdtau,&
                    dprdas, dhrdas, hr, dpr, sgnr,&
                    iret)
!
        dgsdts=dpdtau*sgnr
        dksdts=dpdtau*hr
        dgrdbs=dprdas*sgnr
        dkrdbs=dprdas*hr+dpr*dhrdas

    else if (nuecou.eq.6) then
!        DD-FAT
        call utmess('F', 'COMPOR2_21')
        
    else if (nuecou.ge.7) then
!        DD-CC
!        matrice tangente pas encore programmee
!        mais pourquoi EXTRAPOLE appelle RIGI_MECA_TANG ?
        dgsdts=0.d0
        dksdts=0.d0
        dgrdbs=0.d0
        dkrdbs=0.d0
    else
!        AUTRES COMPORTEMENTS
        call lcmmj1(taur, materf, cpmono, ifa, nmat,&
                    nbcomm, dt, nsfv, nsfa, ir,&
                    is, nbsys, nfs, nsg, hsr,&
                    vind, dy, iexp, expbp, itmax,&
                    toler, dgsdts, dksdts, dgrdbs, dkrdbs,&
                    iret)
    endif
!
end subroutine
