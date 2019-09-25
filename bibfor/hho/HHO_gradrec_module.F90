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
! person_in_charge: mickael.abbas at edf.fr
!
module HHO_gradrec_module
!
use HHO_type
use HHO_size_module
use HHO_quadrature_module
use HHO_basis_module
use HHO_utils_module
use HHO_massmat_module
use HHO_stiffmat_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/utmess.h"
#include "blas/daxpy.h"
#include "blas/dgemm.h"
#include "blas/dgemv.h"
#include "blas/dger.h"
#include "blas/dposv.h"
#include "blas/dsysv.h"
!
!---------------------------------------------------------------------------------------------------
!  HHO - gradient reconstruction
!
!  This module contains all the routines to compute the gradient reconstruction for HHO methods
!
!---------------------------------------------------------------------------------------------------
!
    public :: hhoGradRecVec, hhoGradRecMat, hhoGradRecFullVec, hhoGradRecFullMat, &
              & hhoGradRecSymFullMat, hhoGradRecSymMat, hhoGradRecFullMatFromVec
!    private ::
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGradRecVec(hhoCell, hhoData, gradrec, lhs)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Data), intent(in)          :: hhoData
        real(kind=8), intent(out)           :: gradrec(MSIZE_CELL_SCAL,MSIZE_TDOFS_SCAL)
        real(kind=8), optional, intent(out) :: lhs(MSIZE_TDOFS_SCAL,MSIZE_TDOFS_SCAL)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the gradient reconstruction of a scalar function
!   In hhoCell      : the current HHO Cell
!   In hhoData       : information on HHO methods
!   Out gradrec     : matrix of the gradient reconstruction
!   Out, option lhs : matrix (grad u, grad v) (lhs member for laplacian problem)
!
! --------------------------------------------------------------------------------------------------
! ----- Local variables
        type(HHO_Face)  :: hhoFace
        type(HHO_basis_cell) :: hhoBasisCell
        type(HHO_basis_face) :: hhoBasisFace
        type(HHO_quadrature)  :: hhoQuad
        real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_CELL_SCAL) :: stiffMat, MG
        real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_TDOFS_SCAL) :: BG
        real(kind=8), dimension(MSIZE_CELL_SCAL) :: CGradN
        real(kind=8), dimension(3,MSIZE_CELL_SCAL) :: BSCGradEval
        real(kind=8) :: BSCEval(MSIZE_CELL_SCAL), BSFEval(MSIZE_FACE_SCAL)
        integer :: ipg, dimStiffMat, ifromMG, itoMG, ifromBG, itoBG, dimMG
        integer :: cbs, fbs, total_dofs, iface, info, fromFace, toFace
!
! -- init cell basis
        call hhoBasisCell%initialize(hhoCell)
!
! -- number of dofs
        call hhoTherDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
!
! -- compute stiffness matrix
        dimStiffMat = hhoBasisCell%BSSize(0, hhoData%face_degree() + 1)
        call hhoStiffMatCellScal(hhoCell, 0, hhoData%face_degree() + 1, stiffMat)
!
! -- extract MG:  take basis functions derivatives from degree 1 to face_degree + 1
        dimMG = hhoBasisCell%BSSize(1, hhoData%face_degree() + 1)
        call hhoBasisCell%BSRange(1, hhoData%face_degree() + 1, ifromMG, itoMG)
!
        MG = 0.d0
        MG(1:dimMG, 1:dimMG) = stiffMat(ifromMG:itoMG, ifromMG:itoMG)
!
! -- RHS : volumetric part
        call hhoBasisCell%BSRange(0, hhoData%cell_degree(), ifromBG, itoBG)
!
        BG = 0.d0
        BG(1:dimMG, 1:cbs) = stiffMat(ifromMG:itoMG, ifromBG:itoBG)
!
        toFace = cbs
! -- Loop on the faces
        do iface = 1, hhoCell%nbfaces
            hhoFace = hhoCell%faces(iface)
            fromFace = toFace + 1
            toFace = fromFace + fbs - 1
!
            call hhoBasisFace%initialize(hhoFace)
! ----- get quadrature
            call hhoQuad%GetQuadFace(hhoface, hhoData%face_degree() + max(hhoData%face_degree(), &
                                    & hhoData%cell_degree()))
!
! ----- Loop on quadrature point
            do ipg = 1, hhoQuad%nbQuadPoints
! --------- Eval cell basis function at the quadrature point
                call hhoBasisCell%BSEval(hhoCell, hhoQuad%points(1:3,ipg), &
                                        & 0, hhoData%cell_degree(), BSCEval)
!
! --------- Eval face basis function at the quadrature point
                call hhoBasisFace%BSEval(hhoFace, hhoQuad%points(1:3,ipg), &
                                        & 0, hhoData%face_degree(), BSFEval)
!
! --------- Eval derivative of cell basis function at the quadrature point
                call hhoBasisCell%BSEvalGrad(hhoCell, hhoQuad%points(1:3,ipg), &
                                            & 1, hhoData%face_degree() + 1, BSCGradEval)
!
! --------  Compute grad *normal
                CGradN = 0.d0
                call dgemv('T', hhoCell%ndim, dimMG, hhoQuad%weights(ipg), BSCGradEval, 3, &
                      & hhoFace%normal, 1, 0.d0, CGradN, 1)
!
! --------  Compute (vF, grad *normal)
                call dger(dimMG, fbs, 1.d0, CGradN, 1, BSFEval, 1, BG(1:dimMG, fromFace:toFace), &
                            & dimMG)
!
! --------  Compute -(vT, grad *normal)
                call dger(dimMG, cbs, -1.d0, CGradN, 1, BSCEval, 1, BG, MSIZE_CELL_SCAL)
!
            end do
!
        end do
!
! - Solve the system gradrec =(MG)^-1 * BG
        gradrec = 0.d0
        gradrec(1:dimMG, 1:total_dofs) = BG(1:dimMG, 1:total_dofs)
!
! - Verif strange bug if info neq 0 in entry
        info = 0
        call dposv('U', dimMG, total_dofs, MG, MSIZE_CELL_SCAL, gradrec, MSIZE_CELL_SCAL, info)
!
! - Sucess ?
        if(info .ne. 0) then
            call utmess('F', 'HHO1_4')
        end if
!
        if(present(lhs)) then
            lhs = 0.d0
