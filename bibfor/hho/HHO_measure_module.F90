! --------------------------------------------------------------------
! Copyright (C) 1991 - 2019 - EDF R&D - www.code-aster.org
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
module HHO_measure_module
!
use HHO_type
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "blas/ddot.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO
!
! Compute measure for elements:
!  - volume for 3D elements
!  - surface for 2D elements
!  - length for 1D element
!
! --------------------------------------------------------------------------------------------------
!
    public   :: hhoMeasureCell,  hhoMeasureFace,hhoDiameterCell, hhoDiameterFace, hho_surface_tri
    public   :: hhoLengthBoundingBoxCell
    private  :: hho_vol_hexa, hho_vol_tetra, hho_surface_quad, hho_length_edge
    private  :: hhoDiameter, prod_vec
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    function prod_vec(v0, v1) result(v2)
!
    implicit none
!
        real(kind=8), dimension(3), intent(in)  :: v0, v1
        real(kind=8), dimension(3)              :: v2
!
! --------------------------------------------------------------------------------------------------
!  In v0        :: vector 0
!  In v1        :: vector 1
!  Out v2       :: vector 2
! --------------------------------------------------------------------------------------------------
!
        v2 = 0.d0
!
        v2(1) = v0(2) * v1(3) - v0(3) * v1(2)
        v2(2) = -(v0(1) * v1(3) - v0(3) * v1(1))
        v2(3) = v0(1) * v1(2) - v0(2) * v1(1)
    !
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hho_vol_hexa(nodes) result(vol)
!
    implicit none
!
        real(kind=8), dimension(3,8), intent(in)   :: nodes
        real(kind=8)                               :: vol
!
! --------------------------------------------------------------------------------------------------
!  In nodes        :: list of nodes
!  Out vol         :: volume
! --------------------------------------------------------------------------------------------------
!
        integer, dimension(4,5)  :: tets
        integer :: i, j
        real(kind=8) :: nodestet(3,4)
! --------------------------------------------------------------------------------------------------
!
! --- split the hexa in 5 tets
        tets(1:4,1) = (/1,2,4,5/)
        tets(1:4,2) = (/2,3,4,7/)
        tets(1:4,3) = (/2,7,5,6/)
        tets(1:4,4) = (/4,5,7,8/)
        tets(1:4,5) = (/2,4,5,7/)
!
        vol = 0.d0
        do i =1, 5
            do j = 1, 4
                nodestet(1:3, j) = nodes(1:3, tets(j,i))
            end do
            vol = vol + hho_vol_tetra(nodestet)
        end do
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
   function hho_vol_tetra(nodes) result(vol)
!
      implicit none
!
         real(kind=8), dimension(3,4), intent(in)    :: nodes
         real(kind=8)                                :: vol
!
! --------------------------------------------------------------------------------------------------
!  In nodes        :: list of nodes
!  Out vol         :: volume
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(3)  :: v0 = 0.d0, v1 = 0.d0, v2 = 0.d0, cross= 0.d0
! --------------------------------------------------------------------------------------------------
!
         vol = 0.d0
         v0(1:3) = nodes(1:3,2) - nodes(1:3,1)
         v1(1:3) = nodes(1:3,3) - nodes(1:3,1)
         v2(1:3) = nodes(1:3,4) - nodes(1:3,1)
!
        cross(1:3) = prod_vec(v1,v2)
        vol = abs(dot_product(v0,cross) / 6.d0)
!
   end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hho_surface_quad(nodes) result(surface)
!
    implicit none
!
        real(kind=8), dimension(3,4), intent(in)    :: nodes
        real(kind=8)                                :: surface
!
! --------------------------------------------------------------------------------------------------
!  In nodes        :: list of nodes
!  Out vol         :: surface
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(3)  :: e1, e2, e3, e4, d1, d2
        real(kind=8) :: l1, l2, l3, l4, ld1, ld2
!
! ---- edge
        e1(1:3) = nodes(1:3,2) - nodes(1:3,1)
        e2(1:3) = nodes(1:3,3) - nodes(1:3,2)
        e3(1:3) = nodes(1:3,4) - nodes(1:3,3)
        e4(1:3) = nodes(1:3,1) - nodes(1:3,4)
! ---- diagonals
        d1(1:3) = nodes(1:3,3) - nodes(1:3,1)
        d2(1:3) = nodes(1:3,4) - nodes(1:3,2)
!
! ---- lengths
        l1 = dot_product(e1,e1)
        l2 = dot_product(e2,e2)
        l3 = dot_product(e3,e3)
        l4 = dot_product(e4,e4)
        ld1 = dot_product(d1,d1)
        ld2 = dot_product(d2,d2)
!
        surface = sqrt(4.d0 * ld1 * ld2 - (l1 - l2 + l3 - l4)**2 ) / 4.d0
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hho_surface_tri(nodes) result(surface)
!
    implicit none
!
        real(kind=8), dimension(3,3), intent(in)  :: nodes
        real(kind=8)                              :: surface
!
!---------------------------------------------------------------------------------------------------
!  In nodes        :: list of nodes
!  Out vol         :: surface
!---------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(3) :: v0, v1, v2 = 0.d0
!
        surface = 0.d0
        v0(1:3) = nodes(1:3,2) - nodes(1:3,1)
        v1(1:3) = nodes(1:3,3) - nodes(1:3,1)
        v2 = prod_vec(v0,v1)
!
        surface = norm2(v2) / 2.d0
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hho_length_edge(nodes) result(length)
!
    implicit none
!
        real(kind=8), dimension(3,2), intent(in)  :: nodes
        real(kind=8)                              :: length
