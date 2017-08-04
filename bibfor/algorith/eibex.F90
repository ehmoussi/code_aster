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

subroutine eibex(fami, kpg, ksp, ndim, imate,&
                 instam, instap, epsm, deps,&
                 vim, option, sig, vip, dsidep,&
                 codret)
!
    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/diagp3.h"
#include "asterfort/lceib1.h"
#include "asterfort/r8inir.h"
#include "asterfort/rcvarc.h"
#include "blas/ddot.h"
    character(len=16) :: option
    character(len=*) :: fami
    integer :: ndim, imate, ksp, kpg
    real(kind=8) :: epsm(6), deps(6), vim(2), instap, instam
    real(kind=8) :: sig(6), vip(2), dsidep(6, 6)
! ----------------------------------------------------------------------
!     LOI DE COMPORTEMENT ENDO_ISOT_BETON avec IMPLEX (EN LOCAL)
!
! IN  NDIM    : DIMENSION DE L'ESPACE
! IN  TYPMOD  : TYPE DE MODELISATION
! IN  IMATE   : NATURE DU MATERIAU
! IN  EPSM    : DEFORMATION EN T-
! IN  DEPS    : INCREMENT DE DEFORMATION
! IN  VIM     : VARIABLES INTERNES EN T-
! IN  CRIT    : CRITERES DE CONVERGENCE
! IN  OPTION  : OPTION DEMANDEE
!                 RIGI_MECA_IMPLEX -> SIG extr  DSIDEP
!                 RAPH_MECA      -> SIG        VIP
! OUT SIG     : CONTRAINTE
! OUT VIP     : VARIABLES INTERNES
!                 1   -> VALEUR DE L'ENDOMMAGEMENT
!                 2   -> DD/DT
! OUT DSIDEP  : MATRICE TANGENTE
! ----------------------------------------------------------------------
    aster_logical :: raph, tang
!
    integer :: ndimsi, k, l, i, j, m, n, t(3, 3)
    integer :: codret, iret
!
    real(kind=8) :: eps(6), treps, sigel(6)
    real(kind=8) :: rac2
    real(kind=8) :: rigmin, fd, dm, dp, dd, dddt, dt, ener
    real(kind=8) :: tr(6), rtemp2
    real(kind=8) :: epsp(3), vecp(3, 3), dspdep(6, 6)
    real(kind=8) :: deumud(3), lambdd, sigp(3), rtemp, rtemp3, rtemp4
    real(kind=8) :: lambda, deuxmu, gamma
    real(kind=8) :: seuil
    real(kind=8) :: tm, tp, tref, sref, sechm, hydrm, epsthe(2), kdess, bendo
    real(kind=8) :: kron(6), sechp, hydrp
    data        kron/1.d0,1.d0,1.d0,0.d0,0.d0,0.d0/
!      PARAMETER   (RIGMIN = 0.00001)
! ----------------------------------------------------------------------
!
    rigmin = 1.d-5
!
!
!     RECUPERATION DES VARIABLES DE COMMANDE
    call rcvarc(' ', 'TEMP', '-', fami, kpg,&
                ksp, tm, iret)
    call rcvarc(' ', 'TEMP', '+', fami, kpg,&
                ksp, tp, iret)
    call rcvarc(' ', 'TEMP', 'REF', fami, kpg,&
                ksp, tref, iret)
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
! -- OPTION ET MODELISATION
!
!
    raph = option .eq. 'RAPH_MECA'
    tang = option .eq. 'RIGI_MECA_IMPLEX'
    codret = 0
!
! -- RECUPERATIOIN DES VARIABLES INTERNES
!
    dm = vim(1)
    dddt = vim(2)
    dt = instap - instam
!
! -- INITIALISATION
!
    ndimsi = 2*ndim
    rac2=sqrt(2.d0)
!
    call lceib1(fami, kpg, ksp, imate,&
                ndim, epsm, sref, sechm, hydrm,&
                t, lambda, deuxmu, epsthe, kdess,&
                bendo, gamma, seuil)
