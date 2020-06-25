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

subroutine lc0060(fami, kpg, ksp, ndim, imate,&
                  compor, crit, instam, instap, epsm,&
                  deps, sigm, vim, option, angmas,&
                  sigp, vip, typmod, icomp,&
                  nvi, dsidep, codret)

! aslint: disable=W1504,W0104
    use endo_loca_module, only: CONSTITUTIVE_LAW, Init, Integrate 
    implicit none

! ----------------------------------------------------------------------
    integer :: imate, ndim, kpg, ksp, codret, icomp, nvi
    real(kind=8) :: crit(*), angmas(3)
    real(kind=8) :: instam, instap
    real(kind=8) :: epsm(6), deps(6)
    real(kind=8) :: sigm(6), sigp(6)
    real(kind=8) :: vim(*), vip(*)
    real(kind=8) :: dsidep(6, 6)
    character(len=16) :: compor(*), option
    character(len=8) :: typmod(*)
    character(len=*) :: fami
! ----------------------------------------------------------------------
    integer:: ndimsi
    real(kind=8):: sig(2*ndim),dsde(2*ndim,2*ndim),vi(nvi)
    type(CONSTITUTIVE_LAW):: cl
! ----------------------------------------------------------------------
    
    ndimsi = 2*ndim
    
    cl = Init(ndimsi, option, fami, kpg, ksp, imate, nint(crit(1)), &
            crit(3), instap-instam)
            
    call Integrate(cl, epsm(1:ndimsi), deps(1:ndimsi), vim(1:nvi), sig, &
            vi, dsde)

    codret = cl%exception

    if (option(1:4).eq.'FULL' .or. option(1:4).eq.'RAPH') then
        sigp(1:ndimsi) = sig
        vip(1:nvi) = vi
    end if

    if (option(1:4).eq.'RIGI' .or. option(1:4).eq.'FULL') then
        dsidep(1:ndimsi,1:ndimsi) = dsde
    end if

                      
end subroutine
