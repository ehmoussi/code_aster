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
module HHO_stabilization_module
!
use HHO_basis_module
use HHO_massmat_module
use HHO_quadrature_module
use HHO_size_module
use HHO_tracemat_module
use HHO_type
use HHO_utils_module
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/utmess.h"
#include "blas/dgemm.h"
#include "blas/dposv.h"
#include "blas/dpotrf.h"
#include "blas/dpotrs.h"
!
!---------------------------------------------------------------------------------------------------
!  HHO - stabilization
!
!  This module contains all the routines to compute the stabilzation operator for HHO methods
!
!---------------------------------------------------------------------------------------------------
!
    public :: hhoStabScal, hhoStabVec, hdgStabScal, hdgStabVec, hhoStabSymVec, MatScal2Vec
!    private ::
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoStabScal(hhoCell, hhoData, gradrec, stab)
!
    implicit none
!
        type(HHO_Cell), intent(in)  :: hhoCell
        type(HHO_Data), intent(in)  :: hhoData
        real(kind=8), intent(in)    :: gradrec(MSIZE_CELL_SCAL,MSIZE_TDOFS_SCAL)
        real(kind=8), intent(out)   :: stab(MSIZE_TDOFS_SCAL,MSIZE_TDOFS_SCAL)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the hho stabilization of a scalar function
!   In hhoCell      : the current HHO Cell
!   In hhoData       : information on HHO methods
!   In gradrec      : matrix of the gradient reconstruction
!   Out stab        : matrix of stabilization (lhs member for laplacian problem)
!
! --------------------------------------------------------------------------------------------------
!
        type(HHO_Face)  :: hhoFace
        type(HHO_basis_cell) :: hhoBasisCell
        real(kind=8) :: invH
        real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_CELL_SCAL) :: massMat, M1 = 0.d0, M2 = 0.d0
        real(kind=8), dimension(MSIZE_FACE_SCAL, MSIZE_FACE_SCAL) :: faceMass, piKF
        real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_TDOFS_SCAL) :: proj1 = 0.d0
        real(kind=8), dimension(MSIZE_FACE_SCAL, MSIZE_CELL_SCAL) :: MR1, MR2, traceMat
        real(kind=8), dimension(MSIZE_FACE_SCAL, MSIZE_TDOFS_SCAL) :: proj2, proj3, TMP
        integer :: dimMassMat = 0, ifromM1, itoM1, ifromM2, itoM2, dimM1, colsM2, i, j
        integer :: cbs, fbs, total_dofs, iface, offset_face, info, fromFace, toFace
! --------------------------------------------------------------------------------------------------
!
! -- init cell basis
        call hhoBasisCell%initialize(hhoCell)
!
! -- number of dofs
        call hhoTherDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
!
! -- compute cell mass matrix
        dimMassMat = hhoBasisCell%BSSize(0, hhoData%face_degree() + 1)
        call hhoMassMatCellScal(hhoCell, 0, hhoData%face_degree() + 1, massMat)
!
! -- Range
        call hhoBasisCell%BSRange(0, hhoData%cell_degree(), ifromM1, itoM1)
        dimM1 = hhoBasisCell%BSSize(0, hhoData%cell_degree())
        call hhoBasisCell%BSRange(1, hhoData%face_degree() + 1, ifromM2, itoM2)
        colsM2 = hhoBasisCell%BSSize(1, hhoData%face_degree() + 1)
!
! -- extract M1:
        M1(1:dimM1, 1:dimM1) = massMat(ifromM1:itoM1, ifromM1:itoM1)
!
! -- extract M2:
        M2(1:dimM1, 1:colsM2) = massMat(ifromM1:itoM1, ifromM2:itoM2)
!
! -- Verif size
        ASSERT(MSIZE_CELL_SCAL >= colsM2 .and. MSIZE_TDOFS_SCAL >= dimM1)
!
        stab = 0.d0
!
! -- Build \pi_F^k (v_F - P_T^K v) equations (21) and (22)
! -- compute proj1: Step 1: compute \pi_T^k p_T^k v (third term).
!
! -- Compute proj1 = -M2 * gradrec
        call dgemm('N', 'N', dimM1, total_dofs, colsM2, -1.d0, M2, MSIZE_CELL_SCAL, &
                 & gradrec, MSIZE_CELL_SCAL, 0.d0, proj1, MSIZE_CELL_SCAL)