!
!
!
! -- MAJ DES DEFORMATIONS ET PASSAGE AUX DEFORMATIONS REELLES 3D
!
    if (tang) then
        do k = 1, ndimsi
            eps(k) = epsm(k) - ( epsthe(1) - kdess * (sref-sechm) - bendo * hydrm ) * kron(k)
        end do
    else if (raph) then
        do  k = 1, ndimsi
            eps(k) = epsm(k) + deps(k) - kron(k) * ( epsthe(2) - kdess * (sref-sechp) - bendo * h&
                     &ydrp )
        end do
    endif
!
    do k = 4, ndimsi
        eps(k) = eps(k)/rac2
    end do
!
    if (ndimsi .lt. 6) then
        do k = ndimsi+1, 6
            eps(k)=0.d0
        end do
    endif
!
! -- DIAGONALISATION DES DEFORMATIONS
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
    if (treps .gt. 0.d0) then
        do k = 1, 3
            sigel(k) = lambda*treps
        end do
    else
        do k = 1, 3
            sigel(k) = 0.d0
        end do
    endif
!
    do k = 1, 3
        if (epsp(k) .gt. 0.d0) then
            sigel(k) = sigel(k) + deuxmu*epsp(k)
        endif
    end do
    ener = 0.5d0 * ddot(3,epsp,1,sigel,1)
!
! ======================================================================
!     CAS RIGI_MECA_IMPLEX : EXTRAPOLATION VARIABLES INTERNES ET MATRICE
! ======================================================================
    if (tang) then
!
! -- EXTRAPOLATION ENDOMMAGEMENT
        dp = min(dm + dddt*dt, 1.d0)
        fd = (1 - dp) / (1 + gamma*dp)
!
! -- PARAMETRAGE POUR L EFFET UNILATERAL
        if ((epsp(1)+epsp(2)+epsp(3)) .gt. 0.d0) then
            lambdd=lambda*max(fd,rigmin)
        else
            lambdd=lambda
        endif
!
        if (epsp(1) .gt. 0.d0) then
            deumud(1)=deuxmu*max(fd,rigmin)
        else
            deumud(1)=deuxmu
        endif
!
        if (epsp(2) .gt. 0.d0) then
            deumud(2)=deuxmu*max(fd, rigmin)
        else
            deumud(2)=deuxmu
        endif
!
        if (epsp(3) .gt. 0.d0) then
            deumud(3)=deuxmu*max(fd, rigmin)
        else
            deumud(3)=deuxmu
        endif
!
! -- CALCUL DE LA MATRICE TANGENTE
        call r8inir(36, 0.d0, dspdep, 1)
        call r8inir(36, 0.d0, dsidep, 1)
!
        do k = 1, 3
            do l = 1, 3
                dspdep(k,l) = lambdd
            end do
        end do
!
        do k = 1, 3
            dspdep(k,k) = dspdep(k,k) + deumud(k)
        end do
!
        if (epsp(1)*epsp(2) .ge. 0.d0) then
            dspdep(4,4)=deumud(1)
        else
            dspdep(4,4)=(deumud(1)*epsp(1)-deumud(2)*epsp(2)) /(epsp(1)-epsp(2))
        endif
!
        if (epsp(1)*epsp(3) .ge. 0.d0) then
            dspdep(5,5)=deumud(1)
        else
            dspdep(5,5)=(deumud(1)*epsp(1)-deumud(3)*epsp(3)) /(epsp(1)-epsp(3))
        endif
!
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
!
                do k = 1, 3
                    do l = 1, 3
                        if (t(i,j) .ge. t(k,l)) then
                            if (k .eq. l) then
                                rtemp4=rtemp3
                            else
                                rtemp4=rtemp3/rac2
                            endif
!
                            rtemp2=0.d0
!
                            do m = 1, 3
                                do n = 1, 3
                                    rtemp2=rtemp2+vecp(k,m)* vecp(i,n)&
                                    *vecp(j,n)*vecp(l,m)*dspdep(n,m)
                                end do
                            end do
