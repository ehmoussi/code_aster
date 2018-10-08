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
!
subroutine apinte_weight(elem_dime  , nb_poin_inte, poin_inte,&
                         inte_weight)
!
implicit none
!
#include "asterf_types.h"
!
integer, intent(in) :: elem_dime
integer, intent(in) :: nb_poin_inte
real(kind=8), intent(in) :: poin_inte(elem_dime-1,16)
real(kind=8), intent(out) :: inte_weight
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Compute weight of intersection
!
! --------------------------------------------------------------------------------------------------
!
! In  elem_dime        : dimension of elements
! In  nb_poin_inte     : number of intersection points
! In  poin_inte        : list (sorted) of intersection points
! Out inte_weight      : total weight of intersection
!
! --------------------------------------------------------------------------------------------------
!
    integer :: list_next(16), i_inte_poin
!
! --------------------------------------------------------------------------------------------------
!
    inte_weight = 0.d0
    if ((nb_poin_inte .gt. 2 .and. elem_dime .eq. 3) .or.&
        (nb_poin_inte .ge. 2 .and. elem_dime .eq. 2)) then
        if (elem_dime .eq. 3) then
            do i_inte_poin = 2, nb_poin_inte
                list_next(i_inte_poin-1) = i_inte_poin
            end do
            list_next(nb_poin_inte)=1
            do i_inte_poin = 1,nb_poin_inte
                inte_weight = inte_weight + &
                        poin_inte(1,i_inte_poin)*&
                        poin_inte(2,list_next(i_inte_poin))-&
                        poin_inte(1,list_next(i_inte_poin))*&
                        poin_inte(2,i_inte_poin)
            end do
            inte_weight = 1.d0/2.d0*inte_weight
            inte_weight = sqrt(inte_weight**2)
        else
            inte_weight = sqrt((poin_inte(1,2)-poin_inte(1,1))**2)
        end if
    endif
!
end subroutine
