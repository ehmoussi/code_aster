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
module HHO_LargeStrainMeca_module
!
use HHO_basis_module
use HHO_quadrature_module
use HHO_size_module
use HHO_type
use HHO_utils_module
use HHO_eval_module
use Behaviour_type
!
implicit none
!
private
#include "asterc/r8nnem.h"
#include "asterc/r8prem.h"
#include "asterf_types.h"
#include "asterfort/Behaviour_type.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/assert.h"
#include "asterfort/behaviourInit.h"
#include "asterfort/codere.h"
#include "asterfort/desymt46.h"
#include "asterfort/dmatmc.h"
#include "asterfort/lagmodtonommod.h"
#include "asterfort/lcdetf.h"
#include "asterfort/nmcomp.h"
#include "asterfort/nmcpel.h"
#include "asterfort/ortrep.h"
#include "asterfort/pk2sig.h"
#include "asterfort/pk2topk1.h"
#include "asterfort/poslog.h"
#include "asterfort/prelog.h"
#include "asterfort/taumodtonommod.h"
#include "asterfort/tausig.h"
#include "asterfort/tautopk1.h"
#include "asterfort/utmess.h"
#include "blas/daxpy.h"
#include "blas/dgemm.h"
#include "blas/dgemv.h"
#include "blas/dger.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO - mechanics
!
! Module for large deformations with hho
!
! --------------------------------------------------------------------------------------------------
    public  :: hhoLargeStrainLCMeca
    private :: hhoComputeAgphi, hhoComputeRhs, hhoComputeLhs, hhoCalculF, transfo_A
    private :: select_behavior, gdeflog, nbsigm_cmp, hyperelas, grotgdepl
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoLargeStrainLCMeca(hhoCell, hhoData, hhoQuadCellRigi, gradrec, &
                                    & fami, typmod, imate, compor, option, carcri, lgpg, ncomp,&
                                    & time_prev, time_curr, depl_prev, depl_curr, &
                                    & sig_prev, vi_prev, angmas, mult_comp, resi, rigi, cplan, &
                                    & lhs, rhs, sig_curr, vi_curr, codret)
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
        real(kind=8), intent(in)        :: depl_curr(MSIZE_TDOFS_VEC)
        real(kind=8), intent(in)        :: sig_prev(ncomp,*)
        real(kind=8), intent(in)        :: vi_prev(lgpg,*)
        real(kind=8), intent(in)        :: angmas(*)
        character(len=16), intent(in)   :: mult_comp
        aster_logical, intent(in)       :: resi
        aster_logical, intent(in)       :: rigi
        aster_logical, intent(in)       :: cplan
        real(kind=8), intent(inout)     :: lhs(MSIZE_TDOFS_VEC, MSIZE_TDOFS_VEC)
        real(kind=8), intent(inout)     :: rhs(MSIZE_TDOFS_VEC)
        real(kind=8), intent(inout)     :: sig_curr(ncomp,*)
        real(kind=8), intent(inout)     :: vi_curr(lgpg,*)
        integer, intent(inout)          :: codret
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the local contribution for mechanics in large deformations
!   In hhoCell      : the current HHO Cell
!   In hhoData       : information on HHO methods
!   In hhoQuadCellRigi : quadrature rules from the rigidity family
!   In gradrec      : local gradient reconstruction
!   In fami         : familly of quadrature points (of hhoQuadCellRigi)
!   In typmod       : type of modelization
!   In imate        : materiau code
!   In compor       : type of behavior
!   In option       : option of computations
!   In carcri       : local criterion of convergence
!   In lgpg         : size of internal variables for 1 pg
!   In ncomp        : number of composant of sig_prev et sig_curr
!   In time_prev    : previous time T-
!   In time_curr    : current time T+
!   In depl_prev    : displacement at T-
!   In depl_curr    : displacement at T+
!   In sig_prev     : stress at T-  (XX, YY, ZZ, XY, XZ, YZ)
!   In vi_prev      : internal variables at T-
!   In angmas       : LES TROIS ANGLES DU MOT_CLEF MASSIF
!   In multcomp     : ?
!   In resi         : TRUE. SI FULL_MECA/RAPH_MECA .FALSE. SI RIGI_MECA_TANG
!   In rigi         : TRUE. SI FULL_MECA/RIGI_MECA .FALSE. SI RAPH_MECA_TANG
!   In cplan        : plane stress hypothesis
!   Out lhs         : local contribution (lhs)
!   Out rhs         : local contribution (rhs)
!   In sig_curr     : stress at T+  (XX, YY, ZZ, XY, XZ, YZ)
!   In vi_curr      : internal variables at T+
!   Out codret      : info on integration of the LDC
! --------------------------------------------------------------------------------------------------
!
        type(HHO_basis_cell) :: hhoBasisCell
        type(Behaviour_Integ) :: BEHinteg
        real(kind=8), dimension(MSIZE_CELL_MAT) :: bT, G_prev_coeff, G_curr_coeff
        real(kind=8) :: module_tang(3,3,3,3), G_prev(3,3), G_curr(3,3), hooke(6,6)
        real(kind=8) :: F_prev(3,3), F_curr(3,3), Pk1_curr(3,3), repere(7)
        real(kind=8) :: BSCEval(MSIZE_CELL_SCAL)
        real(kind=8) :: AT(MSIZE_CELL_MAT, MSIZE_CELL_MAT)
        real(kind=8) :: TMP(MSIZE_CELL_MAT, MSIZE_TDOFS_VEC)
        real(kind=8) :: jac_prev, jac_curr, coorpg(3), weight
        integer :: cbs, fbs, total_dofs, faces_dofs, gbs, ipg, gbs_cmp, gbs_sym
        integer :: cod(27) = 0, nbsig
        aster_logical :: l_gdeflog, l_grotgdepl, l_hyperelas, l_simo_miehe, l_tang