!
! ----- Compute lhs =BG**T * gradrec
            call dgemm('T', 'N', total_dofs, total_dofs, dimMG, 1.d0, BG, MSIZE_CELL_SCAL, &
                        & gradrec, MSIZE_CELL_SCAL, 0.d0, lhs, MSIZE_TDOFS_SCAL)
     end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGradRecMat(hhoCell, hhoData, gradrec, gradrec_scal, lhs)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Data), intent(in)          :: hhoData
        real(kind=8), intent(out)           :: gradrec(MSIZE_CELL_VEC,MSIZE_TDOFS_VEC)
        real(kind=8), intent(out)           :: gradrec_scal(MSIZE_CELL_SCAL,MSIZE_TDOFS_SCAL)
        real(kind=8), optional, intent(out) :: lhs(MSIZE_TDOFS_VEC,MSIZE_TDOFS_VEC)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the gradient reconstruction of a vectorial function
!   In hhoCell      : the current HHO Cell
!   In hhoData       : information on HHO methods
!   Out gradrec     : matrix of the gradient reconstruction
!   Out, option lhs : matrix (grad u, grad v) (lhs member for laplacian problem)
!   Out gradrec_scal: matrix of the gradient reconstruction for scalar problem
!
! --------------------------------------------------------------------------------------------------
! ----- Local variables
        type(HHO_basis_cell) :: hhoBasisCell
        real(kind=8), dimension(MSIZE_TDOFS_SCAL,MSIZE_TDOFS_SCAL) :: lhs_scal
        integer :: gradrec_scal_row, cbs_comp, fbs_comp, faces_dofs, cbs, fbs
        integer :: idim, ibeginGrad, iendGrad, jbeginCell, jendCell, jbeginFace, jendFace
        integer :: total_dofs, iFace, jbeginVec, jendVec
!
! -- number of dofs
        call hhoMecaDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
        faces_dofs = total_dofs - cbs
!
! -- init cell basis
        call hhoBasisCell%initialize(hhoCell)
! -- dimension of stiffnes matrix for scalar problem
        gradrec_scal_row = hhoBasisCell%BSSize(1,  hhoData%face_degree() + 1)
!
! -- computation of the gradient reconstruction of a scalar function
        if(present(lhs)) then
            call hhoGradRecVec(hhoCell, hhoData, gradrec_scal, lhs_scal)
        else
            call hhoGradRecVec(hhoCell, hhoData, gradrec_scal)
        end if
!
! -- copy the vectorial gradient in the matrix gradient
        cbs_comp = cbs / hhoCell%ndim
        fbs_comp = fbs / hhoCell%ndim
!
        gradrec = 0.d0
! the componants are ordered direction by direction
        do idim = 1, hhoCell%ndim
! ----- copy volumetric part
            ibeginGrad = (idim - 1) * gradrec_scal_row + 1
            iendGrad = ibeginGrad + gradrec_scal_row - 1
            jbeginCell = (idim - 1) * cbs_comp + 1
            jendCell = jbeginCell + cbs_comp - 1
!
            gradrec(ibeginGrad:iendGrad, jbeginCell:jendCell) &
                                        = gradrec_scal(1:gradrec_scal_row, 1:cbs_comp)
!
! ----- copy faces part
            do iFace = 1, hhoCell%nbfaces
                jbeginFace = cbs + (iFace - 1) * fbs + (idim - 1) * fbs_comp + 1
                jendFace = jbeginFace + fbs_comp - 1
                jbeginVec = cbs_comp + (iFace - 1) * fbs_comp + 1
                jendVec = jbeginVec + fbs_comp - 1
!
                gradrec(ibeginGrad:iendGrad, jbeginFace:jendFace) &
                                        = gradrec_scal(1:gradrec_scal_row, jbeginVec:jendVec)
            end do
!
        end do
!
        if(present(lhs)) then
            call MatScal2Vec(hhoCell, hhoData, lhs_scal, lhs)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGradRecFullVec(hhoCell, hhoData, gradrec, lhs)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Data), intent(in)          :: hhoData
        real(kind=8), intent(out)           :: gradrec(MSIZE_CELL_VEC,MSIZE_TDOFS_SCAL)
        real(kind=8), optional, intent(out) :: lhs(MSIZE_TDOFS_SCAL,MSIZE_TDOFS_SCAL)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the ful gradient reconstruction of a scalar function in P^k_d(T;R^d)
!   In hhoCell      : the current HHO Cell
!   In hhoData       : information on HHO methods
!   Out gradrec     : matrix of the gradient reconstruction
!   Out, option lhs : matrix (grad u, grad v) (lhs member for laplacian problem)
!
! --------------------------------------------------------------------------------------------------
! ----- Local variables
        type(HHO_Face)  :: hhoFace
        type(HHO_basis_cell) :: hhoBasisCell
        type(HHO_basis_face) :: hhoBasisFace
        type(HHO_quadrature)  :: hhoQuad, hhoQuadCell
        real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_CELL_SCAL) :: MassMat
        real(kind=8), dimension(MSIZE_CELL_VEC, MSIZE_TDOFS_SCAL) :: BG
        real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_CELL_SCAL) :: BGCELL
        real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_FACE_SCAL) :: BGFACE
        real(kind=8), dimension(MSIZE_CELL_SCAL, 3*MSIZE_TDOFS_SCAL) :: SOL
        real(kind=8), dimension(3,MSIZE_CELL_SCAL) :: BSCGradEval
        real(kind=8), dimension(MSIZE_CELL_SCAL) :: BSCEval, BSGEval, VecGrad
        real(kind=8), dimension(MSIZE_FACE_SCAL) :: BSFEval
        integer :: cbs, fbs, total_dofs, gbs, dimMassMat
        integer :: ipg, ibeginBG, iendBG, ibeginSOL, iendSOL, idim, info
        integer ::  iface, fromFace, toFace
!
! -- init cell basis
        call hhoBasisCell%initialize(hhoCell)
!
! -- number of dofs
        call hhoTherNLDofs(hhoCell, hhoData, cbs, fbs, total_dofs, gbs)
!
! -- compute mass matrix of P^k_d(T;R)
        dimMassMat = hhoBasisCell%BSSize(0, hhoData%grad_degree())
        call hhoMassMatCellScal(hhoCell, 0, hhoData%grad_degree(), MassMat)
!
        toFace = cbs
        BG = 0.d0
! -- Loop on the faces
        do iface = 1, hhoCell%nbfaces
            BGCELL = 0.d0
            BGFACE = 0.d0
            hhoFace = hhoCell%faces(iface)
            fromFace = toFace + 1
            toFace = fromFace + fbs - 1
!
            call hhoBasisFace%initialize(hhoFace)
! ----- get quadrature
            call hhoQuad%GetQuadFace(hhoface, hhoData%grad_degree() + max(hhoData%face_degree(), &
                                    & hhoData%cell_degree()))
!
! ----- Loop on quadrature point
            do ipg = 1, hhoQuad%nbQuadPoints
