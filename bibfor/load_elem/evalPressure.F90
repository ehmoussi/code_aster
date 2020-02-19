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
subroutine evalPressure(l_func , l_time , time      ,&
                        nb_node, ndim   , ipg       ,&
                        jv_shap, jv_geom, jv_pres   ,&
                        pres   , cisa_  , geom_reac_)
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
integer, intent(in) :: jv_geom, jv_shap, jv_pres
real(kind=8), intent(in) :: time
real(kind=8), intent(out) :: pres
real(kind=8), optional, intent(out) :: cisa_
real(kind=8), optional, intent(in) :: geom_reac_(*)
!
! --------------------------------------------------------------------------------------------------
!
! Utilities for fluid
!
! Evaluation of pressure at Gauss point
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
! In  jv_pres          : JEVEUX adress for pressure
! In  geom_reac        : updated geometry
! Out pres             : normal pressure
! Out cisa             : "tangent" pressure (shear, only in 2D !)
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: x, y, z, xf, yf, zf
    integer :: i_node, ldec, iret
    integer :: nb_para
    character(len=8) :: para_name(7)
    real(kind=8) :: para_vale(7)
!
! --------------------------------------------------------------------------------------------------
!
    para_name = ' '
    pres = 0.d0
    if (present(cisa_)) then
        cisa_ = 0.d0
    endif
!
    ldec = (ipg-1)*nb_node
!
    if (l_func) then
! ----- Coordinates of current Gauss point
        x  = 0.d0
        y  = 0.d0
        z  = 0.d0
        xf = 0.d0
        yf = 0.d0
        zf = 0.d0
        do i_node = 1, nb_node
            x  = x + zr(jv_geom+(ndim+1)*(i_node-1)-1+1) * zr(jv_shap+ldec-1+i_node)
            y  = y + zr(jv_geom+(ndim+1)*(i_node-1)-1+2) * zr(jv_shap+ldec-1+i_node)
            if (present(geom_reac_)) then
                xf = xf + geom_reac_((ndim+1)*(i_node-1)+1) * zr(jv_shap+ldec-1+i_node)
                yf = yf + geom_reac_((ndim+1)*(i_node-1)+2) * zr(jv_shap+ldec-1+i_node)
            endif
            if (ndim .eq. 2) then
                z  = z + zr(jv_geom+(ndim+1)*(i_node-1)-1+3) * zr(jv_shap+ldec-1+i_node)
                if (present(geom_reac_)) then
                    zf = zf + geom_reac_((ndim+1)*(i_node-1)+3) * zr(jv_shap+ldec-1+i_node)
                endif
            endif
        end do
! ----- Evaluation of function
        nb_para = 4
        para_vale(1) = x
        para_name(1) = 'X'
        para_vale(2) = xf
        para_name(2) = 'XF'
        para_vale(3) = y
        para_name(3) = 'Y'
        para_vale(4) = yf
        para_name(4) = 'YF'
        if (ndim .eq. 2) then
            nb_para = nb_para + 1
            para_vale(nb_para) = z
            para_name(nb_para) = 'Z'
            nb_para = nb_para + 1
            para_vale(nb_para) = zf
            para_name(nb_para) = 'ZF'
        endif
        if (l_time) then
            nb_para = nb_para + 1
            para_vale(nb_para) = time
            para_name(nb_para) = 'INST'
        endif
        call fointe('FM', zk8(jv_pres-1+1), nb_para, para_name, para_vale,&
                    pres, iret)
        if (present(cisa_)) then
            call fointe('FM', zk8(jv_pres-1+2), nb_para, para_name, para_vale,&
                        cisa_, iret)
        endif
    else
        if (present(cisa_)) then
            do i_node = 1, nb_node
                pres  = pres  + zr(jv_pres+2*(i_node-1)-1+1) * zr(jv_shap+ldec-1+i_node)
                cisa_ = cisa_ + zr(jv_pres+2*(i_node-1)-1+2) * zr(jv_shap+ldec-1+i_node)
            end do
        else
            do i_node = 1, nb_node
                pres  = pres  + zr(jv_pres+(i_node-1)-1+1) * zr(jv_shap+ldec-1+i_node)
            end do
        endif
    endif
!
end subroutine