! --------------------------------------------------------------------------------------------------
!
! ------ number of dofs
!
        call hhoMecaNLDofs(hhoCell, hhoData, cbs, fbs, total_dofs, gbs, gbs_sym)
        faces_dofs = total_dofs - cbs
        gbs_cmp = gbs / (hhoCell%ndim * hhoCell%ndim)
!
        nbsig = nbsigm_cmp(hhoCell%ndim)
        bT = 0.d0
        AT = 0.d0
        G_prev_coeff = 0.d0
        G_curr_coeff = 0.d0
        !print*, "GT", hhoNorm2Mat(gradrec(1:gbs,1:total_dofs))
!
! ----- Type of behavior
!
        call select_behavior(compor, l_gdeflog, l_grotgdepl, l_simo_miehe, l_hyperelas)
!
! ----- Initialisation of behaviour datastructure
!
        call behaviourInit(BEHinteg)
!
        l_tang = ASTER_TRUE
        repere = 0.d0
        hooke = 0.d0
        if (option(1:10).eq.'RIGI_MECA ') then
            l_tang = ASTER_FALSE
            call ortrep(hhoCell%ndim, hhoCell%barycenter, repere)
        end if
!
        if (cplan .and. (l_simo_miehe .or. l_grotgdepl)) then
            call utmess('F', 'ALGORITH8_1')
        endif
!
! ----- init basis
!
        call hhoBasisCell%initialize(hhoCell)
!
! ----- compute G_prev = gradrec * depl_prev
!
        call dgemv('N', gbs, total_dofs, 1.d0, gradrec, MSIZE_CELL_MAT, depl_prev, 1,&
                   0.d0, G_prev_coeff,1)
!
! ----- compute G_curr = gradrec * depl_curr
!
        call dgemv('N', gbs, total_dofs, 1.d0, gradrec, MSIZE_CELL_MAT, depl_curr, 1,&
                    0.d0, G_curr_coeff,1)
        !print*, "GT_utf", G_curr_coeff(1:gbs)
!
! ----- Loop on quadrature point
!
        do ipg = 1, hhoQuadCellRigi%nbQuadPoints
            coorpg(1:3) = hhoQuadCellRigi%points(1:3,ipg)
            weight = hhoQuadCellRigi%weights(ipg)
            BEHinteg%elga%coorpg(1:3) = coorpg(1:3)
           !print*, ipg, "qp", coorpg(1:3), weight
!
! --------- Eval basis function at the quadrature point
!
            call hhoBasisCell%BSEval(hhoCell, coorpg(1:3), 0, hhoData%grad_degree(), BSCEval)
!
! --------- Eval gradient at T- and T+
!
            G_prev = hhoEvalMatCell(hhoCell, hhoBasisCell, hhoData%grad_degree(), &
                                    coorpg(1:3), G_prev_coeff, gbs)
!
            G_curr = hhoEvalMatCell(hhoCell, hhoBasisCell, hhoData%grad_degree(), &
                                    coorpg(1:3), G_curr_coeff, gbs)
!
! --------- Eval gradient of the deformation at T- and T+
!
            call hhoCalculF(hhoCell%ndim, G_prev, F_prev)
            call hhoCalculF(hhoCell%ndim, G_curr, F_curr)
!
! -------- Check the jacobian jac >= r8prem
! -------- be carrefull with c_plan, I don't know the result
!
            call lcdetf(hhoCell%ndim, F_prev, jac_prev)
            cod(ipg) = merge(1, 0, jac_prev .le. r8prem())
            if (cod(ipg) .ne. 0) goto 999
!
            call lcdetf(hhoCell%ndim, F_curr, jac_curr)
            cod(ipg) = merge(1, 0, jac_curr .le. r8prem())
            if (cod(ipg) .ne. 0) goto 999
