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

subroutine lceigv(fami, kpg, ksp, ndim, neps, &
                  imate, epsm, deps, vim, option,&
                  sig, vip, dsidep)
    implicit none
#include "asterf_types.h"
#include "asterfort/diagp3.h"
#include "asterfort/lceib1.h"
#include "asterfort/lcgrad.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "asterfort/zerop3.h"
#include "blas/ddot.h"
    character(len=16) :: option
    character(len=*) :: fami
    integer :: ndim, neps, imate, ksp, kpg
    real(kind=8) :: epsm(neps), deps(neps), vim(2)
    real(kind=8) :: sig(neps), vip(2), dsidep(neps, neps)
! ----------------------------------------------------------------------
!     LOI DE COMPORTEMENT ENDO_ISOT_BETON (NON LOCAL GRAD_VARI)
!
! IN  FAMI    : FAMILLE DE POINT DE GAUSS
! IN  KPG     : POINT DE GAUSS CONSIDERE
! IN  KSP     :
! IN  NEPS    : DIMENSION DES DEFORMATIONS ET DES CONTRAINTES GENERALI.
! IN  IMATE   : NATURE DU MATERIAU
! IN  EPSM    : DEFORMATION EN T-
! IN  DEPS    : INCREMENT DE DEFORMATION
! IN  VIM     : VARIABLES INTERNES EN T-
! IN  OPTION  : OPTION DEMANDEE
!                 RIGI_MECA_TANG ->     DSIDEP
!                 FULL_MECA      -> SIG DSIDEP VIP
!                 RAPH_MECA      -> SIG        VIP
! OUT SIG     : CONTRAINTE
! OUT VIP     : VARIABLES INTERNES
!                 1   -> VALEUR DE L'ENDOMMAGEMENT
!                 2   -> ETAT DE L'ENDOMMAGEMENT
!                        0: non endommage
!                        1: endommage mais < 1
!                        2: ruine endommagement = 1
! OUT DSIDEP  : MATRICE TANGENTE
! ----------------------------------------------------------------------
! LOC EDFRC1  COMMON CARACTERISTIQUES DU MATERIAU (AFFECTE DANS EDFRMA)
    aster_logical :: rigi, resi, elas, coup, secant
    integer :: ndimsi, k, l, i, j, m, n, t(3, 3), iret, nrac, iok(2)
    real(kind=8) :: eps(6), treps, sigel(6), sigma(6), kron(6)
    real(kind=8) :: rac2
    real(kind=8) :: rigmin, told, fd, d, ener
    real(kind=8) :: tr(6), rtemp2
    real(kind=8) :: epsp(3), vecp(3, 3), dspdep(6, 6)
    real(kind=8) :: deumud(3), lambdd, sigp(3), rtemp, rtemp3, rtemp4
    real(kind=8) :: kdess, bendo, lambda, deuxmu, gamma
    real(kind=8) :: seuil, epsth(2)
    real(kind=8) :: phi, q2, q1, q0, etat, fel, fsat, rac(3)
    real(kind=8) :: coef1, coef2, coef3
    real(kind=8) :: hydrm, hydrp, sechm, sechp, sref
    real(kind=8) :: r, c, grad(ndim), ktg(6, 6, 4), apg, lag, valnl(2)
    character(len=1) :: poum
    character(len=16) :: nomnl(2)
    parameter  (rigmin = 1.d-5)
    parameter  (told = 1.d-6)
    data        kron/1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/
    data nomnl /'C_GRAD_VARI','PENA_LAGR'/
!
! ----------------------------------------------------------------------
!
!
!
! -- OPTION ET MODELISATION
!
    rigi = (option(1:4).eq.'RIGI' .or. option(1:4).eq.'FULL')
    resi = (option(1:4).eq.'RAPH' .or. option(1:4).eq.'FULL')
    coup = (option(6:9).eq.'COUP')
    if (coup) rigi=.true.
    ndimsi = 2*ndim
    rac2=sqrt(2.d0)
    secant=.false.
    poum='-'
    if (resi) poum='+'
