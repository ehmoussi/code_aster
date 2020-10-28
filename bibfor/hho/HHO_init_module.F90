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
module HHO_init_module
!
use HHO_type
use HHO_geometry_module
use HHO_measure_module
use HHO_quadrature_module
use HHO_basis_module
use HHO_utils_module
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/assert.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/infniv.h"
#include "asterfort/jelira.h"
#include "asterfort/jevech.h"
#include "asterfort/jeveuo.h"
#include "asterfort/lteatt.h"
#include "asterfort/teattr.h"
#include "asterfort/tecach.h"
#include "asterfort/tecael.h"
#include "asterfort/utmess.h"
#include "blas/dsyev.h"
#include "blas/dsyr.h"
#include "blas/dscal.h"
#include "blas/daxpy.h"
#include "jeveux.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO - generic
!
! generic routines to initialize data for HHO model
!
! --------------------------------------------------------------------------------------------------
!
!
    public :: hhoInfoInitCell, hhoInfoInitFace, hhoInitializeCellValues
    private :: hhoGeomData, hhoGeomFace, hhoDataInit, hhoFaceInit, hhoCellInit
    private :: hhoOrthoNormBasisFace, hhoL2ProdSFace
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoL2ProdSFace(hhoFace, hhoBasisFace, hhoQuad, ind_basis_i, degree_basis_i, &
                            ind_basis_j, degree_basis_j) result(L2ps)
!
    implicit none
!
        type(HHO_Face), intent(in)          :: hhoFace
        type(HHO_basis_face), intent(inout) :: hhoBasisFace
        type(HHO_quadrature), intent(in)    :: hhoQuad
        integer, intent(in)                 :: ind_basis_i, ind_basis_j
        integer, intent(in)                 :: degree_basis_i, degree_basis_j
        real(kind=8)                        :: L2ps
!
! --------------------------------------------------------------------------------------------------
!  HHO : Compute the L2-scalar product of two basis functions in a face
!
!  In HHO_Face           :: face HHO
!  IO hhoBasisFace       :: basis functions for face
!  In hhoQuad            :: Quadrature of order at least degree_basis_i + degree_basis_j
!  In ind_basis_i        :: indice of the basis i
!  In degree_basis_i     :: degree of the basis i
!  In ind_basis_j        :: indice of the basis j
!  In degree_basis_j     :: degree of the basis j
!  Out L2ps              :: L2-scalar product
! --------------------------------------------------------------------------------------------------

        integer :: ipg
        real(kind=8), dimension(MSIZE_FACE_SCAL) :: basisScalEval
! --------------------------------------------------------------------------------------------------
        L2ps = 0.d0
!
! ----- Loop on quadrature point
        do ipg = 1, hhoQuad%nbQuadPoints
! --------- Eval bais function at the quadrature point
            call hhoBasisFace%BSEval(hhoFace, hhoQuad%points(1:3,ipg), 0, &
                                     max(degree_basis_i, degree_basis_j), basisScalEval)
! --------  Eval
            L2ps = L2ps + hhoQuad%weights(ipg)*basisScalEval(ind_basis_i)*basisScalEval(ind_basis_j)
        end do
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoOrthoNormBasisFace(hhoFace, l_ortho)
!
    implicit none
!
        type(HHO_Face), intent(inout) :: hhoFace
        aster_logical, intent(in)     :: l_ortho
!
! --------------------------------------------------------------------------------------------------
!   Compute coefficient of the orthonormal basis of a face
!
!  In HHO_Face : face HHO
!  In l_ortho  : orthonoralize the basis function
!
! --------------------------------------------------------------------------------------------------
!
        type(HHO_basis_face) :: hhoBasisFace
        type(HHO_quadrature)  :: hhoQuad
        integer :: nb_basis, i_basis, j_basis_ortho, degree_i, degree_j, i_ortho
        real(kind=8) :: rij, rii, hs2
        integer, parameter :: nb_ortho = 1
! --------------------------------------------------------------------------------------------------
!
! ----- init basis
!
        call hhoBasisFace%initialize(hhoFace)
!
! ----- dimension of the basis
!
        nb_basis = hhoBasisFace%BSSize(0, hhoBasisFace%hhoMono%maxOrder())
