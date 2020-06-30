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
! person_in_charge: mickael.abbas at edf.fr
! aslint: disable=W1504
!
module HHO_SmallStrainMeca_module
!
use HHO_basis_module
use HHO_quadrature_module
use HHO_size_module
use HHO_type
use HHO_utils_module
use HHO_eval_module
use Behaviour_type
use Behaviour_module
!
implicit none
!
private
#include "asterf_types.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/assert.h"
#include "asterfort/codere.h"
#include "asterfort/dmatmc.h"
#include "asterfort/nbsigm.h"
#include "asterfort/nmcomp.h"
#include "asterfort/ortrep.h"
#include "blas/daxpy.h"
#include "blas/dgemm.h"
#include "blas/dgemv.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO - mechanics
!
! Module for small deformations with hho
!
! --------------------------------------------------------------------------------------------------
!
    public   :: hhoSmallStrainLCMeca
    private  :: hhoComputeCgphi, hhoComputeRhs, hhoComputeLhs, tranfoMatToSym, tranfoSymToMat
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoSmallStrainLCMeca(hhoCell, hhoData, hhoQuadCellRigi, gradrec, &
                                    & fami, typmod, imate, compor, option, carcri, lgpg, ncomp,&
                                    & time_prev, time_curr, depl_prev, depl_incr, &
                                    & sigm, vim, angmas, mult_comp, &
                                    & lhs, rhs, sigp, vip, codret)
!
    implicit none
!
        type(HHO_Cell), intent(in)      :: hhoCell
        type(HHO_Data), intent(in)      :: hhoData
        type(HHO_Quadrature), intent(in):: hhoQuadCellRigi
        real(kind=8), intent(in)        :: gradrec(MSIZE_CELL_MAT, MSIZE_TDOFS_VEC)
        character(len=*), intent(in)    :: fami
        character(len=8), intent(in)    :: typmod(*)
        integer, intent(in)             :: imate
        character(len=16), intent(in)   :: compor(*)
        character(len=16), intent(in)   :: option
        real(kind=8), intent(in)        :: carcri(*)
        integer, intent(in)             :: lgpg
        integer, intent(in)             :: ncomp
        real(kind=8), intent(in)        :: time_prev
        real(kind=8), intent(in)        :: time_curr
        real(kind=8), intent(in)        :: depl_prev(MSIZE_TDOFS_VEC)
        real(kind=8), intent(in)        :: depl_incr(MSIZE_TDOFS_VEC)
        real(kind=8), intent(in)        :: sigm(ncomp,*)
        real(kind=8), intent(in)        :: vim(lgpg,*)
        real(kind=8), intent(in)        :: angmas(*)
        character(len=16), intent(in)   :: mult_comp
        real(kind=8), intent(inout)     :: lhs(MSIZE_TDOFS_VEC, MSIZE_TDOFS_VEC)
        real(kind=8), intent(inout)     :: rhs(MSIZE_TDOFS_VEC)
        real(kind=8), intent(inout)     :: sigp(ncomp,*)
        real(kind=8), intent(inout)     :: vip(lgpg,*)
        integer, intent(inout)          :: codret
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the local contribution for mechanics with small deformations
!   In hhoCell      : the current HHO Cell
!   In hhoData      : information on HHO methods
!   In hhoQuadCellRigi : quadrature rules from the rigidity family
!   In gradrec      : local gradient reconstruction
!   In fami         : familly of quadrature points (of hhoQuadCellRigi)
!   In typmod       : type of modelization
!   In imate        : materiau code
!   In compor       : type of behavior
!   In option       : option of computations
!   In carcri       : local criterion of convergence
!   In lgpg         : size of internal variables for 1 pg
!   In ncomp        : number of composant of sigm et sigp
!   In time_prev    : previous time T-
!   In time_curr    : current time T+
!   In depl_prev    : displacement at T-
!   In depl_incr    : increment of displacement between T- and T+
!   In sigm         : stress at T-  (XX, YY, ZZ, XY, XZ, YZ)
!   In vim          : internal variables at T-
!   In angmas       : LES TROIS ANGLES DU MOT_CLEF MASSIF
!   In multcomp     : ?
!   Out lhs         : local contribution (lhs)
!   Out rhs         : local contribution (rhs)
!   In sigp         : stress at T+  (XX, YY, ZZ, XY, XZ, YZ)
!   In vip          : internal variables at T+
!   Out codret      : info on integration of the LDC
! --------------------------------------------------------------------------------------------------
!
        type(HHO_basis_cell) :: hhoBasisCell
        type(Behaviour_Integ) :: BEHinteg
        real(kind=8) :: E_prev_coeff(MSIZE_CELL_MAT), E_incr_coeff(MSIZE_CELL_MAT)
        real(kind=8) :: dsidep(6,6), E_prev(6), E_incr(6), Cauchy_curr(6), Cauchy_prev(6)
        real(kind=8) :: coorpg(3), weight, repere(7)
        real(kind=8) :: BSCEval(MSIZE_CELL_SCAL)
        real(kind=8) :: AT(MSIZE_CELL_MAT, MSIZE_CELL_MAT), bT(MSIZE_CELL_MAT)
        real(kind=8) :: TMP(MSIZE_CELL_MAT, MSIZE_TDOFS_VEC)
        integer:: cbs, fbs, total_dofs, faces_dofs, gbs, ipg, gbs_cmp, gbs_sym, nb_sig
        integer :: cod(27)
        aster_logical :: l_tang
