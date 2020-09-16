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

subroutine matr_asse_set_values(matasz, dim, idx, jdx, values)
! person_in_charge: nicolas.tardieu at edf.fr
use sort_module
    implicit none
#include "jeveux.h"
#include "asterfort/assert.h"
#include "asterfort/detrsd.h"
#include "asterfort/dismoi.h"
#include "asterfort/jedema.h"
#include "asterfort/jedetr.h"
#include "asterfort/jeexin.h"
#include "asterfort/jemarq.h"
#include "asterfort/jeveuo.h"
#include "asterfort/jelira.h"
#include "asterfort/jeecra.h"
#include "asterfort/jecrec.h"
#include "asterfort/jecroc.h"
#include "asterfort/jedupo.h"
#include "asterfort/jelibe.h"
#include "asterfort/jexnum.h"
#include "asterfort/utmess.h"
#include "asterfort/wkvect.h"
#include "asterfort/as_deallocate.h"
#include "asterfort/as_allocate.h"

    character(len=*) :: matasz
    integer :: idx(*), jdx(*), dim
    real(kind=8) :: values(*)
!-----------------------------------------------------------------------
! Goal : replace and set the values of an assembly matrix.
!        The new values are in coordinate format (i, j, aij). The matrix  
!        must be stored in CSR format.
!        There is no rule for the indices - they can be in arbitrary
!        order and can be repeated. Repeated indices are sumed according
!        to an assembly process.
!
!  matas : name of the assembly matrix
!  dim   : size of the indices and values arrrays
!  idx   : array of the row indices
!  jdx   : array of the column indices
!  idx   : array of the values
!
!-----------------------------------------------------------------------


    character(len=19) :: matass, kstoc
    character(len=1) :: bas1
    character(len=3) :: tysca
    integer :: i,k,n1,ier, neq, nterms, ierr, n_smdi
    character(len=24), pointer :: refa(:) => null()
    integer, pointer :: smde(:) => null()
    integer, pointer :: smdi(:) => null()
    integer(kind=4), pointer :: smhc(:) => null()
    real(kind=8), pointer :: valm1(:) => null()
    real(kind=8), pointer :: valm2(:) => null()
    integer, pointer :: idx_new(:) => null() 
    integer, pointer :: jdx_new(:) => null() 
    integer, pointer :: sum_ij(:) => null() 
    real(kind=8), pointer :: v_up(:) => null() 
    real(kind=8), pointer :: v_low(:) => null() 
    integer, dimension(:), pointer :: pv => null()
    integer, dimension(:), allocatable, target :: ibuffer 
    !-------------------------------------------------------------------
    call jemarq()
    matass=matasz
    call jelira(matass//'.VALM', 'NUTIOC', n1)
    ASSERT(n1.eq.1 .or. n1.eq.2)

    call jeveuo(matass//'.REFA', 'E', vk24=refa)
    call jelira(matass//'.VALM', 'CLAS', cval=bas1)
    call jelira(matass//'.VALM', 'TYPE', cval=tysca)
    ASSERT(tysca=='R')

    ! storage of the matrix
    kstoc=refa(2)(1:14)//'.SMOS'
    call jeexin(kstoc//'.SMDI', ier)
    if (ier .eq. 0) then
        call utmess('F', 'ALGELINE3_8', sk=matass)
    endif
    ! information on storage
    call jeveuo(kstoc//'.SMDE', 'L', vi=smde)
    neq=smde(1)

    ! Add diagonal terms
    ! ------------------
    AS_ALLOCATE(vi=idx_new, size=dim+neq)
    AS_ALLOCATE(vi=jdx_new, size=dim+neq)
    AS_ALLOCATE(vr=v_up, size=dim+neq)
    AS_ALLOCATE(vr=v_low, size=dim+neq)


    ! Symmetrize profile 
    ! ------------------
    ! 1. Since all diagonal terms must be stored, we extend all the arrays by neq terms to 
    !    set them to 0
    ! 2. We duplicate the values array in order to store the upper and lower diagonal terms
    !    since, in code_aster, sparse matrices are stored this way with *symmetric profile*
    do i=1,dim
        if (idx(i) < jdx(i)) then 
            idx_new(i) = idx(i)
            jdx_new(i) = jdx(i)
            v_up(i) = values(i)
            v_low(i) = 0.D0
        else if (idx(i) > jdx(i)) then 
            idx_new(i) = jdx(i)
            jdx_new(i) = idx(i)
            v_up(i) = 0.D0
            v_low(i) = values(i)
        else if (idx(i) == jdx(i)) then 
            idx_new(i) = jdx(i)
            jdx_new(i) = idx(i)
            v_up(i) = values(i)
            v_low(i) = values(i)
        endif
    enddo
    ! here diagonal terms are if needed set to 0 (i-1 because 0-based index is used)
    do i=1,neq
        idx_new(dim+i) = i-1
        jdx_new(dim+i) = i-1
        v_up(dim+i) = 0.D0
        v_low(dim+i) = 0.D0
    enddo

    ! Sum duplicates
    ! --------------
    ! Super hack : to sort the row (idx) first and then the column (jdx) in a single process, 
    !              we define a new index array containing 10*max(row)*row + col and we sort it
    AS_ALLOCATE(vi=sum_ij,size=dim+neq)
    sum_ij=10*maxval(jdx_new(1:dim+neq))*jdx_new(1:dim+neq) + idx_new(1:dim+neq)
    allocate(ibuffer(dim+neq), stat = ierr )
    pv=>ibuffer(1:dim+neq)
    call qsort_i8(sum_ij, pv)

    ! reorder the arrays 
    idx_new(1:dim+neq)=idx_new(pv)
    jdx_new(1:dim+neq)=jdx_new(pv)
    v_up(1:dim+neq)=v_up(pv)
    v_low(1:dim+neq)=v_low(pv)

    ! sum the duplicates 
    k=1
    do i=2, dim+neq
        if ( (idx_new(k) .ne. idx_new(i)) .or. (jdx_new(k)) .ne. jdx_new(i)) then
            k=k+1
            idx_new(k) = idx_new(i)
            jdx_new(k) = jdx_new(i)
            v_up(k) = v_up(i)
            v_low(k) = v_low(i)
        else
            v_up(k) = v_up(k) + v_up(i)
            v_low(k) = v_low(k) + v_low(i)
        endif
    enddo
    nterms = k

    ! Compute profile
    ! ---------------
    k=1
    do i=1, nterms
        if (idx_new(i)==jdx_new(i)) then
            jdx_new(k)=i
            k=k+1
        endif
    enddo
    n_smdi = k-1


    ! Copy matrix to aster
    ! ---------------------
    ! Destroy the storage and the values
    call jedetr(kstoc//'.SMDI')
    call jedetr(kstoc//'.SMHC')
    call jedetr(matass//'.VALM')

    ! Rebuild the storage
    call wkvect(kstoc//'.SMDI',bas1//' V I', n_smdi, vi=smdi)
    call wkvect(kstoc//'.SMHC',bas1//' V S', nterms, vi4=smhc)
    call jeveuo(kstoc//'.SMDE', 'L', vi=smde)
    smde(2)=n_smdi

    ! Rebuild the values
    call jecrec(matass//'.VALM', bas1//' V '//tysca, 'NU', 'DISPERSE',&
                'CONSTANT', 2)
    call jeecra(matass//'.VALM', 'LONMAX', nterms)
    call jecroc(jexnum(matass//'.VALM', 1))
    call jeveuo(jexnum(matass//'.VALM', 1),'E',vr=valm1)
    call jecroc(jexnum(matass//'.VALM', 2))
    call jeveuo(jexnum(matass//'.VALM', 2),'E',vr=valm2)

    ! Copy the values (switch from 0 to 1-based index)
    do i=1, nterms
        smhc(i)=int(idx_new(i)+1, 4)
        valm1(i) = v_up(i)
        valm2(i) = v_low(i)
    enddo
    do i=1, n_smdi
        smdi(i)=int(jdx_new(i),4)
    enddo

    ! Set the matrix as non-symmetric
    refa(9)='MR'

    ! if kinematic load, they are not taken into account in the new matrix 
    if (refa(3).ne.' ') then 
        refa(3)='ELIML'
        call jedetr(matass//'.CCVA')
    endif

    ! Clear allocation
    AS_DEALLOCATE( vi=idx_new )
    AS_DEALLOCATE( vi=jdx_new )
    AS_DEALLOCATE( vr=v_up )
    AS_DEALLOCATE( vr=v_low )
    AS_DEALLOCATE( vi=sum_ij )
    deallocate( ibuffer )

    call jedema()
end subroutine