!
    call rcvarc(' ', 'HYDR', '-', fami, kpg,&
                ksp, hydrm, iret)
    if (iret .ne. 0) hydrm=0.d0
    call rcvarc(' ', 'HYDR', '+', fami, kpg,&
                ksp, hydrp, iret)
    if (iret .ne. 0) hydrp=0.d0
    call rcvarc(' ', 'SECH', '-', fami, kpg,&
                ksp, sechm, iret)
    if (iret .ne. 0) sechm=0.d0
    call rcvarc(' ', 'SECH', '+', fami, kpg,&
                ksp, sechp, iret)
    if (iret .ne. 0) sechp=0.d0
    call rcvarc(' ', 'SECH', 'REF', fami, kpg,&
                ksp, sref, iret)
    if (iret .ne. 0) sref=0.d0
!
!
! -- INITIALISATION
!
    call lceib1(fami, kpg, ksp, imate,&
                ndim, epsm, sref, sechm, hydrm,&
                t, lambda, deuxmu, epsth, kdess,&
                bendo, gamma, seuil)
!
    call rcvalb(fami, kpg, ksp, poum, imate,&
                ' ', 'NON_LOCAL', 0, ' ', [0.d0],&
                2, nomnl, valnl, iok, 2)
    c = valnl(1)
    r = valnl(2)
!
!
! -- MAJ DES DEFORMATIONS ET PASSAGE AUX DEFORMATIONS REELLES 3D
!
    if (resi) then
        do k = 1, ndimsi
            eps(k) = epsm(k) + &
                     deps(k) - kron(k) * ( epsth(2) - kdess * (sref-sechp) - bendo * hydrp )
        end do
        apg = epsm(ndimsi+1) + deps(ndimsi+1)
        lag = epsm(ndimsi+2) + deps(ndimsi+2)
        do k = 1, ndim
            grad(k) = epsm(ndimsi+2+k) + deps(ndimsi+2+k)
        end do
    else
        do k = 1, ndimsi
            eps(k) = epsm(k) - ( epsth(1) - kdess * (sref-sechm) - bendo * hydrm ) * kron(k)
        end do
        apg = epsm(ndimsi+1)
        lag = epsm(ndimsi+2)
        do  k = 1, ndim
            grad(k) = epsm(ndimsi+2+k)
        end do
    endif
!
    do k = 4, ndimsi
        eps(k) = eps(k)/rac2
    end do
    if (ndimsi .lt. 6) then
        do k = ndimsi+1, 6
            eps(k)=0.d0
        end do
    endif
!
    phi= lag + r*apg
!
!
! -- DIAGONALISATION DES DEFORMATIONS
!
    tr(1) = eps(1)
    tr(2) = eps(4)
    tr(3) = eps(5)
    tr(4) = eps(2)
    tr(5) = eps(6)
    tr(6) = eps(3)
    call diagp3(tr, vecp, epsp)
!
! -- CALCUL DES CONTRAINTES ELAS POSITIVES ET DE L'ENERGIE POSITIVE
!
    treps = eps(1)+eps(2)+eps(3)
    if (treps .ge. 0.d0) then
        do k = 1, 3
            sigel(k) = lambda*treps
        end do
    else
        do k = 1, 3
            sigel(k) = 0.d0
        end do
    endif
    do k = 1, 3
        if (epsp(k) .ge. 0.d0) then
            sigel(k) = sigel(k) + deuxmu*epsp(k)
        endif
    end do
    ener = 0.5d0 * ddot(3,epsp,1,sigel,1)
!
!
! -- CALCUL (OU RECUPERATION) DE L'ENDOMMAGEMENT
    d = vim(1)
    etat = vim(2)
    elas=.true.
!
    if (.not.resi) goto 20
!    ESTIMATION DU CRITERE
    if (etat .eq. 2) goto 10
!
!
!      WRITE(6,*) 'ener=     ',ENER
!      WRITE(6,*) 'phi=      ',PHI
!      WRITE(6,*) 'seuil=    ',SEUIL/(1.D0+GAMMA)**2
!
!
!
    fel = (1+gamma)*ener/(1+gamma*d)**2+phi-r*d-seuil
!
!
!      WRITE(6,*) 'FEL=    ',FEL
!
!
!    CAS ELASTIQUE ?
    if (fel .le. 0) then
        etat = 0
        d = vim(1)
        goto 10
    endif
!    CAS SATURE ?
!
    fsat = (1+gamma)*ener/(1+gamma)**2+phi-r-seuil
!
    if (fsat .ge. 0) then
        etat = 2
        d = 1.d0
!
        goto 10
    endif
!
!     ON RESOUD SI NON ELASTIQUE ET NON SATURE
!
!
    elas=.false.
