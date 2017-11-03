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

subroutine epslmc(nno  , ndim  , nbsig,&
                  npg  , ipoids, ivf  ,&
                  idfde, xyz   , depl ,&
                  epsi )
    implicit none
!
!      epslmc --- compute logarithmic strain at integration points
!                 for isoparametric elements
!
!   nno     : number of element nodes
!   ndim    : element dimension (2 or 3)
!   nbsig   : number of element strain components
!   npg     : number of gauss point integration
!   ipoids  : pointer shape functions
!   ivf     : pointer integration weight
!   idfde   : pointer derivative shape functions
!   xyz(1)  : connectivity coordinates
!   depl(1) : displacements
!   epsi(1) : logarithmic strain at gauss points

#include "jeveux.h"
#include "asterfort/dfdmip.h"
#include "asterfort/nmepsi.h"
#include "asterfort/lteatt.h"
#include "asterfort/deflog.h"
!
    integer     , intent(in)    :: nno
    integer     , intent(in)    :: ndim
    integer     , intent(in)    :: nbsig
    integer     , intent(in)    :: npg
    integer     , intent(in)    :: ipoids
    integer     , intent(in)    :: ivf
    integer     , intent(in)    :: idfde
    real(kind=8), intent(in)    :: xyz(1)
    real(kind=8), intent(in)    :: depl(1)
    real(kind=8), intent(inout) :: epsi(1)
!
    integer :: igau, k, iret
    real(kind=8) :: r, w
    real(kind=8), dimension(nno, ndim) :: dfdi
    real(kind=8), dimension(3, 3)      :: f, gn
    real(kind=8), dimension(6)         :: tbid, epsl
    real(kind=8), dimension(3)         :: lamb, logl
    aster_logical :: axi, grand
    real(kind=8), parameter :: zero = 0.0d0, sqrt2 = sqrt(2.0d0)
!
    if (lteatt('AXIS','OUI')) then
        axi = .true.
    else
        axi = .false.
    endif
    grand = .true.
    do igau = 1, npg
        r = zero
        k = (igau-1)*nno
        call dfdmip(ndim, nno, axi, xyz, igau,&
                    ipoids, zr(ivf+k), idfde, r, w,&
                    dfdi)
!
        call nmepsi(ndim, nno, axi, grand, zr(ivf+k),&
                    r, dfdi, depl, f, tbid)
!
        call deflog(ndim, f, epsl, gn, lamb,&
                    logl, iret)
        epsl(4:6) = epsl(4:6) / sqrt2
        epsi(nbsig*(igau-1)+1:nbsig*igau) = epsl(1:nbsig)
!
    enddo
end subroutine