!
! ----- Init the basis with scaled monomials
!
        hhoFace%coeff_ONB = 0.d0
        do i_basis = 1, nb_basis
            hhoFace%coeff_ONB(i_basis,i_basis) = 1.d0
        end do
!
! ----- Orthonormalize the basis (Algo Bassi 2012)
!
        if(l_ortho) then
            if(hhoFace%ndim == 1) then
                hs2 = sqrt(2.d0/hhoFace%diameter)
                ASSERT(hhoBasisFace%hhoMono%maxOrder() == 2)
!
! ----- Fill basis
!
                hhoFace%coeff_ONB(1,1) = sqrt(0.5d0) * hs2
                hhoFace%coeff_ONB(2,2) = sqrt(1.5d0) * hs2
                hhoFace%coeff_ONB(1,3) = -sqrt(5.d0/8.d0) * hs2
                hhoFace%coeff_ONB(3,3) = 3.d0 * sqrt(5.d0/8.d0) * hs2
!               hhoFace%coeff_ONB(2,4) = -1.5d0 * sqrt(7d0/2.d0) * hs2
!               hhoFace%coeff_ONB(4,4) =  2.5d0 * sqrt(7d0/2.d0) * hs2

            else
                call  hhoQuad%GetQuadFace(hhoFace, 2*hhoBasisFace%hhoMono%maxOrder())
                do i_ortho = 1, nb_ortho
                    do i_basis = 1, nb_basis
                        degree_i = hhoBasisFace%hhoMono%degree_mono(i_basis)
                        do j_basis_ortho = 1, i_basis - 1
                            degree_j = hhoBasisFace%hhoMono%degree_mono(j_basis_ortho)
!
! ---- Compute rij = (basis_i, basis_j)_F
!
                            rij = hhoL2ProdSFace(hhoFace, hhoBasisFace, hhoQuad, i_basis, degree_i,&
                                                j_basis_ortho, degree_j)
!
! ---- Update basis i: basis_i -= rij*basis_j
!
                            call daxpy(j_basis_ortho, - rij, hhoFace%coeff_ONB(1,j_basis_ortho), 1,&
                                      hhoFace%coeff_ONB(1,i_basis), 1)
                        end do
!
! ---- Compute rii = (basis_i, basis_i)_F
!
                        rii = sqrt(hhoL2ProdSFace(hhoFace, hhoBasisFace, hhoQuad, i_basis, &
                                   degree_i, i_basis, degree_i))
!
! ---- Update basis i: basis_i = basis_i/ rii
!
                        call dscal(i_basis, 1.d0/rii, hhoFace%coeff_ONB(1,i_basis), 1)
                    end do
                end do
            end if
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================

!
    subroutine hhoGeomData(nodes_coor, numnodes, nbnodes, typma, elem_dim)
!
    implicit none
!
        real(kind=8), dimension(3,27), intent(out)  :: nodes_coor
        integer, dimension(27), intent(out)         :: numnodes
        integer, intent(out)                        :: nbnodes
        character(len=8), intent(out)               :: typma
        integer, intent(out)                        :: elem_dim
!
! --------------------------------------------------------------------------------------------------
!
! HHO - generic tools
!
! Get geometric data of the current element
!
! --------------------------------------------------------------------------------------------------
!
! Out nodes_coor        : coordinates of the nodes
! Out numnodes          : global id of the nodes in the mesh
! Out nbnodes           : number of nodes
! Out typma             : type of the element
! Out elem_dim          : dimension of the element
! --------------------------------------------------------------------------------------------------
!
        aster_logical, parameter :: l_debug = ASTER_FALSE
        integer :: jv_geom, iadzi, iazk24
        integer :: inode, idim, iret
! --------------------------------------------------------------------------------------------------
!
! --- Init
        nodes_coor = 0.d0
        numnodes   = 0
        nbnodes    = 0
        typma      = ''
        elem_dim   = 0
!
        call teattr('S', 'TYPMA', typma, iret)
        ASSERT(iret == 0)