! --------- Eval cell basis function at the quadrature point
                call hhoBasisCell%BSEval(hhoCell, hhoQuad%points(1:3,ipg), &
                                        & 0, hhoData%cell_degree(), BSCEval)
!
! --------- Eval face basis function at the quadrature point
                call hhoBasisFace%BSEval(hhoFace, hhoQuad%points(1:3,ipg), &
                                        & 0, hhoData%face_degree(), BSFEval)
!
! --------- Eval grad cell basis function at the quadrature point
                call hhoBasisCell%BSEval(hhoCell, hhoQuad%points(1:3,ipg), &
                                        & 0, hhoData%grad_degree(), BSGEval)
!
! --------  Compute (vF, tau *normal)
                call dger(dimMassMat, fbs, hhoQuad%weights(ipg), BSGEval, 1, BSFEval, 1, &
                        & BGFACE, MSIZE_CELL_SCAL)
!
! --------  Compute -(vT, tau *normal)
                call dger(dimMassMat, cbs, -hhoQuad%weights(ipg), BSGEval, 1, BSCEval, 1, &
                        & BGCELL, MSIZE_CELL_SCAL)
!
            end do
!
! ----- copy by dimension
            do idim = 1, hhoCell%ndim
                ibeginBG = (idim - 1) * dimMassMat + 1
                iendBG = ibeginBG + dimMassMat - 1
!
                BG(ibeginBG:iendBG, 1:cbs) = BG(ibeginBG:iendBG, 1:cbs) + &
                                        & hhoFace%normal(idim) *  BGCELL(1:dimMassMat, 1:cbs)
!
                BG(ibeginBG:iendBG, fromFace:toFace) = BG(ibeginBG:iendBG, fromFace:toFace) + &
                                    & hhoFace%normal(idim) *  BGFACE(1:dimMassMat, 1:fbs)
!
            end do
!
        end do
!
! -- RHS : volumetric part
! -- get quadrature
        call hhoQuadCell%GetQuadCell(hhoCell, hhoData%grad_degree() + (hhoData%cell_degree()-1))
!
! - Loop on quadrature point
        do ipg = 1, hhoQuadCell%nbQuadPoints
! ----- Eval cell basis function at the quadrature point
            call hhoBasisCell%BSEval(hhoCell, hhoQuadCell%points(1:3,ipg), &
                                    & 0, hhoData%grad_degree(), BSGEval)
!
! ----- Eval derivative of cell basis function at the quadrature point
            call hhoBasisCell%BSEvalGrad(hhoCell, hhoQuadCell%points(1:3,ipg), &
                                        & 0, hhoData%cell_degree(), BSCGradEval)
!
! ------ Loop on the dimension
            do idim = 1, hhoCell%ndim
                ibeginBG = (idim - 1) * dimMassMat + 1
                iendBG = ibeginBG + dimMassMat - 1
!
                VecGrad(1:cbs) = reshape(BSCGradEval(idim, 1:cbs), (/cbs/))
! --------  Compute (grad(vT), tau)_T
                call dger(dimMassMat, cbs, hhoQuadCell%weights(ipg), BSGEval, 1, VecGrad, 1, &
                        & BG(ibeginBG:iendBG, 1:cbs), dimMassMat)
            end do
        end do
!
!
! - Solve the system gradrec =(MG)^-1 * BG
        SOL = 0.d0
        do idim = 1, hhoCell%ndim
            ibeginBG = (idim - 1) * dimMassMat + 1
            iendBG = ibeginBG + dimMassMat - 1
            ibeginSOL = (idim - 1) * total_dofs + 1
            iendSOL = ibeginSOL + total_dofs - 1
            SOL(1:dimMassMat, ibeginSOL:iendSOL) = BG(ibeginBG:iendBG, 1:total_dofs)
        end do
!
! - Verif strange bug if info neq 0 in entry
        info = 0
        call dposv('U', dimMassMat, hhoCell%ndim * total_dofs, MassMat, MSIZE_CELL_SCAL, &
                & SOL, MSIZE_CELL_SCAL, info)
!
! - Sucess ?
        if(info .ne. 0) then
            call utmess('F', 'HHO1_4')
        end if
!
! -- decompress solution
        gradrec = 0.d0
        do idim = 1, hhoCell%ndim
            ibeginBG = (idim - 1) * dimMassMat + 1
            iendBG = ibeginBG + dimMassMat - 1
            ibeginSOL = (idim - 1) * total_dofs + 1
            iendSOL = ibeginSOL + total_dofs - 1
            gradrec(ibeginBG:iendBG, 1:total_dofs) = SOL(1:dimMassMat, ibeginSOL:iendSOL)
        end do
!
        if(present(lhs)) then
            lhs = 0.d0
!
! ----- Compute lhs =BG**T * gradrec
            call dgemm('T', 'N', total_dofs, total_dofs, hhoCell%ndim * dimMassMat, 1.d0, &
                        & BG, MSIZE_CELL_VEC, gradrec, MSIZE_CELL_VEC, 0.d0, lhs, MSIZE_TDOFS_SCAL)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGradRecFullMatFromVec(hhoCell, hhoData, gradrecvec, gradrec, lhsvec, lhs)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Data), intent(in)          :: hhoData
        real(kind=8), intent(in)            :: gradrecvec(MSIZE_CELL_VEC,MSIZE_TDOFS_SCAL)
        real(kind=8), intent(out)           :: gradrec(MSIZE_CELL_MAT,MSIZE_TDOFS_VEC)
        real(kind=8), optional, intent(in)  :: lhsvec(MSIZE_TDOFS_SCAL,MSIZE_TDOFS_SCAL)
        real(kind=8), optional, intent(out) :: lhs(MSIZE_TDOFS_VEC,MSIZE_TDOFS_VEC)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the ful gradient reconstruction of a vectorial function in P^k_d(T;R^(dxd))
!   In hhoCell      : the current HHO Cell
!   In hhoDta       : information on HHO methods
!   In gradrecvec   : matrix of the gradient reconstruction (for vector)
!   Out gradrec     : matrix of the gradient reconstruction (for matrix)
!   Out, option lhsvec : matrix (grad u, grad v) (lhs member for laplacian problem) (for vector)
!   Out, option lhs : matrix (grad u, grad v) (lhs member for laplacian problem) (for matrix)
!
! --------------------------------------------------------------------------------------------------
! ----- Local variables
        integer :: cbs_comp, fbs_comp, faces_dofs, cbs, fbs
        integer :: idim, ibeginGrad, iendGrad, jbeginCell, jendCell, jbeginFace, jendFace
        integer :: total_dofs, gbs, gbs_comp, gbs_sym, iFace, jbeginVec, jendVec