!
! ------- Compute behavior
!
            if(l_hyperelas) then
                if(l_grotgdepl) then
                    call hyperelas(BEHinteg,&
                                   hhoCell%ndim, fami, typmod, imate, compor, option, carcri, ipg, &
                                   angmas, F_curr, sig_curr(1:nbsig, ipg), vi_curr(1:lgpg, ipg), &
                                   Pk1_curr, module_tang, cod(ipg), l_tang)
                else
                    ASSERT(ASTER_FALSE)
                end if
            else
                if(l_gdeflog) then
                    call gdeflog(BEHinteg,&
                                 hhoCell%ndim, fami, typmod, imate, compor, option, carcri, lgpg, &
                                 ipg, time_prev, time_curr, angmas, mult_comp, resi, rigi, cplan, &
                                 F_prev, F_curr, sig_prev(1:nbsig, ipg), vi_prev(1:lgpg, ipg), &
                                 sig_curr(1:nbsig, ipg), vi_curr(1:lgpg, ipg), &
                                 Pk1_curr, module_tang, cod(ipg), l_tang)
                elseif(l_grotgdepl) then
                    call grotgdepl(BEHinteg,&
                                   hhoCell%ndim, fami, typmod, imate, compor, option, carcri, lgpg,&
                                   ipg, time_prev, time_curr, mult_comp, resi, &
                                   F_prev, F_curr, sig_prev(1:nbsig, ipg), vi_prev(1:lgpg, ipg), &
                                   sig_curr(1:nbsig, ipg), vi_curr(1:lgpg, ipg), &
                                   Pk1_curr, module_tang, cod(ipg), l_tang)
                else
                    ASSERT(ASTER_FALSE)
                end if
            end if
!
! -------- Use Hooke matrix for the elastic modulus
!
            if(.not.l_tang) then
                call dmatmc(fami, imate, time_curr, '+', ipg, 1, repere, coorpg(1:3), nbsig, &
                            hooke(1:nbsig, 1:nbsig))
                call desymt46(hooke, module_tang)
            end if
!
! -------- Test the code of the LDC
!
            if (cod(ipg) .ne. 0) goto 999
!
! ------- Compute rhs
!
            call hhoComputeRhs(hhoCell, Pk1_curr, weight, BSCEval, gbs, bT)
!
! ------- Compute lhs
!
            call hhoComputeLhs(hhoCell, module_tang, weight, BSCEval, gbs, AT)
!
            ! print*,"vi_prev", vi_prev(1:lgpg, ipg)
            ! print*,"vi_curr", vi_curr(1:lgpg, ipg)
            ! print*,"sig_prev", sig_prev(1:nbsig, ipg)
            ! print*,"sig_curr", sig_curr(1:nbsig, ipg)
            ! print*,"Fp"
            ! call hhoPrintMat(F_curr)
            ! print*,"dPK1dF"
            ! call hhoPrintTensor4(module_tang)
            ! print*,"dPK1dF"
            ! call hhoPrintTensor4Mangle(module_tang)
            ! print*,"PK1p"
            ! call hhoPrintMat(Pk1_curr)
            ! print*,"module tangent"
            ! call hhoPrintTensor4(module_tang)
        end do
!
! ----- compute rhs += Gradrec**T * bT
!
        call dgemv('T', gbs, total_dofs, -1.d0, gradrec, MSIZE_CELL_MAT, bT, 1, 1.d0, rhs, 1)
!
! ----- compute lhs += gradrec**T * AT * gradrec
! ----- step1: TMP = AT * gradrec
!
        call dgemm('N', 'N', gbs, total_dofs, total_dofs, 1.d0, AT, MSIZE_CELL_MAT, &
                  & gradrec, MSIZE_CELL_MAT, 0.d0, TMP, MSIZE_CELL_MAT)
!
! ----- step2: lhs += gradrec**T * TMP
!
        call dgemm('T', 'N', total_dofs, total_dofs, gbs, 1.d0, gradrec, MSIZE_CELL_MAT, &
                  & TMP, MSIZE_CELL_MAT, 1.d0, lhs, MSIZE_TDOFS_VEC)
!
        ! print*, "KT", hhoNorm2Mat(lhs(1:total_dofs,1:total_dofs))
        ! print*, "fT", norm2(rhs)
!
999 continue
!
! - SYNTHESE DES CODES RETOURS
!
        call codere(cod, hhoQuadCellRigi%nbQuadPoints, codret)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoComputeRhs(hhoCell, stress, weight, BSCEval, gbs, bT)
!
    implicit none
!
        type(HHO_Cell), intent(in)      :: hhoCell
        real(kind=8), intent(in)        :: stress(3, 3)
        real(kind=8), intent(in)        :: weight
        real(kind=8), intent(in)        :: BSCEval(MSIZE_CELL_SCAL)
        integer, intent(in)             :: gbs
        real(kind=8), intent(inout)     :: bT(MSIZE_CELL_MAT)
!
! ------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the scalar product bT += (stress, gphi)_T at a quadrature point
!   In hhoCell      : the current HHO Cell
!   In stress       : stress tensor
!   In weight       : quadrature weight
!   In BSCEval      : Basis of one composant gphi
!   In gbs          : number of rows of bT
!   Out bT          : contribution of bt
! --------------------------------------------------------------------------------------------------
!
        real(kind = 8) :: qp_stress(3,3)
        integer:: i, j, gbs_cmp, deca
! --------------------------------------------------------------------------------------------------
!
        gbs_cmp = gbs / (hhoCell%ndim * hhoCell%ndim)
        qp_stress = weight * stress
