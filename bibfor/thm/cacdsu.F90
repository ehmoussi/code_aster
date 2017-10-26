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
! aslint: disable=W1306
!
subroutine cacdsu(maxfa    , parm_alpha,&
                  ndim     , nno       , nface,&
                  elem_coor,&
                  vol      , mface     , dface,&
                  xface    , normfa    , kdiag,&
                  yss      , c         , d    )
!
implicit none
!
#include "asterfort/assert.h"
!
integer, intent(in) :: maxfa
real(kind=8), intent(in) :: parm_alpha
integer, intent(in) :: ndim, nno, nface
real(kind=8), intent(in) :: elem_coor(ndim, nno)
real(kind=8), intent(in) :: vol
real(kind=8), intent(in) :: mface(1:maxfa)
real(kind=8), intent(in) :: dface(1:maxfa)
real(kind=8), intent(in) :: xface(1:3, 1:maxfa)
real(kind=8), intent(in) :: normfa(1:3, 1:maxfa)
real(kind=8), intent(in) :: kdiag(6)
real(kind=8), intent(out) :: yss(3, maxfa, maxfa)
real(kind=8), intent(out) :: c(maxfa, maxfa), d(maxfa, maxfa)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute (finite volume)
!
! Compute what ?
!
! --------------------------------------------------------------------------------------------------
!
! In  maxfa            : maximum number of faces
! In  parm_alpha       : parameter for FV (PARM_ALPHA)
! In  ndim             : dimension of space (2 or 3)
! In  nno              : number of nodes
! In  nface            : number of faces (for finite volume)
! In  elem_coor        : coordinates of nodes for current cell
! In  vol              : volume of current cell
! In  mface            : for each face => surface (or length)
! In  dface            : for each face => distance(face, gravity center of cell)
! In  xface            : for each face => center
! In  normfa           : for each face => normal
! In  kdiag
! Out yss
! Out c
! Out d
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: maxfa1=6, maxdi1=3
    integer :: ifa, jfa, kfa
    integer :: idim, jdim
    real(kind=8) :: dim, sqdim, beta
    real(kind=8) :: mcone(maxfa)
    real(kind=8) :: xg(maxdi1)
    real(kind=8) :: ndx(maxfa1, maxfa1), kint(maxdi1, maxdi1)
    real(kind=8) :: kuni(maxdi1, maxdi1), ky, ky1
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(maxfa1 .eq. maxfa)
    ASSERT(maxdi1 .eq. 3)
!
    if (ndim .eq. 2) then
        kint(1,1)=kdiag(1)
        kint(2,2)=kdiag(2)
        kint(1,2)=kdiag(3)
        kint(2,1)=kdiag(3)
        kuni(1,1)=1.d0
        kuni(2,2)=1.d0
        kuni(1,2)=0.d0
        kuni(2,1)=0.d0
    else if (ndim.eq.3) then
        kint(1,1)=kdiag(1)
        kint(2,2)=kdiag(2)
        kint(3,3)=kdiag(3)
        kint(1,2)=kdiag(4)
        kint(1,3)=kdiag(5)
        kint(2,3)=kdiag(6)
        kint(2,1)=kdiag(4)
        kint(3,1)=kdiag(5)
        kint(3,2)=kdiag(6)
        kuni(1,1)=1.d0
        kuni(2,2)=1.d0
        kuni(3,3)=1.d0
        kuni(1,2)=0.d0
        kuni(1,3)=0.d0
        kuni(2,3)=0.d0
        kuni(2,1)=0.d0
        kuni(3,1)=0.d0
        kuni(3,2)=0.d0
    else
        ASSERT(ASTER_FALSE)
    endif
    dim   = ndim
    sqdim = sqrt(dim)
    beta  = sqdim*sqrt(parm_alpha)
    do idim = 1, ndim
        xg(idim)=elem_coor(idim,nno)
    end do
    yss(1:3,1:maxfa,1:maxfa)=0.d0
    c(1:maxfa,1:maxfa)=0.d0
    d(1:maxfa,1:maxfa)=0.d0
!
    do ifa = 1, nface
        mcone(ifa) = (dface(ifa)*mface(ifa))/dim
        do jfa = 1, nface
            ndx(ifa,jfa) = 0.d0
            do idim = 1, ndim
                ndx(ifa,jfa) = ndx(ifa,jfa) + normfa(idim,ifa)*(xface(idim,jfa)-xg(idim))
            end do
        end do
    end do

    do ifa = 1, nface
        do jfa = 1, nface
            if (jfa .eq. ifa) then
                do idim = 1, ndim
                    yss(idim,ifa,ifa) = (mface(ifa)/vol)*normfa(idim,ifa)+&
                        (beta/dface(ifa))*(1.d0-(mface(ifa)/vol)*ndx(ifa,ifa))*normfa(idim,ifa)
                end do
            else
                do idim = 1, ndim
                    yss(idim,ifa,jfa) = (mface(jfa)/vol)*normfa(idim,jfa) -&
                        (beta/(dface(ifa)*vol))*mface(jfa)*ndx(jfa,ifa)*normfa(idim,ifa)
                end do
            endif
        end do
    end do
!
    do ifa = 1, nface
        do jfa = 1, nface
            c(ifa,jfa) = 0.d0
            d(ifa,jfa) = 0.d0
            do kfa = 1, nface
                do idim = 1, ndim
                    ky = 0.d0
                    ky1 = 0.d0
                    do jdim = 1, ndim
                        ky = ky + mcone(kfa)*kint(idim,jdim)* yss( jdim,kfa,jfa)
                        ky1 = ky1 + mcone(kfa)*kuni(idim,jdim)* yss(jdim,kfa,jfa)
                    end do
                    c(ifa,jfa) = c(ifa,jfa) + yss(idim,kfa,ifa)*ky
                    d(ifa,jfa) = d(ifa,jfa) + yss(idim,kfa,ifa)*ky1
                end do
            end do
        end do
    end do
end subroutine