!
! -- number of dofs
        call hhoMecaNLDofs(hhoCell, hhoData, cbs, fbs, total_dofs, gbs, gbs_sym)
        faces_dofs = total_dofs - cbs
!
! -- copy the vectorial gradient in the matrix gradient
        cbs_comp = cbs / hhoCell%ndim
        fbs_comp = fbs / hhoCell%ndim
        gbs_comp = gbs / hhoCell%ndim
!
! -- BE CAREFULL : the componant of the gradient are save in a row format
!
        gradrec = 0.d0
        do idim = 1, hhoCell%ndim
! ----- copy volumetric part
            ibeginGrad = (idim - 1) * gbs_comp + 1
            iendGrad = ibeginGrad + gbs_comp - 1
            jbeginCell = (idim - 1) * cbs_comp + 1
            jendCell = jbeginCell + cbs_comp - 1
!
            gradrec(ibeginGrad:iendGrad, jbeginCell:jendCell) = gradrecvec(1:gbs_comp, 1:cbs_comp)
!
! ----- copy faces part
            do iFace = 1, hhoCell%nbfaces
                jbeginFace = cbs + (iFace - 1) * fbs + (idim - 1) * fbs_comp + 1
                jendFace = jbeginFace + fbs_comp - 1
                jbeginVec = cbs_comp + (iFace - 1) * fbs_comp + 1
                jendVec = jbeginVec + fbs_comp - 1
!
                gradrec(ibeginGrad:iendGrad, jbeginFace:jendFace) &
                                                 = gradrecvec(1:gbs_comp, jbeginVec:jendVec)
            end do
!
        end do
!
        if(present(lhs)) then
            ASSERT(present(lhsvec))
            call MatScal2Vec(hhoCell, hhoData, lhsvec, lhs)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGradRecFullMat(hhoCell, hhoData, gradrec, lhs)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Data), intent(in)          :: hhoData
        real(kind=8), intent(out)           :: gradrec(MSIZE_CELL_MAT,MSIZE_TDOFS_VEC)
        real(kind=8), optional, intent(out) :: lhs(MSIZE_TDOFS_VEC,MSIZE_TDOFS_VEC)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the ful gradient reconstruction of a vectorial function in P^k_d(T;R^(dxd))
!   In hhoCell      : the current HHO Cell
!   In hhoDta       : information on HHO methods
!   Out gradrec     : matrix of the gradient reconstruction
!   Out, option lhs : matrix (grad u, grad v) (lhs member for laplacian problem)
!
! --------------------------------------------------------------------------------------------------
! ----- Local variables
        real(kind=8), dimension(MSIZE_TDOFS_SCAL,MSIZE_TDOFS_SCAL) :: lhs_scal
        real(kind=8), dimension(MSIZE_CELL_VEC,MSIZE_TDOFS_SCAL) :: gradrec_scal
!
! -- computation of the gradient reconstruction of a scalar function
        if(present(lhs)) then
            call hhoGradRecFullVec(hhoCell, hhoData, gradrec_scal, lhs_scal)
            call hhoGradRecFullMatFromVec(hhoCell, hhoData, gradrec_scal, gradrec,&
                                         & lhsvec = lhs_scal, lhs = lhs)
        else
            call hhoGradRecFullVec(hhoCell, hhoData, gradrec_scal)
            call hhoGradRecFullMatFromVec(hhoCell, hhoData, gradrec_scal, gradrec)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGradRecSymFullMat(hhoCell, hhoData, gradrec, lhs)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Data), intent(in)          :: hhoData
        real(kind=8), intent(out)           :: gradrec(MSIZE_CELL_MAT,MSIZE_TDOFS_VEC)
        real(kind=8), optional, intent(out) :: lhs(MSIZE_TDOFS_VEC,MSIZE_TDOFS_VEC)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the full symmetric gradient reconstruction of a vect function in P^k_d(T;R^(dxd)_sym)
!   In hhoCell      : the current HHO Cell
!   In hhoData       : information on HHO methods
!   Out gradrec     : matrix of the symmetric gradient reconstruction
!   Out, option lhs : matrix (grad_s u, grad_s v) (lhs member for the symmetric laplacian problem)
!
! --------------------------------------------------------------------------------------------------
! ----- Local variables
        type(HHO_Face)  :: hhoFace
        type(HHO_basis_cell) :: hhoBasisCell
        type(HHO_basis_face) :: hhoBasisFace
        type(HHO_quadrature)  :: hhoQuad, hhoQuadCell
        real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_CELL_SCAL) :: MassMat
        real(kind=8), dimension(6*MSIZE_CELL_SCAL, MSIZE_TDOFS_VEC) :: BG
        real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_CELL_SCAL) :: BGCELL
        real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_FACE_SCAL) :: BGFACE
        real(kind=8), dimension(MSIZE_CELL_SCAL, 6*MSIZE_TDOFS_VEC) :: SOL
        real(kind=8), dimension(6,MSIZE_CELL_VEC) :: BVCSGradEval
        real(kind=8) :: BSCEval(MSIZE_CELL_SCAL), BSFEval(MSIZE_FACE_SCAL), BSGEval(MSIZE_CELL_SCAL)
        real(kind=8), parameter :: rac2 = sqrt(2.d0)
        real(kind=8) :: coeff
        integer :: cbs, fbs, total_dofs, gbs, dimMassMat, nbdimMat, cbs_comp, fbs_comp, gbs_sym
        integer :: ipg, ibeginBG, iendBG, ibeginSOL, iendSOL, idim, info, j, iface
        integer :: jbegCell, jendCell, jbegFace, jendFace
!
! -- init cell basis
        call hhoBasisCell%initialize(hhoCell)
!
! -- number of independant direction of the gradient
        if(hhoCell%ndim == 2) then
            nbdimMat = 3
        else if(hhoCell%ndim == 3) then
            nbdimMat = 6
        else
            ASSERT(ASTER_FALSE)
        end if
!
! -- number of dofs
        call hhoMecaNLDofs(hhoCell, hhoData, cbs, fbs, total_dofs, gbs, gbs_sym)
!
        cbs_comp = cbs / hhoCell%ndim
        fbs_comp = fbs / hhoCell%ndim
!
! -- compute mass matrix of P^k_d(T;R)
        dimMassMat = hhoBasisCell%BSSize(0, hhoData%grad_degree())
        call hhoMassMatCellScal(hhoCell, 0, hhoData%grad_degree(), MassMat)
!
        BG = 0.d0
!
! -- RHS : volumetric part
! -- get quadrature
        call hhoQuadCell%GetQuadCell(hhoCell, hhoData%grad_degree() + (hhoData%cell_degree()-1))
!
! -- Loop on quadrature point
        do ipg = 1, hhoQuadCell%nbQuadPoints