! -------- Compute scalar_product of (stress, gphi)_T
! -------- (RAPPEL: the composents of the gradient are saved by rows)
        deca = 0
        do i = 1, hhoCell%ndim
            do j = 1, hhoCell%ndim
                call daxpy(gbs_cmp, qp_stress(i,j), BSCEval, 1, bT(deca+1), 1)
                deca = deca + gbs_cmp
            end do
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoComputeLhs(hhoCell, module_tang, weight, BSCEval, gbs, AT)
!
    implicit none
!
        type(HHO_Cell), intent(in)      :: hhoCell
        real(kind=8), intent(in)        :: module_tang(3,3,3,3)
        real(kind=8), intent(in)        :: weight
        real(kind=8), intent(in)        :: BSCEval(MSIZE_CELL_SCAL)
        integer, intent(in)             :: gbs
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
!   In gbs          : number of rows of bT
!   Out AT          : contribution of bt
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: qp_Agphi(MSIZE_CELL_MAT,9)
        integer:: deca, i, j, k, gbs_cmp, col
! --------------------------------------------------------------------------------------------------
!
        gbs_cmp = gbs / (hhoCell%ndim * hhoCell%ndim)
! --------- Eval (A : gphi)_T
        call hhoComputeAgphi(hhoCell, module_tang, BSCEval, gbs, weight, qp_Agphi)
!
! -------- Compute scalar_product of (A_gphi, gphi)_T
! On doit pouvoir l'optimise un peu car c'est symétrique
        deca = 1
        col = 1
        do i = 1, hhoCell%ndim
            do j = 1, hhoCell%ndim
                do k = 1, gbs_cmp
                    call daxpy(gbs, BSCEval(k), qp_Agphi(:,deca), 1, AT(:, col), 1)
                    col = col + 1
                end do
                deca = deca + 1
            end do
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    function transfo_A(ndim, A, row, col)
!
    implicit none
!
        integer, intent(in)         :: ndim
        real(kind=8), intent(in)    :: A(3,3,3,3)
        integer, intent(in)         :: row
        integer, intent(in)         :: col
        real(kind=8)                :: transfo_A(9)
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Extract the matrix A(:,:,row,col) and tranform in vector form
!   In ndim         : the current HHO Cell
!   In A            : elasto_plastic moduli
!   In row, col     : index
!   Out transfo_A   : vector extracted
! --------------------------------------------------------------------------------------------------
!
        integer :: i, j, ind
! --------------------------------------------------------------------------------------------------
!
        transfo_A = 0.d0
        ind = 1
!
        do i = 1, ndim
            do j = 1, ndim
                transfo_A(ind) = A(i, j, row, col)
                ind = ind + 1
            end do
        end do
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    function nbsigm_cmp(ndim)
!
    implicit none
!
        integer, intent(in) :: ndim
        integer             :: nbsigm_cmp
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Return the number of componant of the Cauchy stress tensor
!   In ndim         : the current HHO Cell
! --------------------------------------------------------------------------------------------------
!
        if(ndim == 2) then
            nbsigm_cmp = 4
        elseif(ndim == 3) then
            nbsigm_cmp = 6
        else
            ASSERT(ASTER_FALSE)
        endif
!
    end function
!
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoComputeAgphi(hhoCell, module_tang, BSCEval, gbs, weight, Agphi)
!
    implicit none
!
        type(HHO_Cell), intent(in)      :: hhoCell
        integer, intent(in)             :: gbs
        real(kind=8), intent(in)        :: module_tang(3,3,3,3)
        real(kind=8), intent(in)        :: BSCEval(MSIZE_CELL_SCAL)
        real(kind=8), intent(in)        :: weight
        real(kind=8), intent(out)       :: Agphi(MSIZE_CELL_MAT,9)
!
! -----------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the scalar product (module_tang, gphi)_T

!   In hhoCell      : the current HHO Cell
!   In module_tang  : elasto_plastic moduli

!   In BSCEval      : Basis of one composant gphi
!   In gbs          : number of cols of Aphi
!   In weight       : quadrature weight
!   Out Agphi       : matriw of scalar product
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: qp_module_tang(3,3,3,3), qp_mod_vec(9)
        integer :: i, j, row, col, gbs_cmp, dim2
! --------------------------------------------------------------------------------------------------
!
        Agphi = 0.d0
        dim2 = hhoCell%ndim * hhoCell%ndim
        gbs_cmp = gbs / dim2
        qp_module_tang = weight * module_tang
!
        row = 1
        col = 1
        do i = 1, hhoCell%ndim
            do j = 1, hhoCell%ndim
! ------------- Extract and transform the tangent moduli
                qp_mod_vec = transfo_A(hhoCell%ndim, qp_module_tang, i, j)
                call dger(gbs_cmp, dim2, 1.d0, BSCEval, 1, qp_mod_vec, 1,&
                           & Agphi(row:(row + gbs_cmp - 1), 1:dim2), gbs_cmp)
                row = row + gbs_cmp
            end do
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoCalculF(ndim, G, F)
!
    implicit none