!
        if(typma(1:3) == 'H27') then
            typma = 'HEXA27'
            nbnodes = 27
            elem_dim = 3
        elseif(typma(1:3) == 'QU8') then
            typma = 'QUAD8'
            nbnodes = 8
            elem_dim = 2
        elseif(typma(1:3) == 'QU9') then
            typma = 'QUAD9'
            nbnodes = 9
            elem_dim = 2
        elseif(typma(1:3) == 'TR6') then
            typma = 'TRIA6'
            nbnodes = 6
            elem_dim = 2
        elseif(typma(1:3) == 'TR7') then
            typma = 'TRIA7'
            nbnodes = 7
            elem_dim = 2
        elseif(typma(1:3) == 'TE9') then
            typma = 'TETRA9'
            nbnodes = 9
            elem_dim = 3
        else
            ASSERT(ASTER_FALSE)
        end if
!
        ASSERT((nbnodes .ge. 4) .and. (nbnodes .le. 27))
        ASSERT((elem_dim .eq. 2) .or. (elem_dim .eq. 3))
!
        call jevech('PGEOMER', 'L', jv_geom)
!
! --- Get coordinates
!
        do inode = 1, nbnodes
            do idim = 1, elem_dim
                nodes_coor(idim, inode) = zr(jv_geom+(inode-1)*elem_dim+idim-1)
            end do
        end do
!
! --- Get global id
!
        call tecael(iadzi, iazk24, 0)
        ASSERT(zi(iadzi - 1 + 2) == nbnodes)
!
        do inode = 1, nbnodes
            numnodes(inode) = zi(iadzi - 1 + 2 + inode)
        end do
!
        if(l_debug) then
            write(6,*) "hhoGeomData debug"
            write(6,*) "typma: ", typma
            write(6,*) "nbnodes: ", nbnodes
            do inode = 1, nbnodes
                write(6,*) "node ", inode, ": ", nodes_coor(1:3,inode)
            end do
            write(6,*) "end hhoGeomData debug"
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGeomFace(nodes_coor, numnodes, nbnodes, typma, elem_dim)
!
    implicit none
!
        real(kind=8), dimension(3,9), intent(out)   :: nodes_coor
        integer, dimension(9), intent(out)          :: numnodes
        integer, intent(out)                        :: nbnodes
        character(len=8), intent(out)               :: typma
        integer, intent(out)                        :: elem_dim
!
! --------------------------------------------------------------------------------------------------
!
! HHO - generic tools
!
! Get geometric data of the current element
!
! --------------------------------------------------------------------------------------------------
!
! Out nodes_coor        : coordinates of the nodes
! Out nbnodes           : number of nodes
! Out typma             : type of the element
! Out elem_dim          : dimension of the element
! --------------------------------------------------------------------------------------------------
!
        aster_logical, parameter :: l_debug = ASTER_FALSE
        integer :: jv_geom
        integer :: inode, idim, iret, iadzi, iazk24
!
! --- Init
        nodes_coor = 0.d0
        numnodes   = 0
        nbnodes    = 0
        typma      = ''
        elem_dim   = 0
!
        call teattr('S', 'TYPMA', typma, iret)
        ASSERT(iret == 0)
!
        if(typma(1:3) == 'QU9') then
            typma = 'QUAD4'
            nbnodes = 4
            elem_dim = 2
        elseif(typma(1:3) == 'TR4') then
            typma = 'TRIA3'
            nbnodes = 3
            elem_dim = 2
        elseif(typma(1:3) == 'SE3') then
            typma = 'SEG2'
            nbnodes = 2
            elem_dim = 1
        else
            ASSERT(ASTER_FALSE)
        end if
!
        ASSERT((nbnodes .ge. 2) .and. (nbnodes .le. 9))
        ASSERT((elem_dim .eq. 1) .or. (elem_dim .eq. 2))
!
        call jevech('PGEOMER', 'L', jv_geom)
!
! - Get coordinates
!
        do inode = 1, nbnodes
            do idim = 1, elem_dim + 1
                nodes_coor(idim, inode) = zr(jv_geom+(inode-1)*(elem_dim+1)+idim-1)
            end do
        end do
!
! --- Get global id
!
        call tecael(iadzi, iazk24, 0)
        ASSERT(zi(iadzi - 1 + 2) >= nbnodes)
!
        do inode = 1, nbnodes
            numnodes(inode) = zi(iadzi - 1 + 2 + inode)
        end do