!
! -- Solve proj1 = M1^-1 * proj1
! -- Verif strange bug if info neq 0 in entry
        info = 0
        call dposv('U', dimM1, total_dofs, M1, MSIZE_CELL_SCAL, proj1, MSIZE_CELL_SCAL, info)
!
! - Sucess ?
        if(info .ne. 0) then
            call utmess('F', 'HHO1_4')
        end if
!
! --  Step 2: v_T - \pi_T^k p_T^k v (first term minus third term)
! -- Compute proj1 = proj1 + I_Cell
        do i = 1, dimM1
            proj1(i,i) = proj1(i,i) + 1.d0
        end do
!
! Step 3: project on faces (eqn. 21)
        offset_face = cbs + 1
!
! -- Loop on the faces
        do iface = 1, hhoCell%nbfaces
            hhoFace = hhoCell%faces(iface)
            invH = 1.d0 / hhoFace%diameter
            fromFace = offset_face
            toFace = offset_face + fbs - 1
!
! ----- Compute face mass matrix
            call hhoMassMatFaceScal(hhoFace, 0, hhoData%face_degree(), faceMass)
!
! ----- Compute trace mass matrix
            call hhoTraceMatScal(hhoCell, 0, hhoData%face_degree() + 1, &
                                & hhoFace, 0, hhoData%face_degree(), traceMat)
!
! ---- Factorize face Mass
            piKF = 0.d0
            piKF(1:fbs, 1:fbs) = faceMass(1:fbs, 1:fbs)
! ---- Verif strange bug if info neq 0 in entry
            info = 0
            call dpotrf('U', fbs, piKF, MSIZE_FACE_SCAL, info)
!
! --- Sucess ?
            if(info .ne. 0) then
                call utmess('F', 'HHO1_4')
            end if
!
! ----  Step 3a: \pi_F^k( v_F - p_T^k v )
            MR1 = 0.d0
            MR1(1:fbs, 1:colsM2) = traceMat(1:fbs, ifromM2:itoM2)
!
! ----  compute proj2 = MR1 * gradrec
            proj2 = 0.d0
            call dgemm('N', 'N', fbs, total_dofs, colsM2, 1.d0, MR1, MSIZE_FACE_SCAL, &
                    & gradrec, MSIZE_CELL_SCAL, 0.d0, proj2, MSIZE_FACE_SCAL)
!
! ---- Solve proj2 = pikF^-1 * proj2
! ---- Verif strange bug if info neq 0 in entry
            info = 0
            call dpotrs('U', fbs, total_dofs, piKF, MSIZE_FACE_SCAL, proj2, MSIZE_FACE_SCAL, info)
!
! --- Sucess ?
            if(info .ne. 0) then
                call utmess('F', 'HHO1_4')
            end if
!
! ---- Compute proj2 -= I_F
            i = 1
            do j = fromFace, toFace
                proj2(i,j) = proj2(i,j) - 1.d0
                i = i + 1
            end do
!
! ---- Step 3b: \pi_F^k( v_T - \pi_T^k p_T^k v )
!
            MR2 = 0.d0
            MR2(1:fbs, 1:dimM1) = traceMat(1:fbs, ifromM1:itoM1)
!
! ---- Compute proj3 = MR2 * proj1
            proj3 = 0.d0
            call dgemm('N', 'N', fbs, total_dofs, dimM1, 1.d0, MR2, MSIZE_FACE_SCAL, &
                        & proj1, MSIZE_CELL_SCAL, 0.d0, proj3, MSIZE_FACE_SCAL)
!
! ---- Solve proj3 = pikF^-1 * proj3
            info = 0
            call dpotrs('U', fbs, total_dofs, piKF, MSIZE_FACE_SCAL, proj3, MSIZE_FACE_SCAL, info)
!
! --- -Success ?
! ---- Verif strange bug if info neq 0 in entry
            if(info .ne. 0) then
                call utmess('F', 'HHO1_4')
            end if
!
! ---- proj3 = proj3 + proj2
            proj3(1:fbs, 1:total_dofs) = proj3(1:fbs, 1:total_dofs) + proj2(1:fbs, 1:total_dofs)
!
! ---- Compute TMP = faceMass * proj3
            TMP = 0.d0
            call dgemm('N', 'N', fbs, total_dofs, fbs, 1.d0, faceMass, MSIZE_FACE_SCAL, &
                 & proj3, MSIZE_FACE_SCAL, 0.d0, TMP, MSIZE_FACE_SCAL)
