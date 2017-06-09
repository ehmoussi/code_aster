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

subroutine piesfg(lcesga, eta, g, dg)
    implicit none
#include "asterfort/utmess.h"

    interface
    subroutine lcesga(mode, eps, gameps, dgamde, itemax, precvg, iret)
        integer,intent(in) :: mode, itemax
        real(kind=8),intent(in) :: eps(6), precvg
        integer,intent(out):: iret
        real(kind=8),intent(out):: gameps, dgamde(6)
    end subroutine lcesga
    end interface

    real(kind=8),intent(in) :: eta
    real(kind=8),intent(out):: g, dg
! --------------------------------------------------------------------------------------------------
! CALCUL DE LA FONCTION SEUIL ET DE SA DERIVEE
! --------------------------------------------------------------------------------------------------
! IN  LCESGA FONCTION DE CALCUL DE GAMMA(EPSILON)
! IN  ETA    PARAMETRE DE PILOTAGE
! OUT G      VALEUR DE LA FONCTION SEUIL
! OUT DG     VALEUR DE LA DERIVEE DE LA FONCTION SEUIL
! --------------------------------------------------------------------------------------------------
    integer, parameter:: itemax=100
! --------------------------------------------------------------------------------------------------
    integer :: iret
    real(kind=8) :: eps(6), phi, gameps, dgadep(6)
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: lambda, deuxmu, troisk, gamma, rigmin, pc, pr, epsth
    common /lcee/ lambda,deuxmu,troisk,gamma,rigmin,pc,pr,epsth
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: pk, pm, pp, pq
    common /lces/ pk,pm,pp,pq
! --------------------------------------------------------------------------------------------------
    real(kind=8) :: ep0(6), ep1(6), phi0, phi1, a, drda, precga
    common /pies/ ep0,ep1,phi0,phi1,a,drda,precga
! --------------------------------------------------------------------------------------------------
!
!
    eps = ep0 + eta*ep1
    phi = phi0+ eta*phi1
    call lcesga(1, eps, gameps, dgadep, itemax, precga, iret)
    if (iret .ne. 0) call utmess('F', 'PILOTAGE_83')
    g  = -drda*gameps-pk-pr*a+phi
    dg = -drda*dot_product(dgadep,ep1)+phi1
!
end subroutine