!
        if(l_debug) then
            write(6,*) "hhoGeomFace debug"
            write(6,*) "typma: ", typma
            write(6,*) "nbnodes: ", nbnodes
            do inode = 1, nbnodes
                write(6,*) "node ", inode, ": ", nodes_coor(1:3,inode)
            end do
            write(6,*) "end hhoGeomFace debug"
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoFaceInit(hhoFace, typma, ndim, nbnodes, nodes_coor, numnodes, l_ortho, &
                           barycenter_cell)
!
    implicit none
!
        character(len=8), intent(in)                    :: typma
        integer, intent(in)                             :: ndim
        real(kind=8), dimension(3,4), intent(in)        :: nodes_coor
        integer, dimension(4), intent(in)               :: numnodes
        integer, intent(in)                             :: nbnodes
        real(kind=8), dimension(3), optional, intent(in):: barycenter_cell
        aster_logical, intent(in)                       :: l_ortho
        type(HHO_Face), intent(out)                     :: hhoFace
!
! --------------------------------------------------------------------------------------------------
!
! HHO - generic tools
!
! Initialize a HHO Face
!
! --------------------------------------------------------------------------------------------------
!
! In typma              : type of element
! In ndim               : dimension of the element
! In nodes_coor         : coordinates of nodes
! In nbnodes            : number of nodes
! In numnodes           : global id of the nodes in the mesh
! In l_ortho            : orthonoralize the basis function
! In barycenter_cell    : barycenter of the cell
! Out hhoFace           : a HHO Face
! --------------------------------------------------------------------------------------------------
!
        ASSERT(nbnodes .le. 4)
!
! --- Init: be carefull the order to call the functions is important
!
        hhoFace%typema      = typma
        hhoFace%nbnodes     = nbnodes
        hhoFace%ndim        = ndim
        hhoFace%coorno      = hhoFaceInitCoor(nodes_coor, numnodes, nbnodes, ndim)
        hhoFace%barycenter  = barycenter(hhoFace%coorno, hhoFace%nbnodes)
        if(present(barycenter_cell)) then
            hhoFace%normal  = hhoNormalFace(hhoFace, barycenter_cell)
        else
            hhoFace%normal  = hhoNormalFace2(typma, nodes_coor)
        end if
        hhoFace%measure     = hhoMeasureFace(hhoFace)
        hhoFace%diameter    = hhoDiameterFace(hhoFace)
        hhoFace%local_basis = hhoLocalBasisFace(hhoFace)

        call hhoOrthoNormBasisFace(hhoFace, l_ortho)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoCellInit(typma, nodes_coor, numnodes, l_ortho, hhoCell)
!
    implicit none
!
        character(len=8), intent(in)                :: typma
        real(kind=8), dimension(3,27), intent(in)   :: nodes_coor
        integer, dimension(27), intent(in)          :: numnodes
        aster_logical, intent(in)                   :: l_ortho
        type(HHO_Cell), intent(out)                 :: hhoCell
!
! --------------------------------------------------------------------------------------------------
!
! HHO - generic tools
!
! Initialize a HHO cell
!
! --------------------------------------------------------------------------------------------------
!
! In typma              : type of element
! In nodes_coor         : coordinates of nodes
! In l_ortho            : orthonoralize the basis function
! Out hhoCell           : a HHO cell
! --------------------------------------------------------------------------------------------------
!
        aster_logical, parameter :: l_debug = ASTER_FALSE
        integer, parameter                      :: max_faces = 6
        integer, parameter                      :: max_nodes = 4
        integer, dimension(max_nodes,max_faces) :: nodes_faces
        integer, dimension(max_faces)           :: nbnodes_faces
        character(len=8), dimension(max_faces)  :: type_faces
        real(kind=8), dimension(3,max_nodes)    :: coor_face
        integer, dimension(max_nodes)           :: numnodes_face
        integer :: i_face, i_node
! --------------------------------------------------------------------------------------------------
! --- Init
        nodes_faces = 0
        nbnodes_faces = 0
        type_faces = ' '
        coor_face = 0.d0
        numnodes_face = 0
!
        if(typma(1:6) == 'HEXA27') then
            hhoCell%typema = 'HEXA8'
            hhoCell%nbnodes = 8
            hhoCell%ndim = 3
            hhoCell%nbfaces = 6
