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

subroutine itgthm(ndim    , l_vf     , type_vf, inte_type,&
                  nno     , nnos     , nnom   , nface ,&
                  npi     , npi2     , npg    ,&
                  jv_poids, jv_poids2,&
                  jv_func , jv_func2 ,&
                  jv_dfunc, jv_dfunc2,&
                  jv_gano )
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/thmGetElemInfo.h"
#include "asterfort/thmGetElemRefe.h"
!
! aslint: disable=W1504
!
    integer, intent(in) :: ndim
    aster_logical, intent(in) :: l_vf
    integer, intent(in) :: type_vf
    character(len=3), intent(in) :: inte_type
    integer, intent(out) :: nno, nnos, nnom
    integer, intent(out) :: nface
    integer, intent(out) :: npi, npi2, npg
    integer, intent(out) :: jv_gano
    integer, intent(out) :: jv_poids, jv_poids2
    integer, intent(out) :: jv_func, jv_func2, jv_dfunc, jv_dfunc2
!
! --------------------------------------------------------------------------------------------------
!
! THM - Parameters
!
! Get definition of element
!
! --------------------------------------------------------------------------------------------------
!
! In  ndim         : dimension of element (2 ou 3)
! In  l_vf         : flag for finite volume
! In  type_vf      : type for finite volume
! In  inte_type    : type of integration - classical, lumped (D), reduced (R)
! Out nno          : number of nodes (all)
! Out nnos         : number of nodes (not middle ones)
! Out nnom         : number of nodes (middle ones)
! Out nface        : number of faces (for finite volume)
! Out npi          : number of Gauss points for linear
! Out npi2         : number of Gauss points for quadratic
! Out npg          : number of Gauss points
! Out jv_gano      : JEVEUX adress for Gauss points to nodes functions (linear shape functions)
! Out jv_poids     : JEVEUX adress for weight of Gauss points (linear shape functions)
! Out jv_poids2    : JEVEUX adress for weight of Gauss points (quadratic shape functions)
! Out jv_func      : JEVEUX adress for shape functions (linear shape functions)
! Out jv_func2     : JEVEUX adress for shape functions (quadratic shape functions)
! Out jv_dfunc     : JEVEUX adress for derivative of shape functions (linear shape functions)
! Out jv_dfunc2    : JEVEUX adress for derivative of shape functions (quadratic shape functions)
!
! --------------------------------------------------------------------------------------------------
!
    character(len=8) :: elrefe, elref2
!
! --------------------------------------------------------------------------------------------------
!
!
! - Get reference elements
!
    call thmGetElemRefe(l_vf, elrefe, elref2)
!
! - Get informations about element
!
    call thmGetElemInfo(l_vf, type_vf, inte_type, elrefe, elref2,&
                        nno, nnos, nnom, &
                        npi, npi2, npg,&
                        jv_gano, jv_poids, jv_poids2,&
                        jv_func, jv_func2, jv_dfunc, jv_dfunc2)
!
! - For finite volume
!
    if (l_vf) then
        if (ndim .eq. 2) then
            nface = nnos
        else
            if (elrefe .eq. 'H27') then
                nface = 6
            else if (elrefe.eq.'T9') then
                nface = 4
            else
                ASSERT(.false.)
            endif
        endif
    else
        nface = 0
    endif
!
end subroutine