!
        integer, intent(in)             :: ndim
        real(kind=8), intent(in)        :: G(3,3)
        real(kind=8), intent(out)       :: F(3,3)
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the matrix F = G +I
!   In ndim         : dimension
!   In G            : gradient
!   In F            : gradient of the deformation
! --------------------------------------------------------------------------------------------------
!
        integer :: idim
! --------------------------------------------------------------------------------------------------
!
        F = G
!
        do idim = 1, ndim
            F(idim,idim) = F(idim,idim) + 1.d0
        end do
!
! ---- ! be carrefull with c_plan, I don't know the result
        if (ndim == 2) then
            F(3,1:2) = 0.d0
            F(1:2,3) = 0.d0
            F(3,3)   = 1.d0
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoCalculGreenLagrange(ndim, F, GL, GLvec)
!
    implicit none
!
        integer, intent(in)             :: ndim
        real(kind=8), intent(in)        :: F(3,3)
        real(kind=8), intent(out), optional :: GL(3,3)
        real(kind=8), intent(out), optional :: GLvec(6)
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the matrix F = G +I
!   In ndim         : dimension
!   In F            : deformation gradient
!   In GL           : Green-Lagrange
!   In GLvec        : Green-Lagrange using Voigt Notation (XX, YY, ZZ, XY*rac2, XZ*rac2, YZ*rac2)
! --------------------------------------------------------------------------------------------------
!
        integer :: i, j, k
        real(kind=8) :: GL_(3,3)
        real(kind=8), parameter :: rac2 = sqrt(2.d0)
! --------------------------------------------------------------------------------------------------
!
! ---- Compute C/2 = F^T*F/2
!
        GL_ = 0.d0
        do j = 1, 3
            do i = 1, j
                do k = 1, 3
                    GL_(i,j) = GL_(i,j) + F(k,i) * F(k,j)
                end do
                GL_(i,j) = GL_(i,j) / 2.d0
                GL_(j,i) = GL_(i,j)
            end do
        end do
!
        do k = 1, 3
            GL_(k,k) = GL_(k,k) - 0.5d0
        end do
!
! ---- ! be carrefull with c_plan, I don't know the result
        if (ndim == 2) then
            GL_(3,1:3) = 0.d0
            GL_(1:2,3) = 0.d0
        end if
!
        if(present(GL)) then
            GL = GL_
        end if
!
! ---- convert GL in (XX, YY, ZZ, XY*rac2, XZ*rac2, YZ*rac2)
!
        if(present(GLvec)) then
            if(ndim == 2) then
                GLvec = (/ GL_(1,1), GL_(2,2), 0.d0, GL_(1,2)*rac2, 0.d0, 0.d0/)
            elseif(ndim == 3) then
                GLvec = (/ GL_(1,1), GL_(2,2), GL_(3,3), &
                           GL_(1,2)*rac2, GL_(1,3)*rac2, GL_(2,3)*rac2/)
            else
                ASSERT(ASTER_FALSE)
            endif
        end if
!
    end subroutine
!
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine select_behavior(behavior, l_gdeflog, l_grotgdepl, l_simo_miehe, l_hyperelas)
!
    implicit none
!
        character(len=16), intent(in)   :: behavior(*)
        aster_logical, intent(out)      :: l_gdeflog
        aster_logical, intent(out)      :: l_grotgdepl
        aster_logical, intent(out)      :: l_simo_miehe
        aster_logical, intent(out)      :: l_hyperelas
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Select the appropriate behavior
!   In behavior     : type of behavior
!   Out l_gdeflog   : use GDEF_LOG ?
!   Out l_grotgdepl : use GROT_GDEPL ?
!   Out l_simo_miehe: use SIMO_MIEHE ?
!   Out l_hyperelas : hyperlastic law ?
! --------------------------------------------------------------------------------------------------
!
        l_gdeflog    = ASTER_FALSE
        l_grotgdepl  = ASTER_FALSE
        l_simo_miehe = ASTER_FALSE
        l_hyperelas  = ASTER_FALSE
!
        select case (behavior(DEFO))
            case ('GDEF_LOG')
                l_gdeflog = ASTER_TRUE
            case ('GROT_GDEP')
                l_grotgdepl = ASTER_TRUE
            case ('SIMO_MIEHE')
                l_simo_miehe = ASTER_TRUE
            case default
                ASSERT(ASTER_FALSE)
        end select
!
        if (behavior(INCRELAS) .eq. 'COMP_ELAS') then
            l_hyperelas = ASTER_TRUE
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine gdeflog(BEHinteg, ndim, fami, typmod, imate, compor, option, carcri, lgpg, ipg, &
                       time_prev, time_curr, angmas, mult_comp, resi, rigi, cplan, &
                       F_prev, F_curr, sig_prev_pg, vi_prev_pg, sig_curr_pg, vi_curr_pg, &
                       PK1_curr, module_tang, cod, l_tang)
!
    implicit none