!
! ----- !!!! Attention l'ordre des faces doit etre le meme que celui du catalogue
! ----- Face 1
            nodes_faces(1:4,1) = (/1, 4, 3, 2/)
            nbnodes_faces(1) = 4
            type_faces(1) = 'QUAD4'
! ----- Face 2
            nodes_faces(1:4,2) = (/1, 2, 6, 5/)
            nbnodes_faces(2) = 4
            type_faces(2) = 'QUAD4'
! ----- Face 3
            nodes_faces(1:4,3) = (/2, 3, 7, 6/)
            nbnodes_faces(3) = 4
            type_faces(3) = 'QUAD4'
! ----- Face 4
            nodes_faces(1:4,4) = (/3, 4, 8, 7/)
            nbnodes_faces(4) = 4
            type_faces(4) = 'QUAD4'
! ----- Face 5
            nodes_faces(1:4,5) = (/4, 1, 5, 8/)
            nbnodes_faces(5) = 4
            type_faces(5) = 'QUAD4'
! ----- Face 6
            nodes_faces(1:4,6) = (/5, 6, 7, 8/)
            nbnodes_faces(6) = 4
            type_faces(6) = 'QUAD4'
!
        else if(typma(1:6) == 'TETRA9') then
            hhoCell%typema = 'TETRA4'
            hhoCell%nbnodes = 4
            hhoCell%ndim = 3
            hhoCell%nbfaces = 4
!
! ----- !!!! Attention l'ordre des faces doit etre le meme que celui du catalogue
! ----- Face 1
            nodes_faces(1:3,1) = (/1, 2, 3/)
            nbnodes_faces(1) = 3
            type_faces(1) = 'TRIA3'
! ----- Face 2
            nodes_faces(1:3,2) = (/1, 2, 4/)
            nbnodes_faces(2) = 3
            type_faces(2) = 'TRIA3'
! ----- Face 3
            nodes_faces(1:3,3) = (/1, 3, 4/)
            nbnodes_faces(3) = 3
            type_faces(3) = 'TRIA3'
! ----- Face 4
            nodes_faces(1:3,4) = (/2, 3, 4/)
            nbnodes_faces(4) = 3
            type_faces(4) = 'TRIA3'
!
        else if(typma(1:5) == 'QUAD8' .or. typma(1:5) == 'QUAD9') then
            hhoCell%typema = 'QUAD4'
            hhoCell%nbnodes = 4
            hhoCell%ndim = 2
            hhoCell%nbfaces = 4
!
! ----- !!!! Attention l'ordre des faces doit etre le meme que celui du catalogue
! ----- Face 1
            nodes_faces(1:2,1) = (/1, 2/)
            nbnodes_faces(1) = 2
            type_faces(1) = 'SEG2'
! ----- Face 2
            nodes_faces(1:2,2) = (/2, 3/)
            nbnodes_faces(2) = 2
            type_faces(2) = 'SEG2'
! ----- Face 3
            nodes_faces(1:2,3) = (/3, 4/)
            nbnodes_faces(3) = 2
            type_faces(3) = 'SEG2'
! ----- Face 4
            nodes_faces(1:2,4) = (/4, 1/)
            nbnodes_faces(4) = 2
            type_faces(4) = 'SEG2'
!
        else if(typma(1:5) == 'TRIA6' .or. typma(1:5) == 'TRIA7') then
            hhoCell%typema = 'TRIA3'
            hhoCell%nbnodes = 3
            hhoCell%ndim = 2
            hhoCell%nbfaces = 3
!
! ----- !!!! Attention l'ordre des faces doit etre le meme que celui du catalogue
! ----- Face 1
            nodes_faces(1:2,1) = (/1, 2/)
            nbnodes_faces(1) = 2
            type_faces(1) = 'SEG2'
! ----- Face 2
            nodes_faces(1:2,2) = (/2, 3/)
            nbnodes_faces(2) = 2
            type_faces(2) = 'SEG2'
! ----- Face 3
            nodes_faces(1:2,3) = (/3, 1/)
            nbnodes_faces(3) = 2
            type_faces(3) = 'SEG2'
!
        else
            ASSERT(ASTER_FALSE)
        end if