!
! ---- Compute stab += invH * proj3**T * TMP
            call dgemm('T', 'N', total_dofs, total_dofs, fbs, invH, proj3, MSIZE_FACE_SCAL, &
                        & TMP, MSIZE_FACE_SCAL, 1.d0, stab, MSIZE_TDOFS_SCAL)
!
            offset_face = offset_face + fbs
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoStabVec(hhoCell, hhoData, gradrec_scal, stab)
!
    implicit none
!
        type(HHO_Cell), intent(in)  :: hhoCell
        type(HHO_Data), intent(in)  :: hhoData
        real(kind=8), intent(in)    :: gradrec_scal(MSIZE_CELL_SCAL,MSIZE_TDOFS_SCAL)
        real(kind=8), intent(out)   :: stab(MSIZE_TDOFS_VEC,MSIZE_TDOFS_VEC)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the hho stabilization of a vectorial function
!   In hhoCell      : the current HHO Cell
!   In hhoData      : information on HHO methods
!   In gradrec_scal : matrix of the gradient reconstruction of a scalar function
!   Out stab        : matrix of stabilization (lhs member for vectorial laplacian problem)
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(MSIZE_TDOFS_SCAL,MSIZE_TDOFS_SCAL) :: stab_scal
! --------------------------------------------------------------------------------------------------
!
! -- compute scalar stabilization
        call hhoStabScal(hhoCell, hhoData, gradrec_scal, stab_scal)
!
! -- copy the scalar stabilization in the vectorial stabilization
        call MatScal2Vec(hhoCell, hhoData, stab_scal, stab)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoStabSymVec(hhoCell, hhoData, gradrec, stab)
!
    implicit none
!
        type(HHO_Cell), intent(in)  :: hhoCell
        type(HHO_Data), intent(in)  :: hhoData
        real(kind=8), intent(in)    :: gradrec(MSIZE_CELL_VEC,MSIZE_TDOFS_VEC)
        real(kind=8), intent(out)   :: stab(MSIZE_TDOFS_VEC,MSIZE_TDOFS_VEC)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the hho stabilization of a vectorial function
!   In hhoCell      : the current HHO Cell
!   In hhoData      : information on HHO methods
!   In gradrec      : matrix of the symmetric gradient reconstruction
!   Out stab        : matrix of stabilization (lhs member for laplacian problem)
!
! --------------------------------------------------------------------------------------------------
!
        type(HHO_Face)  :: hhoFace
        type(HHO_basis_cell) :: hhoBasisCell
        real(kind=8) :: invH
        real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_CELL_SCAL) :: massMat, M1 = 0.d0, M2 = 0.d0
        real(kind=8), dimension(MSIZE_FACE_SCAL, MSIZE_FACE_SCAL) :: faceMass, piKF
        real(kind=8), dimension(MSIZE_CELL_VEC, MSIZE_TDOFS_VEC) :: proj1 = 0.d0
        real(kind=8), dimension(MSIZE_FACE_SCAL, MSIZE_CELL_SCAL) :: MR1, MR2, traceMat
        real(kind=8), dimension(MSIZE_FACE_SCAL, MSIZE_TDOFS_VEC) :: proj2, proj3, TMP
        integer :: dimMassMat, ifromM1, itoM1, ifromM2, itoM2, dimM1, colsM2, i, j, idir
        integer :: cbs, fbs, total_dofs, iface, info, fromFace, toFace
        integer :: ifromGrad, itoGrad, ifromProj, itoProj, fbs_comp, faces_dofs, faces_dofs_comp
! --------------------------------------------------------------------------------------------------
!
! -- init cell basis
        call hhoBasisCell%initialize(hhoCell)
!
! -- number of dofs
        call hhoMecaDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
!
        fbs_comp = fbs / hhoCell%ndim
        faces_dofs = total_dofs - cbs
        faces_dofs_comp = faces_dofs / hhoCell%ndim
!
! -- compute cell mass matrix
        dimMassMat = hhoBasisCell%BSSize(0, hhoData%face_degree() + 1)
        call hhoMassMatCellScal(hhoCell, 0, hhoData%face_degree() + 1, massMat)
