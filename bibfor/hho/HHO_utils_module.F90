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
module HHO_utils_module
!
use HHO_type
use HHO_size_module
!
implicit none
!
private
#include "asterf_types.h"
#include "asterc/r8prem.h"
#include "asterfort/HHO_size_module.h"
#include "asterfort/assert.h"
#include "asterfort/dismoi.h"
#include "asterfort/exisd.h"
#include "asterfort/jevech.h"
#include "asterfort/symt46.h"
#include "asterfort/getResuElem.h"
#include "blas/dcopy.h"
#include "jeveux.h"
!
! --------------------------------------------------------------------------------------------------
!
! HHO - utilitaries
!
! Some common utilitaries
!
! --------------------------------------------------------------------------------------------------
    public :: hhoCopySymPartMat, hhoPrintMat, hhoNorm2Mat, hhoProdSmatVec
    public :: hhoPrintTensor4, hhoPrintTensor4Mangle
    public :: hhoGetTypeFromModel, MatScal2Vec
    public :: SigVec2Mat, hhoGetMatrElem
!    private  ::
!
contains
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGetTypeFromModel(model, hhoData, ndim)
!
    implicit none
!
        character(len=8), intent(in) :: model
        type(HHO_Data), intent(out)  :: hhoData
        integer, intent(out)         :: ndim
!
! --------------------------------------------------------------------------------------------------
!
! HHO - Utilities
!
! Get type from model
!
! --------------------------------------------------------------------------------------------------
!
! In  model            : name of model
! Out hhoData          : information about the HHO formulation
! Out ndim             : topogical dimension of the HHO formulation
! --------------------------------------------------------------------------------------------------
!
        character(len=8) :: answer
!
        call dismoi('EXI_HHO', model, 'MODELE', repk=answer)
        if (answer .eq. 'OUI') then
            call dismoi('EXI_HHO010', model, 'MODELE', repk=answer)
            if (answer .eq. 'OUI') then
                call hhoData%initialize(0,1,0,ASTER_FALSE,0.d0,ASTER_FALSE,ASTER_FALSE,ASTER_FALSE)
            else
                call dismoi('EXI_HHO111', model, 'MODELE', repk=answer)
                if (answer .eq. 'OUI') then
                    call hhoData%initialize(1,1,1,ASTER_FALSE,0.d0,ASTER_FALSE,ASTER_FALSE, &
                                           ASTER_FALSE)
                else
                    call dismoi('EXI_HHO222', model, 'MODELE', repk=answer)
                    if (answer .eq. 'OUI') then
                        call hhoData%initialize(2,2,2,ASTER_FALSE,0.d0,ASTER_FALSE,ASTER_FALSE, &
                                                ASTER_FALSE)
                    else
                        call dismoi('EXI_HHO121', model, 'MODELE', repk=answer)
                        if (answer .eq. 'OUI') then
                            call hhoData%initialize(1,2,1,ASTER_FALSE,0.d0,ASTER_FALSE,ASTER_FALSE,&
                                                    ASTER_FALSE)
                        else
                            call dismoi('EXI_HHO232', model, 'MODELE', repk=answer)
                            if (answer .eq. 'OUI') then
                                call hhoData%initialize(2,3,2,ASTER_FALSE,0.d0,ASTER_FALSE,&
                                                        ASTER_FALSE, ASTER_FALSE)
                            else
                                ASSERT(ASTER_FALSE)
                            end if
                        end if
                    endif
                endif
            endif
        else
            ASSERT(ASTER_FALSE)
        endif
!
        ndim = 0
        call dismoi('DIM_GEOM', model, 'MODELE', repi=ndim)
        ASSERT(ndim == 2 .or. ndim == 3)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoCopySymPartMat(uplo, mat, size_mat)
!
    implicit none
!
        character(len=1), intent(in)                :: uplo
        real(kind=8), dimension(:,:), intent(inout) :: mat
        integer, intent(in), optional               :: size_mat
!
! --------------------------------------------------------------------------------------------------
!
!   Copy the other part of a symetric matrix
!   In uplo     : 'L' the lower part is given or 'U' for the upper part
!   In size     : size of the matrix
!   Inout mat   : matrix to copy
! --------------------------------------------------------------------------------------------------
!
        integer :: ncols, nrows, i
!
        if (present(size_mat)) then
            nrows = size_mat
            ncols = size_mat
        else
            nrows = size(mat,1)
            ncols = size(mat,2)
        end if
!
        ASSERT(nrows == ncols)
!
        if(uplo == 'L') then
            do i = 1, ncols - 1
                mat(i, i+1:ncols) = mat(i+1:ncols, i)
            end do
        elseif(uplo == 'U') then
            do i = 1, ncols - 1
                mat(i+1:ncols, i) = mat(i, i+1:ncols)
            end do
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoPrintMat(mat)
!
    implicit none
!
        real(kind=8), dimension(:,:), intent(in) :: mat