!
        type(Behaviour_Integ), intent(inout) :: BEHinteg
        integer, intent(in)             :: ndim
        character(len=*), intent(in)    :: fami
        character(len=8), intent(in)    :: typmod(*)
        integer, intent(in)             :: imate
        character(len=16), intent(in)   :: compor(*)
        character(len=16), intent(in)   :: option
        real(kind=8), intent(in)        :: carcri(*)
        integer, intent(in)             :: lgpg
        integer, intent(in)             :: ipg
        real(kind=8), intent(in)        :: time_prev
        real(kind=8), intent(in)        :: time_curr
        real(kind=8), intent(in)        :: angmas(*)
        character(len=16), intent(in)   :: mult_comp
        aster_logical, intent(in)       :: resi
        aster_logical, intent(in)       :: rigi
        aster_logical, intent(in)       :: cplan
        real(kind=8), intent(in)        :: F_prev(3,3)
        real(kind=8), intent(in)        :: F_curr(3,3)
        real(kind=8), intent(in)        :: sig_prev_pg(2*ndim)
        real(kind=8), intent(in)        :: vi_prev_pg(lgpg)
        real(kind=8), intent(out)       :: sig_curr_pg(2*ndim)
        real(kind=8), intent(out)       :: vi_curr_pg(lgpg)
        real(kind=8), intent(out)       :: PK1_curr(3,3)
        real(kind=8), intent(out)       :: module_tang(3,3,3,3)
        integer, intent(out)            :: cod
        aster_logical, intent(in)       :: l_tang
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the behavior laws for GDEF_LOF
!   IO BEHinteg     : integration informations
!   In ndim         : dimension of the problem
!   In fami         : familly of quadrature points
!   In typmod       : type of modelization
!   In imate        : materiau code
!   In compor       : type of behavior
!   In option       : option of computations
!   In carcri       : local criterion of convergence
!   In lgpg         : size of internal variables for 1 pg
!   In ipg          : i-th quadrature point
!   In time_prev    : previous time T-
!   In time_curr    : current time T+
!   In angmas       : LES TROIS ANGLES DU MOT_CLEF MASSIF
!   In multcomp     : ?
!   In resi         : TRUE. SI FULL_MECA/RAPH_MECA .FALSE. SI RIGI_MECA_TANG
!   In rigi         : TRUE. SI FULL_MECA/RIGI_MECA .FALSE. SI RAPH_MECA_TANG
!   In cplan        : plane stress hypothesis
!   In F_prev       : previous deformation gradient at T-
!   In F_curr       : curr deformation gradient at T+
!   In sig_prev_pg  : cauchy stress at T-  (XX, YY, ZZ, XY, XZ, YZ)
!   In vi_prev_pg   : internal variables at T-
!   Out sig_curr    : cauchy stress at T+  (XX, YY, ZZ, XY, XZ, YZ)
!   Out vi_curr     : internal variables at T+
!   Out Pk1_curr    : piola-kirschooff 1 at T+
!   Out module_tang : tangent modulus dPK1/dF(Fp)
!   Out cod         : info on integration of the LDC
!   In  l_tang      : compute tangent modulus ?
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: gn(3,3), lamb(3), logl(3), epsml(6), deps(6), tn(6), tp(6)
        real(kind=8) :: dtde(6, 6), PK2_prev(6), PK2_curr(6)
        real(kind=8) :: dpk2dc(6,6), me(3,3,3,3)
!
! ----- Compute pre-processing Elog
!
        call prelog(ndim, lgpg, vi_prev_pg, gn, lamb, logl, F_prev, F_curr,&
                    epsml, deps, tn, resi, cod)
!
        if (cod .ne. 0) goto 999
!
! ----- Compute Stress and module_tangent
!
        dtde = 0.d0
        tp = 0.d0
        call nmcomp(BEHinteg  , fami      , ipg       , 1     , ndim     , typmod,&
                    imate     , compor    , carcri, time_prev, time_curr,&
                    6         , epsml     , deps  , 6        , tn    ,&
                    vi_prev_pg, option    , angmas, &
                    tp        , vi_curr_pg, 36    , dtde     , cod       , mult_comp)
!
! ----- Test the code of the LDC
!
        if (cod .eq. 1) goto 999
!
! ----- Compute post-processing Elog
!
        call poslog(resi       , rigi       , tn      , tp      , F_prev ,&
                    lgpg       , vi_curr_pg , ndim    , F_curr  , ipg    ,&
                    dtde       , sig_prev_pg, cplan   , fami    , imate  ,&
                    time_curr  , angmas     , gn      , lamb    , logl   ,&
                    sig_curr_pg, dpk2dc     , PK2_prev, PK2_curr, cod)
!
! ----- Test the code of the LDC
!
        if (cod .ne. 0) goto 999
!
        if(.not. resi) then
            PK2_curr = PK2_prev
        end if
!
! ----- Compute PK1
!
        call pk2topk1(ndim, PK2_curr, F_curr, Pk1_curr)
!
        if(l_tang) then
!
! ----- Unpack lagrangian tangent modulus
!
            call desymt46(dpk2dc, me)
!
! ----- Compute nominal tangent modulus
!
            call lagmodtonommod(me, PK2_curr, F_curr, module_tang)
        end if
