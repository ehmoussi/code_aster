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
subroutine te0448(option, nomte)
!
implicit none
!
#include "asterf_types.h"
#include "asterfort/assert.h"
#include "asterfort/jevech.h"
#include "asterfort/tecach.h"
#include "asterfort/utmess.h"
#include "blas/daxpy.h"
#include "jeveux.h"
!
character(len=16), intent(in) :: option, nomte
!
! --------------------------------------------------------------------------------------------------
!
! Elementary computation
!
! Elements: HHO
!
! Options: HHO_COMB
!
! --------------------------------------------------------------------------------------------------
!
! In  option           : name of option to compute
! In  nomte            : type of finite element
!
! --------------------------------------------------------------------------------------------------
!
    integer, parameter :: max_param = 4
    integer :: iret, i_matr, i_vect
    integer :: idmatr(2), idvect(2), nb_vale_matr_sym, nb_vale_matr_ns, nb_vale_vect
    integer :: jv_matr_in(max_param), jv_vect_in(max_param)
    integer :: jv_matr_out, jv_vect_out, nddl
    real(kind=8) :: coef_matr(max_param), coef_vect(max_param)
    aster_logical :: l_matr(max_param), l_vect(max_param), l_matsym, l_onematsym
!
! --------------------------------------------------------------------------------------------------
!
    nb_vale_matr_sym = 0
    nb_vale_matr_ns  = 0
    nb_vale_vect     = 0
!
    jv_matr_in(:) = 0
    jv_matr_out   = 0
    jv_vect_in(:) = 0
    jv_vect_out   = 0
!
    coef_matr(:)  = 1.d0
    coef_vect(:)  = 1.d0
!
    l_matr(:)     = ASTER_FALSE
    l_vect(:)     = ASTER_FALSE
    l_matsym      = ASTER_TRUE
    l_onematsym   = ASTER_FALSE
!
! - Get matrices
!
    call tecach('ONO', 'PMAELS1', 'L', iret, nval=2, itab=idmatr)
    if (iret .eq. 0) then
        l_matr(1)     = ASTER_TRUE
        l_matsym      = ASTER_TRUE
        l_onematsym   = ASTER_TRUE
        nb_vale_matr_sym  = idmatr(2)
        jv_matr_in(1) = idmatr(1)
    endif
!
    call tecach('ONO', 'PMAELS2', 'L', iret, nval=2, itab=idmatr)
    if (iret .eq. 0) then
        l_matr(2)     = ASTER_TRUE
        l_matsym      = ASTER_TRUE
        l_onematsym   = ASTER_TRUE
        ASSERT(nb_vale_matr_sym .eq. idmatr(2))
        jv_matr_in(2) = idmatr(1)
    endif
!
    call tecach('ONO', 'PMAELNS1', 'L', iret, nval=2, itab=idmatr)
    if (iret .eq. 0) then
        l_matr(3)     = ASTER_TRUE
        l_matsym      = ASTER_FALSE
        nb_vale_matr_ns  = idmatr(2)
        jv_matr_in(3) = idmatr(1)
    endif
!
    call tecach('ONO', 'PMAELNS2', 'L', iret, nval=2, itab=idmatr)
    if (iret .eq. 0) then
        l_matr(4)     = ASTER_TRUE
        l_matsym      = ASTER_FALSE
        ASSERT(nb_vale_matr_ns .eq. idmatr(2))
        jv_matr_in(4) = idmatr(1)
    endif
!
! - Get vectors
!
    call tecach('ONO', 'PVEELE1', 'L', iret, nval=2, itab=idvect)
    if (iret .eq. 0) then
        l_vect(1)     = ASTER_TRUE
        nb_vale_vect  = idvect(2)
        jv_vect_in(1) = idvect(1)
    endif
!
    call tecach('ONO', 'PVEELE2', 'L', iret, nval=2, itab=idvect)
    if (iret .eq. 0) then
        l_vect(2)     = ASTER_TRUE
        ASSERT(nb_vale_vect .eq. idvect(2))
        jv_vect_in(2) = idvect(1)
    endif
!
    call tecach('ONO', 'PVEELE3', 'L', iret, nval=2, itab=idvect)
    if (iret .eq. 0) then
        l_vect(3)     = ASTER_TRUE
        ASSERT(nb_vale_vect .eq. idvect(2))
        jv_vect_in(3) = idvect(1)
    endif
!
    call tecach('ONO', 'PVEELE4', 'L', iret, nval=2, itab=idvect)
    if (iret .eq. 0) then
        l_vect(4)     = ASTER_TRUE
        ASSERT(nb_vale_vect .eq. idvect(2))
        jv_vect_in(4) = idvect(1)
    endif
!
    if(l_matsym) then
        call jevech('PMATUUR', 'E', jv_matr_out)
    else
        call jevech('PMATUNS', 'E', jv_matr_out)
    end if
!
    if(l_matsym) then
!
! --- All matrices are symmetric
!
        do i_matr = 1, max_param
            if(l_matr(i_matr)) then
                call daxpy(nb_vale_matr_sym, coef_matr(i_matr), zr(jv_matr_in(i_matr)), 1,&
                           zr(jv_matr_out), 1)
            end if
        end do
    else
        if(l_onematsym) then
!
! --- At least one matrix is symmetrix and unsymmetric
!
! J'ai pas encore vérifié comment les enregistrer donc pour l'instant on interdit
! les matrices qui ont différentes tailles
            nddl = int(sqrt(dble(nb_vale_matr_ns)))
            ASSERT(nb_vale_matr_sym == nddl*(nddl+1)/2)
            ASSERT(ASTER_FALSE)
        else
!
! --- All matrices are unsymmetric
!
            do i_matr = 1, max_param
                if(l_matr(i_matr)) then
                    call daxpy(nb_vale_matr_ns, coef_matr(i_matr), zr(jv_matr_in(i_matr)), 1,&
                            zr(jv_matr_out), 1)
                end if
            end do
        end if
    end if
!
    call jevech('PVECTUR', 'E', jv_vect_out)
!
    do i_vect = 1, max_param
        if(l_vect(i_vect)) then
            call daxpy(nb_vale_vect, coef_vect(i_vect), zr(jv_vect_in(i_vect)),1, zr(jv_vect_out),1)
        end if
    end do
!
end subroutine