! ----- Eval cell basis function at the quadrature point
            call hhoBasisCell%BSEval(hhoCell, hhoQuadCell%points(1:3,ipg), &
                                    & 0, hhoData%grad_degree(), BSGEval)
!
! ----- Eval symmetric derivative of cell basis function at the quadrature point
            call hhoBasisCell%BVEvalSymGrad(hhoCell, hhoQuadCell%points(1:3,ipg), &
                                            & 0, hhoData%cell_degree(), BVCSGradEval)
!
! ------ Loop on diagonal terms
            do idim = 1, hhoCell%ndim
                ibeginBG = (idim - 1) * dimMassMat + 1
!
                do j = 1, cbs
                    coeff = hhoQuadCell%weights(ipg) * BVCSGradEval(idim,j)
                    call daxpy(dimMassMat, coeff , BSGEval, 1, BG(ibeginBG,j), 1)
                end do
            end do
!
! ------ Loop on extra-diagonal terms
            if (hhoCell%ndim == 3) then
                do idim = 1, hhoCell%ndim
                    ibeginBG = (3+idim - 1) * dimMassMat + 1
!
                    do j = 1, cbs
                        coeff = hhoQuadCell%weights(ipg) * BVCSGradEval(3+idim,j)
                        call daxpy(dimMassMat, coeff , BSGEval, 1, BG(ibeginBG,j), 1)
                    end do
                end do
            else if (hhoCell%ndim == 2) then
                ibeginBG = (3 - 1) * dimMassMat + 1
!
                do j = 1, cbs
                    coeff = hhoQuadCell%weights(ipg) * BVCSGradEval(4,j)
                    call daxpy(dimMassMat, coeff , BSGEval, 1, BG(ibeginBG,j), 1)
                end do
            else
                ASSERT(ASTER_FALSE)
            end if
!
        end do
!
! -- Loop on the faces
        do iface = 1, hhoCell%nbfaces
            BGCELL = 0.d0
            BGFACE = 0.d0
            hhoFace = hhoCell%faces(iface)
!
            call hhoBasisFace%initialize(hhoFace)
! ----- get quadrature
            call hhoQuad%GetQuadFace(hhoface, hhoData%grad_degree() + max(hhoData%face_degree(), &
                                     hhoData%cell_degree()))
!
! ----- Loop on quadrature point
            do ipg = 1, hhoQuad%nbQuadPoints
! --------- Eval cell basis function at the quadrature point
                call hhoBasisCell%BSEval(hhoCell, hhoQuad%points(1:3,ipg), &
                                         0, hhoData%cell_degree(), BSCEval)
!
! --------- Eval face basis function at the quadrature point
                call hhoBasisFace%BSEval(hhoFace, hhoQuad%points(1:3,ipg), &
                                         0, hhoData%face_degree(), BSFEval)
!
! --------- Eval grad cell basis function at the quadrature point
                call hhoBasisCell%BSEval(hhoCell, hhoQuad%points(1:3,ipg), &
                                        & 0, hhoData%grad_degree(), BSGEval)
!
! --------  Compute (vF, tau *normal)
                call dger(dimMassMat, fbs_comp, hhoQuad%weights(ipg), BSGEval, 1, BSFEval, 1, &
                        & BGFACE, MSIZE_CELL_SCAL)
!
! --------  Compute -(vT, tau *normal)
                call dger(dimMassMat, cbs_comp, -hhoQuad%weights(ipg), BSGEval, 1, BSCEval, 1, &
                        & BGCELL, MSIZE_CELL_SCAL)
!
            end do
!
! ----- copy by dimension
! ----- diagonal composants
            do idim = 1, hhoCell%ndim
                ibeginBG = (idim - 1) * dimMassMat + 1
                iendBG = ibeginBG + dimMassMat - 1
                jbegCell = (idim - 1) * cbs_comp + 1
                jendCell = jbegCell + cbs_comp - 1
                jbegFace = cbs + (iface - 1) * fbs + (idim - 1) * fbs_comp + 1
                jendFace = jbegFace + fbs_comp - 1
!
                BG(ibeginBG:iendBG, jbegCell:jendCell) = BG(ibeginBG:iendBG, jbegCell:jendCell) + &
                                        & hhoFace%normal(idim) * BGCELL(1:dimMassMat, 1:cbs_comp)
!
                BG(ibeginBG:iendBG, jbegFace:jendFace) = BG(ibeginBG:iendBG, jbegFace:jendFace) + &
                                    & hhoFace%normal(idim) * BGFACE(1:dimMassMat, 1:fbs_comp)
            end do
!
            if(hhoCell%ndim == 2) then
! ------ extra diagonal composants term 12
                ibeginBG = 2 * dimMassMat + 1
                iendBG = ibeginBG + dimMassMat - 1
! ------ cell
                BG(ibeginBG:iendBG, 1:cbs_comp) = BG(ibeginBG:iendBG, 1:cbs_comp) + &
                                    & hhoFace%normal(2) / rac2 * BGCELL(1:dimMassMat, 1:cbs_comp)
!
                BG(ibeginBG:iendBG, (cbs_comp+1):cbs) = BG(ibeginBG:iendBG, (cbs_comp+1):cbs) + &
                                    & hhoFace%normal(1) / rac2 * BGCELL(1:dimMassMat, 1:cbs_comp)
! ------ face
                jbegFace = cbs + (iface - 1) * fbs + 1
                jendFace = jbegFace + fbs_comp - 1
                BG(ibeginBG:iendBG, jbegFace:jendFace) = BG(ibeginBG:iendBG, jbegFace:jendFace) + &
                                & hhoFace%normal(2) / rac2 * BGFACE(1:dimMassMat, 1:fbs_comp)
!
                jbegFace = jbegFace + fbs_comp
                jendFace = jbegFace + fbs_comp - 1
                BG(ibeginBG:iendBG, jbegFace:jendFace) = BG(ibeginBG:iendBG, jbegFace:jendFace) + &
                                & hhoFace%normal(1) / rac2 * BGFACE(1:dimMassMat, 1:fbs_comp)
!
            else if(hhoCell%ndim == 3) then
! ------ hors diagonal composants term 12
                ibeginBG = 3 * dimMassMat + 1
                iendBG = ibeginBG + dimMassMat - 1
! ------ cell
                jbegCell = 1
                jendCell = jbegCell + cbs_comp - 1
                BG(ibeginBG:iendBG, jbegCell:jendCell) = BG(ibeginBG:iendBG, jbegCell:jendCell) + &
                                    & hhoFace%normal(2) / rac2 * BGCELL(1:dimMassMat, 1:cbs_comp)