!
                            rtemp2=rtemp2+vecp(i,1)*vecp(j,2)*vecp(k,1)*vecp(l,2) *dspdep(4,4)
                            rtemp2=rtemp2+vecp(i,2)*vecp(j,1)*vecp(k,2)*vecp(l,1) *dspdep(4,4)
                            rtemp2=rtemp2+vecp(i,1)*vecp(j,3)*vecp(k,1)*vecp(l,3) *dspdep(5,5)
                            rtemp2=rtemp2+vecp(i,3)*vecp(j,1)*vecp(k,3)*vecp(l,1) *dspdep(5,5)
                            rtemp2=rtemp2+vecp(i,2)*vecp(j,3)*vecp(k,2)*vecp(l,3) *dspdep(6,6)
                            rtemp2=rtemp2+vecp(i,3)*vecp(j,2)*vecp(k,3)*vecp(l,2) *dspdep(6,6)
                            dsidep(t(i,j),t(k,l)) = dsidep(t(i,j),t(k, l) ) + rtemp2*rtemp4
                        endif
                    end do
                end do
            end do
        end do
!
        do i = 1, 6
            do j = i+1, 6
                dsidep(i,j)=dsidep(j,i)
            end do
        end do
!
! -- CALCUL DES CONTRAINTES
        treps=epsp(1)+epsp(2)+epsp(3)
        sigp(1)=lambdd*treps+deumud(1)*epsp(1)
        sigp(2)=lambdd*treps+deumud(2)*epsp(2)
        sigp(3)=lambdd*treps+deumud(3)*epsp(3)
!
        call r8inir(6, 0.d0, sig, 1)
!
        do i = 1, 3
            rtemp=sigp(i)
            sig(1)=sig(1)+vecp(1,i)*vecp(1,i)*rtemp
            sig(2)=sig(2)+vecp(2,i)*vecp(2,i)*rtemp
            sig(3)=sig(3)+vecp(3,i)*vecp(3,i)*rtemp
            sig(4)=sig(4)+vecp(1,i)*vecp(2,i)*rtemp
            sig(5)=sig(5)+vecp(1,i)*vecp(3,i)*rtemp
            sig(6)=sig(6)+vecp(2,i)*vecp(3,i)*rtemp
        end do
!
        do k = 4, ndimsi
            sig(k)=rac2*sig(k)
        end do
!
! ======================================================================
!     CAS RAPH_MECA : CALCUL VARIABLES INTERNES ET CONTRAINTE
! ======================================================================
    else if (raph) then
! -- CALCUL (OU RECUPERATION) DE L'ENDOMMAGEMENT
        dp = (sqrt((1+gamma)/seuil * ener) - 1) / gamma
!
        if (dp .lt. vim(1)) then
            dp = vim(1)
        else if (dp .gt. 1) then
            dp = 1
        endif
!
        fd = (1 - dp) / (1 + gamma*dp)
        dd = dp - dm
!
        vip(1) = dp
        vip(2) = dd/dt
!
! -- CALCUL DES CONTRAINTES
        if ((epsp(1)+epsp(2)+epsp(3)) .gt. 0.d0) then
            lambdd=lambda * fd
        else
            lambdd=lambda
        endif
!
        if (epsp(1) .gt. 0.d0) then
            deumud(1)=deuxmu*fd
        else
            deumud(1)=deuxmu
        endif
!
        if (epsp(2) .gt. 0.d0) then
            deumud(2)=deuxmu*fd
        else
            deumud(2)=deuxmu
        endif
!
        if (epsp(3) .gt. 0.d0) then
            deumud(3)=deuxmu*fd
        else
            deumud(3)=deuxmu
        endif
!
        treps=epsp(1)+epsp(2)+epsp(3)
        sigp(1)=lambdd*treps+deumud(1)*epsp(1)
        sigp(2)=lambdd*treps+deumud(2)*epsp(2)
        sigp(3)=lambdd*treps+deumud(3)*epsp(3)
!
        call r8inir(6, 0.d0, sig, 1)
!
        do i = 1, 3
            rtemp=sigp(i)
            sig(1)=sig(1)+vecp(1,i)*vecp(1,i)*rtemp
            sig(2)=sig(2)+vecp(2,i)*vecp(2,i)*rtemp
            sig(3)=sig(3)+vecp(3,i)*vecp(3,i)*rtemp
            sig(4)=sig(4)+vecp(1,i)*vecp(2,i)*rtemp
            sig(5)=sig(5)+vecp(1,i)*vecp(3,i)*rtemp
            sig(6)=sig(6)+vecp(2,i)*vecp(3,i)*rtemp
        end do
!
        do k = 4, ndimsi
            sig(k)=rac2*sig(k)
        end do
    else
        ASSERT(.false.)
    endif
!
end subroutine