!
999 continue
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hyperelas(BEHinteg, ndim, fami, typmod, imate, compor, option, carcri, ipg, &
                         angmas, F, sig_pg, vi_pg, pk1, module_tang, cod, l_tang)
!
    implicit none
!
        type(Behaviour_Integ), intent(inout) :: BEHinteg
        integer, intent(in)             :: ndim
        character(len=*), intent(in)    :: fami
        character(len=8), intent(in)    :: typmod(*)
        integer, intent(in)             :: imate
        character(len=16), intent(in)   :: compor(*)
        character(len=16), intent(in)   :: option
        real(kind=8), intent(in)        :: carcri(*)
        integer, intent(in)             :: ipg
        real(kind=8), intent(in)        :: angmas(*)
        real(kind=8), intent(in)        :: F(3,3)
        real(kind=8), intent(out)       :: sig_pg(2*ndim)
        real(kind=8), intent(out)       :: vi_pg(*)
        real(kind=8), intent(out)       :: pk1(3,3)
        real(kind=8), intent(out)       :: module_tang(3,3,3,3)
        integer, intent(out)            :: cod
        aster_logical, intent(in)       :: l_tang
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the local contribution for mechanics in large deformations
!   IO BEHinteg     : integration informations
!   In ndim          : dimension of the problem
!   In fami         : familly of quadrature points
!   In typmod       : type of modelization
!   In imate        : materiau code
!   In compor       : type of behavior
!   In option       : option of computations
!   In carcri       : local criterion of convergence
!   In ipg          : i-th quadrature point
!   In angmas       : LES TROIS ANGLES DU MOT_CLEF MASSIF
!   In F            : deformation gradient
!   Out vi_pg       : internal variables
!   Out sig_pg      : stress   (XX, YY, ZZ, XY, XZ, YZ)
!   Out Pk1         : piola-kirschooff 1
!   Out module_tang : tangent modulus dPk1/dF
!   Out cod         : info on integration of the LDC
!   In  l_tang      : compute tangent modulus ?
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: GL(6), dpk2dc(6,6), me(3,3,3,3), pk2(6), detF
        character(len=1) :: poum
!
        if (option(1:10) .eq. 'RIGI_MECA_') then
            poum = '-'
        else
            poum = '+'
        end if
!
! ----- Compute pre-processing E (Green-Lagrange)
!
        call hhoCalculGreenLagrange(ndim, F, GLvec=GL)
!
! ----- Compute Stress PK2(C) and module_tangent dPk2dc(C)
!
        call nmcpel(BEHinteg, fami, ipg, 1, poum, 3, typmod, angmas, imate, compor, &
                    carcri, option, GL, pk2, vi_pg, dpk2dc, cod)
!
! ----- Test the code of the LDC
!
        if (cod .ne. 0) goto 999
!
! ----- Compute Cauchy stress and save them
!
        call lcdetf(ndim, F, detF)
        call pk2sig(ndim, F, detF, pk2, sig_pg, 1)
!
! ----- Compute PK1
!
        call pk2topk1(ndim, pk2, F, pk1)
!
        if(l_tang) then
!
! ----- Unpack lagrangian tangent modulus
!
            call desymt46(dpk2dc, me)
!
! ----- Compute nominal tangent modulus
!
            call lagmodtonommod(me, pk2, F, module_tang)
        end if
!
999 continue
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine grotgdepl(BEHinteg, ndim, fami, typmod, imate, compor, option, carcri, lgpg, ipg, &
                       time_prev, time_curr, mult_comp, resi, &
                       F_prev, F_curr, sig_prev_pg, vi_prev_pg, sig_curr_pg, vi_curr_pg, &
                       PK1_curr, module_tang, cod, l_tang)
!
    implicit none