!
                jbegCell = cbs_comp + 1
                jendCell = jbegCell + cbs_comp - 1
                BG(ibeginBG:iendBG, jbegCell:jendCell) = BG(ibeginBG:iendBG, jbegCell:jendCell) + &
                                    & hhoFace%normal(1) / rac2 * BGCELL(1:dimMassMat, 1:cbs_comp)
! ------ face
                jbegFace = cbs + (iface - 1) * fbs  + 1
                jendFace = jbegFace + fbs_comp - 1
                BG(ibeginBG:iendBG, jbegFace:jendFace) = BG(ibeginBG:iendBG, jbegFace:jendFace) + &
                                & hhoFace%normal(2) / rac2 * BGFACE(1:dimMassMat, 1:fbs_comp)
!
                jbegFace = jbegFace + fbs_comp
                jendFace = jbegFace + fbs_comp - 1
                BG(ibeginBG:iendBG, jbegFace:jendFace) = BG(ibeginBG:iendBG, jbegFace:jendFace) + &
                                & hhoFace%normal(1) / rac2 * BGFACE(1:dimMassMat, 1:fbs_comp)
! ------ extra diagonal composants term 13
                ibeginBG = 4 * dimMassMat + 1
                iendBG = ibeginBG + dimMassMat - 1
! ------ cell
                jbegCell = 1
                jendCell = jbegCell + cbs_comp - 1
                BG(ibeginBG:iendBG, jbegCell:jendCell) = BG(ibeginBG:iendBG, jbegCell:jendCell) + &
                                    & hhoFace%normal(3) / rac2 * BGCELL(1:dimMassMat, 1:cbs_comp)
!
                jbegCell = 2 * cbs_comp + 1
                jendCell = jbegCell + cbs_comp - 1
                BG(ibeginBG:iendBG, jbegCell:jendCell) = BG(ibeginBG:iendBG, jbegCell:jendCell) + &
                                    & hhoFace%normal(1) / rac2 * BGCELL(1:dimMassMat, 1:cbs_comp)
! ------ face
                jbegFace = cbs + (iface - 1) * fbs  + 1
                jendFace = jbegFace + fbs_comp - 1
                BG(ibeginBG:iendBG, jbegFace:jendFace) = BG(ibeginBG:iendBG, jbegFace:jendFace) + &
                                & hhoFace%normal(3) / rac2 * BGFACE(1:dimMassMat, 1:fbs_comp)
!
                jbegFace = cbs + (iface - 1) * fbs + 1 + 2 * fbs_comp
                jendFace = jbegFace + fbs_comp - 1
                BG(ibeginBG:iendBG, jbegFace:jendFace) = BG(ibeginBG:iendBG, jbegFace:jendFace) + &
                                & hhoFace%normal(1) / rac2 * BGFACE(1:dimMassMat, 1:fbs_comp)
! ------ extra diagonal composants term 23
                ibeginBG = 5 * dimMassMat + 1
                iendBG = ibeginBG + dimMassMat - 1
! ------ cell
                jbegCell = cbs_comp + 1
                jendCell = jbegCell + cbs_comp - 1
                BG(ibeginBG:iendBG, jbegCell:jendCell) = BG(ibeginBG:iendBG, jbegCell:jendCell) + &
                                    & hhoFace%normal(3) / rac2 * BGCELL(1:dimMassMat, 1:cbs_comp)
!
                jbegCell = 2 * cbs_comp + 1
                jendCell = jbegCell + cbs_comp - 1
                BG(ibeginBG:iendBG, jbegCell:jendCell) = BG(ibeginBG:iendBG, jbegCell:jendCell) + &
                                    & hhoFace%normal(2) / rac2 * BGCELL(1:dimMassMat, 1:cbs_comp)
! ------ face
                jbegFace = cbs + (iface - 1) * fbs + 1 + fbs_comp
                jendFace = jbegFace + fbs_comp - 1
                BG(ibeginBG:iendBG, jbegFace:jendFace) = BG(ibeginBG:iendBG, jbegFace:jendFace) + &
                                & hhoFace%normal(3) / rac2 * BGFACE(1:dimMassMat, 1:fbs_comp)
!
                jbegFace = cbs + (iface - 1) * fbs + 1 + 2 * fbs_comp
                jendFace = jbegFace + fbs_comp - 1
                BG(ibeginBG:iendBG, jbegFace:jendFace) = BG(ibeginBG:iendBG, jbegFace:jendFace) + &
                                & hhoFace%normal(2) / rac2 * BGFACE(1:dimMassMat, 1:fbs_comp)
!
            else
                ASSERT(ASTER_FALSE)
            end if
!
        end do
!
! - Solve the system gradrec =(MG)^-1 * BG
        SOL = 0.d0
        do idim = 1, nbdimMat
            ibeginBG = (idim - 1) * dimMassMat + 1
            iendBG = ibeginBG + dimMassMat - 1
            ibeginSOL = (idim - 1) * total_dofs + 1
            iendSOL = ibeginSOL + total_dofs - 1
            SOL(1:dimMassMat, ibeginSOL:iendSOL) = BG(ibeginBG:iendBG, 1:total_dofs)
        end do
!
! - Verif strange bug if info neq 0 in entry
        info = 0
        call dposv('U', dimMassMat, nbdimMat * total_dofs, MassMat, MSIZE_CELL_SCAL, &
                & SOL, MSIZE_CELL_SCAL, info)
!
! - Sucess ?
        if(info .ne. 0) then
            call utmess('F', 'HHO1_4')
        end if
!
! -- decompress solution
        gradrec = 0.d0
        do idim = 1, nbdimMat
            ibeginBG = (idim - 1) * dimMassMat + 1
            iendBG = ibeginBG + dimMassMat - 1
            ibeginSOL = (idim - 1) * total_dofs + 1
            iendSOL = ibeginSOL + total_dofs - 1
            gradrec(ibeginBG:iendBG, 1:total_dofs) = SOL(1:dimMassMat, ibeginSOL:iendSOL)
        end do
!
        if(present(lhs)) then
            lhs = 0.d0
!
! ----- Compute lhs =BG**T * gradrec
            call dgemm('T', 'N', total_dofs, total_dofs, gbs_sym, 1.d0, BG, 6*MSIZE_CELL_SCAL, &
                        & gradrec, MSIZE_CELL_MAT, 0.d0, lhs, MSIZE_TDOFS_VEC)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGradRecSymMat(hhoCell, hhoData, gradrec, lhs)
!
    implicit none
