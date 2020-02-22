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
!
subroutine nmpr2d(l_axis, nno  , npg ,&
                  poidsg, vff  , dff ,&
                  geom  , pres , cisa,&
                  vect_ , matr_)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/subac1.h"
#include "asterfort/subacv.h"
#include "asterfort/sumetr.h"
#include "asterfort/utmess.h"
!
aster_logical, intent(in):: l_axis
integer, intent(in) :: nno, npg
real(kind=8), intent(in) :: poidsg(npg), vff(nno, npg), dff(nno, npg)
real(kind=8), intent(in) :: geom(2, nno), pres(npg), cisa(npg)
real(kind=8), intent(out), optional :: vect_(2, nno), matr_(2, nno, 2, nno)
!
! --------------------------------------------------------------------------------------------------
!
! Loads computation
!
! Pressure for faces of 2D elements - Second member and matrix
!
! --------------------------------------------------------------------------------------------------
!
! In  l_axis           : flag for axisymmetric elements
! In  nno              : number of nodes
! In  nng              : number of Gauss points
! In  poidsg           : weight of Gauss points
! In  vff              : shape functions at Gauss points
! In  dff              : derivative of shape functions at Gauss point point
! In  geom             : coordinates of nodes
! In  pres             : pressure at Gauss points
! In  cisa             : shear at Gauss points
! Out vect             : second member
! Out matr             : matrix
!
! --------------------------------------------------------------------------------------------------
!
    integer :: kpg, ino1, idim2, ino2, idim1
    real(kind=8) :: cova(3, 3), metr(2, 2), jac, cnva(3, 2)
    real(kind=8) :: t1, t2, t, acv(2, 2), r
!
! --------------------------------------------------------------------------------------------------
!
    if (present(vect_)) then
        vect_ = 0.d0
    endif
    if (present(matr_)) then
        matr_ = 0.d0
    endif
!
! - Loop on Gauss points
!
    do kpg = 1, npg
! ----- Shear stress => no undead loads
        if (cisa(kpg) .ne. 0.d0) then
            call utmess('F', 'ALGORITH8_24')
        endif
! ----- Check
        if (l_axis) then
            r = 0.d0
            do ino1 = 1, nno
                r = r + vff(ino1,kpg)*geom(1,ino1)
            end do
            if (r .eq. 0.d0) then
                if (pres(kpg) .ne. 0.d0) then
                    call utmess('F', 'ALGORITH8_25')
                endif
                goto 100
            endif
        endif
! ----- Covariant basis
        call subac1(l_axis, nno, vff(1, kpg), dff(1, kpg), geom,&
                    cova)
! ----- Metric tensor
        call sumetr(cova, metr, jac)
! ----- Compute vector
        if (present(vect_)) then
            do ino1 = 1, nno
                vect_(1,ino1) = vect_(1,ino1)- poidsg(kpg)*jac*pres(kpg)*cova(1,3)*vff(ino1,kpg)
                vect_(2,ino1) = vect_(2,ino1)- poidsg(kpg)*jac*pres(kpg)*cova(2,3)*vff(ino1,kpg)
            end do
        endif
! ----- Compute matrix
        if (present(matr_)) then
            call subacv(cova, metr, jac, cnva, acv)
            do ino2 = 1, nno
                do idim1 = 1, 2
                    do ino1 = 1, nno
                        do idim2 = 1, 2
                            t1                           = dff(ino2,kpg)*vff(ino1,kpg)*&
                                                           cnva(idim1,1)*cova(idim2,3)
                            t2                           = dff(ino2,kpg)*vff(ino1,kpg)*&
                                                           cnva(idim2,1)*cova(idim1,3)
                            t                            = poidsg(kpg)*pres(kpg)*jac*(t1 - t2)
                            matr_(idim2,ino1,idim1,ino2) = matr_(idim2,ino1,idim1,ino2) + t
                        end do
                    end do
                end do
            end do
            if (l_axis) then
                do ino1 = 1, nno
                    do ino2 = 1, nno
                        do idim1 = 1, 2
                            t1                       = vff(ino1,kpg)*vff(ino2,kpg)*&
                                                       cnva(3,2)*cova(idim1,3)
                            t                        = poidsg(kpg)*pres(kpg)*jac*t1
                            matr_(1,ino1,idim1,ino2) = matr_(1,ino1,idim1,ino2) + t
                        end do
                    end do
                end do
            endif
        endif
!
100     continue
!
    end do
!
end subroutine