!
! -- Range
        call hhoBasisCell%BSRange(0, hhoData%cell_degree(), ifromM1, itoM1)
        dimM1 = hhoBasisCell%BSSize(0, hhoData%cell_degree())
        call hhoBasisCell%BSRange(1, hhoData%face_degree() + 1, ifromM2, itoM2)
        colsM2 = hhoBasisCell%BSSize(1, hhoData%face_degree() + 1)
!
! -- extract M1:
        M1(1:dimM1, 1:dimM1) = massMat(ifromM1:itoM1, ifromM1:itoM1)
!
! -- factorize M1
        info = 0
        call dpotrf('U', dimM1, M1, MSIZE_CELL_SCAL, info)
!
! -- Sucess ?
        if(info .ne. 0) then
            call utmess('F', 'HHO1_4')
        end if
!
! -- extract M2:
        M2(1:dimM1, 1:colsM2) = massMat(ifromM1:itoM1, ifromM2:itoM2)
!
! -- Verif size
        ASSERT(MSIZE_CELL_SCAL >= colsM2 .and. MSIZE_TDOFS_SCAL >= dimM1)
!
        stab = 0.d0
!
! -- Build \pi_F^k (v_F - P_T^K v) equations (21) and (22)
! -- compute proj1: Step 1: compute \pi_T^k p_T^k v (third term).
!
! -- Compute proj1 = -M2 * gradrec
!
        do idir = 1, hhoCell%ndim
!
            ifromGrad = (idir - 1) * colsM2 + 1
            itoGrad = ifromGrad + colsM2 - 1
            ifromProj = (idir - 1) * dimM1 + 1
            itoProj = ifromProj + dimM1 - 1
!
            call dgemm('N', 'N', dimM1, total_dofs, colsM2, -1.d0, M2, MSIZE_CELL_SCAL, &
                    & gradrec(ifromGrad:itoGrad,1:total_dofs), colsM2, 0.d0, &
                    & proj1(ifromProj:itoProj,1:total_dofs), dimM1)
!
! -- Solve proj1 = M1^-1 * proj1
! -- Verif strange bug if info neq 0 in entry
            info = 0
            call dpotrs('U', dimM1, total_dofs, M1, MSIZE_CELL_SCAL, &
                        & proj1(ifromProj:itoProj,1:total_dofs), dimM1, info)
!
! -- Sucess ?
            if(info .ne. 0) then
                call utmess('F', 'HHO1_4')
            end if
!
        end do
!
! --  Step 2: v_T - \pi_T^k p_T^k v (first term minus third term)
! -- Compute proj1 = proj1 + I_Cell
        do i = 1, hhoCell%ndim * dimM1
            proj1(i,i) = proj1(i,i) + 1.d0
        end do
!
! Step 3: project on faces (eqn. 21)
!
! -- Loop on the faces
        do iface = 1, hhoCell%nbfaces
            hhoFace = hhoCell%faces(iface)
            invH = 1.d0 / hhoFace%diameter
!
! ----- Compute face mass matrix
            call hhoMassMatFaceScal(hhoFace, 0, hhoData%face_degree(), faceMass)
!
! ----- Compute trace mass matrix
            call hhoTraceMatScal(hhoCell, 0, hhoData%face_degree() + 1, &
                                & hhoFace, 0, hhoData%face_degree(), traceMat)
!
! ---- Factorize face Mass
            piKF = 0.d0
            piKF(1:fbs_comp, 1:fbs_comp) = faceMass(1:fbs_comp, 1:fbs_comp)
! ---- Verif strange bug if info neq 0 in entry
            info = 0
            call dpotrf('U', fbs_comp, piKF, MSIZE_FACE_SCAL, info)
!
! --- Sucess ?
            if(info .ne. 0) then
                call utmess('F', 'HHO1_4')
            end if
!
! ----  Step 3a: \pi_F^k( v_F - p_T^k v )
            MR1 = 0.d0
            MR1(1:fbs_comp, 1:colsM2) = traceMat(1:fbs_comp, ifromM2:itoM2)
!
            MR2 = 0.d0
            MR2(1:fbs_comp, 1:dimM1) = traceMat(1:fbs_comp, ifromM1:itoM1)
!
            do idir = 1, hhoCell%ndim
!
                proj2 = 0.d0
                proj3 = 0.d0
!
                ifromGrad = (idir - 1) * colsM2 + 1
                itoGrad = ifromGrad + colsM2 - 1
