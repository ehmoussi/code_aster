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

subroutine thmGetParaPhysic(mecani, press1, press2, tempe,&
                            yamec_, addeme_,&
                            yate_, addete_,&
                            yap1_, addep1_,&
                            yap2_, addep2_)
!
implicit none
!
#include "asterf_types.h"
!
!
    integer, intent(in) :: mecani(5)
    integer, intent(in) :: press1(7)
    integer, intent(in) :: press2(7)
    integer, intent(in) :: tempe(5)
    integer, optional, intent(out) :: yamec_
    integer, optional, intent(out) :: addeme_
    integer, optional, intent(out) :: yate_
    integer, optional, intent(out) :: addete_
    integer, optional, intent(out) :: yap1_
    integer, optional, intent(out) :: addep1_
    integer, optional, intent(out) :: yap2_
    integer, optional, intent(out) :: addep2_
!
! --------------------------------------------------------------------------------------------------
!
! THM - Parameters
!
! Get parameters for physics
!
! --------------------------------------------------------------------------------------------------
!
! In  mecani       : parameters for mechanic
! In  press1       : parameters for hydraulic (first pressure)
! In  press1       : parameters for hydraulic (second pressure)
! In  tempe        : parameters for thermic
! Out yamec        : 1 if mechanic , 0 otherwise
! Out addeme       : adress of first mechanic component in generalized strain vector
! Out yate         : 1 if thermic, 0 otherwise
! Out addete       : adress of first thermic component in in generalized strain vector
! Out yap1         : 1 if hydraulic (first pressure), 0 otherwise
! Out addep1       : adress of first hydraulic (first pressure) component in gen. strain vector
! Out yap2         : 1 if hydraulic (second pressure), 0 otherwise
! Out addep2       : adress of first hydraulic (second pressure) component in gen. strain vector
!
! --------------------------------------------------------------------------------------------------
!
    if (present(yamec_)) then
        yamec_  = mecani(1)
        addeme_ = 0
        if (yamec_ .eq. 1) then
            addeme_ = mecani(2)
        endif
    endif
!
    if (present(yap1_)) then
        yap1_   = press1(1)
        addep1_ = 0
        if (yap1_ .eq. 1) then
            addep1_ = press1(3)
        endif
    endif
!
    if (present(yap2_)) then
        yap2_   = press2(1)
        addep2_ = 0
        if (yap2_ .eq. 1) then
            addep2_ = press2(3)
        endif
    endif
!
    if (present(yate_)) then
        yate_   = tempe(1)
        addete_ = 0
        if (yate_ .eq. 1) then
            addete_ = tempe(2)
        endif
    endif
!
end subroutine