!
! --------------------------------------------------------------------------------------------------
!
!   print matrix
!   In mat   : matrix to print
! --------------------------------------------------------------------------------------------------
!
        integer :: ncols, nrows, i
!
        nrows = size(mat,1)
        ncols = size(mat,2)
!
!
        write(6,*) "matrix of", nrows, "rows x ", ncols, "cols"
        do i = 1, nrows
            write(6,'(50F13.6)') mat(i, 1:ncols)
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoPrintTensor4(tens)
!
    implicit none
!
        real(kind=8), dimension(3,3,3,3), intent(in) :: tens
!
! --------------------------------------------------------------------------------------------------
!
!   print fourth order tensor
!   In tens   : tensor to print
! --------------------------------------------------------------------------------------------------

!
        integer :: i, k
!
!
        write(6,*) "tensor of 9 rows x 9 cols"
        do i = 1, 3
            do k = 1, 3
                write(6,'(50F14.7)')    tens(i,1,k,1), tens(i,1,k,2), tens(i,1,k,3), &
                                    &   tens(i,2,k,1), tens(i,2,k,2), tens(i,2,k,3), &
                                    &   tens(i,3,k,1), tens(i,3,k,2), tens(i,3,k,3)
            end do
        end do
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoPrintTensor4Mangle(tens)
!
    implicit none
!
        real(kind=8), dimension(3,3,3,3), intent(in) :: tens
!
! --------------------------------------------------------------------------------------------------
!
!   print fourth order tensor
!   In tens   : tensor to print
! --------------------------------------------------------------------------------------------------

!
        real(kind=8) :: tens6(6,6)
!
        tens6 = 0.d0
        call symt46(tens, tens6)
        call hhoPrintMat(tens6)
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    function hhoNorm2Mat(mat) result(norm)
!
    implicit none
!
        real(kind=8), dimension(:,:), intent(in)    :: mat
        real(kind=8)                                :: norm
!
! --------------------------------------------------------------------------------------------------
!
!   compute the frobenius-norm of a matrix
!   In mat   : matrix to evaluate
! --------------------------------------------------------------------------------------------------
!
        integer :: nrows, ncols, irow, jcol
!
        nrows = size(mat,1)
        ncols = size(mat,2)
!
        norm = 0.d0
        do jcol = 1, ncols
            do irow = 1, nrows
                norm =  norm + mat(irow, jcol)**2
            end do
        end do
!
        norm = sqrt(norm)
!
    end function
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoProdSmatVec(SymMat, vect, ndim, resu)
!
    implicit none
!
        real(kind=8), dimension(6), intent(in) :: SymMat
        real(kind=8), dimension(3), intent(in) :: vect
        integer, intent(in)                    :: ndim
        real(kind=8), dimension(3), intent(out):: resu
!
! --------------------------------------------------------------------------------------------------
!
!   evaluate the product of a symetrix matrix with a vector
!   In SymMat       : symmetric matrix (M11, M22, M33, Rac2*M12, Rac2*M13, Rac2*M23)
!   In vector       : vector
!   In ndim         : dim of the matrix
!   Out resu        : result of the product
! --------------------------------------------------------------------------------------------------
!
        real(kind=8), parameter :: rac2 = sqrt(2.d0)
!
        resu = 0.d0
!
        if(ndim == 2) then
            resu(1) = SymMat(1) * vect(1) + SymMat(4) / rac2 * vect(2)
            resu(2) = SymMat(2) * vect(2) + SymMat(4) / rac2 * vect(1)
        else if(ndim == 3) then
            resu(1) = SymMat(1) * vect(1) + (SymMat(4) * vect(2) + SymMat(5) * vect(3) ) / rac2
            resu(2) = SymMat(2) * vect(2) + (SymMat(4) * vect(1) + SymMat(6) * vect(3) ) / rac2
            resu(3) = SymMat(3) * vect(3) + (SymMat(5) * vect(1) + SymMat(6) * vect(2) ) / rac2
        else
            ASSERT(ASTER_FALSE)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine SigVec2Mat(ndim, sigvec, sigmat)
!
    implicit none
!
        integer, intent(in)             :: ndim
        real(kind=8), intent(in)        :: sigvec(*)
        real(kind=8), intent(out)       :: sigmat(3,3)
!
! --------------------------------------------------------------------------------------------------
!   HHO - mechanics
!
!   tranform the Cauchy stress for a vector to a matrix
!   In ndim         : dimension of the problem
!   In sigvec       : Stress to transform (XX YY ZZ SQRT(2)*XY SQRT(2)*XZ SQRT(2)*YZ)
!   Out sigmat      : Stress matrix
! --------------------------------------------------------------------------------------------------
! --------------------------------------------------------------------------------------------------
!
        sigmat = 0.d0
!
        sigmat(1,1) = sigvec(1)
        sigmat(2,2) = sigvec(2)
        sigmat(3,3) = sigvec(3)
!
        sigmat(1,2) = sigvec(4)
        sigmat(2,1) = sigmat(1,2)