!
! ----  compute proj2 = MR1 * gradrec
                call dgemm('N', 'N', fbs_comp, total_dofs, colsM2, 1.d0, MR1, MSIZE_FACE_SCAL, &
                            gradrec(ifromGrad:itoGrad,1:total_dofs), colsM2, &
                            0.d0, proj2, MSIZE_FACE_SCAL)
!
! ---- Solve proj2 = pikF^-1 * proj2
! ---- Verif strange bug if info neq 0 in entry
                info = 0
                call dpotrs('U', fbs_comp, total_dofs, piKF, MSIZE_FACE_SCAL, &
                             proj2, MSIZE_FACE_SCAL, info)
!
! --- Sucess ?
                if(info .ne. 0) then
                    call utmess('F', 'HHO1_4')
                end if
!
! ---- Compute proj2 -= I_F
                fromFace = cbs + (idir - 1) * fbs_comp + (iface - 1) * fbs + 1
                toFace = fromFace + fbs_comp - 1
                i = 1
                do j = fromFace, toFace
                    proj2(i,j) = proj2(i,j) - 1.d0
                    i = i + 1
                end do
!
! ---- Step 3b: \pi_F^k( v_T - \pi_T^k p_T^k v )
! ---- Compute proj3 = MR2 * proj1
!
                ifromProj = (idir - 1) * dimM1 + 1
                itoProj = ifromProj + dimM1 - 1
!
                call dgemm('N', 'N', fbs_comp, total_dofs, dimM1, 1.d0, MR2, MSIZE_FACE_SCAL, &
                      proj1(ifromProj:itoProj,1:total_dofs), dimM1, 0.d0, proj3, MSIZE_FACE_SCAL)
!
! ---- Solve proj3 = pikF^-1 * proj3
                info = 0
                call dpotrs('U', fbs_comp, total_dofs, piKF, MSIZE_FACE_SCAL, &
                            proj3, MSIZE_FACE_SCAL, info)
!
! --- -Success ?
! ---- Verif strange bug if info neq 0 in entry
                if(info .ne. 0) then
                    call utmess('F', 'HHO1_4')
                end if
!
! ---- proj3 = proj3 + proj2
                proj3(1:fbs_comp, 1:total_dofs) = proj3(1:fbs_comp, 1:total_dofs) &
                                                  + proj2(1:fbs_comp, 1:total_dofs)
!
! ---- Compute TMP = faceMass * proj3
                TMP = 0.d0
                call dgemm('N', 'N', fbs_comp, total_dofs, fbs_comp, 1.d0, faceMass, &
                            MSIZE_FACE_SCAL, proj3, MSIZE_FACE_SCAL, 0.d0, TMP, MSIZE_FACE_SCAL)
!
! ---- Compute stab += invH * proj3**T * TMP
                call dgemm('T', 'N', total_dofs, total_dofs, fbs_comp, invH, proj3, &
                            MSIZE_FACE_SCAL, TMP, MSIZE_FACE_SCAL, 1.d0, stab, MSIZE_TDOFS_VEC)
!
            end do
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hdgStabScal(hhoCell, hhoData, stab)
!
    implicit none
!
        type(HHO_Cell), intent(in)  :: hhoCell
        type(HHO_Data), intent(in)  :: hhoData
        real(kind=8), intent(out)   :: stab(MSIZE_TDOFS_SCAL,MSIZE_TDOFS_SCAL)
!
! --------------------------------------------------------------------------------------------------
!   HHO - HDG type stabilisation 1/h_F(v_F - pi^k_F(vT))_F
!
!   Compute the hdg stabilization of a scalar function
!   In hhoCell      : the current HHO Cell
!   In hhoData       : information on HHO methods
!   Out stab        : matrix of stabilization (lhs member for laplacian problem)
!
! --------------------------------------------------------------------------------------------------
!
        type(HHO_Face)  :: hhoFace
        type(HHO_basis_cell) :: hhoBasisCell
        real(kind=8) :: invH
        real(kind=8), dimension(MSIZE_FACE_SCAL, MSIZE_FACE_SCAL) :: faceMass, piKF
        real(kind=8), dimension(MSIZE_CELL_SCAL, MSIZE_TDOFS_SCAL) :: proj1 = 0.d0
        real(kind=8), dimension(MSIZE_FACE_SCAL, MSIZE_CELL_SCAL) ::  traceMat
        real(kind=8), dimension(MSIZE_FACE_SCAL, MSIZE_TDOFS_SCAL) :: proj3, TMP
        integer :: cbs, fbs, total_dofs, iface, offset_face, info, fromFace, toFace, i, j