!
    q2 = (2.d0*gamma*r-(phi-seuil)*gamma**2.d0)/r/gamma**2
    q1 = (r-2.d0*gamma*(phi-seuil))/r/gamma**2
    q0 = -((phi-seuil)+(1+gamma)*ener)/r/gamma**2
!
    call zerop3(q2, q1, q0, rac, nrac)
!
    etat = 1
    d = rac(nrac)
    if (d .lt. vim(1)) then
        d = vim(1)
        elas=.true.
    else if (d.gt.(1.d0-told)) then
        d = 1.d0
        elas=.true.
        etat = 2
    endif
!
!      WRITE(6,*) 'deltaD=         ', D-VIM(1)
!
!
!
10 continue
!
! -- CALCUL DES CONTRAINTES
!
!
!
    fd = (1-d)/(1+gamma*d)
!
    treps=epsp(1)+epsp(2)+epsp(3)
    call r8inir(3, 0.d0, sigp, 1)
!
    if (treps .ge. 0.d0) then
        lambdd=lambda * fd
    else
        lambdd=lambda
    endif
    do i = 1, 3
        if (epsp(i) .ge. 0.d0) then
            deumud(i)=deuxmu*fd
        else
            deumud(i)=deuxmu
        endif
        sigp(i)=lambdd*treps+deumud(i)*epsp(i)
    end do
!
    call r8inir(6, 0.d0, sigma, 1)
    do i = 1, 3
        rtemp=sigp(i)
        sigma(1)=sigma(1)+vecp(1,i)*vecp(1,i)*rtemp
        sigma(2)=sigma(2)+vecp(2,i)*vecp(2,i)*rtemp
        sigma(3)=sigma(3)+vecp(3,i)*vecp(3,i)*rtemp
        sigma(4)=sigma(4)+vecp(1,i)*vecp(2,i)*rtemp
        sigma(5)=sigma(5)+vecp(1,i)*vecp(3,i)*rtemp
        sigma(6)=sigma(6)+vecp(2,i)*vecp(3,i)*rtemp
    end do
    do  k = 4, ndimsi
        sigma(k)=rac2*sigma(k)
    end do
!
!
    vip(1) = d
    vip(2) = etat
!
20 continue
!
!
! -- CALCUL DE LA MATRICE TANGENTE
!
    if (.not.rigi) goto 99
!
    fd=(1-d)/(1+gamma*d)
!
!
    treps=epsp(1)+epsp(2)+epsp(3)
    if (treps .ge. 0.d0) then
        lambdd=lambda * fd
    else
        lambdd=lambda
    endif
    do i = 1, 3
        if (epsp(i) .ge. 0.d0) then
            deumud(i)=deuxmu*fd
        else
            deumud(i)=deuxmu
        endif
    end do
!
    if (option(11:14) .eq. 'ELAS') secant=.true.
    call r8inir(36, 0.d0, dspdep, 1)
    call r8inir(36*4, 0.d0, ktg, 1)
!
    if (fd .lt. rigmin) then
        if (treps .ge. 0.d0) then
            lambdd=lambda * rigmin
        endif
        do i = 1, 3
            if (epsp(i) .ge. 0.d0) then
                deumud(i)=deuxmu*rigmin
            endif
        end do
    endif
!
    do k = 1, 3
        do l = 1, 3
            dspdep(k,l) = lambdd
        end do
    end do
    do k = 1, 3
        dspdep(k,k) = dspdep(k,k) + deumud(k)
    end do
    if (epsp(1)*epsp(2) .ge. 0.d0) then
        dspdep(4,4)=deumud(1)
    else
        dspdep(4,4)=(deumud(1)*epsp(1)-deumud(2)*epsp(2)) /(epsp(1)-epsp(2))
    endif
    if (epsp(1)*epsp(3) .ge. 0.d0) then
        dspdep(5,5)=deumud(1)
    else
        dspdep(5,5)=(deumud(1)*epsp(1)-deumud(3)*epsp(3)) /(epsp(1)-epsp(3))
    endif
    if (epsp(3)*epsp(2) .ge. 0.d0) then
        dspdep(6,6)=deumud(3)
    else
        dspdep(6,6)=(deumud(3)*epsp(3)-deumud(2)*epsp(2)) /(epsp(3)-epsp(2))
    endif
