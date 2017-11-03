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
!
subroutine cabhvf(maxfa    , ndim , nno  , nnos , nface ,&
                  elem_coor,&
                  vol      , mface, dface, xface, normfa)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/pdvc2d.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
#include "asterfort/vfgefa.h"
#include "asterfort/vfnulo.h"
!
integer, intent(in) :: maxfa, ndim, nno, nnos, nface
real(kind=8), intent(in) :: elem_coor(ndim, nno)
real(kind=8), intent(out) :: vol
real(kind=8), intent(out) :: mface(1:maxfa)
real(kind=8), intent(out) :: dface(1:maxfa)
real(kind=8), intent(out) :: xface(1:3, 1:maxfa)
real(kind=8), intent(out) :: normfa(1:3, 1:maxfa)
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute (finite volume)
!
! Compute geometric parameters for current cell
!
! --------------------------------------------------------------------------------------------------
!
! In  maxfa            : maximum number of faces
! In  ndim             : dimension of space (2 or 3)
! In  nno              : number of nodes
! In  nnos             : number of nodes (not middle ones)
! In  nface            : number of faces (for finite volume)
! In  elem_coor        : coordinates of nodes for current cell
! Out vol              : volume of current cell
! Out mface            : for each face => surface (or length)
! Out dface            : for each face => distance(face, gravity center of cell)
! Out xface            : for each face => center
! Out normfa           : for each face => normal
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: maxfa1=6, maxdi1=3, maxar=12, manofa=4
    real(kind=8) :: xg(maxdi1)
    integer :: ifa
    real(kind=8), parameter :: epsrel=0.1d0
    real(kind=8) :: epsilo
    integer :: nbnofa(1:maxfa1)
    integer :: nosar(1:maxar, 2)
    integer :: nosfa(1:maxfa1, manofa)
    integer :: narfa(1:maxfa1, manofa)
    real(kind=8) :: xs(1:maxdi1, manofa), t(1:maxdi1, maxar)
    integer :: idim, is, iar, ns1, ns2, iret
    integer :: iadzi, iazk24
    character(len=8) :: elem_name
!
! --------------------------------------------------------------------------------------------------
!
    ASSERT(maxfa1.eq.maxfa)
!
! - Get numbering of faces
!
    call vfnulo(maxfa1, maxar, ndim , nnos , nface,&
                nbnofa, nosar, nosfa, narfa)
!
    if (ndim .eq. 2) then
        do idim = 1, ndim
            xg(idim) = elem_coor(idim,nno)
        end do
        do ifa = 1, nface
            do idim = 1, ndim
                xface(idim,ifa) = elem_coor(idim,nnos+ifa)
                t(idim,ifa)     = elem_coor(idim,nosfa(ifa,2))- elem_coor(idim,nosfa(ifa,1))
            end do
        end do
        if (nface .eq. 3) then
            vol    = abs(pdvc2d(t(1,1),t(1,2)))/2.d0
            epsilo = epsrel*sqrt(vol)
        else
            vol    = (abs(pdvc2d(t(1,1),t(1,4)))+ abs(pdvc2d(t(1,3),t(1,2))))/2.d0
        endif
        do ifa = 1, nface
            mface(ifa)    = sqrt(t(1,ifa)**2+t(2,ifa)**2)
            normfa(1,ifa) = -t(2,ifa)/mface(ifa)
            normfa(2,ifa) =  t(1,ifa)/mface(ifa)
        end do
        do ifa = 1, nface
            dface(ifa) = (xface(1,ifa)-xg(1))*normfa(1,ifa)+ (xface(2,ifa)-xg(2))*normfa(2,ifa)
            if (dface(ifa) .lt. 0.d0) then
                dface(ifa)    = -dface(ifa)
                normfa(1,ifa) = -normfa(1,ifa)
                normfa(2,ifa) = -normfa(2,ifa)
            endif
        end do
    else
        vol = 0.d0
        do idim = 1, ndim
            xg(idim) = 0.d0
            do is = 1, nnos
                xg(idim) = xg(idim)+elem_coor(idim,is)
            end do
            xg(idim) = xg(idim)/nnos
        end do
        do ifa = 1, nface
            do iar = 1, nbnofa(ifa)
                ns1 = nosar(narfa(ifa,iar),1)
                ns2 = nosar(narfa(ifa,iar),2)
                do idim = 1, ndim
                    t(idim,iar) = elem_coor(idim,ns2)-elem_coor(idim,ns1)
                end do
            end do
            do is = 1, nbnofa(ifa)
                do idim = 1, ndim
                    xs(idim,is) = elem_coor(idim,nosfa(ifa,is))
                end do
            end do
            call vfgefa(nbnofa(ifa), xs            , t            , xg        ,&
                        mface(ifa) , normfa(1, ifa), xface(1, ifa), dface(ifa),&
                        iret)
            if (iret .ne. 0) then
                call tecael(iadzi, iazk24)
                elem_name = zk24(iazk24-1+3) (1:8)
                call utmess('F', 'VOLUFINI_13', sk=elem_name, si=ifa)
            endif
            vol = vol+dface(ifa)*mface(ifa)/3.d0
        end do
    endif
end subroutine