!
        type(HHO_Cell), intent(in)          :: hhoCell
        type(HHO_Data), intent(in)          :: hhoData
        real(kind=8), intent(out)           :: gradrec(MSIZE_CELL_VEC,MSIZE_TDOFS_VEC)
        real(kind=8), optional, intent(out) :: lhs(MSIZE_TDOFS_VEC,MSIZE_TDOFS_VEC)
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the symmetric gradient reconstruction of a vectoriel function
!   In hhoCell      : the current HHO Cell
!   In hhoData      : information on HHO methods
!   Out gradrec     : matrix of the symmetric gradient reconstruction
!   Out, option lhs : matrix (grad_s u, grad_s v) (lhs member for symmetric laplacian problem)
!
! --------------------------------------------------------------------------------------------------
! ----- Local variables
        type(HHO_Face)  :: hhoFace
        type(HHO_basis_cell) :: hhoBasisCell
        type(HHO_basis_face) :: hhoBasisFace
        type(HHO_quadrature)  :: hhoQuad, hhoQuadCell
        real(kind=8), dimension(MSIZE_CELL_VEC, MSIZE_CELL_VEC) :: stiffMat
        real(kind=8), dimension(MSIZE_CELL_VEC + 3, MSIZE_CELL_VEC + 3) :: MG
        real(kind=8), dimension(MSIZE_CELL_VEC + 3, MSIZE_TDOFS_VEC) :: BG, gradrec2
        real(kind=8), dimension(MSIZE_CELL_VEC,3) :: CGradN
        real(kind=8), dimension(6,MSIZE_CELL_VEC) :: BVCGradEval
        real(kind=8), dimension(3,MSIZE_CELL_SCAL) :: BSCGradEval
        real(kind=8) :: BSCEval(MSIZE_CELL_SCAL), BSFEval(MSIZE_FACE_SCAL)
        integer, parameter :: LWORK = (MSIZE_CELL_VEC + 3) * MSIZE_TDOFS_VEC
        real(kind=8), dimension(LWORK):: WORK
        blas_int, dimension(MSIZE_CELL_VEC + 3) :: IPIV
        blas_int :: info
        integer :: ipg, dimStiffMat, ifromBG, itoBG, dimMG, nblag, dimMGLag, idir, idir2
        integer :: cbs, fbs, total_dofs, iface, i, cbs_comp, fbs_comp, dimMG_cmp, ind_MG
        integer :: jbeginCell, jendCell, jbeginFace, jendFace, idim, j, dimStiffMat_cmp
        integer :: row_deb_MG, row_fin_MG, col_deb_MG, col_fin_MG, col_deb_BG, col_fin_BG
        integer :: row_deb_ST, row_fin_ST, col_deb_ST, col_fin_ST
        real(kind=8) :: qp_dphi_ss
!
! -- init cell basis
        call hhoBasisCell%initialize(hhoCell)
!
! -- number of dofs
        call hhoMecaDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
        cbs_comp = cbs / hhoCell%ndim
        fbs_comp = fbs / hhoCell%ndim
!
! -- number of lagrange to impose skew symmetric part to zero
        nblag = 0
        if(hhoCell%ndim == 2) then
            nblag = 1
        else if(hhoCell%ndim == 3) then
            nblag = 3
        else
            ASSERT(ASTER_FALSE)
        end if
!
! -- compute stiffness matrix
        dimStiffMat = hhoBasisCell%BVSize(0,  hhoData%face_degree() + 1)
        dimStiffMat_cmp = dimStiffMat / hhoCell%ndim
        call hhoSymStiffMatCellVec(hhoCell, 0, hhoData%face_degree() + 1, stiffMat)
!
! -- extract MG:  take basis functions derivatives from degree 1 to face_degree + 1
        dimMG = hhoBasisCell%BVSize(1, hhoData%face_degree() + 1)
        dimMG_cmp = dimMG / hhoCell%ndim
        dimMGLag = dimMG + nblag
!
        MG = 0.d0
        BG = 0.d0
!
        do idir = 1, hhoCell%ndim
            row_deb_MG = (idir - 1) * dimMG_cmp + 1
            row_fin_MG = row_deb_MG + dimMG_cmp - 1
            row_deb_ST = (idir - 1) * dimStiffMat_cmp + 2
            row_fin_ST = row_deb_ST + dimMG_cmp - 1

            do idir2 = 1, hhoCell%ndim
                col_deb_MG = (idir2 - 1) * dimMG_cmp + 1
                col_fin_MG = col_deb_MG + dimMG_cmp - 1
                col_deb_ST = (idir2 - 1) * dimStiffMat_cmp + 2
                col_fin_ST = col_deb_ST + dimMG_cmp - 1
!
                MG(row_deb_MG:row_fin_MG, col_deb_MG:col_fin_MG) = &
                    & stiffMat(row_deb_ST:row_fin_ST, col_deb_ST:col_fin_ST)
!
                MG(col_deb_MG:col_fin_MG, row_deb_MG:row_fin_MG) = &
                    & stiffMat(col_deb_ST:col_fin_ST, row_deb_ST:row_fin_ST)
!
                col_deb_BG = (idir2 - 1) * cbs_comp + 1
                col_fin_BG = col_deb_BG + cbs_comp - 1
                col_deb_ST = (idir2 - 1) * dimStiffMat_cmp + 1
                col_fin_ST = col_deb_ST + cbs_comp - 1
!
                BG(row_deb_MG:row_fin_MG, col_deb_BG:col_fin_BG) = &
                    & stiffMat(row_deb_ST:row_fin_ST, col_deb_ST:col_fin_ST)
            end do
!
        end do
!
! -- impose lagrange multipliers
! -- get quadrature
        call hhoQuadCell%GetQuadCell(hhoCell, hhoData%face_degree() + 1)
!
! -- Loop on quadrature point
        do ipg = 1, hhoQuadCell%nbQuadPoints
!
! ----- Eval derivative of cell basis function at the quadrature point
            call hhoBasisCell%BSEvalGrad(hhoCell, hhoQuadCell%points(1:3,ipg), &
                                        & 1, hhoData%face_degree() + 1, BSCGradEval)
            do j = 1, dimMG_cmp
                if(hhoCell%ndim == 2) then
! ------------- lag1
! ------------- dir = 1
                    qp_dphi_ss = hhoQuadCell%weights(ipg) * BSCGradEval(2,j)
                    ind_MG = j
                    MG(ind_MG, dimMG + 1) = MG(ind_MG, dimMG + 1) + qp_dphi_ss
                    MG(dimMG + 1, ind_MG) = MG(dimMG + 1, ind_MG) + qp_dphi_ss
! ------------- dir = 2
                    qp_dphi_ss = -hhoQuadCell%weights(ipg) * BSCGradEval(1,j)
                    ind_MG = dimMG_cmp + j
                    MG(ind_MG, dimMG + 1) = MG(ind_MG, dimMG + 1) + qp_dphi_ss
                    MG(dimMG + 1, ind_MG) = MG(dimMG + 1, ind_MG) + qp_dphi_ss
                else if(hhoCell%ndim == 3) then
