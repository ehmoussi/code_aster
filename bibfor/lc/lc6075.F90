! --------------------------------------------------------------------
! Copyright (C) 1991 - 2020 - EDF R&D - www.code-aster.org
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

subroutine lc6075(fami, kpg, ksp, ndim, imate,&
                    compor, carcri, instam, instap, neps, &
                    epsm, deps, nsig, sigm, nvi, &
                    vim, option, angmas, sigp, vip, &
                    typmod, icomp, ndsde, dsidep, codret)

!
!
! aslint: disable=W1504,W0104
    use Behaviour_module, only : behaviourOption
    use lcgtn_module, only: CONSTITUTIVE_LAW, Init, InitGradVari, InitViscoPlasticity, &
                                    Integrate 

    implicit none
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/lcgrad.h"
    
    
    integer             :: imate, ndim, kpg, ksp, codret, icomp
    integer             :: nvi,neps,nsig,ndsde
    real(kind=8)        :: carcri(*), angmas(*)
    real(kind=8)        :: instam, instap
    real(kind=8)        :: epsm(neps), deps(neps)
    real(kind=8)        :: sigm(nsig), sigp(nsig)
    real(kind=8)        :: vim(nvi), vip(nvi)
    real(kind=8)        :: dsidep(nsig,neps)
    character(len=16)   :: compor(*), option
    character(len=8)    :: typmod(*)
    character(len=*)    :: fami
! ----------------------------------------------------------------------
!  Loi de comportement GTN
! ----------------------------------------------------------------------
    aster_logical :: lMatr, lVect, lSigm, lVari,visc
    integer     :: ndimsi
    real(kind=8):: sig(2*ndim),vi(nvi),ka
    real(kind=8):: deps_sig(2*ndim,2*ndim),deps_vi(2*ndim),dphi_sig(2*ndim),dphi_vi
    real(kind=8):: apg,lag,grad(ndim),eps_gene(neps),eps_meca(2*ndim)
    type(CONSTITUTIVE_LAW):: cl
! --------------------------------------------------------------------------------------------------
    ASSERT (neps*nsig .eq. ndsde)
    ASSERT (neps .eq. nsig)
    ASSERT (neps .ge. 2*ndim)
    ASSERT (neps .ge. 3*ndim+2)
! --------------------------------------------------------------------------------------------------
    ndimsi = 2*ndim
    eps_gene = epsm(1:neps)+deps(1:neps)
    eps_meca = eps_gene(1:ndimsi)
    apg      = eps_gene(ndimsi+1)
    lag      = eps_gene(ndimsi+2)
    grad     = eps_gene(ndimsi+3:ndimsi+2+ndim)

    call behaviourOption(option, compor,lMatr , lVect ,lVari , lSigm)
    
    cl = Init(ndimsi, option, fami, kpg, ksp, imate, nint(carcri(1)), &
            carcri(3))
    ASSERT(.not. lMatr .or. cl%rigi)
    ASSERT(.not. lVari .or. cl%vari)
    
    call InitGradVari(cl,fami,kpg,ksp,imate,lag,apg)

    visc = compor(1)(1:4) .eq. 'VISC'
    call InitViscoPlasticity(cl,visc,fami,kpg,ksp,imate,instap-instam)
        
    call Integrate(cl, eps_meca, vim(1:nvi), sig, &
            vi, deps_sig, dphi_sig, deps_vi, dphi_vi)

    codret = cl%exception
    if (codret.ne.0) goto 999

    if (lVari) vip(1:nvi) = vi

    ka = merge(vi(1),vim(1),cl%vari)
    call lcgrad(lSigm, lMatr, sig, apg, lag, grad, ka, &
              cl%mat%r, cl%mat%c, deps_sig, dphi_sig, deps_vi, dphi_vi, sigp, dsidep)

999 continue    

end subroutine