!
        if(ndim == 3) then
            sigmat(1,3) = sigvec(5)
            sigmat(3,1) = sigmat(1,3)
            sigmat(2,3) = sigvec(6)
            sigmat(3,2) = sigmat(2,3)
        end if
!
    end subroutine
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine hhoGetMatrElem(matr_elem, resu_elem, isym)
!
    implicit none
!
        character(len=19), intent(in)  :: matr_elem
        character(len=19), intent(out) :: resu_elem
        integer, intent(out)           :: isym
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Get name of matr_elem and if is a symmetric matrix
!   In matr_elem    : name of MATR_ELEM
!   Out resu_elem   : name of RESU_ELEM
!   Out isym        : -1 -> MATR_ELEM does not exist
!                   : 1  -> MATR_ELEM is symmetric
!                   : 0  -> MATR_ELEM is unsymmetric
! --------------------------------------------------------------------------------------------------
!
        integer :: iret
        character(len=8) :: nomgd
!
! --------------------------------------------------------------------------------------------------
!
        resu_elem = getResuElem(matr_elem_=matr_elem)
        isym = -1
!
        if (resu_elem .ne. ' ') then
            call exisd('RESUELEM', resu_elem, iret)
            if (iret == 1) then
                call dismoi('NOM_GD', resu_elem, 'RESUELEM', repk=nomgd)
                if (nomgd == 'MDNS_R') then
                    isym = 0
                elseif (nomgd == 'MDEP_R') then
                    isym = 1
                else
                    ASSERT(ASTER_FALSE)
                end if
            else
                ASSERT(ASTER_FALSE)
            endif
        endif
!
    end subroutine
!
!
!===================================================================================================
!
!===================================================================================================
!
    subroutine MatScal2Vec(hhoCell, hhoData, mat_scal, mat_vec)
!
    implicit none
!
        type(HHO_Cell), intent(in)  :: hhoCell
        type(HHO_Data), intent(in)  :: hhoData
        real(kind=8), intent(in)    :: mat_scal(MSIZE_TDOFS_SCAL,MSIZE_TDOFS_SCAL)
        real(kind=8), intent(out)   :: mat_vec(MSIZE_TDOFS_VEC,MSIZE_TDOFS_VEC)
!
! --------------------------------------------------------------------------------------------------
!   HHO
!
!   Create the vectorial matrix by tensorization of the scalar matrix
!   In hhoCell      : the current HHO Cell
!   In hhoData      : information on HHO methods
!   In mat_scal     : matrix for the scalar problem
!   Out mat_vec     : matrix for the vectorial problem
!
! --------------------------------------------------------------------------------------------------
!
        integer :: cbs_comp, fbs_comp, cbs, fbs, jbeginVec, jendVec
        integer :: total_dofs, idim, jbeginCell, jendCell, jbeginFace, jendFace, iFace
        integer :: jFace, ibeginFace, iendFace, ibeginVec, iendVec
! --------------------------------------------------------------------------------------------------
!
! -- number of dofs
        call hhoMecaDofs(hhoCell, hhoData, cbs, fbs, total_dofs)
!
        cbs_comp = cbs / hhoCell%ndim
        fbs_comp = fbs / hhoCell%ndim
!
! -- copy the scalar matrix in the vectorial matrix
        mat_vec = 0.d0
!
        do idim = 1, hhoCell%ndim
! --------- copy volumetric part
            jbeginCell = (idim - 1) * cbs_comp + 1
            jendCell = jbeginCell + cbs_comp - 1
!
            mat_vec(jbeginCell:jendCell, jbeginCell:jendCell) = mat_scal(1:cbs_comp, 1:cbs_comp)
!
! --------- copy faces part
            do iFace = 1, hhoCell%nbfaces
                ibeginFace = cbs + (iFace - 1) * fbs + (idim - 1) * fbs_comp + 1
                iendFace = ibeginFace + fbs_comp - 1
                ibeginVec = cbs_comp + (iFace - 1) * fbs_comp + 1
                iendVec = ibeginVec + fbs_comp - 1

                do jFace = 1, hhoCell%nbfaces
                    jbeginFace = cbs + (jFace - 1) * fbs + (idim - 1) * fbs_comp + 1
                    jendFace = jbeginFace + fbs_comp - 1
                    jbeginVec = cbs_comp + (jFace - 1) * fbs_comp + 1
                    jendVec = jbeginVec + fbs_comp - 1
!
                    mat_vec(ibeginFace:iendFace, jbeginFace:jendFace) &
                                = mat_scal(ibeginVec:iendVec, jbeginVec:jendVec)
                end do
!
! --------- copy coupled part
                mat_vec(jbeginCell:jendCell, ibeginFace:iendFace) &
                                = mat_scal(1:cbs_comp, ibeginVec:iendVec)
                mat_vec(ibeginFace:iendFace, jbeginCell:jendCell) &
                                = mat_scal(ibeginVec:iendVec, 1:cbs_comp)
            end do
        end do
!
    end subroutine
!
end module