!
! --------------------------------------------------------------------------------------------------
!  In nodes        :: list of nodes
!  Out vol         :: length
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(3)  :: v0 = 0.d0
! --------------------------------------------------------------------------------------------------
!
        v0(1:3) = nodes(1:3,2) - nodes(1:3,1)
!
        length = norm2(v0)
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoMeasureCell(cell) result(measure)
!
    implicit none
!
        type(HHO_Cell), intent(in)    :: cell
        real(kind=8)                  :: measure
!
! --------------------------------------------------------------------------------------------------
!  In HHO_Cell           :: cell HHO
!  Out measure           :: measure of the cell
! --------------------------------------------------------------------------------------------------

!
        measure = 0.d0
!
        if(cell%typema(1:5) == 'HEXA8') then
            measure = hho_vol_hexa(cell%coorno(1:3,1:8))
        elseif(cell%typema(1:6) == 'TETRA4') then
            measure = hho_vol_tetra(cell%coorno(1:3,1:4))
        elseif(cell%typema(1:5) == 'QUAD4') then
            measure = hho_surface_quad(cell%coorno(1:3,1:4))
        elseif(cell%typema(1:5) == 'TRIA3') then
            measure = hho_surface_tri(cell%coorno(1:3,1:3))
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoMeasureFace(face) result(measure)
!
    implicit none
!
        type(HHO_Face), intent(in)                  :: face
        real(kind=8)                                :: measure
!
! --------------------------------------------------------------------------------------------------
!  In HHO_Face           :: face HHO
!  Out measure           :: measure of the face
! --------------------------------------------------------------------------------------------------
!
        measure = 0.d0
!
        if(face%typema(1:5) == 'QUAD4') then
            measure = hho_surface_quad(face%coorno(1:3,1:4))
        elseif(face%typema(1:5) == 'TRIA3') then
            measure = hho_surface_tri(face%coorno(1:3,1:3))
        elseif(face%typema(1:4) == 'SEG2') then
            measure = hho_length_edge(face%coorno(1:3,1:2))
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoDiameter(coorno, nbnodes) result(diam)
!
    implicit none
        integer, intent(in)                             :: nbnodes
        real(kind=8), dimension(3, nbnodes), intent(in) :: coorno
        real(kind=8)                                    :: diam
!
! --------------------------------------------------------------------------------------------------
!  In coorno            :: coordinates of the nodes
!  In nbnodes           :: number of nodes
!  Out diam              :: maximum length of two distinc nodes
! --------------------------------------------------------------------------------------------------
!
        integer :: inode, jnode
        real(kind=8), dimension(3) :: vector
!
        diam = 0.d0
!
        do inode = 1, nbnodes
            do jnode = inode + 1, nbnodes
                vector(1:3) = coorno(1:3, inode) - coorno(1:3, jnode)
                diam = max(norm2(vector), diam);
            end do
        end do
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoDiameterCell(cell) result(measure)
!
    implicit none
!
        type(HHO_Cell), intent(in)    :: cell
        real(kind=8)                  :: measure
!
! --------------------------------------------------------------------------------------------------
!  In HHO_Cell              :: cell HHO
!  Out measure              :: maximum length of two distinc nodes
! --------------------------------------------------------------------------------------------------

!
        measure = 0.d0
!
        if(cell%typema(1:5) == 'HEXA8') then
            measure = hhoDiameter(cell%coorno(1:3,1:8),8)
        elseif(cell%typema(1:6) == 'TETRA4') then
            measure = hhoDiameter(cell%coorno(1:3,1:4),4)
        elseif(cell%typema(1:5) == 'QUAD4') then
            measure = hhoDiameter(cell%coorno(1:3,1:4),4)
        elseif(cell%typema(1:5) == 'TRIA3') then
            measure = hhoDiameter(cell%coorno(1:3,1:3),3)
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoDiameterFace(face) result(measure)
!
    implicit none
!
        type(HHO_Face), intent(in)    :: face
        real(kind=8)                  :: measure
!
! --------------------------------------------------------------------------------------------------
!  In HHO_Face              :: face HHO
!  Out measure              :: maximum length of two distinc nodes
! --------------------------------------------------------------------------------------------------
!
        measure = 0.d0
        if(face%typema(1:5) == 'QUAD4') then
            measure = hhoDiameter(face%coorno(1:3,1:4),4)
        elseif(face%typema(1:5) == 'TRIA3') then
            measure = hhoDiameter(face%coorno(1:3,1:3),3)
        elseif(face%typema(1:4) == 'SEG2') then
            measure = hhoDiameter(face%coorno(1:3,1:2),2)
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoLengthBoundingBoxCell(hhocell) result(length)
!
    implicit none
!
        type(HHO_Cell), intent(in)    :: hhocell
        real(kind=8), dimension(3)    :: length
!
! --------------------------------------------------------------------------------------------------
!  In HHO_Cell              :: cell HHO
!  Out length               :: length of the boundix box of the cell
! --------------------------------------------------------------------------------------------------
        real(kind=8), dimension(3) :: xmin, xmax
        integer :: inode, idim, ndim
! --------------------------------------------------------------------------------------------------
        length = 1.d0
        ndim = hhoCell%ndim
!
        xmin(1:3) = hhoCell%coorno(1:3, 1)
        xmax(1:3) = hhoCell%coorno(1:3, 1)
!
        do inode = 1, hhoCell%nbnodes
            do idim = 1, ndim
                xmin(idim) = min(xmin(idim), hhoCell%coorno(idim, inode))
                xmax(idim) = max(xmax(idim), hhoCell%coorno(idim, inode))
            end do
        end do
!
        do idim = 1, ndim
            length(idim) = abs(xmax(idim) - xmin(idim))
        end do
!
    end function
!
end module