! --------------------------------------------------------------------------------------------------
!
! -- init cell basis
        call hhoBasisCell%initialize(hhoCell)
!
! -- number of dofs
        call hhoTherDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
!
        stab = 0.d0
!
! --  Step 1: v_T
! -- Compute proj1 =  I_Cell
        do i = 1, cbs
            proj1(i,i) = 1.d0
        end do
!
! Step 3: project on faces (eqn. 21)
        offset_face = cbs + 1
!
! -- Loop on the faces
        do iface = 1, hhoCell%nbfaces
            hhoFace = hhoCell%faces(iface)
            invH = 1.d0 / hhoFace%diameter
            fromFace = offset_face
            toFace = offset_face + fbs - 1
!
! ----- Compute face mass matrix
            call hhoMassMatFaceScal(hhoFace, 0, hhoData%face_degree(), faceMass)
!
! ----- Compute trace mass matrix
            call hhoTraceMatScal(hhoCell, 0, hhoData%cell_degree(), &
                                & hhoFace, 0, hhoData%face_degree(), traceMat)
!
! ---- Factorize face Mass
            piKF = 0.d0
            piKF(1:fbs, 1:fbs) = faceMass(1:fbs, 1:fbs)
! ---- Verif strange bug if info neq 0 in entry
            info = 0
            call dpotrf('U', fbs, piKF, MSIZE_FACE_SCAL, info)
!
! --- Sucess ?
            if(info .ne. 0) then
                call utmess('F', 'HHO1_4')
            end if
!
! ---- Compute proj3 = traceMat * proj1
            proj3 = 0.d0
            call dgemm('N', 'N', fbs, total_dofs, cbs, 1.d0, traceMat, MSIZE_FACE_SCAL, &
                    & proj1, MSIZE_CELL_SCAL, 0.d0, proj3, MSIZE_FACE_SCAL)
!
! ---- Solve proj3 = pikF^-1 * proj3
            info = 0
            call dpotrs('U', fbs, total_dofs, piKF, MSIZE_FACE_SCAL, proj3, MSIZE_FACE_SCAL, info)
!
! --- -Success ?
! ---- Verif strange bug if info neq 0 in entry
            if(info .ne. 0) then
                call utmess('F', 'HHO1_4')
            end if
!
! ---- Compute proj3 -= I_F
            i = 1
            do j = fromFace, toFace
                proj3(i,j) = proj3(i,j) - 1.d0
                i = i + 1
            end do
!
! ---- Compute TMP = faceMass * proj3
            TMP = 0.d0
            call dgemm('N', 'N', fbs, total_dofs, fbs, 1.d0, faceMass, MSIZE_FACE_SCAL  , &
                    & proj3, MSIZE_FACE_SCAL, 0.d0, TMP, MSIZE_FACE_SCAL)
!
! ---- Compute stab += invH * proj3**T * TMP
            call dgemm('T', 'N', total_dofs, total_dofs, fbs, invH, proj3, MSIZE_FACE_SCAL, &
                    & TMP, MSIZE_FACE_SCAL, 1.d0, stab, MSIZE_TDOFS_SCAL)
!
            offset_face = offset_face + fbs
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hdgStabVec(hhoCell, hhoData, stab)
!
    implicit none
!
        type(HHO_Cell), intent(in)  :: hhoCell
        type(HHO_Data), intent(in)  :: hhoData
        real(kind=8), intent(out)   :: stab(MSIZE_TDOFS_VEC,MSIZE_TDOFS_VEC)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Compute the hdg stabilization of a vectorial function
!   In hhoCell      : the current HHO Cell
!   In hhoData      : information on HHO methods
!   Out stab        : matrix of stabilization (lhs member for vectorial laplacian problem)
!
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), dimension(MSIZE_TDOFS_SCAL,MSIZE_TDOFS_SCAL) :: stab_scal
! --------------------------------------------------------------------------------------------------
!
! -- compute scalar stabilization
        call hdgStabScal(hhoCell, hhoData, stab_scal)
!
! -- copy the scalar stabilization in the vectorial stabilization
        call MatScal2Vec(hhoCell, hhoData, stab_scal, stab)
!
    end subroutine
!
end module