! --------------------------------------------------------------------------------------------------
!
        cod = 0
! ------ number of dofs
        call hhoMecaNLDofs(hhoCell, hhoData, cbs, fbs, total_dofs, gbs, gbs_sym)
        faces_dofs = total_dofs - cbs
        gbs_cmp = gbs / (hhoCell%ndim * hhoCell%ndim)
!
        bT = 0.d0
        AT = 0.d0
        dsidep = 0.d0
        E_prev_coeff = 0.d0
        E_incr_coeff = 0.d0
        Cauchy_curr = 0.d0
        l_tang = ASTER_TRUE
        repere = 0.d0
        nb_sig = nbsigm()
!
        if (option(1:10).eq.'RIGI_MECA ') then
            l_tang = ASTER_FALSE
            call ortrep(hhoCell%ndim, hhoCell%barycenter, repere)
        end if
!
! ----- Initialisation of behaviour datastructure
!
        call behaviourInit(BEHinteg)
!
! ----- init basis
        call hhoBasisCell%initialize(hhoCell)
!
! ----- compute E_prev = gradrec_sym * depl_prev
        call dgemv('N', gbs_sym, total_dofs, 1.d0, gradrec, MSIZE_CELL_MAT, &
                  & depl_prev, 1, 0.d0, E_prev_coeff, 1)
!
! ----- compute E_incr = gradrec_sym * depl_incr
        call dgemv('N', gbs_sym, total_dofs, 1.d0, gradrec, MSIZE_CELL_MAT, &
                  & depl_incr, 1, 0.d0, E_incr_coeff, 1)
!
! ----- Loop on quadrature point
!
        do ipg = 1, hhoQuadCellRigi%nbQuadPoints
            coorpg(1:3) = hhoQuadCellRigi%points(1:3,ipg)
            weight = hhoQuadCellRigi%weights(ipg)
            !print*, "qp", coorpg(1:3)
! --------- Eval basis function at the quadrature point
            call hhoBasisCell%BSEval(hhoCell, coorpg(1:3), 0, hhoData%grad_degree(), BSCEval)
!
! --------- Eval deformations
            E_prev = hhoEvalSymMatCell(hhoCell, hhoBasisCell, hhoData%grad_degree(), &
                                   coorpg(1:3), E_prev_coeff, gbs_sym)
!
            E_incr = hhoEvalSymMatCell(hhoCell, hhoBasisCell, hhoData%grad_degree(), &
                                   coorpg(1:3), E_incr_coeff, gbs_sym)
