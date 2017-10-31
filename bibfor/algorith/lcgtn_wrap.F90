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

subroutine lcgtn_wrap(fami, kpg, ksp, ndim, imate, &
                      crit, instam, instap, neps, epsm, &
                      deps, vim, option, sigp, vip, &
                      grvi, dsidep, codret)
    use lcgtn_module, only: gtn_material

    implicit none
#include "asterfort/lcgrad.h"
#include "asterfort/lcgtn_compute.h"
#include "asterfort/lcgtn_material.h"

! aslint: disable=W1504
    
    aster_logical:: grvi
    integer      :: imate, ndim, kpg, ksp, codret, neps
    real(kind=8) :: crit(*)
    real(kind=8) :: instam, instap
    real(kind=8) :: epsm(neps), deps(neps)
    real(kind=8) :: sigp(neps)
    real(kind=8) :: vim(*), vip(*)
    real(kind=8) :: dsidep(neps,neps)
    character(len=16) :: option
    character(len=*) :: fami
! ----------------------------------------------------------------------
    real(kind=8),parameter,dimension(6)::rac2 = [1.d0,1.d0,1.d0,sqrt(2.d0),sqrt(2.d0),sqrt(2.d0)]
! ----------------------------------------------------------------------
    type(gtn_material):: mat
    aster_logical:: elas,rigi,resi
    integer      :: itemax,ndimsi,state
    real(kind=8) :: epsth,prec
    real(kind=8) :: apg,lag,phi,ka,f
    real(kind=8) :: grad(ndim),eps(2*ndim),ep(2*ndim),t(2*ndim)
    real(kind=8) :: deps_t(2*ndim,2*ndim),dphi_t(2*ndim),deps_ka(2*ndim),dphi_ka
! ----------------------------------------------------------------------
        

! INITIALISATION

    elas = option(11:14).eq.'ELAS' 
    rigi = option(1:4).eq.'RIGI' .or. option(1:4).eq.'FULL'
    resi = option(1:4).eq.'FULL' .or. option(1:4).eq.'RAPH'
    itemax = nint(crit(1))
    prec = crit(3)
    ndimsi = 2*ndim



! EXTRACTION DES DONNEES CINEMATIQUES

    eps = epsm(1:ndimsi)
    if (grvi) then
        apg  = epsm(ndimsi+1)
        lag  = epsm(ndimsi+2)
        grad = epsm(ndimsi+3:ndimsi+2+ndim) 
    end if
    
    if (resi) then
        eps = eps + deps(1:ndimsi)
        if (grvi) then
            apg  = apg  + deps(ndimsi+1)
            lag  = lag  + deps(ndimsi+2)
            grad = grad + deps(ndimsi+3:ndimsi+2+ndim) 
        end if
    endif



! LECTURE DU MATERIAU ET DES DEFORMATIONS DE RETRAIT   

    mat = lcgtn_material(fami,kpg,ksp,imate,resi,grvi)   
    epsth  = 0.d0   

    

! INTERACTION MATERIAU / CINEMATIQUE    
    
    eps(1:3) = eps(1:3) - epsth
    phi = lag + mat%r*apg



! LECTURE DES VARIABLES INTERNES    

    ka = vim(1)
    f  = max(mat%f0,vim(2))
    state = nint(vim(3))
    ep = vim(4:3+ndimsi)*rac2(1:ndimsi)



! COMPORTEMENT    

    codret = lcgtn_compute(resi,rigi,elas, itemax, prec, mat, instap-instam, eps, phi, ep, ka, &
                  f, state, t, deps_t,dphi_t,deps_ka,dphi_ka)
    if (codret.ne.0) goto 999



! MISE A JOUR DES CHAMPS

    if (resi) then
        vip(1) = ka
        vip(2) = f
        vip(3) = state
        vip(4:3+ndimsi) = ep/rac2(1:ndimsi)
    end if

    if (grvi) then
        ! Non local
        call lcgrad(resi, rigi, t, apg, lag, grad, ka,&
                  mat%r, mat%c, deps_t,dphi_t,deps_ka,dphi_ka, sigp, dsidep)
    else
        ! Local
        if (resi) sigp(1:ndimsi) = t
        if (rigi) dsidep(1:ndimsi,1:ndimsi) = deps_t    
    end if



    
999 continue
end subroutine
