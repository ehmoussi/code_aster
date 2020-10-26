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


subroutine lc0076(fami, kpg, ksp, ndim, imate,&
                    compor, carcri, instam, instap, neps, &
                    epsm, deps, nsig, sigm, nvi, vim, &
                    option, angmas, sigp, vip, typmod, icomp,&
                    ndsde, dsidep, codret) 


 
! aslint: disable=W1504,W0104
    use Behaviour_module, only : behaviourOption
    use vmis_isot_nl_module, only: CONSTITUTIVE_LAW, Init, InitViscoPlasticity, Integrate 
    implicit none
#include "asterfort/assert.h"

! ----------------------------------------------------------------------
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
    aster_logical :: lMatr, lVect, lSigm, lVari
    integer     :: ndimsi
    real(kind=8):: eps(2*ndim), sig(2*ndim),dsde(2*ndim,2*ndim),vi(nvi)
    type(CONSTITUTIVE_LAW):: cl
! ----------------------------------------------------------------------
    ASSERT (neps*nsig .eq. ndsde)
    ASSERT (neps .eq. nsig)
    ASSERT (neps .ge. 2*ndim)
! --------------------------------------------------------------------------------------------------
    
    ndimsi = 2*ndim
    eps    = epsm(1:ndimsi) + deps(1:ndimsi)
    
    call behaviourOption(option, compor,lMatr , lVect ,lVari , lSigm)

    cl = Init(ndimsi, option, fami, kpg, ksp, imate, nint(carcri(1)), &
            carcri(3))
    ASSERT(.not. lMatr .or. cl%rigi)
    ASSERT(.not. lVari .or. cl%resi)
    
    if (compor(1)(1:4) .eq. 'VISC') &
        call InitViscoPlasticity(cl,fami,kpg,ksp,imate,instap-instam)
        
    call Integrate(cl, eps, vim(1:nvi), sig, vi, dsde)

    codret = cl%exception
    if (codret.ne.0) goto 999

    if (lSigm) sigp(1:ndimsi) = sig
    if (lVari) vip(1:nvi) = vi
    if (lMatr) dsidep(1:ndimsi,1:ndimsi) = dsde

999 continue                      
end subroutine