!
! -------- tranform sigm in symmetric form
!
            call tranfoMatToSym(hhoCell%ndim, sigm(1:ncomp,ipg), Cauchy_prev)
!
! --------- Compute behaviour
!
            call nmcomp(BEHinteg,&
                        fami       , ipg        , 1        , hhoCell%ndim, typmod      ,&
                        imate      , compor     , carcri   , time_prev   , time_curr   ,&
                        6          , E_prev     , E_incr   , 6           , Cauchy_prev ,&
                        vim(1, ipg), option     , angmas   ,&
                        Cauchy_curr, vip(1, ipg), 36       , dsidep      , cod(ipg)   , mult_comp)
!
            if (cod(ipg) .eq. 1) then
                goto 999
            endif
!
! -------- Use Hooke matrix for the elastic modulus
!
            if(.not.l_tang) then
                call dmatmc(fami, imate, time_curr, '+', ipg, 1, repere, coorpg(1:3), nb_sig, &
                            dsidep(1:nb_sig, 1:nb_sig))
            end if
! --------- For new prediction and nmisot.F90
            if (option.eq.'RIGI_MECA_TANG') then
                Cauchy_curr = 0.d0
            endif
!
            if (option(1:9) .eq. 'RAPH_MECA' .or. option(1:9) .eq. 'FULL_MECA') then
! -------- tranform Cauchy_curr in symmetric form
                call tranfoSymToMat(hhoCell%ndim, Cauchy_curr, sigp(1:ncomp,ipg))
            end if
!
            call hhoComputeRhs(hhoCell, Cauchy_curr, weight, BSCEval, gbs_cmp, bT)
!
            call hhoComputeLhs(hhoCell, dsidep, weight, BSCEval, gbs_sym, gbs_cmp, AT)
        end do
!
! ----- Copy symetric part of AT
        call hhoCopySymPartMat('U', AT, gbs_sym)

!
! ----- compute rhs += Gradrec**T * bT
        call dgemv('T', gbs_sym, total_dofs, -1.d0, gradrec, MSIZE_CELL_MAT, bT, 1, 1.d0, rhs, 1)
!
! ----- compute lhs += gradrec**T * AT * gradrec
! ----- step1: TMP = AT * gradrec
        call dgemm('N', 'N', gbs_sym, total_dofs, total_dofs, 1.d0, AT, MSIZE_CELL_MAT, &
                  & gradrec, MSIZE_CELL_MAT, 0.d0, TMP, MSIZE_CELL_MAT)
!
! ----- step2: lhs += gradrec**T * TMP
        call dgemm('T', 'N', total_dofs, total_dofs, gbs_sym, 1.d0, gradrec, MSIZE_CELL_MAT, &
                  & TMP, MSIZE_CELL_MAT, 1.d0, lhs, MSIZE_TDOFS_VEC)
!
        ! print*, "AT", hhoNorm2Mat(AT(1:gbs_sym,1:gbs_sym))
        ! print*, "bT", norm2(bT)
        ! print*, "KT", hhoNorm2Mat(lhs(1:total_dofs,1:total_dofs))
        ! print*, "fT", norm2(rhs)
!
999 continue
!
! ---- Return code summary
!
        call codere(cod, hhoQuadCellRigi%nbQuadPoints, codret)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoComputeRhs(hhoCell, stress, weight, BSCEval, gbs_cmp, bT)
!
    implicit none
!
        type(HHO_Cell), intent(in)      :: hhoCell
        real(kind=8), intent(in)        :: stress(6)
        real(kind=8), intent(in)        :: weight
        real(kind=8), intent(in)        :: BSCEval(MSIZE_CELL_SCAL)
        integer, intent(in)             :: gbs_cmp
        real(kind=8), intent(inout)     :: bT(MSIZE_CELL_MAT)
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the scalar product bT += (stress, sgphi)_T at a quadrature point
!   In hhoCell      : the current HHO Cell
!   In stress       : stress tensor (XX YY ZZ SQRT(2)*XY SQRT(2)*XZ SQRT(2)*YZ)
!   In weight       : quadrature weight
!   In BSCEval      : Basis of one composant gphi
!   In gbs_cmp      : size of BSCEval
!   Out bT          : contribution of bt
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: qp_stress(6)
        integer:: i, deca
