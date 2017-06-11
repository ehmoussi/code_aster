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

subroutine thmGetElemInfo(l_vf, type_vf, inte_type, elrefe, elref2,&
                          nno, nnos, nnom, &
                          npi, npi2, npg,&
                          jv_gano, jv_poids, jv_poids2,&
                          jv_func, jv_func2, jv_dfunc, jv_dfunc2)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/elrefe_info.h"
#include "asterfort/utmess.h"
!
!
    aster_logical, intent(in) :: l_vf
    integer, intent(in) :: type_vf
    character(len=3), intent(in) :: inte_type
    character(len=8), intent(in) :: elrefe
    character(len=8), intent(in) :: elref2
    integer, intent(out) :: nno, nnos, nnom
    integer, intent(out) :: npi, npi2, npg
    integer, intent(out) :: jv_gano
    integer, intent(out) :: jv_poids, jv_poids2
    integer, intent(out) :: jv_func, jv_func2, jv_dfunc, jv_dfunc2
!
! --------------------------------------------------------------------------------------------------
!
! THM - Parameters
!
! Get informations about element
!
! --------------------------------------------------------------------------------------------------
!
! In  l_vf         : flag for finite volume
! In  type_vf      : type for finite volume
! In  inte_type    : type of integration - classical, lumped (D), reduced (R)
! In  elrefe       : reference element for non-middle nodes (linear)
! In  elref2       : reference element for middle nodes (quadratic)
! Out nno          : number of nodes (all)
! Out nnos         : number of nodes (not middle ones)
! Out nnom         : number of nodes (middle ones)
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
    integer :: nno2, nnos2
!
! --------------------------------------------------------------------------------------------------
!
    nno  = 0
    nnos = 0
    nnom = 0
    npi  = 0
    npi2 = 0
    npg  = 0
! - Quadratic (mechanic)
    call elrefe_info(elrefe=elrefe, fami='RIGI', nno=nno, nnos=nnos,&
                     npg=npi, jpoids=jv_poids, jvf=jv_func, jdfde=jv_dfunc, jgano=jv_gano)
! - Linear (hydraulic, thermic)
    call elrefe_info(elrefe=elref2, fami='RIGI', nno=nno2, nnos=nnos2,&
                     npg=npi2, jpoids=jv_poids2, jvf=jv_func2, jdfde=jv_dfunc2)
!
    ASSERT(nnos.eq.nno2)
    if (.not. l_vf) then
        nnom = nno - nnos
    endif
!
! - Number of Gauss points
!
    if (l_vf) then
        if (type_vf .eq. 3) then
            npg = npi
        else
            call utmess('F', 'VOLUFINI_9', si=type_vf)
        endif
    else
        npg = npi
    endif
    if (inte_type .eq. 'RED') then
        npg = npi- nnos
    endif
!
end subroutine