!
    do i = 1, 3
        do j = i, 3
            if (i .eq. j) then
                rtemp3=1.d0
            else
                rtemp3=rac2
            endif
            do k = 1, 3
                do l = 1, 3
                    if (t(i,j) .ge. t(k,l)) then
                        if (k .eq. l) then
                            rtemp4=rtemp3
                        else
                            rtemp4=rtemp3/rac2
                        endif
                        rtemp2=0.d0
                        do m = 1, 3
                            do n = 1, 3
                                rtemp2=rtemp2+vecp(k,m)* vecp(i,n)*&
                                vecp(j,n)*vecp(l,m)*dspdep(n,m)
                            end do
                        end do
                        rtemp2=rtemp2+vecp(i,1)*vecp(j,2)*vecp(k,1)*vecp(l,2)*dspdep(4,4)
                        rtemp2=rtemp2+vecp(i,2)*vecp(j,1)*vecp(k,2)*vecp(l,1)*dspdep(4,4)
                        rtemp2=rtemp2+vecp(i,1)*vecp(j,3)*vecp(k,1)*vecp(l,3)*dspdep(5,5)
                        rtemp2=rtemp2+vecp(i,3)*vecp(j,1)*vecp(k,3)*vecp(l,1)*dspdep(5,5)
                        rtemp2=rtemp2+vecp(i,2)*vecp(j,3)*vecp(k,2)*vecp(l,3)*dspdep(6,6)
                        rtemp2=rtemp2+vecp(i,3)*vecp(j,2)*vecp(k,3)*vecp(l,2)*dspdep(6,6)
                        ktg(t(i,j),t(k,l),1)=ktg(t(i,j),t(k,l),1)+&
                        rtemp2*rtemp4
                    endif
                end do
            end do
        end do
    end do
!
    do i = 1, 6
        do j = i+1, 6
            ktg(i,j,1)=ktg(j,i,1)
        end do
    end do
!
!
! -- CONTRIBUTION DISSIPATIVE
    if ((.not. elas) .or. (etat.eq.1.d0)) then
!
        tr(1) = sigel(1)
        tr(2) = sigel(2)
        tr(3) = sigel(3)
        call r8inir(6, 0.d0, sigel, 1)
        do i = 1, 3
            rtemp=tr(i)
            sigel(1)=sigel(1)+vecp(1,i)*vecp(1,i)*rtemp
            sigel(2)=sigel(2)+vecp(2,i)*vecp(2,i)*rtemp
            sigel(3)=sigel(3)+vecp(3,i)*vecp(3,i)*rtemp
            sigel(4)=sigel(4)+vecp(1,i)*vecp(2,i)*rtemp
            sigel(5)=sigel(5)+vecp(1,i)*vecp(3,i)*rtemp
            sigel(6)=sigel(6)+vecp(2,i)*vecp(3,i)*rtemp
        end do
        do k = 4, ndimsi
            sigel(k)=rac2*sigel(k)
        end do
!
        coef1=(1.d0+gamma)/(1.d0+gamma*d)**2
!
        coef2=(1.d0+gamma)/(r*(1.d0+gamma*d)**2 +2.d0*gamma*(1.d0+gamma)*ener/(1.d0+gamma*d))
        coef3=(1.d0+gamma*d)**3/(r*(1.d0+gamma*d)**3 +2.d0*gamma*(1.d0+gamma)*ener)
!
!
! dans le cas de la matrice secante, on enleve la partie dissipative
! seulement sur la partie meca/meca
        if (.not.secant) then
            do k = 1, ndimsi
                do l = 1, ndimsi
                    ktg(k,l,1)=ktg(k,l,1)-coef1*coef2*sigel(k)*sigel(l)
                end do
            end do
        endif
!
!
! les autres termes ne sont pas annules car ils permettent de faire
! converger sur la regularisation
        do k = 1, ndimsi
            ktg(k,1,3) = coef2*sigel(k)
            ktg(k,1,2) = - ktg(k,1,3)
        end do
        ktg(1,1,4) = coef3
!
!
    endif
!
!
99 continue
    call lcgrad(resi, rigi, sigma(1:ndimsi), apg, lag, &
                grad, d, r, c, ktg(1:ndimsi,1:ndimsi,1), &
                ktg(1:ndimsi,1,2),ktg(1:ndimsi,1,3),ktg(1,1,4),sig, dsidep)
!
end subroutine