! --------------------------------------------------------------------------------------------------
!
        qp_stress = weight * stress
! -------- Compute scalar_product of (stress, sgphi)_T
! -------- (RAPPEL: the composents of the gradient are saved by G11, G22, G33, G12, G13, G23)
        deca = 0
        do i = 1, hhoCell%ndim
            call daxpy(gbs_cmp, qp_stress(i), BSCEval, 1, bT(deca+1), 1)
            deca = deca + gbs_cmp
        end do
!
! ---- non-diagonal terms
        select case (hhoCell%ndim)
            case (3)
                do i = 1, 3
                    call daxpy(gbs_cmp, qp_stress(3+i), BSCEval, 1, bT(deca+1), 1)
                    deca = deca + gbs_cmp
                end do
            case (2)
                call daxpy(gbs_cmp, qp_stress(4), BSCEval, 1, bT(deca+1), 1)
                deca = deca + gbs_cmp
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
    subroutine hhoComputeLhs(hhoCell, module_tang, weight, BSCEval, gbs_sym, gbs_cmp, AT)
!
    implicit none
!
        type(HHO_Cell), intent(in)      :: hhoCell
        real(kind=8), intent(in)        :: module_tang(6,6)
        real(kind=8), intent(in)        :: weight
        real(kind=8), intent(in)        :: BSCEval(MSIZE_CELL_SCAL)
        integer, intent(in)             :: gbs_sym
        integer, intent(in)             :: gbs_cmp
        real(kind=8), intent(inout)     :: AT(MSIZE_CELL_MAT, MSIZE_CELL_MAT)
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the scalar product AT += (module_tang:gphi, gphi)_T at a quadrature point
!   In hhoCell      : the current HHO Cell
!   In module_tang  : elasto-plastic tangent moduli
!   In weight       : quadrature weight
!   In BSCEval      : Basis of one composant gphi
!   In gbs_cmp      : size of BSCEval
!   In gbs          : number of rows of AT
!   Out AT          : contribution of At
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: qp_Cgphi(6, MSIZE_CELL_MAT)
        integer:: i, j, k, row
! --------------------------------------------------------------------------------------------------
!
! --------- Eval (C : sgphi)_T
        call hhoComputeCgphi(hhoCell, module_tang, BSCEval, gbs_cmp, weight, qp_Cgphi)
!
! -------- Compute scalar_product of (C_sgphi(j), sgphi(j))_T
        do j = 1, gbs_sym
            row = 1
! ---------- diagonal term
            do i = 1, hhoCell%ndim
                do k = 1, gbs_cmp
                    AT(row, j) =  AT(row, j) + qp_Cgphi(i, j) * BSCEval(k)
                    row = row + 1
                    if (row > j) then
                        go to 100
                    end if
                end do
            end do
!
! --------- non-diagonal terms
            select case (hhoCell%ndim)
                case (3)
                    do i = 1, 3
                        do k = 1, gbs_cmp
                            AT(row, j) =  AT(row, j) + qp_Cgphi(3+i, j) * BSCEval(k)
                            row = row + 1
                            if (row > j) then
                                go to 100
                            end if
                        end do
                    end do
                case (2)
                    do k = 1, gbs_cmp
                        AT(row, j) =  AT(row, j) + qp_Cgphi(4, j) * BSCEval(k)
                        row = row + 1
                        if (row > j) then
                            go to 100
                        end if
                    end do
                case default
                    ASSERT(ASTER_FALSE)
            end select
!
100 continue
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoComputeCgphi(hhoCell, module_tang, BSCEval, gbs_cmp, weight, Cgphi)
!
    implicit none
