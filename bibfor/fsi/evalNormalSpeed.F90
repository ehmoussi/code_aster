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
! person_in_charge: mickael.abbas at edf.fr
!
subroutine evalNormalSpeed(l_func , l_time , time    ,&
                           nb_node, ndim   , ipg     ,&
                           jv_shap, jv_geom, jv_speed,&
                           vnor)
!
implicit none
!
#include "jeveux.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/fointe.h"
!
aster_logical, intent(in) :: l_func, l_time
integer, intent(in) :: ndim, nb_node, ipg
integer, intent(in) :: jv_geom, jv_shap, jv_speed
real(kind=8), intent(in) :: time
real(kind=8), intent(out) :: vnor
!
! --------------------------------------------------------------------------------------------------
!
! Utilities for fluid
!
! Evaluation of normal speed (CHAR_MECA_VNOR)
!
! --------------------------------------------------------------------------------------------------
!
! In  l_func           : flag if CHAR_MECA_VNOR is function
! In  l_time           : flag if have time for function
! In  time             : value of current time
! In  nb_node          : total number of nodes
! In  ndim             : dimension of cell (2 or 3)
! In  ipg              : current index of Gauss point
! In  jv_shap          : JEVEUX adress for shape functions
! In  jv_geom          : JEVEUX adress for geometry (coordinates of nodes)
! In  jv_speed         : JEVEUX adress for normal speed
! Out vnor             : normal speed
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: x, y, z
    integer :: i_node, ldec, iret
    integer :: nb_para
    character(len=8), parameter :: para_name(4) = (/'X   ', 'Y   ',  'Z   ', 'INST'/)
    real(kind=8) :: para_vale(4)
!
! --------------------------------------------------------------------------------------------------
!
    vnor = 0.d0
!
    if (l_func) then
        ldec = (ipg-1)*nb_node
! ----- Coordinates of current Gauss point
        x = 0.d0
        y = 0.d0
        z = 0.d0
        do i_node = 1, nb_node
            x = x + zr(jv_geom+(ndim+1)*(i_node-1)-1+1) * zr(jv_shap+ldec-1+i_node)
            y = y + zr(jv_geom+(ndim+1)*(i_node-1)-1+2) * zr(jv_shap+ldec-1+i_node)
            if (ndim .eq. 2) then
                z = z + zr(jv_geom+(ndim+1)*(i_node-1)-1+3) * zr(jv_shap+ldec-1+i_node)
            endif
        end do
! ----- Evaluation of function
        nb_para = 2
        para_vale(1) = x
        para_vale(2) = y
        if (ndim .eq. 2) then
            nb_para = 3
            para_vale(3) = z
        endif
        if (l_time) then
            nb_para = nb_para + 1
            para_vale(nb_para) = time
        endif
        call fointe('FM', zk8(jv_speed), nb_para, para_name, para_vale,&
                    vnor, iret)
    else
        vnor = zr(jv_speed)
    endif
!
end subroutine
