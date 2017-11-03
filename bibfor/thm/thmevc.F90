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
subroutine thmevc(option  , nomte  , l_axi   ,&
                  nno     , nnos   ,&
                  npg     , nddls  , nddlm   ,&
                  jv_poids, jv_func, jv_dfunc)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/dfdm2d.h"
#include "asterfort/dfdm3d.h"
#include "asterfort/jevech.h"
#include "asterfort/tefrep.h"
!
character(len=16), intent(in) :: option, nomte
aster_logical, intent(in) :: l_axi
integer, intent(in) :: nno, nnos
integer, intent(in) :: npg
integer, intent(in) :: nddls, nddlm
integer, intent(in) :: jv_poids, jv_func, jv_dfunc
!
! --------------------------------------------------------------------------------------------------
!
! THM - Compute
!
! Volumic loads (CHAR_MECA_FR3D3D, CHAR_MECA_FR2D2D)
!
! --------------------------------------------------------------------------------------------------
!
! In  option       : name of option to compute
! In  nomte        : type of finite element
! In  l_axi        : flag is axisymmetric model
! In  nno          : number of nodes (all)
! In  nnos         : number of nodes (not middle ones)
! In  npg          : number of Gauss points
! In  nddls        : number of dof at nodes (not middle ones)
! In  nddlm        : number of dof at nodes (middle ones)
! In  jv_poids     : JEVEUX adress for weight of Gauss points (linear shape functions)
! In  jv_func      : JEVEUX adress for shape functions (linear shape functions)
! In  jv_dfunc     : JEVEUX adress for derivative of shape functions (linear shape functions)
!
! --------------------------------------------------------------------------------------------------
!
    real(kind=8) :: poids
    integer :: i_node, jv_forc, jv_geom, jv_vect, ii, kp, k, nnom
    real(kind=8) :: fx, fy, fz
    real(kind=8) :: rx
!
! --------------------------------------------------------------------------------------------------
!
    nnom = nno - nnos
    if (option .eq. 'CHAR_MECA_FR3D3D') then
        call jevech('PGEOMER', 'L', jv_geom)
        call tefrep(option, nomte, 'PFR3D3D', jv_forc)
        call jevech('PVECTUR', 'E', jv_vect)
        do kp = 1, npg
            k = (kp-1)*nno
            call dfdm3d(nno, kp, jv_poids, jv_dfunc, zr(jv_geom),&
                        poids)
            fx = 0.d0
            fy = 0.d0
            fz = 0.d0
            do i_node = 1, nno
                ii = 3 * (i_node-1)
                fx = fx + zr(jv_func+k+i_node-1) * zr(jv_forc+ii-1+1)
                fy = fy + zr(jv_func+k+i_node-1) * zr(jv_forc+ii-1+2)
                fz = fz + zr(jv_func+k+i_node-1) * zr(jv_forc+ii-1+3)
            end do
            do i_node = 1, nnos
                ii = nddls * (i_node-1)
                zr(jv_vect+ii-1+1) = zr(jv_vect+ii-1+1) + poids * fx * zr(jv_func+k+i_node-1)
                zr(jv_vect+ii-1+2) = zr(jv_vect+ii-1+2) + poids * fy * zr(jv_func+k+i_node-1)
                zr(jv_vect+ii-1+3) = zr(jv_vect+ii-1+3) + poids * fz * zr(jv_func+k+i_node-1)
            end do
            do i_node = 1, nnom
                ii = nnos*nddls+nddlm*(i_node-1)
                zr(jv_vect+ii-1+1) = zr(jv_vect+ii-1+1) + poids * fx * zr(jv_func+k+i_node+nnos-1)
                zr(jv_vect+ii-1+2) = zr(jv_vect+ii-1+2) + poids * fy * zr(jv_func+k+i_node+nnos-1)
                zr(jv_vect+ii-1+3) = zr(jv_vect+ii-1+3) + poids * fz * zr(jv_func+k+i_node+nnos-1)
            end do
        end do
    endif
!
    if (option .eq. 'CHAR_MECA_FR2D2D') then
        call jevech('PGEOMER', 'L', jv_geom)
        call tefrep(option, nomte, 'PFR2D2D', jv_forc)
        call jevech('PVECTUR', 'E', jv_vect)
!
        do kp = 1, npg
            k = (kp-1)*nno
            call dfdm2d(nno, kp, jv_poids, jv_dfunc, zr(jv_geom),&
                        poids)
            fx = 0.d0
            fy = 0.d0
            do i_node = 1, nno
                ii = 2 * (i_node-1)
                fx = fx + zr(jv_func+k+i_node-1) * zr(jv_forc+ii-1+1)
                fy = fy + zr(jv_func+k+i_node-1) * zr(jv_forc+ii-1+2)
            end do
            if (l_axi) then
                rx = 0.d0
                do i_node = 1, nno
                    rx = rx + zr(jv_geom+2*(i_node-1))*zr(jv_func+k+i_node-1)
                end do
                poids = poids*rx
            endif
            do i_node = 1, nnos
                ii = nddls* (i_node-1)
                zr(jv_vect+ii-1+1) = zr(jv_vect+ii-1+1) + poids * fx * zr(jv_func+k+ i_node-1)
                zr(jv_vect+ii-1+2) = zr(jv_vect+ii-1+2) + poids * fy * zr( jv_func+k+i_node-1)
            end do
            do i_node = 1, nnom
                ii = nnos*nddls+nddlm*(i_node-1)
                zr(jv_vect+ii-1+1)= zr(jv_vect+ii-1+1) + poids * fx * zr(jv_func+k+i_node+nnos-1)
                zr(jv_vect+ii-1+2)= zr(jv_vect+ii-1+2) + poids * fy * zr(jv_func+k+i_node+nnos-1)
            end do
        end do
    endif
!
end subroutine
