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
!
module HHO_geometry_module
!
use HHO_type
!
implicit none
!
private
#include "asterc/r8prem.h"
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/elrfvf.h"
#include "asterfort/elrfdf.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO - Geometry module
!
! Compute outward normal of a surface
! Compute barycenter of an element
!
! --------------------------------------------------------------------------------------------------
!
   public  :: barycenter, hhoNormalFace, hhoFaceInitCoor, hhoGeomBasis, hhoGeomDerivBasis
   public  :: hhoLocalBasisFace, hhoNormalFace2
   private :: hhoNormalFace2d, well_oriented, hhoNormalFace1d, prod_vec
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    function barycenter(nodes, nbnodes) result(bar)
!
    implicit none
!
        integer, intent(in)                             :: nbnodes
        real(kind=8), dimension(3,nbnodes), intent(in)  :: nodes
        real(kind=8), dimension(3)                      :: bar
!
! --------------------------------------------------------------------------------------------------
!  In nodes        :: list of nodes
!  In nbnodes      :: number of nodes
!  In ndim         :: topological dimension
!  Out bar         :: barycenter of nodes
! --------------------------------------------------------------------------------------------------
!
        integer :: inode
! --------------------------------------------------------------------------------------------------
!
        bar = 0.d0
!
        do inode = 1, nbnodes
            bar(1:3) = bar(1:3) + nodes(1:3, inode)
        end do
!
        bar(1:3) = bar(1:3) / real(nbnodes, kind=8)
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function prod_vec(v0, v1) result(v2)
!
    implicit none
!
        real(kind=8), dimension(3), intent(in)  :: v0
        real(kind=8), dimension(3), intent(in)  :: v1
        real(kind=8), dimension(3)              :: v2
!
! --------------------------------------------------------------------------------------------------
!  In v0        :: vector 0
!  In v1        :: vector 1
!  Out v2       :: vector 2 = v0 x v1
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
    function well_oriented(v0, normal)
!
    implicit none
!
        real(kind=8), dimension(3), intent(in)  :: v0
        real(kind=8), dimension(3), intent(in)  :: normal
        aster_logical                           :: well_oriented
!
! --------------------------------------------------------------------------------------------------
!  In v0        :: vector 0
!  In normal    :: normal
!  Out logical  :: is well oriented
! --------------------------------------------------------------------------------------------------
!
        if(dot_product(v0,normal) .le. r8prem()) then
            well_oriented = ASTER_FALSE
        else
            well_oriented = ASTER_TRUE
        end if
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoNormalFace2d(coorno, nbnodes, barycenter_face, barycenter_cell) result(normal)
!
    implicit none
!
        real(kind=8), dimension(3,4), intent(in)            :: coorno
        integer, intent(in)                                 :: nbnodes
        real(kind=8), dimension(3), optional, intent(in)    :: barycenter_face
        real(kind=8), dimension(3), optional, intent(in)    :: barycenter_cell
        real(kind=8), dimension(3)                          :: normal
!
! --------------------------------------------------------------------------------------------------
!  In coorno             :: coordinates of the nodes
!  In nbnodes            :: number of nodes
!  In barycenter_face    :: barycenter of the face
!  In barycenter_cell    :: barycenter of the cell
!  Out normal            :: outward normal
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(3) :: v0, v1, vbar
!  -------------------------------------------------------------------------------------------------
        normal = 0.d0
!
        v0(1:3) = coorno(1:3,2) - coorno(1:3,1)
        v1(1:3) = coorno(1:3,nbnodes) - coorno(1:3,1)
!
        normal = prod_vec(v0, v1)
        normal = normal / norm2(normal)
!
! ---- Test normal
        if(present(barycenter_cell)) then
            vbar(1:3) = barycenter_face(1:3) - barycenter_cell(1:3)
            if(.not.well_oriented(vbar, normal)) then
                normal = -normal
            end if
        end if
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
   function hhoNormalFace1d(coorno, barycenter_face, barycenter_cell) result(normal)
!
    implicit none
!
        real(kind=8), dimension(3,4), intent(in)            :: coorno
        real(kind=8), dimension(3), optional, intent(in)    :: barycenter_face
        real(kind=8), dimension(3), optional, intent(in)    :: barycenter_cell
        real(kind=8), dimension(3)                          :: normal
!
! --------------------------------------------------------------------------------------------------
!  In coorno             :: coordinates of the node
!  In barycenter_face    :: barycenter of the face
!  In barycenter_cell    :: barycenter of the cell
!  Out normal            :: outward normal
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(3) :: tangente, vbar
! --------------------------------------------------------------------------------------------------
! -- Normal to the face
        tangente = coorno(1:3,2) - coorno(1:3,1)
!
        normal = (/-tangente(2), tangente(1), 0.d0/)
        normal = -normal / norm2(normal)
!
! ---- Test normal
        if(present(barycenter_cell)) then
            vbar(1:3) = barycenter_face(1:3) - barycenter_cell(1:3)
            if(.not.well_oriented(vbar, normal)) then
                normal = -normal
            end if
        end if
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoNormalFace(hhoFace, barycenter_cell) result(normal)
!
    implicit none
