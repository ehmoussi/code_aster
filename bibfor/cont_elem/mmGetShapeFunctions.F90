! --------------------------------------------------------------------
! Copyright (C) 1991 - 2018 - EDF R&D - www.code-aster.org
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
subroutine mmGetShapeFunctions(laxis, typmae, typmam, &
                               ndim , nne   , nnm   , &
                               xpc  , ypc   , xpr   , ypr   ,&
                               ffe  , ffm   , dffm  , ddffm ,&
                               ffl  , jacobi)
!
implicit none
!
#include "asterf_types.h"
#include "jeveux.h"
#include "asterfort/jevech.h"
#include "asterfort/mmform.h"
#include "asterfort/mmmjac.h"
#include "asterfort/utmess.h"
!
aster_logical, intent(in) :: laxis
character(len=8), intent(in) :: typmae, typmam
integer, intent(in) :: ndim, nne, nnm
real(kind=8), intent(in) :: xpc, ypc, xpr, ypr
real(kind=8), intent(out) :: ffe(9), ffm(9), dffm(2,9), ddffm(3, 9), ffl(9)
real(kind=8), intent(out) :: jacobi
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Elementary computations
!
! Get shape functions
!
! --------------------------------------------------------------------------------------------------
!
! In  laxis            : flag for axisymmetric
! In  typmae           : type of slave element
! In  typmam           : type of master element
! In  ndim             : dimension of problem (2 or 3)
! In  nne              : number of slave nodes
! In  nnm              : number of master nodes
! In  xpc              : X-coordinate for contact point
! In  ypc              : Y-coordinate for contact point
! In  xpr              : X-coordinate for projection of contact point
! In  ypr              : Y-coordinate for projection of contact point
! Out ffe              : shape function for slave nodes
! Out ffm              : shape function for master nodes
! Out dffm             : first derivative of shape function for master nodes
! Out ddffm            : second derivative of shape function for master nodes
! Out ffl              : shape function for Lagrange dof
! Out jacobi           : jacobian at integration point
!
! --------------------------------------------------------------------------------------------------
!
    integer :: i_node, i_dime
    integer :: jgeom
    real(kind=8) :: slav_coor_init(3,9)
    real(kind=8) :: dffe(2, 9), ddffe(3, 9)
    real(kind=8) :: dffl(2, 9), ddffl(3, 9)
    aster_logical :: l_axis_warn
!
! --------------------------------------------------------------------------------------------------
!
    call jevech('PGEOMER', 'L', jgeom)
!
! - Initial coordinates
!
    do i_node = 1, nne
        do i_dime = 1, ndim
            slav_coor_init(i_dime, i_node) = zr(jgeom+(i_node-1)*ndim+i_dime-1)
        end do
    end do
!
! - Get shape functions
!
    call mmform(ndim  ,&
                typmae, typmam,&
                nne   , nnm   ,&
                xpc   , ypc   , xpr  , ypr,&
                ffe   , dffe  , ddffe,&
                ffm   , dffm  , ddffm,&
                ffl   , dffl  , ddffl)
!
! - Compute jacobian on slave element
!
    call mmmjac(laxis , nne           , ndim,&
                typmae, slav_coor_init,&
                ffe   , dffe          ,&
                jacobi, l_axis_warn)
    if (l_axis_warn) then
        call utmess('A', 'CONTACT2_14')
    endif
!
end subroutine