!
! ----- Copy coordinates
        hhoCell%coorno     = nodes_coor
        hhoCell%barycenter = barycenter(hhoCell%coorno, hhoCell%nbnodes)
        hhoCell%measure    = hhoMeasureCell(hhoCell)
        hhoCell%diameter   = hhoDiameterCell(hhoCell)
!
        hhoCell%length_box = hhoLengthBoundingBoxCell(hhoCell)
!
! ----- Init faces
!
            do i_face = 1, hhoCell%nbfaces
                coor_face = 0.d0
                do i_node = 1, nbnodes_faces(i_face)
                    coor_face(1:3, i_node) = hhoCell%coorno(1:3, nodes_faces(i_node, i_face))
                    numnodes_face(i_node)  = numnodes(nodes_faces(i_node, i_face))
                end do
                call hhoFaceInit(hhoCell%faces(i_face), type_faces(i_face), hhoCell%ndim-1, &
                                nbnodes_faces(i_face), coor_face, numnodes_face, l_ortho, &
                                hhoCell%barycenter)
            end do
!
        if(l_debug) then
            call hhoCell%print()
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoDataInit(hhoData)
!
    implicit none
!
        type(HHO_Data), intent(out)            :: hhoData
!
! --------------------------------------------------------------------------------------------------
!
! HHO
!
! Get hho data on the modelisation
!
! --------------------------------------------------------------------------------------------------
!
! Out hhoData  :: information on the modelisation
! --------------------------------------------------------------------------------------------------
!
        aster_logical, parameter :: l_debug = ASTER_FALSE
        aster_logical :: l_stab, l_precalc, l_adapt_coeff
        integer :: grad_deg, face_deg, cell_deg
        integer :: jv_carcri, jtab(1), iret
        real(kind=8) :: coef_stab
!
! --- Read Parameters
!
        ASSERT(lteatt('TYPMOD2','HHO'))
        if (lteatt('FORMULATION','HHO_LINE')) then
            face_deg = 1
            cell_deg = 2
            grad_deg = 1
        elseif (lteatt('FORMULATION','HHO_QUAD')) then
            face_deg = 2
            cell_deg = 2
            grad_deg = 2
        else
            ASSERT(ASTER_FALSE)
        endif
!
! --- Get coefficient (if possible)
!
        coef_stab = 111.d0
        iret = -1
        l_precalc  = ASTER_FALSE
        l_adapt_coeff = ASTER_TRUE
        l_stab = ASTER_TRUE
        call tecach('NNN', 'PCARCRI', 'L', iret, nval=1, itab=jtab)
        if (iret .eq. 0) then
            call jevech('PCARCRI','L', jv_carcri)
            if(int(zr(jv_carcri-1+HHO_CALC)) == HHO_CALC_YES) then
                l_precalc = ASTER_TRUE
            elseif(int(zr(jv_carcri-1+HHO_CALC)) == HHO_CALC_NO) then
                l_precalc = ASTER_FALSE
            else
                ASSERT(ASTER_FALSE)
            end if
!
            if(int(zr(jv_carcri-1+HHO_STAB)) == HHO_STAB_AUTO) then
                l_adapt_coeff = ASTER_TRUE
            elseif(int(zr(jv_carcri-1+HHO_STAB)) == HHO_STAB_MANU) then
                l_adapt_coeff = ASTER_FALSE
            else
                ASSERT(ASTER_FALSE)
            end if
        endif
!
! --- Init
!
        call hhoData%initialize(face_deg, cell_deg, grad_deg, l_stab, coef_stab, l_debug, &
                                l_precalc, l_adapt_coeff)
!
        if(hhoData%grad_degree() == hhoData%face_degree()) then
            ASSERT(l_stab)
        end if
!
        if(hhoData%debug()) then
            call hhoData%print()
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoInfoInitCell(hhoCell, hhoData, npg, hhoQuad, l_ortho_)
!
    implicit none
!
        type(HHO_Cell), intent(out)                 :: hhoCell
        type(HHO_Data), intent(out)                 :: hhoData
        integer, intent(in), optional               :: npg
        type(HHO_Quadrature), optional, intent(out) :: hhoQuad
        aster_logical, optional, intent(in)         :: l_ortho_