!
        type(HHO_Face), intent(in)                :: hhoFace
        real(kind=8), dimension(3), intent(in)    :: barycenter_cell
        real(kind=8), dimension(3)                :: normal
!
! --------------------------------------------------------------------------------------------------
!  In HHO_Face           :: face HHO
!  In barycenter_cell    :: barycenter of the cell
!  In normal cell        :: normal to the cell (use for 2D cell)
!  Out normal            :: outward normal of the face
! --------------------------------------------------------------------------------------------------

! --------------------------------------------------------------------------------------------------
        normal = 0.d0
!
        if(hhoFace%typema(1:5) == 'QUAD4') then
            normal = hhoNormalFace2d(hhoFace%coorno, 4, hhoFace%barycenter, barycenter_cell)
        elseif(hhoFace%typema(1:5) == 'TRIA3') then
            normal = hhoNormalFace2d(hhoFace%coorno, 3, hhoFace%barycenter, barycenter_cell)
        elseif(hhoFace%typema(1:4) == 'SEG2') then
            normal = hhoNormalFace1d(hhoFace%coorno, hhoFace%barycenter, barycenter_cell)
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
    function hhoNormalFace2(typma, nodes_coor) result(normal)
!
    implicit none
!
        character(len=8), intent(in)                    :: typma
        real(kind=8), dimension(3,4), intent(in)        :: nodes_coor
        real(kind=8), dimension(3)                      :: normal
!
! --------------------------------------------------------------------------------------------------
!  In typma              :: type of face
!  In nodes_coor         :: coordinates of the face
!  In normal cell        :: normal to the cell (use for 2D cell)
!  Out normal            :: outward normal of the face
! --------------------------------------------------------------------------------------------------

! --------------------------------------------------------------------------------------------------
        normal = 0.d0
!
        if(typma(1:5) == 'QUAD4') then
            normal = hhoNormalFace2d(nodes_coor, 4)
        elseif(typma(1:5) == 'TRIA3') then
            normal = hhoNormalFace2d(nodes_coor, 3)
        elseif(typma(1:4) == 'SEG2') then
            normal = hhoNormalFace1d(nodes_coor)
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
    function hhoLocalBasisFace(hhoFace) result(axes)
!
    implicit none
!
        type(HHO_Face), intent(in) :: hhoFace
        real(kind=8), dimension(3,2) :: axes
!
! --------------------------------------------------------------------------------------------------
!   HHO - geometry
!
!   compute orthonormal local basis of the face
!   In hhoFace              : the current HHO Face
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(3) :: v0, v1
!
        axes = 0.d0
!
        if(hhoFace%ndim == 2) then
            v0 = hhoFace%coorno(1:3,2) - hhoFace%coorno(1:3,1)
            v1 = hhoFace%coorno(1:3,hhoFace%nbnodes) - hhoFace%coorno(1:3,1)
!
            v1 = v1 - (dot_product(v0,v1) * v0) / (dot_product(v0, v0))
!
            axes(1:3,1) = v0 / norm2(v0)
            axes(1:3,2) = v1 / norm2(v1)
!
        elseif(hhoFace%ndim == 1) then
            v0 = hhoFace%coorno(1:3,2) - hhoFace%coorno(1:3,1)
!
            axes(1:3,1) = v0 / norm2(v0)
!
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
    function hhoFaceInitCoor(coorno, numnodes, nbnodes, ndimF) result(nodes_face)
!
    implicit none
!
        integer, intent(in)                         :: ndimF
        real(kind=8), dimension(3,4), intent(in)    :: coorno
        integer, dimension(4), intent(in)           :: numnodes
        integer, intent(in)                         :: nbnodes
        real(kind=8), dimension(3,4)                :: nodes_face
!
! --------------------------------------------------------------------------------------------------
!   We have to reorder the nodes of the face to use the same basis functions for a face
!     which is shared by two cells
!  In HHO_Face           :: face HHO
! --------------------------------------------------------------------------------------------------
!
        integer :: ino, minnum, numsorted(4)
!
        numsorted(:) = 0
!
        if (ndimF == 1) then
            ASSERT(nbnodes == 2)
!
            if (numnodes(1) < numnodes(2)) then
                numsorted(1:2) = (/1, 2 /)
            else if (numnodes(2) < numnodes(1)) then
                numsorted(1:2) = (/2, 1 /)
            else
                ASSERT(ASTER_FALSE)
            end if
        else if (ndimF == 2) then
            minnum = minloc(numnodes(1:nbnodes), 1)