! ------------- lag1
! ------------- dir = 1
                    qp_dphi_ss = hhoQuadCell%weights(ipg) * BSCGradEval(2,j)
                    ind_MG = j
                    MG(ind_MG, dimMG + 1) = MG(ind_MG, dimMG + 1) + qp_dphi_ss
                    MG(dimMG + 1, ind_MG) = MG(dimMG + 1, ind_MG) + qp_dphi_ss
! ------------- dir = 2
                    qp_dphi_ss = -hhoQuadCell%weights(ipg) * BSCGradEval(1,j)
                    ind_MG = dimMG_cmp + j
                    MG(ind_MG, dimMG + 1) = MG(ind_MG, dimMG + 1) + qp_dphi_ss
                    MG(dimMG + 1, ind_MG) = MG(dimMG + 1, ind_MG) + qp_dphi_ss
! ------------- lag2
! ------------- dir = 1
                    qp_dphi_ss = hhoQuadCell%weights(ipg) * BSCGradEval(3,j)
                    ind_MG = j
                    MG(ind_MG, dimMG + 2) = MG(ind_MG, dimMG + 2) + qp_dphi_ss
                    MG(dimMG + 2, ind_MG) = MG(dimMG + 2, ind_MG) + qp_dphi_ss
! ------------- dir = 3
                    qp_dphi_ss = -hhoQuadCell%weights(ipg) * BSCGradEval(1,j)
                    ind_MG = 2*dimMG_cmp + j
                    MG(ind_MG, dimMG + 2) = MG(ind_MG, dimMG + 2) + qp_dphi_ss
                    MG(dimMG + 2, ind_MG) = MG(dimMG + 2, ind_MG) + qp_dphi_ss
! ------------- lag3
! ------------- dir = 2
                    qp_dphi_ss = hhoQuadCell%weights(ipg) * BSCGradEval(3,j)
                    ind_MG = dimMG_cmp + j
                    MG(ind_MG, dimMG + 3) = MG(ind_MG, dimMG + 3) + qp_dphi_ss
                    MG(dimMG + 3, ind_MG) = MG(dimMG + 3, ind_MG) + qp_dphi_ss
! ------------- dir = 3
                    qp_dphi_ss = -hhoQuadCell%weights(ipg) * BSCGradEval(2,j)
                    ind_MG = 2*dimMG_cmp + j
                    MG(ind_MG, dimMG + 3) = MG(ind_MG, dimMG + 3) + qp_dphi_ss
                    MG(dimMG + 3, ind_MG) = MG(dimMG + 3, ind_MG) + qp_dphi_ss
                else
                    ASSERT(ASTER_FALSE)
                end if
            end do
        end do
!
! -- RHS : volumetric part
        call hhoBasisCell%BVRange(0, hhoData%cell_degree(), ifromBG, itoBG)
!
! -- Loop on the faces
        do iface = 1, hhoCell%nbfaces
            hhoFace = hhoCell%faces(iface)
!
            call hhoBasisFace%initialize(hhoFace)
! ----- get quadrature
            call hhoQuad%GetQuadFace(hhoface, hhoData%face_degree() + max(hhoData%face_degree(), &
                                    & hhoData%cell_degree()))
!
! ----- Loop on quadrature point
            do ipg = 1, hhoQuad%nbQuadPoints
! --------- Eval cell basis function at the quadrature point
                call hhoBasisCell%BSEval(hhoCell, hhoQuad%points(1:3,ipg), &
                                        & 0, hhoData%cell_degree(), BSCEval)
!
! --------- Eval face basis function at the quadrature point
                call hhoBasisFace%BSEval(hhoFace, hhoQuad%points(1:3,ipg), &
                                        & 0, hhoData%face_degree(), BSFEval)
!
! --------- Eval symetric derivative of cell basis function at the quadrature point
                call hhoBasisCell%BVEvalSymGrad(hhoCell, hhoQuad%points(1:3,ipg), &
                                        & 1,  hhoData%face_degree() + 1, BVCGradEval)
!
! --------  Compute grad_s *normal
                CGradN = 0.d0
                do i = 1, dimMG
                    call hhoProdSmatVec(BVCGradEval(1:6,i), hhoFace%normal, hhoCell%ndim, &
                                        & CGradN(i,1:3))
                    CGradN(i,1:3) = hhoQuad%weights(ipg) * CGradN(i,1:3)
                end do
!
                do idim = 1, hhoCell%ndim
! ------------- Compute (vF, grad_s *normal)
                    jbeginFace = cbs + (idim - 1) * fbs_comp + (iface - 1) * fbs + 1
                    jendFace = jbeginFace + fbs_comp - 1
!
                    call dger(dimMG, fbs_comp, 1.d0, CGradN(1:dimMG,idim), 1, BSFEval, 1,&
                            BG(1:dimMG, jbeginFace:jendFace), dimMG)
!
! ------------  Compute -(vT, grad_s *normal)
                    jbeginCell = (idim - 1) * cbs_comp + 1
                    jendCell = jbeginCell + cbs_comp - 1
                    call dger(dimMG, cbs_comp, -1.d0, CGradN(1:dimMG,idim), 1, BSCEval, 1,&
                            BG(1:dimMG, jbeginCell:jendCell), dimMG)
                end do
!
            end do
!
        end do
!
! - Solve the system gradrec =(MG)^-1 * BG
        gradrec2 = 0.d0
        gradrec2(1:dimMGLag, 1:total_dofs) = BG(1:dimMGLag, 1:total_dofs)
!
! - Verif strange bug if info neq 0 in entry
        info = 0
        call dsysv('U', dimMGLag, total_dofs, MG, MSIZE_CELL_VEC+3, IPIV, gradrec2, &
                    MSIZE_CELL_VEC+3, WORK, LWORK, info)
!
! - Sucess ?
        if(info .ne. 0) then
            call utmess('F', 'HHO1_5')
        end if
!
        gradrec = 0.d0
        gradrec(1:dimMG, 1:total_dofs) = gradrec2(1:dimMG, 1:total_dofs)
!
        if(present(lhs)) then
            lhs = 0.d0
!
! ----- Compute lhs =BG**T * gradrec
            call dgemm('T', 'N', total_dofs, total_dofs, dimMG, 1.d0, BG, MSIZE_CELL_VEC+3, &
                    & gradrec, MSIZE_CELL_VEC, 0.d0, lhs, MSIZE_TDOFS_VEC)
        end if
!
    end subroutine
!
end module
