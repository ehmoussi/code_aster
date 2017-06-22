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

subroutine lctria(nb_inte_poin, nb_tria, tria_node)
!
implicit none
!
#include "asterfort/assert.h"
!
!
    integer, intent(in) :: nb_inte_poin
    integer, intent(out) :: nb_tria
    integer, intent(out) :: tria_node(6,3)
!
! --------------------------------------------------------------------------------------------------
!
! Contact - Pairing segment to segment
!
! Triangulation of convex polygon
!
! --------------------------------------------------------------------------------------------------
!
! In  nb_poin_inte     : number of intersection points
! Out nb_tria          : number of triangles
! Out tria_node        : list of triangles (defined by index of intersection points)
!
! --------------------------------------------------------------------------------------------------
!
    tria_node(1:6,1:3) = 0
    ASSERT(nb_inte_poin.ge.3)
    ASSERT(nb_inte_poin.le.8)
!
! - Total number of triangles
!
    nb_tria=nb_inte_poin-2
!
! - Cut
!
    if (nb_tria.eq.1) then    
        tria_node(1,1) =1
        tria_node(1,2) =2
        tria_node(1,3) =3
    else if (nb_tria.eq.2) then
        tria_node(1,1) =1
        tria_node(1,2) =2
        tria_node(1,3) =3
        tria_node(2,1) =3
        tria_node(2,2) =4
        tria_node(2,3) =1
    else if (nb_tria.eq.3) then
        tria_node(1,1) =1
        tria_node(1,2) =2
        tria_node(1,3) =3
        tria_node(2,1) =3
        tria_node(2,2) =4
        tria_node(2,3) =5
        tria_node(3,1) =5
        tria_node(3,2) =1
        tria_node(3,3) =3
    else if (nb_tria.eq.4) then
        tria_node(1,1) =1
        tria_node(1,2) =2
        tria_node(1,3) =3
        tria_node(2,1) =3
        tria_node(2,2) =4
        tria_node(2,3) =5
        tria_node(3,1) =5
        tria_node(3,2) =6
        tria_node(3,3) =1
        tria_node(4,1) =1
        tria_node(4,2) =3
        tria_node(4,3) =5
    else if (nb_tria.eq.5) then
        tria_node(1,1) =1
        tria_node(1,2) =2
        tria_node(1,3) =3
        tria_node(2,1) =3
        tria_node(2,2) =4
        tria_node(2,3) =5
        tria_node(3,1) =5
        tria_node(3,2) =6
        tria_node(3,3) =7
        tria_node(4,1) =7
        tria_node(4,2) =1
        tria_node(4,3) =3
        tria_node(5,1) =3
        tria_node(5,2) =5
        tria_node(5,3) =7
    else if (nb_tria.eq.6) then
        tria_node(1,1) =1
        tria_node(1,2) =2
        tria_node(1,3) =3
        tria_node(2,1) =3
        tria_node(2,2) =4
        tria_node(2,3) =5
        tria_node(3,1) =5
        tria_node(3,2) =6
        tria_node(3,3) =7  
        tria_node(4,1) =7
        tria_node(4,2) =8
        tria_node(4,3) =1
        tria_node(5,1) =1
        tria_node(5,2) =3
        tria_node(5,3) =5
        tria_node(6,1) =5
        tria_node(6,2) =7
        tria_node(6,3) =1
    else
        ASSERT(.false.)
    end if

end subroutine