!
        type(Behaviour_Integ), intent(inout) :: BEHinteg
        integer, intent(in)             :: ndim
        character(len=*), intent(in)    :: fami
        character(len=8), intent(in)    :: typmod(*)
        integer, intent(in)             :: imate
        character(len=16), intent(in)   :: compor(*)
        character(len=16), intent(in)   :: option
        real(kind=8), intent(in)        :: carcri(*)
        integer, intent(in)             :: lgpg
        integer, intent(in)             :: ipg
        real(kind=8), intent(in)        :: time_prev
        real(kind=8), intent(in)        :: time_curr
        character(len=16), intent(in)   :: mult_comp
        aster_logical, intent(in)       :: resi
        real(kind=8), intent(in)        :: F_prev(3,3)
        real(kind=8), intent(in)        :: F_curr(3,3)
        real(kind=8), intent(in)        :: sig_prev_pg(2*ndim)
        real(kind=8), intent(in)        :: vi_prev_pg(lgpg)
        real(kind=8), intent(out)       :: sig_curr_pg(2*ndim)
        real(kind=8), intent(out)       :: vi_curr_pg(lgpg)
        real(kind=8), intent(out)       :: PK1_curr(3,3)
        real(kind=8), intent(out)       :: module_tang(3,3,3,3)
        integer, intent(out)            :: cod
        aster_logical, intent(in)       :: l_tang
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   Compute the behavior laws for GROT_GDEPL
!   IO BEHinteg     : integration informations
!   In ndim         : dimension of the problem
!   In fami         : familly of quadrature points
!   In typmod       : type of modelization
!   In imate        : materiau code
!   In compor       : type of behavior
!   In option       : option of computations
!   In carcri       : local criterion of convergence
!   In lgpg         : size of internal variables for 1 pg
!   In ipg          : i-th quadrature point
!   In time_prev    : previous time T-
!   In time_curr    : current time T+
!   In multcomp     : ?
!   In resi         : TRUE. SI FULL_MECA/RAPH_MECA .FALSE. SI RIGI_MECA_TANG
!   In F_prev       : previous deformation gradient at T-
!   In F_curr       : curr deformation gradient at T+
!   In sig_prev_pg  : cauchy stress at T-  (XX, YY, ZZ, XY, XZ, YZ)
!   In vi_prev_pg   : internal variables at T-
!   Out sig_curr    : cauchy stress at T+  (XX, YY, ZZ, XY, XZ, YZ)
!   Out vi_curr     : internal variables at T+
!   Out Pk1_curr    : piola-kirschooff 1 at T+
!   Out module_tang : tangent modulus dPK1/dF(Fp)
!   Out cod         : info on integration of the LDC
!   In  l_tang      : compute tangent modulus ?
! --------------------------------------------------------------------------------------------------
!
        real(kind=8) :: GL_prev(6), GL_curr(6), GL_incr(6), dpk2dc(6,6), me(3,3,3,3), detF_prev
        real(kind=8) :: maxeps, PK2_prev(6), PK2_curr(6), detF_curr, sig(6)
        real(kind=8), parameter :: rac2 = sqrt(2.d0)
        real(kind=8) :: angmas(1:3)
        integer :: jstrainexte
!
        angmas(1:3) = r8nnem()
!
! ----- Get coded integer for external state variable
!
        jstrainexte = nint(carcri(ISTRAINEXTE))
!
! ----- Compute PK2 at T-
!
        PK2_prev = 0.d0
        sig = 0.d0
        sig(1:2*ndim) = sig_prev_pg(1:2*ndim)
        call lcdetf(ndim, F_prev, detF_prev)
        call pk2sig(ndim, F_prev, detF_prev, PK2_prev, sig, -1)
        PK2_prev(4:6) = PK2_prev(4:6) * rac2
!
! ----- Compute behaviour
!
        PK2_curr = 0.d0
        dpk2dc = 0.d0
        if ((jstrainexte .eq. MFRONT_STRAIN_GROTGDEP_S) .or. (jstrainexte .eq. 0)) then
!
! --------- Compute pre-processing E (Green-Lagrange)
!
            call hhoCalculGreenLagrange(ndim, F_prev, GLvec=GL_prev)
            call hhoCalculGreenLagrange(ndim, F_curr, GLvec=GL_curr)
            GL_incr = GL_curr - GL_prev
!
! --------- Check "small strains"
!
            maxeps = abs(maxval(GL_incr))
            if ((maxeps .gt. 0.05d0) .and. (compor(RELA_NAME) .ne. 'ELAS')) then
                call utmess('A', 'COMPOR2_9', sr=maxeps)
            endif
!
! --------- Compute behaviour
!
            call nmcomp(BEHinteg  , fami      , ipg       , 1      , ndim     , typmod   ,&
                        imate     , compor    , carcri , time_prev, time_curr,&
                        6         , GL_prev   , GL_incr, 6        , PK2_prev ,&
                        vi_prev_pg, option    , angmas , &
                        PK2_curr  , vi_curr_pg, 36     , dpk2dc   , cod       , mult_comp)
        elseif (jstrainexte .eq. MFRONT_STRAIN_GROTGDEP_L) then
            call nmcomp(BEHinteg  , fami      , ipg       , 1      , ndim     , typmod   ,&
                        imate     , compor    , carcri , time_prev, time_curr,&
                        9         , F_prev    , F_curr , 6        , PK2_prev ,&
                        vi_prev_pg, option    , angmas , &
                        PK2_curr  , vi_curr_pg, 36     , dpk2dc   , cod       , mult_comp)
        else
            ASSERT(.false.)
        endif
!
! ----- Test the code of the LDC
!
        if (cod .ne. 0) goto 999
!
        if(.not. resi) then
            PK2_curr = PK2_prev
        end if
!
! ----- Compute Cauchy stress and save them
!
        call lcdetf(ndim, F_curr, detF_curr)
        call pk2sig(ndim, F_curr, detF_curr, PK2_curr, sig_curr_pg, 1)
!
! ----- Compute PK1
!
        call pk2topk1(ndim, PK2_curr, F_curr, PK1_curr)
!
        if(l_tang) then
!
! ----- Unpack lagrangian tangent modulus
            call desymt46(dpk2dc, me)
!
! ----- Compute nominal tangent modulus
!
            call lagmodtonommod(me, PK2_curr, F_curr, module_tang)
        end if
!
999 continue
!
    end subroutine
!
end module