!
        type(HHO_Cell), intent(in)      :: hhoCell
        integer, intent(in)             :: gbs_cmp
        real(kind=8), intent(in)        :: module_tang(6,6)
        real(kind=8), intent(in)        :: BSCEval(MSIZE_CELL_SCAL)
        real(kind=8), intent(in)        :: weight
        real(kind=8), intent(out)       :: Cgphi(6, MSIZE_CELL_MAT)
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the scalar product qp_weight * (module_tang, sgphi)_T
!   In hhoCell      : the current HHO Cell
!   In module_tang  : elasto_plastic moduli
!   In BSCEval      : Basis of one composant gphi
!   In gbs_cmp     : size of BSCEval
!   In weight       : quadrature weight
!   Out Agphi       : matrix of scalar product
! --------------------------------------------------------------------------------------------------
!
        integer :: i, col, k
        real(kind=8) :: qp_C(6,6)
! --------------------------------------------------------------------------------------------------
!
        Cgphi = 0.d0
        qp_C = weight * module_tang
        col = 1
!
        select case (hhoCell%ndim)
            case (3)
                do i = 1, 6
                    do k = 1, gbs_cmp
                        call daxpy(6, BSCEval(k), qp_C(1, i), 1, Cgphi(1, col), 1)
                        col = col + 1
                    end do
                end do
            case (2)
! ---------- diagonal terms
                do i = 1, 2
                    do k = 1, gbs_cmp
                        Cgphi(1:2, col) = qp_C(1:2, i) * BSCEval(k)
                        Cgphi(4, col) = qp_C(4, i) * BSCEval(k)
                        col = col + 1
                    end do
                end do
! ---- non-diagonal terms
                do k = 1, gbs_cmp
                    Cgphi(1:2, col) = qp_C(1:2, 4) * BSCEval(k)
                    Cgphi(4, col) = qp_C(4, 4) * BSCEval(k)
                    col = col + 1
                end do
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
    subroutine tranfoMatToSym(ndim, mat, mat_sym)
!
    implicit none
!
        integer, intent(in)             :: ndim
        real(kind=8), intent(in)        :: mat(*)
        real(kind=8), intent(out)       :: mat_sym(6)
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   tranform a matrix to matrix symmetrix form
!   In ndim         : dimension of the problem
!   In matrix       : symmetrix matrix to transform (XX, YY, ZZ, XY, XZ, YZ)
!   Out mat_sym     : matrix in form (XX YY ZZ SQRT(2)*XY SQRT(2)*XZ SQRT(2)*YZ)
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), parameter :: rac2 = sqrt(2.d0)
! --------------------------------------------------------------------------------------------------
!
        mat_sym = 0.d0
!
        select case (ndim)
            case (3)
                mat_sym(1:3) = mat(1:3)
                mat_sym(4:6) = mat(4:6) * rac2
            case (2)
                mat_sym(1:3) = mat(1:3)
                mat_sym(4)   = mat(4) * rac2
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
    subroutine tranfoSymToMat(ndim, mat_sym, mat)
!
    implicit none
!
        integer, intent(in)             :: ndim
        real(kind=8), intent(out)       :: mat(*)
        real(kind=8), intent(in)        :: mat_sym(6)
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   tranform a matrix to matrix symmetrix form
!   In ndim        : dimension of the problem
!   Out matrix     : symmetrix matrix to transform (XX, YY, ZZ, XY, XZ, YZ)
!   In mat_sym     : matrix in form (XX YY ZZ SQRT(2)*XY SQRT(2)*XZ SQRT(2)*YZ)
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), parameter :: rac2 = sqrt(2.d0)
! --------------------------------------------------------------------------------------------------
!
        select case (ndim)
            case (3)
                mat(1:3) = mat_sym(1:3)
                mat(4:6) = mat_sym(4:6) / rac2
            case (2)
                mat(1:3) = mat_sym(1:3)
                mat(4)   = mat_sym(4) / rac2
            case default
                ASSERT(ASTER_FALSE)
        end select
!
    end subroutine
!
end module