!
            if (nbnodes == 3) then
                if (minnum == 1) then
                    if (numnodes(2) < numnodes(3)) then
                        numsorted(1:3) = (/1, 2, 3 /)
                    else if (numnodes(3) < numnodes(2)) then
                        numsorted(1:3) = (/1, 3, 2 /)
                    else
                        ASSERT(ASTER_FALSE)
                    end if
                elseif (minnum == 2) then
                    if (numnodes(1) < numnodes(3)) then
                        numsorted(1:3) = (/2, 1, 3 /)
                    else if (numnodes(3) < numnodes(1)) then
                        numsorted(1:3) = (/2, 3, 1 /)
                    else
                        ASSERT(ASTER_FALSE)
                    end if
                elseif (minnum == 3) then
                    if (numnodes(1) < numnodes(2)) then
                        numsorted(1:3) = (/3, 1, 2 /)
                    else if (numnodes(2) < numnodes(1)) then
                        numsorted(1:3) = (/3, 2, 1 /)
                    else
                        ASSERT(ASTER_FALSE)
                    end if
                else
                    ASSERT(ASTER_FALSE)
                end if
            else if (nbnodes == 4) then
                if (minnum == 1) then
                    if (numnodes(2) < numnodes(4)) then
                        numsorted(1:4) = (/1, 2, 3, 4 /)
                    else if (numnodes(4) < numnodes(2)) then
                        numsorted(1:4) = (/1, 4, 3, 2 /)
                    else
                        ASSERT(ASTER_FALSE)
                    end if
                elseif (minnum == 2) then
                    if (numnodes(1) < numnodes(3)) then
                        numsorted(1:4) = (/2, 1, 4, 3 /)
                    else if (numnodes(3) < numnodes(1)) then
                        numsorted(1:4) = (/2, 3, 4, 1 /)
                    else
                        ASSERT(ASTER_FALSE)
                    end if
                elseif (minnum == 3) then
                    if (numnodes(2) < numnodes(4)) then
                        numsorted(1:4) = (/3, 2, 1, 4 /)
                    else if (numnodes(4) < numnodes(2)) then
                        numsorted(1:4) = (/3, 4, 1, 2 /)
                    else
                        ASSERT(ASTER_FALSE)
                    end if
                elseif (minnum == 4) then
                    if (numnodes(1) < numnodes(3)) then
                        numsorted(1:4) = (/4, 1, 2, 3 /)
                    else if (numnodes(3) < numnodes(1)) then
                        numsorted(1:4) = (/4, 3, 2, 1 /)
                    else
                        ASSERT(ASTER_FALSE)
                    end if
                else
                    ASSERT(ASTER_FALSE)
                end if
            else
                ASSERT(ASTER_FALSE)
            end if
!
        else
            ASSERT(ASTER_FALSE)
        end if
!
! --- Copy the coordinates
        nodes_face = 0.d0
        do ino = 1, nbnodes
            nodes_face(1:3,ino) = coorno(1:3,numsorted(ino))
        end do
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGeomBasis(typema, pt, basis)
!
    implicit none
!
        character(len=8), intent(in)  :: typema
        real(kind=8), intent(in)      :: pt(3)
        real(kind=8), intent(out)     :: basis(8)
!
! ---------------------------------------------------------------------------------
!  HHO - geometrie
!  Compute the functions which descript the geometry
!
! In typema : type of element
! In pt     : coordinate of the point
! In basis  : evaluation of the basis at the point pt
! ---------------------------------------------------------------------------------
!
        integer :: nno
        basis = 0.d0
!
        select case (typema)
            case ('SE2')
                call elrfvf('SE2', pt, 8, basis, nno)
            case ('TRIA3')
                call elrfvf('TR6', pt, 8, basis, nno)
            case ('QUAD4')
                call elrfvf('QU4', pt, 8, basis, nno)
            case ('TETRA4')
                call elrfvf('TE4', pt, 8, basis, nno)
            case ('PYRAM5')
                call elrfvf('PY5', pt, 8, basis, nno)
            case ('PENTA6')
                call elrfvf('PE6', pt, 8, basis, nno)
            case ('HEXA8')
                call elrfvf('HE8', pt, 8, basis, nno)
            case default
                ASSERT(ASTER_FALSE)
        end select
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGeomDerivBasis(typema, pt, dbasis)
!
    implicit none
!
        character(len=8), intent(in)  :: typema
        real(kind=8), intent(in)      :: pt(3)
        real(kind=8), intent(out)     :: dbasis(3,8)
!
! ---------------------------------------------------------------------------------
!  HHO - geometrie
!  Compute the derivative of functions which descript the geometry
!
! In typema : type of element
! In pt     : coordinate of the point
! In dbasis  : evaluation of the derivative of basis at the point pt
! ---------------------------------------------------------------------------------
!
!
        integer :: nno, ndim
        dbasis = 0.d0
!
        select case (typema)
            case ('SE2')
                call elrfdf('SE2', pt, 24, dbasis, nno, ndim)
            case ('TRIA3')
                call elrfdf('TR3', pt, 24, dbasis, nno, ndim)
            case ('QUAD4')
                call elrfdf('QU4', pt, 24, dbasis, nno, ndim)
            case ('TETRA4')
                call elrfdf('TE4', pt, 24, dbasis, nno, ndim)
            case ('PYRAM5')
                call elrfdf('PY5', pt, 24, dbasis, nno, ndim)
            case ('HEXA8')
                call elrfdf('HE8', pt, 24, dbasis, nno, ndim)
            case default
                ASSERT(ASTER_FALSE)
        end select
!
    end subroutine
!
end module
