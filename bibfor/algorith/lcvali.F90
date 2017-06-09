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

subroutine lcvali(fami, kpg, ksp, imate, compor,&
                  ndim, epsm, deps, instam, instap,&
                  codret)
!
    implicit none
#include "asterfort/rcvalb.h"
#include "asterfort/rcvarc.h"
#include "blas/daxpy.h"
#include "blas/dcopy.h"
#include "blas/ddot.h"
#include "blas/dscal.h"

    integer :: imate, kpg, ksp, iret1, iret2, iret3, codret, icodre(4), iret
    integer :: ndim
    integer :: ndimsi
    character(len=*) :: fami
    character(len=16) :: compor(*), nomres(4)
    real(kind=8) :: deps(6), epsm(6), eps(6), valres(4), epsmax, eps2, vepsm
    real(kind=8) :: veps(6)
    real(kind=8) :: veps2, instam, instap, dt, tmax, tmin, temp
!
!     EXAMEN DU DOMAINE DE VALIDITE
    iret1=0
    iret2=0
    iret3=0
    ndimsi=2*ndim
    if (compor(3) .eq. 'SIMO_MIEHE') goto 9999
!
    nomres(1)='EPSI_MAXI'
    nomres(2)='VEPS_MAXI'
    nomres(3)='TEMP_MINI'
    nomres(4)='TEMP_MAXI'
    call rcvalb(fami, kpg, ksp, '+', imate,&
                ' ', 'VERI_BORNE', 0, ' ', [0.d0],&
                4, nomres, valres, icodre, 0)
!
!     TRAITEMENT DE EPSI_MAXI
    if (icodre(1) .eq. 0) then
        epsmax=valres(1)
        call dcopy(ndimsi, epsm, 1, eps, 1)
        call daxpy(ndimsi, 1.d0, deps, 1, eps,&
                   1)
        eps2=sqrt(ddot(ndimsi,eps,1,eps,1))
        if (eps2 .gt. epsmax) then
            iret1=4
        endif
    endif
!     TRAITEMENT DE VEPS_MAXI
    if (icodre(2) .eq. 0) then
        vepsm=valres(2)
        dt=instap-instam
        call dcopy(ndimsi, deps, 1, veps, 1)
        call dscal(ndimsi, 1.d0/dt, veps, 1)
        veps2=sqrt(ddot(ndimsi,veps,1,veps,1))
        if (veps2 .gt. vepsm) then
            iret2=4
        endif
    endif
!     TRAITEMENT DE TEMP_MINI ET TEMP_MAXI
    if (icodre(3) .eq. 0) then
        tmin=valres(3)
        tmax=valres(4)
        call rcvarc(' ', 'TEMP', '+', fami, kpg,&
                    ksp, temp, iret)
        if (iret .eq. 0) then
            if ((temp.lt.tmin) .or. (temp.gt.tmax)) then
                iret3=4
            endif
        endif
    endif
!
    codret=max(iret1,iret2)
    codret=max(codret,iret3)
!
9999  continue
end subroutine
