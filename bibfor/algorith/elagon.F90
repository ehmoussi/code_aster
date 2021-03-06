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

subroutine elagon(ndim, imate, biot,&
                  alpha, deps, e,&
                  nu, snetm, option, snetp, dsidep,&
                  p1, dp1, dsidp1, dsidp2)
!
! ROUTINE ELAGON
! MODELE POUR L ARGILE GONFLANTE (HOXHNA COLLIN) EN CONTRAINTES NET
!
! ======================================================================
! SNET : CONTRAINTES NET : SIGTOT=SIGNET-biot*Pgaz
!                          SIGNET=SIGTOT+biot*Pgaz
!       DANS CETTE VERSION SIP=-biot*Pgaz
! ======================================================================
    implicit none
#include "asterfort/dpgfp1.h"
#include "asterfort/prgonf.h"
#include "asterfort/rcvalb.h"
#include "asterfort/get_varc.h"
    integer :: ndim, imate
    character(len=16) :: option
    real(kind=8) :: alpha
    real(kind=8) :: deps(6), biot, p1, dp1
    real(kind=8) :: snetm(6), snetp(6), dsidep(6, 6)
    real(kind=8) :: dsidp1(6), dsidp2(6)
!
    real(kind=8) :: valres(2)
    real(kind=8) :: betam, pref
    real(kind=8) :: depsmo, sigmmo, e, nu, k0, deuxmu
    real(kind=8) :: kron(6), depsdv(6), sigmdv(6), sigpdv(6)
    real(kind=8) :: sigpmo
    real(kind=8) :: p1m, tm, tp, tref
    real(kind=8) :: valpam(1)
    integer :: ndimsi
    integer :: k, l, kpg, spt
    integer :: icodre(2)
    character(len=16) :: nomres(2)
    character(len=8) :: nprefr(1), fami, poum
!
! ======================================================================
    integer :: ndt, ndi
    common /tdim/   ndt  , ndi
    data        kron/1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/
! ======================================================================
!
!
!     --  INITIALISATIONS :
!     ----------------------
    ndimsi = 2*ndim
!
    pref= 1.d6
    p1m=p1-dp1
!
! - Get temperatures
!
    call get_varc('RIGI' , 1  , 1 , 'T',&
                  tm, tp, tref)
!
!
!     --  RECUPERATION DES CARACTERISTIQUES
!     ---------------------------------------
    nomres(1)='BETAM'
    nomres(2)='PREF'
!
    nprefr(1) = 'TEMP'
    valpam(1) = tm
!
    fami='FPG1'
    kpg=1
    spt=1
    poum='+'
    call rcvalb(fami, kpg, spt, poum, imate,&
                ' ', 'GONF_ELAS ', 1, nprefr, [valpam],&
                1, nomres(1), valres(1), icodre(1), 2)
    betam=valres(1)
!
    call rcvalb(fami, kpg, spt, poum, imate,&
                ' ', 'GONF_ELAS ', 1, nprefr, [valpam],&
                1, nomres(2), valres(2), icodre(2), 2)
    pref = valres(2)
!
!
    deuxmu = e/(1.d0+nu)
    k0 = e/(3.d0*(1.d0-2.d0*nu))
!
!
! ======================================================================
! --- RETRAIT DE LA DEFORMATION DUE A LA DILATATION THERMIQUE ----------
! ======================================================================
    do k = 1, ndi
        deps(k) = deps(k) - alpha*(tp-tm)
    end do
!
!     --  CALCUL DE DEPSMO ET DEPSDV :
!     --------------------------------
    depsmo = 0.d0
    do k = 1, 3
        depsmo = depsmo + deps(k)
    end do
!
    do k = 1, ndimsi
        depsdv(k) = deps(k) - depsmo/3.d0 * kron(k)
    end do
!
!     --  CALCUL DES CONTRAINTES
!     ----------------------------
! Contraintes moyenne (1/3 trace(sig) )
    sigmmo = 0.d0
    do k = 1, 3
        sigmmo = sigmmo + snetm(k)/3.d0
    end do
!
    do k = 1, ndimsi
        sigmdv(k) = snetm(k) - sigmmo * kron(k)
    end do
    sigpmo = 0.d0
    if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
!
!     --------------------------------
! MODELE DE GONFLEMENT APPLIQUE A LA CONTRAINTE MOYENNE
!
! ATTENTION ICI KO INDEP DE LA SUCCION
! ON N APPLIQUE PAS LA NON LINEARITE DEMANDANT LES PARAMETRES R ET BETA
! CE QUI POURRAIT ETRE ENVISAGE DANS UN SECOND TEMPS
!
        sigpmo = sigmmo+k0*depsmo +prgonf(biot,betam,pref,p1)-prgonf( biot,betam,pref,p1m)
    endif
!
    do k = 1, ndimsi
        sigpdv(k) = sigmdv(k) + deuxmu * depsdv(k)
        snetp(k) = sigpdv(k) + sigpmo*kron(k)
    end do
!
!
!     --  CALCUL DE L'OPERATEUR TANGENT :
!     --------------------------------
    if (option(1:14) .eq. 'RIGI_MECA_TANG' .or. option(1:9) .eq. 'FULL_MECA') then
!
!     --9.0 INITIALISATION DE L'OPERATEUR TANGENT
!     ---------------------------------------
        do k = 1, 6
            dsidp1(k) = 0.d0
            dsidp2(k) = 0.d0
            do l = 1, 6
                dsidep(k,l) = 0.d0
            end do
        end do
!
        do k = 1, 3
            do l = 1, 3
                dsidep(k,l) = k0-deuxmu/3.d0
            end do
        end do
        do k = 1, ndimsi
            dsidep(k,k) = dsidep(k,k)+deuxmu
        end do
!
    endif
!
    if (option(1:9) .eq. 'FULL_MECA' .or. option(1:9) .eq. 'RAPH_MECA') then
!
        do k = 1, ndimsi
            dsidp1(k) = dpgfp1(biot,betam,pref,p1)
        end do
!
    endif
end subroutine