!
! --------------------------------------------------------------------------------------------------
!
! HHO
!
! Get hho data on the modelisation
!
! --------------------------------------------------------------------------------------------------
!
!   Initialize information for a HHO cell
!   Out hhoCell  : the current HHO Cell
!   Out hhoData  : information on HHO methods
!   Out hhoQuad  : Quadrature for the cell
!   In npg (optional)      : number of quadrature point for the face
!   In l_ortho (optional)  : orthonoralize the basis function
! --------------------------------------------------------------------------------------------------
!
        integer :: numnodes(27), nbnodes, elem_dim
        character(len=8) :: typma
        real(kind=8) :: coor(3,27)
        aster_logical :: l_ortho
!
        coor = 0.d0
        l_ortho = ASTER_TRUE
        if(present(l_ortho_)) then
            l_ortho = l_ortho_
        end if
!
! --- Get HHO informations
!
        call hhoGeomData(coor, numnodes, nbnodes, typma, elem_dim)
        call hhoDataInit(hhoData)
!
! --- Initialize HHO Cell
        call hhoCellInit(typma, coor, numnodes, ASTER_FALSE, hhoCell)
!
! --- Get quadrature (optional)
!
        if(present(hhoQuad)) then
            if(present(npg))then
                call hhoQuad%initCell(hhoCell, npg)
            else
                call hhoQuad%GetQuadCell(hhoCell, 2 * hhoData%cell_degree())
            end if
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoInfoInitFace(hhoFace, hhoData, npg, hhoQuadFace)
!
    implicit none
!
        type(HHO_Face), intent(out)   :: hhoFace
        type(HHO_Data), intent(out)   :: hhoData
        integer, intent(in), optional :: npg
        type(HHO_Quadrature), intent(out), optional :: hhoQuadFace
!
! --------------------------------------------------------------------------------------------------
!
! HHO - generic tool
!
! Get hho info on the modelisation and initialize
!
! --------------------------------------------------------------------------------------------------
!
!   Initialize information for surfacique load
!   Out hhoFace  : the current HHO Face
!   Out hhoData  : information on HHO methods
!   Out hhoQuad  : Quadrature for the face
!   In npg (optional)      : number of quadrature point for the face
! --------------------------------------------------------------------------------------------------
!
        integer :: nbnodes, elem_dim, numnodes(9)
        real(kind=8) :: nodes_coor(3,9)
        character(len=8) :: typma
!
! --- Get HHO informations
!
        call hhoGeomFace(nodes_coor, numnodes, nbnodes, typma, elem_dim)
        ASSERT(elem_dim == 1 .or. elem_dim == 2)
        call hhoDataInit(hhoData)
!
! --- Initialize HHO Face
!
        call hhoFaceInit(hhoFace, typma, elem_dim, nbnodes, nodes_coor, numnodes(1:4), ASTER_FALSE)
!
! --- Get quadrature (optional)
!
        if(present(hhoQuadFace)) then
            if(present(npg)) then
                call hhoQuadFace%initFace(hhoFace, npg)
            else
                call hhoQuadFace%GetQuadFace(hhoFace, 2 * hhoData%face_degree())
            end if
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoInitializeCellValues(field, value)
!
    implicit none
!
        character(len=19), intent(in) :: field
        real(kind=8), intent(in)      :: value
!
! --------------------------------------------------------------------------------------------------
!
! HHO - Non-linear mechanics
!
! Initialize cell values (Newton algorithm)
!
! --------------------------------------------------------------------------------------------------
!
! In  field         : fields
! In  val           : value to initialize
!
! --------------------------------------------------------------------------------------------------
!
        integer :: ifm, niv
        integer :: nb_comp, jvale, i
        character(len=4) :: scal
!
! --------------------------------------------------------------------------------------------------
!
        call infniv(ifm, niv)
        if (niv .ge. 2) then
            call utmess('I', 'HHO2_18')
        endif
!
! --- Update the cell field
!
        call jelira(field//'.CELV', 'TYPE', cval=scal)
        ASSERT(scal(1:1) .eq. 'R')
        call jelira(field//'.CELV', 'LONMAX', nb_comp)
        call jeveuo(field//'.CELV', 'E', jvale)
!
        do i = 1, nb_comp
            zr(jvale-1+i) = value
        end do
!
    end subroutine
!
end module
